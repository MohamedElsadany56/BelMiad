// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BelMiad';

  @override
  String get appTagline => 'Medicines on time, offline';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get close => 'Close';

  @override
  String get confirm => 'Confirm';

  @override
  String get search => 'Search';

  @override
  String get done => 'Done';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get optional => 'Optional';

  @override
  String get requiredField => 'Required';

  @override
  String get notSet => 'Not set';

  @override
  String get none => 'None';

  @override
  String get restore => 'Restore';

  @override
  String get permanentlyDelete => 'Delete permanently';

  @override
  String get archive => 'Archive';

  @override
  String get unarchive => 'Unarchive';

  @override
  String get undo => 'Undo';

  @override
  String get share => 'Share';

  @override
  String get details => 'Details';

  @override
  String get history => 'History';

  @override
  String get all => 'All';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get loadMore => 'Load more';

  @override
  String errorGeneric(Object message) {
    return 'Something went wrong: $message';
  }

  @override
  String get savedMessage => 'Saved';

  @override
  String get deletedMessage => 'Moved to trash';

  @override
  String get navToday => 'Today';

  @override
  String get navMedications => 'Medicines';

  @override
  String get navInventory => 'Stock';

  @override
  String get navHealth => 'Health';

  @override
  String get navMore => 'More';

  @override
  String get welcomeTitle => 'Welcome to BelMiad';

  @override
  String get welcomeBody =>
      'Track medicines, doses, stock and health records for yourself or the people you care for. Everything stays on this phone and works offline.';

  @override
  String get getStarted => 'Get started';

  @override
  String get whoAreYou => 'Who is using this phone?';

  @override
  String get whoAreYouHint =>
      'Your name is attached to the actions you record (doses, stock changes). This is not a login and has no password.';

  @override
  String get yourName => 'Your name';

  @override
  String get firstPatientTitle => 'Who are you caring for?';

  @override
  String get patientIsMe => 'Myself';

  @override
  String get patientIsSomeoneElse => 'Someone else';

  @override
  String get relationshipLabel => 'Relationship (e.g. Mother)';

  @override
  String get continueAction => 'Continue';

  @override
  String get patients => 'Patients';

  @override
  String get patient => 'Patient';

  @override
  String get addPatient => 'Add patient';

  @override
  String get editPatient => 'Edit patient';

  @override
  String get fullName => 'Full name';

  @override
  String get phone => 'Phone';

  @override
  String get email => 'Email';

  @override
  String get dateOfBirth => 'Date of birth';

  @override
  String get sex => 'Sex';

  @override
  String get sexMale => 'Male';

  @override
  String get sexFemale => 'Female';

  @override
  String get bloodType => 'Blood type';

  @override
  String get emergencyContactName => 'Emergency contact name';

  @override
  String get emergencyContactPhone => 'Emergency contact phone';

  @override
  String get notes => 'Notes';

  @override
  String get timezone => 'Timezone';

  @override
  String get timezoneHint =>
      'Dose times keep the same local clock time when the timezone changes.';

  @override
  String get switchPatient => 'Switch patient';

  @override
  String get currentPatient => 'Current patient';

  @override
  String get noPatients => 'No patients yet';

  @override
  String get noPatientSelected => 'Select or add a patient to continue';

  @override
  String get deletePatientTitle => 'Move patient to trash?';

  @override
  String deletePatientBody(Object name) {
    return '$name and all their data will move to trash. You can restore them later or delete them permanently.';
  }

  @override
  String ageYears(Object years) {
    return '$years years';
  }

  @override
  String get caregivers => 'Caregivers';

  @override
  String get addCaregiver => 'Add caregiver';

  @override
  String get removeCaregiver => 'Remove caregiver';

  @override
  String removeCaregiverBody(Object name) {
    return '$name will no longer be listed as a caregiver. Their past actions stay in the history.';
  }

  @override
  String get selectPerson => 'Select a person';

  @override
  String get newPerson => 'New person';

  @override
  String get relationship => 'Relationship';

  @override
  String get relationshipSelf => 'Self';

  @override
  String get deviceCaregiver => 'Caregiver on this phone';

  @override
  String get changeCaregiver => 'Change caregiver';

  @override
  String caregiverSwitched(Object name) {
    return 'Now recording as $name';
  }

  @override
  String get medications => 'Medicines';

  @override
  String get medication => 'Medicine';

  @override
  String get addMedication => 'Add medicine';

  @override
  String get editMedication => 'Edit medicine';

  @override
  String get searchCatalog => 'Search Egyptian drug catalog';

  @override
  String get searchCatalogHint => 'Type at least 2 letters, English or Arabic';

  @override
  String get noCatalogResults => 'No catalog match';

  @override
  String get addCustomMedication => 'Add custom medicine';

  @override
  String catalogPrice(Object price) {
    return 'Catalog price: EGP $price';
  }

  @override
  String get referencePriceNote =>
      'Reference price only. Actual purchase prices are recorded with stock.';

  @override
  String get recentlySelected => 'Recently selected';

  @override
  String get fromCatalog => 'From catalog';

  @override
  String get nameEn => 'Name (English)';

  @override
  String get nameAr => 'Name (Arabic)';

  @override
  String get scientificName => 'Scientific / generic name';

  @override
  String get strength => 'Strength (e.g. 500 mg)';

  @override
  String get dosageForm => 'Dosage form';

  @override
  String get route => 'Route';

  @override
  String get doseUnit => 'Dose unit';

  @override
  String get instructionsEn => 'Instructions (English)';

  @override
  String get instructionsAr => 'Instructions (Arabic)';

  @override
  String get instructionsSeparateNote =>
      'English and Arabic instructions are entered separately and never auto-translated.';

  @override
  String get startDate => 'Start date';

  @override
  String get endDate => 'End date';

  @override
  String get prn => 'As needed (PRN)';

  @override
  String get prnHint =>
      'Doses are recorded when taken; no reminders are generated.';

  @override
  String get maximumDaily => 'Maximum per day';

  @override
  String get maximumDailyHint => 'Warns before the daily maximum is exceeded';

  @override
  String get statusActive => 'Active';

  @override
  String get statusArchived => 'Archived';

  @override
  String get showArchived => 'Show archived';

  @override
  String get deleteMedicationTitle => 'Move medicine to trash?';

  @override
  String get deleteMedicationBody =>
      'Dose history and stock history are kept and can be restored.';

  @override
  String get noMedications => 'No medicines yet';

  @override
  String get overview => 'Overview';

  @override
  String get schedules => 'Schedules';

  @override
  String get inventory => 'Stock';

  @override
  String get doseHistory => 'Dose history';

  @override
  String get addStockNowTitle => 'Add stock now?';

  @override
  String get addStockNowBody =>
      'You can record the stock you have for this medicine now, or later from the Stock tab.';

  @override
  String get later => 'Later';

  @override
  String get prnBadge => 'PRN';

  @override
  String maxPerDay(Object quantity) {
    return 'Max $quantity per day';
  }

  @override
  String get unit_tablet => 'tablet';

  @override
  String get unit_capsule => 'capsule';

  @override
  String get unit_ml => 'ml';

  @override
  String get unit_drop => 'drop';

  @override
  String get unit_puff => 'puff';

  @override
  String get unit_sachet => 'sachet';

  @override
  String get unit_injection => 'injection';

  @override
  String get unit_patch => 'patch';

  @override
  String get unit_suppository => 'suppository';

  @override
  String get unit_application => 'application';

  @override
  String get unit_mg => 'mg';

  @override
  String get unit_g => 'g';

  @override
  String get unit_unit => 'unit';

  @override
  String get addSchedule => 'Add schedule';

  @override
  String get editSchedule => 'Edit schedule';

  @override
  String get scheduleType => 'Timing';

  @override
  String get fixedTime => 'Fixed time';

  @override
  String get mealRelative => 'Relative to a meal';

  @override
  String get time => 'Time';

  @override
  String get meal => 'Meal';

  @override
  String get beforeMeal => 'Before meal';

  @override
  String get withMeal => 'With meal';

  @override
  String get afterMeal => 'After meal';

  @override
  String get offsetMinutes => 'Minutes';

  @override
  String get quantity => 'Quantity';

  @override
  String get recurrence => 'Repeat';

  @override
  String get daily => 'Every day';

  @override
  String get weekly => 'Selected weekdays';

  @override
  String get everyNDays => 'Every N days';

  @override
  String get customCycle => 'Custom cycle';

  @override
  String get intervalDays => 'Every how many days';

  @override
  String get intervalWeeks => 'Every how many weeks';

  @override
  String get onDays => 'Active days';

  @override
  String get offDays => 'Pause days';

  @override
  String get cycleStart => 'Cycle start date';

  @override
  String get differentQuantityByDay => 'Different quantity on some days';

  @override
  String get validFrom => 'From date';

  @override
  String get validUntil => 'Until date';

  @override
  String get noSchedules => 'No schedules';

  @override
  String get deleteScheduleTitle => 'Delete schedule?';

  @override
  String get deleteScheduleBody =>
      'Future doses from this schedule are removed. Past doses stay in the history.';

  @override
  String get prnPlannedNote =>
      'For as-needed medicines, schedules are only a planned frequency used for stock forecasting.';

  @override
  String get scheduleEveryDay => 'every day';

  @override
  String scheduleEveryNDays(Object count) {
    return 'every $count days';
  }

  @override
  String scheduleWeekdays(Object days) {
    return 'on $days';
  }

  @override
  String scheduleEveryNWeeks(Object count, Object days) {
    return 'every $count weeks on $days';
  }

  @override
  String scheduleCycle(Object on, Object off) {
    return '$on days on, $off days off';
  }

  @override
  String scheduleBeforeMeal(Object minutes, Object meal) {
    return '$minutes min before $meal';
  }

  @override
  String scheduleAfterMeal(Object minutes, Object meal) {
    return '$minutes min after $meal';
  }

  @override
  String scheduleWithMeal(Object meal) {
    return 'with $meal';
  }

  @override
  String get todayTitle => 'Today';

  @override
  String get noDoses => 'No doses on this day';

  @override
  String get take => 'Take';

  @override
  String get taken => 'Taken';

  @override
  String get skip => 'Skip';

  @override
  String get skipped => 'Skipped';

  @override
  String get missed => 'Missed';

  @override
  String get scheduled => 'Scheduled';

  @override
  String get pending => 'Pending';

  @override
  String get undoTake => 'Undo taken';

  @override
  String get undoTakeBody =>
      'The dose returns to scheduled and the exact stock is restored to its original batches.';

  @override
  String get skipDoseTitle => 'Skip this dose?';

  @override
  String get skipDoseBody => 'A skipped dose cannot be taken later.';

  @override
  String takenAt(Object time) {
    return 'Taken at $time';
  }

  @override
  String lateBy(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min late',
      one: '1 min late',
    );
    return '$_temp0';
  }

  @override
  String get onTime => 'On time';

  @override
  String get logPrn => 'Log as-needed dose';

  @override
  String get howMuchTaken => 'How much was actually taken?';

  @override
  String get insufficientStockTitle => 'Not enough stock';

  @override
  String insufficientStockBody(Object required, Object available) {
    return 'Required $required, but only $available is available in usable stock.';
  }

  @override
  String get customAmount => 'Custom';

  @override
  String get leaveScheduled => 'Leave scheduled';

  @override
  String get zeroTakenNote =>
      'Nothing was taken. The dose is not marked taken and no stock is used.';

  @override
  String get maxExceededTitle => 'Daily maximum would be exceeded';

  @override
  String maxExceededBody(Object maximum, Object taken, Object attempt) {
    return 'Maximum $maximum per day. Already taken today: $taken. This dose: $attempt.';
  }

  @override
  String get recordAnyway => 'Record anyway';

  @override
  String get doseWindowClosed =>
      'This dose is past its allowed window and is now missed.';

  @override
  String get chooseBatches => 'Stock batches';

  @override
  String get automaticFefo => 'Automatic (first expiring first)';

  @override
  String get manualSelection => 'Choose batches';

  @override
  String allocatedOf(Object allocated, Object required) {
    return 'Allocated $allocated of $required';
  }

  @override
  String get stockNotRecordedNote =>
      'Stock is not recorded for this medicine; no stock will be deducted.';

  @override
  String get requiredQuantity => 'Required';

  @override
  String get actualQuantity => 'Actually taken';

  @override
  String get confirmTake => 'Mark taken';

  @override
  String get doseTaken => 'Dose recorded';

  @override
  String get doseSkippedMessage => 'Dose skipped';

  @override
  String get doseUndone => 'Dose restored to scheduled';

  @override
  String get upcomingAppointment => 'Next appointment';

  @override
  String get alerts => 'Alerts';

  @override
  String dosesDone(Object done, Object total) {
    return '$done of $total doses taken';
  }

  @override
  String partialDose(Object actual, Object required) {
    return 'Partial: $actual of $required';
  }

  @override
  String get prnTaken => 'As needed';

  @override
  String get inventoryTitle => 'Stock';

  @override
  String get totalMedications => 'Medicines';

  @override
  String get withStock => 'With stock';

  @override
  String get lowStock => 'Low stock';

  @override
  String get emptyStock => 'Empty';

  @override
  String get expiringSoon => 'Expiring soon';

  @override
  String get stockNotRecorded => 'Stock not recorded';

  @override
  String get stockNormal => 'Normal';

  @override
  String get stockLow => 'Low stock';

  @override
  String get stockEmpty => 'Empty';

  @override
  String get stockExpiredOnly => 'Expired only';

  @override
  String get stockExpiring => 'Expiring soon';

  @override
  String daysRemaining(Object count) {
    return '~$count days remaining';
  }

  @override
  String get dayRemaining => '~1 day remaining';

  @override
  String get lessThanDay => 'Less than a day';

  @override
  String get noForecast => 'No scheduled use';

  @override
  String get addStock => 'Add stock';

  @override
  String get selectMedication => 'Select medicine';

  @override
  String get byPackages => 'By packages';

  @override
  String get byQuantity => 'By quantity';

  @override
  String get packagingType => 'Packaging';

  @override
  String get packagesCount => 'Packages';

  @override
  String get unitsPerPackage => 'Units per package';

  @override
  String get availableQuantity => 'Available quantity';

  @override
  String packagesTotal(Object quantity) {
    return 'Total: $quantity';
  }

  @override
  String get purchaseDate => 'Purchase date';

  @override
  String get purchasePrice => 'Purchase price (EGP)';

  @override
  String get expirationDate => 'Expiration date';

  @override
  String get totalQuantity => 'Total usable';

  @override
  String get batches => 'Batches';

  @override
  String get noBatches => 'No batches recorded';

  @override
  String get depleted => 'Depleted';

  @override
  String get expired => 'Expired';

  @override
  String get expiresToday => 'Expires today';

  @override
  String expiresInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Expires in $count days',
      one: 'Expires in 1 day',
    );
    return '$_temp0';
  }

  @override
  String expiresOn(Object date) {
    return 'Expires $date';
  }

  @override
  String get noExpiry => 'No expiry date';

  @override
  String get adjustStock => 'Adjust stock';

  @override
  String get addQuantity => 'Add quantity';

  @override
  String get removeQuantity => 'Remove quantity';

  @override
  String get reason => 'Reason';

  @override
  String get reason_manual_correction => 'Manual correction';

  @override
  String get reason_damaged => 'Damaged medication';

  @override
  String get reason_lost => 'Lost medication';

  @override
  String get reason_returned => 'Returned medication';

  @override
  String get reason_count_correction => 'Count correction';

  @override
  String get reason_other => 'Other';

  @override
  String get adjustmentHistory => 'Adjustments';

  @override
  String get consumptionHistory => 'Consumption';

  @override
  String get editBatch => 'Edit batch';

  @override
  String get deleteBatchTitle => 'Move batch to trash?';

  @override
  String get deleteBatchBody =>
      'The batch and its history are kept in trash and can be restored.';

  @override
  String get useAdjustmentNote =>
      'This batch has history, so quantity changes must be recorded as adjustments.';

  @override
  String get packaging_box => 'Box';

  @override
  String get packaging_bottle => 'Bottle';

  @override
  String get packaging_tube => 'Tube';

  @override
  String get packaging_sachet => 'Sachet';

  @override
  String get packaging_vial => 'Vial';

  @override
  String get packaging_ampoule => 'Ampoule';

  @override
  String get packaging_container => 'Container';

  @override
  String get packaging_other => 'Other';

  @override
  String quantityChange(Object previous, Object next) {
    return '$previous → $next';
  }

  @override
  String consumedForDose(Object date) {
    return 'Dose $date';
  }

  @override
  String get reversed => 'Reversed (undo)';

  @override
  String get manual => 'Manual';

  @override
  String get storageReport => 'Storage report';

  @override
  String get needsPurchase => 'Needs purchase';

  @override
  String get batchCount => 'Batches';

  @override
  String get earliestExpiration => 'Earliest expiry';

  @override
  String get expiredQuantity => 'Expired quantity';

  @override
  String get lastPurchase => 'Last purchase';

  @override
  String get projectedThreeDays => 'Needed next 3 days';

  @override
  String get remainingDays => 'Remaining days';

  @override
  String get stockState => 'Stock state';

  @override
  String get currentQuantity => 'Current quantity';

  @override
  String get unit => 'Unit';

  @override
  String get health => 'Health';

  @override
  String get appointments => 'Appointments';

  @override
  String get vitals => 'Vitals';

  @override
  String get illnesses => 'Illnesses';

  @override
  String get dietaryRules => 'Diet';

  @override
  String get prescriptions => 'Prescriptions';

  @override
  String get addAppointment => 'Add appointment';

  @override
  String get doctor => 'Doctor';

  @override
  String get specialty => 'Specialty';

  @override
  String get dateAndTime => 'Date and time';

  @override
  String get date => 'Date';

  @override
  String get location => 'Location';

  @override
  String get status => 'Status';

  @override
  String get appointment_scheduled => 'Scheduled';

  @override
  String get appointment_completed => 'Completed';

  @override
  String get appointment_cancelled => 'Cancelled';

  @override
  String get addVital => 'Add measurement';

  @override
  String get vitalType => 'Measurement';

  @override
  String get value => 'Value';

  @override
  String get systolic => 'Systolic';

  @override
  String get diastolic => 'Diastolic';

  @override
  String get measuredAt => 'Measured at';

  @override
  String get vital_blood_pressure => 'Blood pressure';

  @override
  String get vital_heart_rate => 'Heart rate';

  @override
  String get vital_blood_glucose => 'Blood glucose';

  @override
  String get vital_temperature => 'Temperature';

  @override
  String get vital_weight => 'Weight';

  @override
  String get vital_oxygen_saturation => 'Oxygen saturation';

  @override
  String get vital_respiratory_rate => 'Respiratory rate';

  @override
  String get vital_other => 'Other';

  @override
  String get addIllness => 'Add illness';

  @override
  String get condition => 'Condition';

  @override
  String get diagnosedDate => 'Diagnosis date';

  @override
  String get addDietRule => 'Add diet rule';

  @override
  String get foodItemEn => 'Food (English)';

  @override
  String get foodItemAr => 'Food (Arabic)';

  @override
  String get ruleType => 'Rule';

  @override
  String get diet_avoid => 'Avoid';

  @override
  String get diet_limit => 'Limit';

  @override
  String get diet_prefer => 'Prefer';

  @override
  String get diet_separate_from_medication => 'Separate from medicine';

  @override
  String get dietNoInferenceNote =>
      'Diet rules are recorded as entered; the app never infers medical rules.';

  @override
  String get addPrescription => 'Add prescription';

  @override
  String get pickFile => 'Choose image or PDF';

  @override
  String fileSelected(Object name) {
    return 'File: $name';
  }

  @override
  String get issueDate => 'Issue date';

  @override
  String get fileMissing => 'The prescription file is missing from this device';

  @override
  String get openFile => 'Open';

  @override
  String get prescriptionsPrivateNote =>
      'Stored privately in the app. Prescriptions are never included in doctor reports.';

  @override
  String get filesUnsupported =>
      'Attaching files is not available on this platform';

  @override
  String get noRecords => 'Nothing recorded yet';

  @override
  String get meals => 'Meals';

  @override
  String get addMeal => 'Add meal';

  @override
  String get editMeal => 'Edit meal';

  @override
  String get mealType => 'Meal type';

  @override
  String get meal_breakfast => 'Breakfast';

  @override
  String get meal_lunch => 'Lunch';

  @override
  String get meal_dinner => 'Dinner';

  @override
  String get meal_snack => 'Snack';

  @override
  String get meal_custom => 'Custom';

  @override
  String get mealTime => 'Meal time';

  @override
  String mealDefaultTime(Object time) {
    return 'Default $time';
  }

  @override
  String get mealsNote =>
      'Changing a meal time moves every dose scheduled relative to it.';

  @override
  String get reports => 'Reports';

  @override
  String get doctorReport => 'Doctor report';

  @override
  String get summaryReport => 'Summary';

  @override
  String get detailedReport => 'Detailed';

  @override
  String get period => 'Period';

  @override
  String get periodAll => 'Everything';

  @override
  String get period7 => 'Last 7 days';

  @override
  String get period30 => 'Last 30 days';

  @override
  String get period90 => 'Last 90 days';

  @override
  String get exportPdf => 'Export PDF';

  @override
  String reportGeneratedOn(Object date) {
    return 'Generated $date';
  }

  @override
  String get reportPeriodAll => 'Period: everything';

  @override
  String reportPeriodRange(Object from, Object to) {
    return 'Period: $from – $to';
  }

  @override
  String get adherence => 'Adherence';

  @override
  String get overallAdherence => 'Overall adherence';

  @override
  String get takenOnTime => 'Taken on time';

  @override
  String get takenLate => 'Taken late';

  @override
  String get medicationsSection => 'Medicines';

  @override
  String get doseHistorySection => 'Dose history';

  @override
  String get vitalsSection => 'Vitals';

  @override
  String get appointmentsSection => 'Appointments';

  @override
  String get illnessesSection => 'Illnesses';

  @override
  String get dietSection => 'Diet rules';

  @override
  String get patientSection => 'Patient';

  @override
  String get noData => 'No data';

  @override
  String get inventoryReport => 'Storage report';

  @override
  String get whatWeHave => 'What medicine do we have?';

  @override
  String get whatToBuy => 'What needs to be purchased?';

  @override
  String get nothingToBuy => 'Nothing needs to be purchased';

  @override
  String get pdfArabicFontMissing =>
      'Arabic PDF font is not bundled; Arabic text may not render in the PDF.';

  @override
  String get backup => 'Backup';

  @override
  String get backupTitle => 'Backup and restore';

  @override
  String get backupNote =>
      'Backups are portable ZIP files (not encrypted). Keep them somewhere safe.';

  @override
  String get exportBackup => 'Export current patient';

  @override
  String get exportBackupBody =>
      'Everything needed to rebuild this patient\'s profile, including prescription files.';

  @override
  String get importAsNew => 'Import as a new patient';

  @override
  String get importAsNewBody => 'Creates a separate profile with new IDs.';

  @override
  String get mergeBackup => 'Merge into the same patient';

  @override
  String get mergeBackupBody =>
      'Keeps the latest changes and every unique historical event.';

  @override
  String backupSaved(Object name) {
    return 'Backup ready: $name';
  }

  @override
  String importDone(Object name) {
    return 'Imported $name';
  }

  @override
  String mergeDone(Object added, Object updated) {
    return 'Merged: $added added, $updated updated';
  }

  @override
  String get invalidBackup => 'This file is not a valid BelMiad backup';

  @override
  String get newerBackup =>
      'This backup was made by a newer version of the app';

  @override
  String get backupPatientMissing =>
      'This backup\'s patient does not exist here. Import it as a new patient instead.';

  @override
  String get trash => 'Trash';

  @override
  String get trashEmpty => 'Trash is empty';

  @override
  String get restored => 'Restored';

  @override
  String get deletedPermanently => 'Deleted permanently';

  @override
  String get permanentDeleteTitle => 'Delete permanently?';

  @override
  String get permanentDeleteBody => 'This cannot be undone.';

  @override
  String deletedOn(Object date) {
    return 'Deleted $date';
  }

  @override
  String get entity_patient => 'Patient';

  @override
  String get entity_medication => 'Medicine';

  @override
  String get entity_inventory_batch => 'Stock batch';

  @override
  String get entity_appointment => 'Appointment';

  @override
  String get entity_vital_measurement => 'Measurement';

  @override
  String get entity_illness => 'Illness';

  @override
  String get entity_dietary_rule => 'Diet rule';

  @override
  String get entity_prescription => 'Prescription';

  @override
  String get entity_meal => 'Meal';

  @override
  String get auditLog => 'Activity history';

  @override
  String get auditEmpty => 'No activity yet';

  @override
  String get systemActor => 'App';

  @override
  String get unknownActor => 'Unknown';

  @override
  String get audit_created => 'Created';

  @override
  String get audit_updated => 'Updated';

  @override
  String get audit_deleted => 'Moved to trash';

  @override
  String get audit_restored => 'Restored';

  @override
  String get audit_permanently_deleted => 'Deleted permanently';

  @override
  String get audit_archived => 'Archived';

  @override
  String get audit_unarchived => 'Unarchived';

  @override
  String get audit_inventory_added => 'Stock added';

  @override
  String get audit_inventory_edited => 'Stock edited';

  @override
  String get audit_inventory_adjusted => 'Stock adjusted';

  @override
  String get audit_inventory_deleted => 'Stock deleted';

  @override
  String get audit_dose_taken => 'Dose taken';

  @override
  String get audit_dose_undone => 'Dose undone';

  @override
  String get audit_dose_skipped => 'Dose skipped';

  @override
  String get audit_dose_missed => 'Dose missed';

  @override
  String get audit_prn_logged => 'As-needed dose logged';

  @override
  String get audit_batch_manually_selected => 'Batch chosen manually';

  @override
  String get audit_maximum_daily_overridden => 'Daily maximum overridden';

  @override
  String get audit_caregiver_assigned => 'Caregiver added';

  @override
  String get audit_caregiver_removed => 'Caregiver removed';

  @override
  String get audit_imported => 'Imported from backup';

  @override
  String get audit_merged => 'Merged from backup';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationSettings => 'Notification preferences';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get notif_dose_reminder => 'Medication reminders';

  @override
  String get notif_missed_dose => 'Missed doses';

  @override
  String get notif_low_stock => 'Low stock';

  @override
  String get notif_empty_stock => 'Empty stock';

  @override
  String get notif_expiration => 'Expiration';

  @override
  String get notif_appointment_reminder => 'Appointment reminders';

  @override
  String get notificationsPerPatient =>
      'Preferences apply to the current patient only.';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get theme => 'Appearance';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get expiryThreshold => 'Expiring-soon warning';

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get missedGrace => 'Mark doses missed after';

  @override
  String minutesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String hoursCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String get inactivityReset => 'Return to home after inactivity';

  @override
  String get inactivityResetNote =>
      'Resets the screen only. This is not a lock and needs no password.';

  @override
  String get off => 'Off';

  @override
  String get about => 'About';

  @override
  String get aboutBody =>
      'BelMiad works fully offline. Data is stored only on this device, without accounts, cloud or encryption.';

  @override
  String catalogEntries(Object count) {
    return '$count medicines in the offline catalog';
  }

  @override
  String version(Object version) {
    return 'Version $version';
  }

  @override
  String get error_nameRequired => 'Please enter a name';

  @override
  String get error_invalidTimezone => 'Unknown timezone';

  @override
  String get error_doseUnitRequired => 'Please choose a dose unit';

  @override
  String get error_endBeforeStart => 'The end date is before the start date';

  @override
  String get error_invalidMaximum => 'The maximum must be greater than zero';

  @override
  String get error_quantityRequired =>
      'Please enter a quantity greater than zero';

  @override
  String get error_invalidQuantity => 'Enter a quantity like 1, 0.5 or 1.25';

  @override
  String get error_invalidTime => 'Please choose a valid time';

  @override
  String get error_mealRequired => 'Please choose a meal';

  @override
  String get error_weekdaysRequired => 'Choose at least one weekday';

  @override
  String get error_invalidRecurrence => 'Check the repeat settings';

  @override
  String get error_invalidScheduleType => 'Choose a timing type';

  @override
  String get error_useAdjustment =>
      'This batch has history; use Adjust stock to change its quantity';

  @override
  String get error_negativeStock => 'Stock cannot become negative';

  @override
  String get error_insufficientStock => 'Not enough usable stock';

  @override
  String get error_invalidDoseTransition =>
      'This dose can no longer be changed that way';

  @override
  String get error_doseWindowClosed =>
      'This dose is past its allowed window and is now missed';

  @override
  String get error_actualQuantityZero =>
      'Nothing was taken, so the dose was not recorded';

  @override
  String get error_batchNotUsable =>
      'That batch cannot be used (expired, empty or deleted)';

  @override
  String get error_allocationTotalMismatch =>
      'The chosen batches must add up to the quantity taken';

  @override
  String get error_invalidAllocation => 'Invalid batch quantities';

  @override
  String get error_batchHasHistory =>
      'Batches with consumption history cannot be deleted permanently';

  @override
  String get error_mealInUse => 'This meal is used by a schedule';

  @override
  String get error_valueRequired => 'Please enter a value';

  @override
  String get error_doctorRequired => 'Please enter the doctor\'s name';

  @override
  String get error_patientAlreadyExists =>
      'This person already has a patient profile';

  @override
  String get error_invalidPrice => 'Price cannot be negative';

  @override
  String get error_invalidDate => 'Invalid date';

  @override
  String get error_invalidPackages => 'Package counts cannot be negative';

  @override
  String get error_invalidReason => 'Choose a reason';

  @override
  String get error_notFound => 'The item no longer exists';

  @override
  String get error_maximumDailyExceeded =>
      'The daily maximum would be exceeded';

  @override
  String get error_unsupportedTrashEntity =>
      'This item cannot be moved to trash';

  @override
  String get error_invalidBackup => 'This file is not a valid BelMiad backup';

  @override
  String get error_newerBackup =>
      'This backup was made by a newer version of the app';

  @override
  String get error_backupPatientMissing =>
      'This backup\'s patient does not exist here';

  @override
  String get error_filesUnsupported =>
      'Files are not supported on this platform';

  @override
  String get dosePlan => 'Dose plan';

  @override
  String get doseTimes => 'Times of day';

  @override
  String get addTime => 'Add time';

  @override
  String get removeTime => 'Remove time';

  @override
  String get quickSetup => 'Quick setup';

  @override
  String get presetOnce => 'Once a day';

  @override
  String get presetTwice => 'Twice a day';

  @override
  String get presetThree => '3 times a day';

  @override
  String get presetFour => '4 times a day';

  @override
  String get presetAfterMeals => 'After each main meal';

  @override
  String get presetBeforeMeals => 'Before each main meal';

  @override
  String get presetEvery8h => 'Every 8 hours';

  @override
  String get presetEvery12h => 'Every 12 hours';

  @override
  String doseTimeNumber(Object number) {
    return 'Time $number';
  }

  @override
  String timesPerDay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count times a day',
      two: 'Twice a day',
      one: 'Once a day',
    );
    return '$_temp0';
  }

  @override
  String get sharedSettings => 'Applies to all times';

  @override
  String get variesByDay => 'varies by day';

  @override
  String get error_timesRequired => 'Add at least one time';

  @override
  String get containsInnerPacks => 'Contains strips';

  @override
  String get innerPackType => 'Inner pack';

  @override
  String innerPacksPer(Object inner, Object outer) {
    return '$inner per $outer';
  }

  @override
  String unitsPer(Object unit, Object pack) {
    return '$unit per $pack';
  }

  @override
  String get looseUnits => 'Extra loose units';

  @override
  String packagingBreakdown(Object breakdown, Object total) {
    return '$breakdown = $total';
  }

  @override
  String get packaging_strip => 'Strip';

  @override
  String get storageOnly => 'Storage only';

  @override
  String get storageOnlyHint =>
      'Keep this medicine in storage without adding it to the patient\'s treatment. No schedules or reminders are created.';

  @override
  String get newStorageMedicine => 'New medicine just for storage';

  @override
  String get startTaking => 'Start taking this medicine';

  @override
  String get moveToStorage => 'Move to storage only';

  @override
  String get storageBadge => 'Storage';

  @override
  String get filterActive => 'Active';

  @override
  String get filterArchived => 'Archived';

  @override
  String get filterStorage => 'Storage';

  @override
  String timeInZone(Object timezone) {
    return '$timezone time';
  }

  @override
  String get mealTimeMode => 'Meal time';

  @override
  String get sameEveryDay => 'Same every day';

  @override
  String get differentByDay => 'Different by weekday';

  @override
  String get mealWeeklyNote =>
      'Set a time for each day. Days left empty use the default time.';

  @override
  String get measurementContext => 'When was it measured?';

  @override
  String get context_random => 'Any time';

  @override
  String get context_fasting => 'Fasting';

  @override
  String get context_before_meal => 'Before a meal';

  @override
  String get context_after_meal => 'After a meal';

  @override
  String get context_after_medication => 'After taking medicine';

  @override
  String get relatedMeal => 'Which meal';

  @override
  String get relatedMedication => 'Which medicine';

  @override
  String get minutesAfter => 'Minutes after';

  @override
  String contextAfterMeal(Object meal, Object minutes) {
    return 'After $meal · $minutes min';
  }

  @override
  String contextAfterMedication(Object medicine, Object minutes) {
    return 'After $medicine · $minutes min';
  }

  @override
  String get takePhoto => 'Take photo';

  @override
  String get addPage => 'Add another page';

  @override
  String pagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages',
      one: '1 page',
    );
    return '$_temp0';
  }

  @override
  String get saveAs => 'Save as';

  @override
  String get formatPhoto => 'Photo';

  @override
  String get formatPdf => 'PDF';

  @override
  String get multiPagePdfNote => 'Several pages are saved as one PDF.';

  @override
  String get cameraPermissionDenied =>
      'Camera access is off. Allow it to photograph prescriptions.';

  @override
  String get openSettings => 'Open settings';

  @override
  String get groupBy => 'Group by';

  @override
  String get groupDoctor => 'Doctor';

  @override
  String get groupDate => 'Date';

  @override
  String get groupFileType => 'File type';

  @override
  String get unknownDoctor => 'Unknown doctor';

  @override
  String get noDate => 'No date';

  @override
  String get fileType_image => 'Photos';

  @override
  String get fileType_pdf => 'PDF documents';

  @override
  String get fileType_other => 'Other files';

  @override
  String get error_cameraDenied => 'Camera access was denied';

  @override
  String get whenTaken => 'When was it taken?';

  @override
  String get takenNow => 'Now';

  @override
  String get takenEarlier => 'Earlier';

  @override
  String get intakeTime => 'Time the patient took it';

  @override
  String get recordLaterHint =>
      'Use this when the patient took the dose alone and you are recording it afterwards.';

  @override
  String get recordAsTaken => 'Record as taken';

  @override
  String get recordedLater => 'Recorded later';

  @override
  String recordedLaterAt(Object taken, Object recorded) {
    return 'Taken at $taken · recorded at $recorded';
  }

  @override
  String get missedCorrectionHint =>
      'Taken but not recorded? Enter the time the patient took it.';

  @override
  String get audit_dose_recorded_late => 'Dose recorded later';

  @override
  String get error_takenInFuture => 'The intake time can\'t be in the future';

  @override
  String get error_takenTooEarly =>
      'That time is too long before the scheduled dose';

  @override
  String get error_invalidPartialPack =>
      'Units left in an opened pack can\'t be more than it holds';

  @override
  String get openedPacks => 'Opened or incomplete packs';

  @override
  String get addOpenedPack => 'Add opened pack';

  @override
  String get openedPacksHint =>
      'For example a strip with 9 of 14 tablets left, or a box with some strips used.';

  @override
  String get unitsLeft => 'Units left';

  @override
  String get packCapacity => 'Holds when full';

  @override
  String partialPackOf(Object pack, Object remaining, Object capacity) {
    return '$pack $remaining of $capacity';
  }

  @override
  String get reminderSound => 'Reminder sound';

  @override
  String get reminderSoundHint =>
      'Plays when a dose reminder or missed-dose alert pops up. Reminders already scheduled switch to the new sound.';

  @override
  String get soundDefault => 'Phone default';

  @override
  String get soundChime => 'Chime';

  @override
  String get soundBell => 'Bell';

  @override
  String get soundGentle => 'Gentle';

  @override
  String get soundAlert => 'Alert beeps';

  @override
  String get soundFromPhone => 'Choose from phone sounds…';

  @override
  String get soundPhonePicked => 'Phone sound';

  @override
  String get soundSilent => 'Silent (vibrate only)';

  @override
  String get soundPreview => 'Play';

  @override
  String get soundCustomAndroidOnly =>
      'Custom tones and ringtones are available on Android.';

  @override
  String get doseGroupTaken =>
      'All medications in this dose group were marked as taken';

  @override
  String doseGroupPartial(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Dose taken. $count other medications in this group could not be recorded.',
      one:
          'Dose taken. 1 other medication in this group could not be recorded.',
    );
    return '$_temp0';
  }

  @override
  String takeAll(Object count) {
    return 'Take all ($count)';
  }

  @override
  String groupCompletionNote(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'This will also mark $count other medications in this dose group as taken.',
      one:
          'This will also mark 1 other medication in this dose group as taken.',
    );
    return '$_temp0';
  }

  @override
  String get doseCompletion => 'Dose completion';

  @override
  String get doseCompletionCombinedHint =>
      'Taking one medication also marks the other medications scheduled at the same time or for the same meal.';

  @override
  String get doseCompletionSeparateHint =>
      'Each medication is marked as taken on its own.';

  @override
  String get notificationGrouping => 'Notification grouping';

  @override
  String get notificationGroupingCombinedHint =>
      'One notification for all medications at the same time or for the same meal.';

  @override
  String get notificationGroupingSeparateHint =>
      'A separate notification for every medication.';

  @override
  String get modeCombined => 'Combined';

  @override
  String get modeSeparate => 'Separate';

  @override
  String get fontSize => 'Font size';

  @override
  String get fontSize_standard => 'Standard';

  @override
  String get fontSize_medium => 'Medium';

  @override
  String get fontSize_large => 'Large';

  @override
  String get fontSize_larger => 'Extra large';

  @override
  String get fontSize_maximum => 'Maximum';

  @override
  String get fontSizePreview => 'Your next dose: 1 tablet after lunch.';

  @override
  String get notificationRetentionNote =>
      'Notifications are removed automatically after 7 days.';

  @override
  String get markAsRead => 'Mark as read';

  @override
  String get markAsUnread => 'Mark as unread';

  @override
  String get moreOptions => 'More options';

  @override
  String get notificationRead => 'Read';

  @override
  String get unread => 'Unread';

  @override
  String get deleteReadNotifications => 'Delete read notifications';

  @override
  String get deleteAllNotifications => 'Delete all notifications';

  @override
  String get deleteNotificationsBody =>
      'This removes them from the notification list. Scheduled reminders are not affected.';

  @override
  String stripRemaining(Object remaining, Object total, Object unit) {
    return '$remaining of $total $unit remaining';
  }

  @override
  String stripExtra(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+ $count more full strips',
      one: '+ 1 more full strip',
    );
    return '$_temp0';
  }

  @override
  String stripTapHint(Object unit) {
    return 'Tap a remaining $unit to mark it as used';
  }

  @override
  String stripUnitUsed(Object quantity) {
    return 'Marked $quantity as used';
  }

  @override
  String stripCellRemaining(Object index, Object total) {
    return '$index of $total, remaining. Double tap to mark as used.';
  }

  @override
  String stripCellUsed(Object index, Object total) {
    return '$index of $total, already used';
  }

  @override
  String get stripUseOne => 'Use one';

  @override
  String get stripDisabledExpired =>
      'This batch has expired, so it cannot be used from the strip.';

  @override
  String get reason_strip_use => 'Marked as used from the strip';

  @override
  String get addMedicationNextTitle => 'Medication added';

  @override
  String get addMedicationNextBody =>
      'What would you like to do next? You can do any of this later.';

  @override
  String get setSchedule => 'Set up schedule';

  @override
  String get viewMedication => 'View medication';

  @override
  String get duplicateMedicationTitle => 'Already in your list';

  @override
  String duplicateMedicationBody(Object name) {
    return '$name is already in this patient\'s medications. Open it instead of adding a duplicate?';
  }

  @override
  String get openExisting => 'Open existing';

  @override
  String get addAnyway => 'Add anyway';

  @override
  String get thisMonth => 'This month';

  @override
  String get blisterPickHint =>
      'Tap the tablets that are already used. They will show as empty.';

  @override
  String stripMaxUnits(Object max) {
    return 'A strip holds at most $max units';
  }

  @override
  String get error_halfStepOnly =>
      'Only whole or half tablets are allowed (for example 1 or 1.5)';

  @override
  String get error_wholeUnitsOnly =>
      'Only whole numbers are allowed for this medicine';

  @override
  String get fullPacksHint => 'Use 0 if you only have an opened pack';

  @override
  String get blisterPickHintHalf =>
      'Tap a tablet to change it: full, half, or empty.';

  @override
  String stripCellHalf(Object index, Object total) {
    return '$index of $total, half a tablet left. Double tap to change.';
  }

  @override
  String get fullPacksMode => 'Full packs';

  @override
  String get openedOnlyMode => 'Only an incomplete pack';
}
