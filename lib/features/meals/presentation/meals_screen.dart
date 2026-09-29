import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/labels.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';
import '../../../core/database/app_database.dart';
import '../../../core/errors/domain_exceptions.dart';
import '../../audit/data/audit_log.dart';
import '../../medications/presentation/medication_detail_screen.dart';
import '../domain/meal_timing.dart';

/// Meals drive meal-relative dosing (spec §11).
class MealsScreen extends ConsumerWidget {
  const MealsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final patientId = ref.watch(currentPatientIdProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.meals)),
      floatingActionButton: patientId == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _edit(context, ref, patientId, null),
              icon: const Icon(Icons.add),
              label: Text(l10n.addMeal),
            ),
      body: RequirePatient(
        builder: (id) => AsyncBody(
          value: ref.watch(patientMealsProvider(id)),
          builder: (meals) => ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              Text(l10n.mealsNote,
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              for (final meal in meals)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.restaurant),
                    title: Text(mealName(meal, l10n)),
                    subtitle: Text(mealTypeLabel(meal.mealType, l10n)),
                    trailing: Text(
                      formatHHmm(
                        context,
                        effectiveMealTime(meal.mealType, meal.defaultTime)
                            .toHHmm(),
                      ),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    onTap: () => _edit(context, ref, id, meal),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    String patientId,
    Meal? meal,
  ) async {
    final l10n = context.l10n;
    final nameEn = TextEditingController(text: meal?.nameEn);
    final nameAr = TextEditingController(text: meal?.nameAr);
    var type = meal?.mealType ?? MealType.custom.name;
    var time =
        meal?.defaultTime ?? defaultMealTime(mealTypeFromCode(type)).toHHmm();
    final action = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(meal == null ? l10n.addMeal : l10n.editMeal),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameEn,
                  decoration: InputDecoration(labelText: l10n.nameEn),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameAr,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(labelText: l10n.nameAr),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: type,
                  decoration: InputDecoration(labelText: l10n.mealType),
                  items: [
                    for (final t in MealType.values)
                      DropdownMenuItem(
                        value: t.name,
                        child: Text(mealTypeLabel(t.name, l10n)),
                      ),
                  ],
                  onChanged: (v) => setState(() => type = v ?? type),
                ),
                const SizedBox(height: 12),
                TimeField(
                  label: l10n.mealTime,
                  value: time,
                  onChanged: (v) => setState(() => time = v),
                ),
              ],
            ),
          ),
          actions: [
            if (meal != null)
              TextButton(
                onPressed: () => Navigator.pop(context, 'delete'),
                child: Text(l10n.delete),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, 'save'),
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
    if (action == null || !context.mounted) return;
    final repo = ref.read(mealRepositoryProvider);
    final english = nameEn.text.trim().isEmpty ? nameAr.text : nameEn.text;
    final arabic = nameAr.text.trim().isEmpty ? nameEn.text : nameAr.text;
    if (action == 'delete') {
      await runGuarded(context, () async {
        if (await repo.isInUse(meal!.mealId)) {
          throw const ValidationException('mealInUse');
        }
        await ref.read(trashRepositoryProvider).moveToTrash(
              entityType: EntityTypes.meal,
              entityId: meal.mealId,
              patientId: patientId,
              label: meal.nameEn,
            );
      }, success: l10n.deletedMessage);
      return;
    }
    await runGuarded(context, () async {
      if (meal == null) {
        await repo.create(
          patientId: patientId,
          nameEn: english,
          nameAr: arabic,
          mealType: type,
          time: time,
        );
      } else {
        final changed = await repo.update(
          mealId: meal.mealId,
          nameEn: english,
          nameAr: arabic,
          mealType: type,
          time: time,
        );
        if (changed) {
          ref
              .read(syncCoordinatorProvider)
              .request(regeneratePatientId: patientId);
        }
      }
    }, success: l10n.savedMessage);
  }
}
