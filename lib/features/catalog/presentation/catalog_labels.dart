import 'package:flutter/material.dart';

import '../../../app/localization/labels.dart';
import '../../../core/utilities/scaled_quantity.dart';
import '../../../l10n/app_localizations.dart';
import '../data/drug_catalog_repository.dart';
import '../domain/catalog_name_parser.dart';

String drugFormLabel(String code, AppLocalizations l10n) => switch (code) {
      DrugForms.tablet => l10n.drugForm_tablet,
      DrugForms.capsule => l10n.drugForm_capsule,
      DrugForms.sachet => l10n.drugForm_sachet,
      DrugForms.ampoule => l10n.drugForm_ampoule,
      DrugForms.vial => l10n.drugForm_vial,
      DrugForms.syringe => l10n.drugForm_syringe,
      DrugForms.pen => l10n.drugForm_pen,
      DrugForms.suppository => l10n.drugForm_suppository,
      DrugForms.lozenge => l10n.drugForm_lozenge,
      DrugForms.patch => l10n.drugForm_patch,
      DrugForms.film => l10n.drugForm_film,
      DrugForms.piece => l10n.drugForm_piece,
      DrugForms.teaBag => l10n.drugForm_teaBag,
      DrugForms.syrup => l10n.drugForm_syrup,
      DrugForms.suspension => l10n.drugForm_suspension,
      DrugForms.solution => l10n.drugForm_solution,
      DrugForms.drops => l10n.drugForm_drops,
      DrugForms.eyeDrops => l10n.drugForm_eyeDrops,
      DrugForms.earDrops => l10n.drugForm_earDrops,
      DrugForms.nasalSpray => l10n.drugForm_nasalSpray,
      DrugForms.spray => l10n.drugForm_spray,
      DrugForms.inhaler => l10n.drugForm_inhaler,
      DrugForms.infusion => l10n.drugForm_infusion,
      DrugForms.injection => l10n.drugForm_injection,
      DrugForms.cream => l10n.drugForm_cream,
      DrugForms.ointment => l10n.drugForm_ointment,
      DrugForms.gel => l10n.drugForm_gel,
      DrugForms.lotion => l10n.drugForm_lotion,
      DrugForms.shampoo => l10n.drugForm_shampoo,
      DrugForms.mouthwash => l10n.drugForm_mouthwash,
      DrugForms.powder => l10n.drugForm_powder,
      DrugForms.emulsion => l10n.drugForm_emulsion,
      DrugForms.oil => l10n.drugForm_oil,
      DrugForms.soap => l10n.drugForm_soap,
      _ => code,
    };

String drugDetailLabel(String code, AppLocalizations l10n) => switch (code) {
      DrugFormDetails.filmCoated => l10n.drugDetail_filmCoated,
      DrugFormDetails.coated => l10n.drugDetail_coated,
      DrugFormDetails.sugarCoated => l10n.drugDetail_sugarCoated,
      DrugFormDetails.entericCoated => l10n.drugDetail_entericCoated,
      DrugFormDetails.extendedRelease => l10n.drugDetail_extendedRelease,
      DrugFormDetails.delayedRelease => l10n.drugDetail_delayedRelease,
      DrugFormDetails.chewable => l10n.drugDetail_chewable,
      DrugFormDetails.effervescent => l10n.drugDetail_effervescent,
      DrugFormDetails.orodispersible => l10n.drugDetail_orodispersible,
      DrugFormDetails.dispersible => l10n.drugDetail_dispersible,
      DrugFormDetails.sublingual => l10n.drugDetail_sublingual,
      DrugFormDetails.scored => l10n.drugDetail_scored,
      DrugFormDetails.softGel => l10n.drugDetail_softGel,
      DrugFormDetails.hardGelatin => l10n.drugDetail_hardGelatin,
      DrugFormDetails.vaginal => l10n.drugDetail_vaginal,
      DrugFormDetails.rectal => l10n.drugDetail_rectal,
      DrugFormDetails.paediatric => l10n.drugDetail_paediatric,
      DrugFormDetails.intravenous => l10n.drugDetail_intravenous,
      DrugFormDetails.intramuscular => l10n.drugDetail_intramuscular,
      DrugFormDetails.subcutaneous => l10n.drugDetail_subcutaneous,
      DrugFormDetails.transdermal => l10n.drugDetail_transdermal,
      _ => code,
    };

String drugRouteLabel(String code, AppLocalizations l10n) => switch (code) {
      DrugRoutes.oral => l10n.drugRoute_oral,
      DrugRoutes.topical => l10n.drugRoute_topical,
      DrugRoutes.injection => l10n.drugRoute_injection,
      DrugRoutes.eye => l10n.drugRoute_eye,
      DrugRoutes.ear => l10n.drugRoute_ear,
      DrugRoutes.nasal => l10n.drugRoute_nasal,
      DrugRoutes.inhalation => l10n.drugRoute_inhalation,
      DrugRoutes.mouth => l10n.drugRoute_mouth,
      DrugRoutes.vaginal => l10n.drugRoute_vaginal,
      DrugRoutes.rectal => l10n.drugRoute_rectal,
      _ => code,
    };

String drugFlagLabel(String code, AppLocalizations l10n) => switch (code) {
      DrugFlags.cancelled => l10n.catalogFlagCancelled,
      DrugFlags.illegalImport => l10n.catalogFlagIllegalImport,
      DrugFlags.notAvailable => l10n.catalogFlagNotAvailable,
      DrugFlags.hospitalOnly => l10n.catalogFlagHospitalOnly,
      _ => code,
    };

/// "Tablet (film-coated)", "Syrup".
String dosageFormText(CatalogDrugFacts facts, AppLocalizations l10n) {
  final form = facts.form;
  if (form == null) return '';
  final details = [
    for (final d in facts.formDetails)
      // The form already says it is an IV infusion.
      if (!(form == DrugForms.infusion && d == DrugFormDetails.intravenous))
        drugDetailLabel(d, l10n),
  ];
  final label = drugFormLabel(form, l10n);
  return details.isEmpty
      ? label
      : '$label (${details.join(l10n.localeName == 'ar' ? '، ' : ', ')})';
}

/// "30 tablets", "120 ml", "30 g" — what one pack holds.
String? packSizeText(CatalogDrugFacts facts, AppLocalizations l10n) {
  final count = facts.packCount;
  if (count != null && facts.doseUnit != null) {
    // A single vial or ampoule is just "1 vial".
    final unit = count == 1 &&
            facts.form != null &&
            {
              DrugForms.vial,
              DrugForms.ampoule,
              DrugForms.syringe,
              DrugForms.pen
            }.contains(facts.form)
        ? drugFormLabel(facts.form!, l10n).toLowerCase()
        : unitLabelFor(facts.doseUnit!, count * quantityScale, l10n);
    final text = l10n.catalogPackOf(count, unit);
    final volume = facts.contentUnit == 'ml' && facts.contentAmount != null
        ? ' × ${_amount(facts.contentAmount!)} ${l10n.unit_ml}'
        : '';
    return '$text$volume';
  }
  final amount = facts.contentAmount;
  if (amount != null) {
    final unit = facts.contentUnit == 'g' ? l10n.unit_g : l10n.unit_ml;
    return '${_amount(amount)} $unit';
  }
  return null;
}

String _amount(double value) =>
    value == value.roundToDouble() ? '${value.round()}' : value.toString();

/// One line describing a catalog entry: "Syrup · 250 mg/5 ml · 100 ml".
String catalogVariantSummary(DrugSearchResult entry, AppLocalizations l10n) {
  final facts = entry.facts;
  if (facts == null) return entry.nameEn;
  final parts = [
    if (facts.form != null) dosageFormText(facts, l10n),
    if (facts.strength != null) facts.strength!,
    if (packSizeText(facts, l10n) case final pack?) pack,
  ];
  // In Arabic each part keeps its own direction, so "625 mg" and
  // "10 أقراص" don't get mixed up (first-strong isolates).
  return l10n.localeName == 'ar'
      ? parts.map((p) => '\u2068$p\u2069').join(' · ')
      : parts.join(' · ');
}

IconData drugFormIcon(String? form) => switch (form) {
      DrugForms.tablet || DrugForms.capsule => Icons.medication,
      DrugForms.sachet ||
      DrugForms.powder ||
      DrugForms.teaBag =>
        Icons.inventory_2_outlined,
      DrugForms.ampoule ||
      DrugForms.vial ||
      DrugForms.syringe ||
      DrugForms.pen ||
      DrugForms.injection ||
      DrugForms.infusion =>
        Icons.vaccines_outlined,
      DrugForms.syrup ||
      DrugForms.suspension ||
      DrugForms.solution ||
      DrugForms.emulsion ||
      DrugForms.mouthwash ||
      DrugForms.oil =>
        Icons.medication_liquid_outlined,
      DrugForms.drops ||
      DrugForms.eyeDrops ||
      DrugForms.earDrops =>
        Icons.water_drop_outlined,
      DrugForms.nasalSpray || DrugForms.spray || DrugForms.inhaler => Icons.air,
      DrugForms.cream ||
      DrugForms.ointment ||
      DrugForms.gel ||
      DrugForms.lotion ||
      DrugForms.shampoo ||
      DrugForms.soap =>
        Icons.sanitizer_outlined,
      DrugForms.patch => Icons.healing_outlined,
      _ => Icons.medication_outlined,
    };

/// Values for the add-medicine form taken from a catalog entry. Only a
/// starting point: the user reviews and edits them.
class CatalogSuggestion {
  const CatalogSuggestion({
    required this.nameEn,
    required this.nameAr,
    required this.strength,
    required this.doseUnit,
    required this.dosageForm,
    required this.route,
    required this.scientificName,
  });

  factory CatalogSuggestion.from(
    DrugSearchResult entry,
    AppLocalizations l10n,
  ) {
    final facts = entry.facts;
    final unit = facts?.doseUnit;
    return CatalogSuggestion(
      nameEn: facts?.brand ?? entry.nameEn,
      nameAr: entry.nameAr,
      strength: facts?.strength ?? '',
      doseUnit: unit != null && doseUnits.contains(unit) ? unit : null,
      dosageForm: facts == null ? '' : dosageFormText(facts, l10n),
      route: facts?.route == null ? '' : drugRouteLabel(facts!.route!, l10n),
      scientificName: entry.scientificName == null
          ? ''
          : catalogTitleCase(entry.scientificName!.replaceAll('+', ' + ')),
    );
  }

  final String nameEn;
  final String nameAr;
  final String strength;
  final String? doseUnit;
  final String dosageForm;
  final String route;
  final String scientificName;
}
