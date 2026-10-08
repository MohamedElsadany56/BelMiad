import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';
import '../data/drug_catalog_repository.dart';
import 'catalog_labels.dart';

const _recentCatalogKey = 'recent_catalog_ids';

/// Remembers a picked catalog entry so it is offered for empty searches.
void rememberCatalogSelection(SharedPreferences prefs, String catalogId) {
  final recent = prefs.getStringList(_recentCatalogKey) ?? [];
  recent
    ..remove(catalogId)
    ..insert(0, catalogId);
  prefs.setStringList(_recentCatalogKey, recent.take(10).toList());
}

/// Debounced, bounded FTS5 search of the offline drug catalog.
class CatalogSearch extends ConsumerStatefulWidget {
  const CatalogSearch({
    required this.onSelected,
    required this.onCustom,
    super.key,
  });

  final ValueChanged<DrugSearchResult> onSelected;
  final VoidCallback onCustom;

  @override
  ConsumerState<CatalogSearch> createState() => _CatalogSearchState();
}

class _CatalogSearchState extends ConsumerState<CatalogSearch> {
  final _controller = TextEditingController();
  Timer? _debounce;
  List<DrugSearchResult> _results = const [];
  List<DrugSearchResult> _recent = const [];
  bool _searching = false;
  bool _hasMore = false;
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    final ids =
        ref.read(sharedPreferencesProvider).getStringList(_recentCatalogKey) ??
            const [];
    final recent = await ref.read(catalogRepositoryProvider).byIds(ids);
    if (mounted) setState(() => _recent = recent);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 250),
      () => _search(value, reset: true),
    );
  }

  Future<void> _search(String query, {required bool reset}) async {
    final generation = ++_generation;
    if (query.trim().length < DrugCatalogRepository.minimumQueryLength) {
      setState(() {
        _results = const [];
        _hasMore = false;
      });
      return;
    }
    setState(() => _searching = true);
    final repo = ref.read(catalogRepositoryProvider);
    final offset = reset ? 0 : _results.length;
    final page = await repo.search(query, offset: offset);
    if (!mounted || generation != _generation) return;
    setState(() {
      _searching = false;
      _results = reset ? page : [..._results, ...page];
      _hasMore = page.length == DrugCatalogRepository.defaultLimit;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final query = _controller.text.trim();
    final showRecent = query.length < DrugCatalogRepository.minimumQueryLength;
    final items = showRecent ? _recent : _results;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _controller,
            autofocus: true,
            onChanged: (v) {
              setState(() {});
              _onChanged(v);
            },
            decoration: InputDecoration(
              labelText: l10n.searchCatalog,
              hintText: l10n.searchCatalogHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searching
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : null,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.add_circle_outline),
          title: Text(l10n.addCustomMedication),
          onTap: widget.onCustom,
        ),
        const Divider(),
        if (showRecent && _recent.isNotEmpty)
          SectionHeader(l10n.recentlySelected),
        if (!showRecent && !_searching && _results.isEmpty)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(l10n.noCatalogResults),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length + (!showRecent && _hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == items.length) {
                return TextButton(
                  onPressed: () => _search(_controller.text, reset: false),
                  child: Text(l10n.loadMore),
                );
              }
              final item = items[index];
              final theme = Theme.of(context);
              final flags = item.facts?.flags ?? const <String>{};
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    drugFormIcon(item.facts?.form),
                    color: theme.colorScheme.primary,
                  ),
                ),
                title: MixedText(item.nameEn),
                // Form, strength and pack size tell apart the syrup, tablets
                // and drops of the same medicine.
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.facts != null)
                      Text(
                        catalogVariantSummary(item, l10n),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    MixedText(item.nameAr),
                    Text(
                      l10n.catalogPrice(item.priceEgp.toStringAsFixed(2)),
                      style: theme.textTheme.bodySmall,
                    ),
                    if (flags.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            for (final flag in flags)
                              StatusBadge(
                                drugFlagLabel(flag, l10n),
                                tone: BadgeTone.warning,
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
                isThreeLine: true,
                onTap: () => widget.onSelected(item),
              );
            },
          ),
        ),
      ],
    );
  }
}
