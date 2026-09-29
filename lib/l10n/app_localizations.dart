import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'BelMiad'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Medicines on time, offline'**
  String get appTagline;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @permanentlyDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete permanently'**
  String get permanentlyDelete;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @unarchive.
  ///
  /// In en, this message translates to:
  /// **'Unarchive'**
  String get unarchive;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong: {message}'**
  String errorGeneric(Object message);

  /// No description provided for @savedMessage.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedMessage;

  /// No description provided for @deletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Moved to trash'**
  String get deletedMessage;

  /// No description provided for @navToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// No description provided for @navMedications.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get navMedications;

  /// No description provided for @navInventory.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get navInventory;

  /// No description provided for @navHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get navHealth;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to BelMiad'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Track medicines, doses, stock and health records for yourself or the people you care for. Everything stays on this phone and works offline.'**
  String get welcomeBody;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @whoAreYou.
  ///
  /// In en, this message translates to:
  /// **'Who is using this phone?'**
  String get whoAreYou;

  /// No description provided for @whoAreYouHint.
  ///
  /// In en, this message translates to:
  /// **'Your name is attached to the actions you record (doses, stock changes). This is not a login and has no password.'**
  String get whoAreYouHint;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @firstPatientTitle.
  ///
  /// In en, this message translates to:
  /// **'Who are you caring for?'**
  String get firstPatientTitle;

  /// No description provided for @patientIsMe.
  ///
  /// In en, this message translates to:
  /// **'Myself'**
  String get patientIsMe;

  /// No description provided for @patientIsSomeoneElse.
  ///
  /// In en, this message translates to:
  /// **'Someone else'**
  String get patientIsSomeoneElse;

  /// No description provided for @relationshipLabel.
  ///
  /// In en, this message translates to:
  /// **'Relationship (e.g. Mother)'**
  String get relationshipLabel;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @patients.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patients;

  /// No description provided for @patient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get patient;

  /// No description provided for @addPatient.
  ///
  /// In en, this message translates to:
  /// **'Add patient'**
  String get addPatient;

  /// No description provided for @editPatient.
  ///
  /// In en, this message translates to:
  /// **'Edit patient'**
  String get editPatient;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirth;

  /// No description provided for @sex.
  ///
  /// In en, this message translates to:
  /// **'Sex'**
  String get sex;

  /// No description provided for @sexMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get sexMale;

  /// No description provided for @sexFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get sexFemale;

  /// No description provided for @bloodType.
  ///
  /// In en, this message translates to:
  /// **'Blood type'**
  String get bloodType;

  /// No description provided for @emergencyContactName.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact name'**
  String get emergencyContactName;

  /// No description provided for @emergencyContactPhone.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact phone'**
  String get emergencyContactPhone;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @timezone.
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get timezone;

  /// No description provided for @timezoneHint.
  ///
  /// In en, this message translates to:
  /// **'Dose times keep the same local clock time when the timezone changes.'**
  String get timezoneHint;

  /// No description provided for @switchPatient.
  ///
  /// In en, this message translates to:
  /// **'Switch patient'**
  String get switchPatient;

  /// No description provided for @currentPatient.
  ///
  /// In en, this message translates to:
  /// **'Current patient'**
  String get currentPatient;

  /// No description provided for @noPatients.
  ///
  /// In en, this message translates to:
  /// **'No patients yet'**
  String get noPatients;

  /// No description provided for @noPatientSelected.
  ///
  /// In en, this message translates to:
  /// **'Select or add a patient to continue'**
  String get noPatientSelected;

  /// No description provided for @deletePatientTitle.
  ///
  /// In en, this message translates to:
  /// **'Move patient to trash?'**
  String get deletePatientTitle;

  /// No description provided for @deletePatientBody.
  ///
  /// In en, this message translates to:
  /// **'{name} and all their data will move to trash. You can restore them later or delete them permanently.'**
  String deletePatientBody(Object name);

  /// No description provided for @ageYears.
  ///
  /// In en, this message translates to:
  /// **'{years} years'**
  String ageYears(Object years);

  /// No description provided for @caregivers.
  ///
  /// In en, this message translates to:
  /// **'Caregivers'**
  String get caregivers;

  /// No description provided for @addCaregiver.
  ///
  /// In en, this message translates to:
  /// **'Add caregiver'**
  String get addCaregiver;

  /// No description provided for @removeCaregiver.
  ///
  /// In en, this message translates to:
  /// **'Remove caregiver'**
  String get removeCaregiver;

  /// No description provided for @removeCaregiverBody.
  ///
  /// In en, this message translates to:
  /// **'{name} will no longer be listed as a caregiver. Their past actions stay in the history.'**
  String removeCaregiverBody(Object name);

  /// No description provided for @selectPerson.
  ///
  /// In en, this message translates to:
  /// **'Select a person'**
  String get selectPerson;

  /// No description provided for @newPerson.
  ///
  /// In en, this message translates to:
  /// **'New person'**
  String get newPerson;

  /// No description provided for @relationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get relationship;

  /// No description provided for @relationshipSelf.
  ///
  /// In en, this message translates to:
  /// **'Self'**
  String get relationshipSelf;

  /// No description provided for @deviceCaregiver.
  ///
  /// In en, this message translates to:
  /// **'Caregiver on this phone'**
  String get deviceCaregiver;

  /// No description provided for @changeCaregiver.
  ///
  /// In en, this message translates to:
  /// **'Change caregiver'**
  String get changeCaregiver;

  /// No description provided for @caregiverSwitched.
  ///
  /// In en, this message translates to:
  /// **'Now recording as {name}'**
  String caregiverSwitched(Object name);

  /// No description provided for @medications.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get medications;

  /// No description provided for @medication.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get medication;

  /// No description provided for @addMedication.
  ///
  /// In en, this message translates to:
  /// **'Add medicine'**
  String get addMedication;

  /// No description provided for @editMedication.
  ///
  /// In en, this message translates to:
  /// **'Edit medicine'**
  String get editMedication;

  /// No description provided for @searchCatalog.
  ///
  /// In en, this message translates to:
  /// **'Search Egyptian drug catalog'**
  String get searchCatalog;

  /// No description provided for @searchCatalogHint.
  ///
  /// In en, this message translates to:
  /// **'Type at least 2 letters, English or Arabic'**
  String get searchCatalogHint;

  /// No description provided for @noCatalogResults.
  ///
  /// In en, this message translates to:
  /// **'No catalog match'**
  String get noCatalogResults;

  /// No description provided for @addCustomMedication.
  ///
  /// In en, this message translates to:
  /// **'Add custom medicine'**
  String get addCustomMedication;

  /// No description provided for @catalogPrice.
  ///
  /// In en, this message translates to:
  /// **'Catalog price: EGP {price}'**
  String catalogPrice(Object price);

  /// No description provided for @referencePriceNote.
  ///
  /// In en, this message translates to:
  /// **'Reference price only. Actual purchase prices are recorded with stock.'**
  String get referencePriceNote;

  /// No description provided for @recentlySelected.
  ///
  /// In en, this message translates to:
  /// **'Recently selected'**
  String get recentlySelected;

  /// No description provided for @fromCatalog.
  ///
  /// In en, this message translates to:
  /// **'From catalog'**
  String get fromCatalog;

  /// No description provided for @nameEn.
  ///
  /// In en, this message translates to:
  /// **'Name (English)'**
  String get nameEn;

  /// No description provided for @nameAr.
  ///
  /// In en, this message translates to:
  /// **'Name (Arabic)'**
  String get nameAr;

  /// No description provided for @scientificName.
  ///
  /// In en, this message translates to:
  /// **'Scientific / generic name'**
  String get scientificName;

  /// No description provided for @strength.
  ///
  /// In en, this message translates to:
  /// **'Strength (e.g. 500 mg)'**
  String get strength;

  /// No description provided for @dosageForm.
  ///
  /// In en, this message translates to:
  /// **'Dosage form'**
  String get dosageForm;

  /// No description provided for @route.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get route;

  /// No description provided for @doseUnit.
  ///
  /// In en, this message translates to:
  /// **'Dose unit'**
  String get doseUnit;

  /// No description provided for @instructionsEn.
  ///
  /// In en, this message translates to:
  /// **'Instructions (English)'**
  String get instructionsEn;

  /// No description provided for @instructionsAr.
  ///
  /// In en, this message translates to:
  /// **'Instructions (Arabic)'**
  String get instructionsAr;

  /// No description provided for @instructionsSeparateNote.
  ///
  /// In en, this message translates to:
  /// **'English and Arabic instructions are entered separately and never auto-translated.'**
  String get instructionsSeparateNote;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get endDate;

  /// No description provided for @prn.
  ///
  /// In en, this message translates to:
  /// **'As needed (PRN)'**
  String get prn;

  /// No description provided for @prnHint.
  ///
  /// In en, this message translates to:
  /// **'Doses are recorded when taken; no reminders are generated.'**
  String get prnHint;

  /// No description provided for @maximumDaily.
  ///
  /// In en, this message translates to:
  /// **'Maximum per day'**
  String get maximumDaily;

  /// No description provided for @maximumDailyHint.
  ///
  /// In en, this message translates to:
  /// **'Warns before the daily maximum is exceeded'**
  String get maximumDailyHint;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get statusArchived;

  /// No description provided for @showArchived.
  ///
  /// In en, this message translates to:
  /// **'Show archived'**
  String get showArchived;

  /// No description provided for @deleteMedicationTitle.
  ///
  /// In en, this message translates to:
  /// **'Move medicine to trash?'**
  String get deleteMedicationTitle;

  /// No description provided for @deleteMedicationBody.
  ///
  /// In en, this message translates to:
  /// **'Dose history and stock history are kept and can be restored.'**
  String get deleteMedicationBody;

  /// No description provided for @noMedications.
  ///
  /// In en, this message translates to:
  /// **'No medicines yet'**
  String get noMedications;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @schedules.
  ///
  /// In en, this message translates to:
  /// **'Schedules'**
  String get schedules;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get inventory;

  /// No description provided for @doseHistory.
  ///
  /// In en, this message translates to:
  /// **'Dose history'**
  String get doseHistory;

  /// No description provided for @addStockNowTitle.
  ///
  /// In en, this message translates to:
  /// **'Add stock now?'**
  String get addStockNowTitle;

  /// No description provided for @addStockNowBody.
  ///
  /// In en, this message translates to:
  /// **'You can record the stock you have for this medicine now, or later from the Stock tab.'**
  String get addStockNowBody;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @prnBadge.
  ///
  /// In en, this message translates to:
  /// **'PRN'**
  String get prnBadge;

  /// No description provided for @maxPerDay.
  ///
  /// In en, this message translates to:
  /// **'Max {quantity} per day'**
  String maxPerDay(Object quantity);

  /// No description provided for @unit_tablet.
  ///
  /// In en, this message translates to:
  /// **'tablet'**
  String get unit_tablet;

  /// No description provided for @unit_capsule.
  ///
  /// In en, this message translates to:
  /// **'capsule'**
  String get unit_capsule;

  /// No description provided for @unit_ml.
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get unit_ml;

  /// No description provided for @unit_drop.
  ///
  /// In en, this message translates to:
  /// **'drop'**
  String get unit_drop;

  /// No description provided for @unit_puff.
  ///
  /// In en, this message translates to:
  /// **'puff'**
  String get unit_puff;

  /// No description provided for @unit_sachet.
  ///
  /// In en, this message translates to:
  /// **'sachet'**
  String get unit_sachet;

  /// No description provided for @unit_injection.
  ///
  /// In en, this message translates to:
  /// **'injection'**
  String get unit_injection;

  /// No description provided for @unit_patch.
  ///
  /// In en, this message translates to:
  /// **'patch'**
  String get unit_patch;

  /// No description provided for @unit_suppository.
  ///
  /// In en, this message translates to:
  /// **'suppository'**
  String get unit_suppository;

  /// No description provided for @unit_application.
  ///
  /// In en, this message translates to:
  /// **'application'**
  String get unit_application;

  /// No description provided for @unit_mg.
  ///
  /// In en, this message translates to:
  /// **'mg'**
  String get unit_mg;

  /// No description provided for @unit_g.
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get unit_g;

  /// No description provided for @unit_unit.
  ///
  /// In en, this message translates to:
  /// **'unit'**
  String get unit_unit;

  /// No description provided for @addSchedule.
  ///
  /// In en, this message translates to:
  /// **'Add schedule'**
  String get addSchedule;

  /// No description provided for @editSchedule.
  ///
  /// In en, this message translates to:
  /// **'Edit schedule'**
  String get editSchedule;

  /// No description provided for @scheduleType.
  ///
  /// In en, this message translates to:
  /// **'Timing'**
  String get scheduleType;

  /// No description provided for @fixedTime.
  ///
  /// In en, this message translates to:
  /// **'Fixed time'**
  String get fixedTime;

  /// No description provided for @mealRelative.
  ///
  /// In en, this message translates to:
  /// **'Relative to a meal'**
  String get mealRelative;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @meal.
  ///
  /// In en, this message translates to:
  /// **'Meal'**
  String get meal;

  /// No description provided for @beforeMeal.
  ///
  /// In en, this message translates to:
  /// **'Before meal'**
  String get beforeMeal;

  /// No description provided for @withMeal.
  ///
  /// In en, this message translates to:
  /// **'With meal'**
  String get withMeal;

  /// No description provided for @afterMeal.
  ///
  /// In en, this message translates to:
  /// **'After meal'**
  String get afterMeal;

  /// No description provided for @offsetMinutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get offsetMinutes;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @recurrence.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get recurrence;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Selected weekdays'**
  String get weekly;

  /// No description provided for @everyNDays.
  ///
  /// In en, this message translates to:
  /// **'Every N days'**
  String get everyNDays;

  /// No description provided for @customCycle.
  ///
  /// In en, this message translates to:
  /// **'Custom cycle'**
  String get customCycle;

  /// No description provided for @intervalDays.
  ///
  /// In en, this message translates to:
  /// **'Every how many days'**
  String get intervalDays;

  /// No description provided for @intervalWeeks.
  ///
  /// In en, this message translates to:
  /// **'Every how many weeks'**
  String get intervalWeeks;

  /// No description provided for @onDays.
  ///
  /// In en, this message translates to:
  /// **'Active days'**
  String get onDays;

  /// No description provided for @offDays.
  ///
  /// In en, this message translates to:
  /// **'Pause days'**
  String get offDays;

  /// No description provided for @cycleStart.
  ///
  /// In en, this message translates to:
  /// **'Cycle start date'**
  String get cycleStart;

  /// No description provided for @differentQuantityByDay.
  ///
  /// In en, this message translates to:
  /// **'Different quantity on some days'**
  String get differentQuantityByDay;

  /// No description provided for @validFrom.
  ///
  /// In en, this message translates to:
  /// **'From date'**
  String get validFrom;

  /// No description provided for @validUntil.
  ///
  /// In en, this message translates to:
  /// **'Until date'**
  String get validUntil;

  /// No description provided for @noSchedules.
  ///
  /// In en, this message translates to:
  /// **'No schedules'**
  String get noSchedules;

  /// No description provided for @deleteScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete schedule?'**
  String get deleteScheduleTitle;

  /// No description provided for @deleteScheduleBody.
  ///
  /// In en, this message translates to:
  /// **'Future doses from this schedule are removed. Past doses stay in the history.'**
  String get deleteScheduleBody;

  /// No description provided for @prnPlannedNote.
  ///
  /// In en, this message translates to:
  /// **'For as-needed medicines, schedules are only a planned frequency used for stock forecasting.'**
  String get prnPlannedNote;

  /// No description provided for @scheduleEveryDay.
  ///
  /// In en, this message translates to:
  /// **'every day'**
  String get scheduleEveryDay;

  /// No description provided for @scheduleEveryNDays.
  ///
  /// In en, this message translates to:
  /// **'every {count} days'**
  String scheduleEveryNDays(Object count);

  /// No description provided for @scheduleWeekdays.
  ///
  /// In en, this message translates to:
  /// **'on {days}'**
  String scheduleWeekdays(Object days);

  /// No description provided for @scheduleEveryNWeeks.
  ///
  /// In en, this message translates to:
  /// **'every {count} weeks on {days}'**
  String scheduleEveryNWeeks(Object count, Object days);

  /// No description provided for @scheduleCycle.
  ///
  /// In en, this message translates to:
  /// **'{on} days on, {off} days off'**
  String scheduleCycle(Object off, Object on);

  /// No description provided for @scheduleBeforeMeal.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min before {meal}'**
  String scheduleBeforeMeal(Object meal, Object minutes);

  /// No description provided for @scheduleAfterMeal.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min after {meal}'**
  String scheduleAfterMeal(Object meal, Object minutes);

  /// No description provided for @scheduleWithMeal.
  ///
  /// In en, this message translates to:
  /// **'with {meal}'**
  String scheduleWithMeal(Object meal);

  /// No description provided for @todayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayTitle;

  /// No description provided for @noDoses.
  ///
  /// In en, this message translates to:
  /// **'No doses on this day'**
  String get noDoses;

  /// No description provided for @take.
  ///
  /// In en, this message translates to:
  /// **'Take'**
  String get take;

  /// No description provided for @taken.
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get taken;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @skipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get skipped;

  /// No description provided for @missed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get missed;

  /// No description provided for @scheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduled;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @undoTake.
  ///
  /// In en, this message translates to:
  /// **'Undo taken'**
  String get undoTake;

  /// No description provided for @undoTakeBody.
  ///
  /// In en, this message translates to:
  /// **'The dose returns to scheduled and the exact stock is restored to its original batches.'**
  String get undoTakeBody;

  /// No description provided for @skipDoseTitle.
  ///
  /// In en, this message translates to:
  /// **'Skip this dose?'**
  String get skipDoseTitle;

  /// No description provided for @skipDoseBody.
  ///
  /// In en, this message translates to:
  /// **'A skipped dose cannot be taken later.'**
  String get skipDoseBody;

  /// No description provided for @takenAt.
  ///
  /// In en, this message translates to:
  /// **'Taken at {time}'**
  String takenAt(Object time);

  /// No description provided for @lateBy.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min late'**
  String lateBy(Object minutes);

  /// No description provided for @onTime.
  ///
  /// In en, this message translates to:
  /// **'On time'**
  String get onTime;

  /// No description provided for @logPrn.
  ///
  /// In en, this message translates to:
  /// **'Log as-needed dose'**
  String get logPrn;

  /// No description provided for @howMuchTaken.
  ///
  /// In en, this message translates to:
  /// **'How much was actually taken?'**
  String get howMuchTaken;

  /// No description provided for @insufficientStockTitle.
  ///
  /// In en, this message translates to:
  /// **'Not enough stock'**
  String get insufficientStockTitle;

  /// No description provided for @insufficientStockBody.
  ///
  /// In en, this message translates to:
  /// **'Required {required}, but only {available} is available in usable stock.'**
  String insufficientStockBody(Object available, Object required);

  /// No description provided for @customAmount.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customAmount;

  /// No description provided for @leaveScheduled.
  ///
  /// In en, this message translates to:
  /// **'Leave scheduled'**
  String get leaveScheduled;

  /// No description provided for @zeroTakenNote.
  ///
  /// In en, this message translates to:
  /// **'Nothing was taken. The dose is not marked taken and no stock is used.'**
  String get zeroTakenNote;

  /// No description provided for @maxExceededTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily maximum would be exceeded'**
  String get maxExceededTitle;

  /// No description provided for @maxExceededBody.
  ///
  /// In en, this message translates to:
  /// **'Maximum {maximum} per day. Already taken today: {taken}. This dose: {attempt}.'**
  String maxExceededBody(Object attempt, Object maximum, Object taken);

  /// No description provided for @recordAnyway.
  ///
  /// In en, this message translates to:
  /// **'Record anyway'**
  String get recordAnyway;

  /// No description provided for @doseWindowClosed.
  ///
  /// In en, this message translates to:
  /// **'This dose is past its allowed window and is now missed.'**
  String get doseWindowClosed;

  /// No description provided for @chooseBatches.
  ///
  /// In en, this message translates to:
  /// **'Stock batches'**
  String get chooseBatches;

  /// No description provided for @automaticFefo.
  ///
  /// In en, this message translates to:
  /// **'Automatic (first expiring first)'**
  String get automaticFefo;

  /// No description provided for @manualSelection.
  ///
  /// In en, this message translates to:
  /// **'Choose batches'**
  String get manualSelection;

  /// No description provided for @allocatedOf.
  ///
  /// In en, this message translates to:
  /// **'Allocated {allocated} of {required}'**
  String allocatedOf(Object allocated, Object required);

  /// No description provided for @stockNotRecordedNote.
  ///
  /// In en, this message translates to:
  /// **'Stock is not recorded for this medicine; no stock will be deducted.'**
  String get stockNotRecordedNote;

  /// No description provided for @requiredQuantity.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredQuantity;

  /// No description provided for @actualQuantity.
  ///
  /// In en, this message translates to:
  /// **'Actually taken'**
  String get actualQuantity;

  /// No description provided for @confirmTake.
  ///
  /// In en, this message translates to:
  /// **'Mark taken'**
  String get confirmTake;

  /// No description provided for @doseTaken.
  ///
  /// In en, this message translates to:
  /// **'Dose recorded'**
  String get doseTaken;

  /// No description provided for @doseSkippedMessage.
  ///
  /// In en, this message translates to:
  /// **'Dose skipped'**
  String get doseSkippedMessage;

  /// No description provided for @doseUndone.
  ///
  /// In en, this message translates to:
  /// **'Dose restored to scheduled'**
  String get doseUndone;

  /// No description provided for @upcomingAppointment.
  ///
  /// In en, this message translates to:
  /// **'Next appointment'**
  String get upcomingAppointment;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @dosesDone.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} doses taken'**
  String dosesDone(Object done, Object total);

  /// No description provided for @partialDose.
  ///
  /// In en, this message translates to:
  /// **'Partial: {actual} of {required}'**
  String partialDose(Object actual, Object required);

  /// No description provided for @prnTaken.
  ///
  /// In en, this message translates to:
  /// **'As needed'**
  String get prnTaken;

  /// No description provided for @inventoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get inventoryTitle;

  /// No description provided for @totalMedications.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get totalMedications;

  /// No description provided for @withStock.
  ///
  /// In en, this message translates to:
  /// **'With stock'**
  String get withStock;

  /// No description provided for @lowStock.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get lowStock;

  /// No description provided for @emptyStock.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get emptyStock;

  /// No description provided for @expiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring soon'**
  String get expiringSoon;

  /// No description provided for @stockNotRecorded.
  ///
  /// In en, this message translates to:
  /// **'Stock not recorded'**
  String get stockNotRecorded;

  /// No description provided for @stockNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get stockNormal;

  /// No description provided for @stockLow.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get stockLow;

  /// No description provided for @stockEmpty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get stockEmpty;

  /// No description provided for @stockExpiredOnly.
  ///
  /// In en, this message translates to:
  /// **'Expired only'**
  String get stockExpiredOnly;

  /// No description provided for @stockExpiring.
  ///
  /// In en, this message translates to:
  /// **'Expiring soon'**
  String get stockExpiring;

  /// No description provided for @daysRemaining.
  ///
  /// In en, this message translates to:
  /// **'~{count} days remaining'**
  String daysRemaining(Object count);

  /// No description provided for @dayRemaining.
  ///
  /// In en, this message translates to:
  /// **'~1 day remaining'**
  String get dayRemaining;

  /// No description provided for @lessThanDay.
  ///
  /// In en, this message translates to:
  /// **'Less than a day'**
  String get lessThanDay;

  /// No description provided for @noForecast.
  ///
  /// In en, this message translates to:
  /// **'No scheduled use'**
  String get noForecast;

  /// No description provided for @addStock.
  ///
  /// In en, this message translates to:
  /// **'Add stock'**
  String get addStock;

  /// No description provided for @selectMedication.
  ///
  /// In en, this message translates to:
  /// **'Select medicine'**
  String get selectMedication;

  /// No description provided for @byPackages.
  ///
  /// In en, this message translates to:
  /// **'By packages'**
  String get byPackages;

  /// No description provided for @byQuantity.
  ///
  /// In en, this message translates to:
  /// **'By quantity'**
  String get byQuantity;

  /// No description provided for @packagingType.
  ///
  /// In en, this message translates to:
  /// **'Packaging'**
  String get packagingType;

  /// No description provided for @packagesCount.
  ///
  /// In en, this message translates to:
  /// **'Packages'**
  String get packagesCount;

  /// No description provided for @unitsPerPackage.
  ///
  /// In en, this message translates to:
  /// **'Units per package'**
  String get unitsPerPackage;

  /// No description provided for @availableQuantity.
  ///
  /// In en, this message translates to:
  /// **'Available quantity'**
  String get availableQuantity;

  /// No description provided for @packagesTotal.
  ///
  /// In en, this message translates to:
  /// **'Total: {quantity}'**
  String packagesTotal(Object quantity);

  /// No description provided for @purchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Purchase date'**
  String get purchaseDate;

  /// No description provided for @purchasePrice.
  ///
  /// In en, this message translates to:
  /// **'Purchase price (EGP)'**
  String get purchasePrice;

  /// No description provided for @expirationDate.
  ///
  /// In en, this message translates to:
  /// **'Expiration date'**
  String get expirationDate;

  /// No description provided for @totalQuantity.
  ///
  /// In en, this message translates to:
  /// **'Total usable'**
  String get totalQuantity;

  /// No description provided for @batches.
  ///
  /// In en, this message translates to:
  /// **'Batches'**
  String get batches;

  /// No description provided for @noBatches.
  ///
  /// In en, this message translates to:
  /// **'No batches recorded'**
  String get noBatches;

  /// No description provided for @depleted.
  ///
  /// In en, this message translates to:
  /// **'Depleted'**
  String get depleted;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @expiresToday.
  ///
  /// In en, this message translates to:
  /// **'Expires today'**
  String get expiresToday;

  /// No description provided for @expiresInDays.
  ///
  /// In en, this message translates to:
  /// **'Expires in {count} days'**
  String expiresInDays(Object count);

  /// No description provided for @expiresOn.
  ///
  /// In en, this message translates to:
  /// **'Expires {date}'**
  String expiresOn(Object date);

  /// No description provided for @noExpiry.
  ///
  /// In en, this message translates to:
  /// **'No expiry date'**
  String get noExpiry;

  /// No description provided for @adjustStock.
  ///
  /// In en, this message translates to:
  /// **'Adjust stock'**
  String get adjustStock;

  /// No description provided for @addQuantity.
  ///
  /// In en, this message translates to:
  /// **'Add quantity'**
  String get addQuantity;

  /// No description provided for @removeQuantity.
  ///
  /// In en, this message translates to:
  /// **'Remove quantity'**
  String get removeQuantity;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @reason_manual_correction.
  ///
  /// In en, this message translates to:
  /// **'Manual correction'**
  String get reason_manual_correction;

  /// No description provided for @reason_damaged.
  ///
  /// In en, this message translates to:
  /// **'Damaged medication'**
  String get reason_damaged;

  /// No description provided for @reason_lost.
  ///
  /// In en, this message translates to:
  /// **'Lost medication'**
  String get reason_lost;

  /// No description provided for @reason_returned.
  ///
  /// In en, this message translates to:
  /// **'Returned medication'**
  String get reason_returned;

  /// No description provided for @reason_count_correction.
  ///
  /// In en, this message translates to:
  /// **'Count correction'**
  String get reason_count_correction;

  /// No description provided for @reason_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get reason_other;

  /// No description provided for @adjustmentHistory.
  ///
  /// In en, this message translates to:
  /// **'Adjustments'**
  String get adjustmentHistory;

  /// No description provided for @consumptionHistory.
  ///
  /// In en, this message translates to:
  /// **'Consumption'**
  String get consumptionHistory;

  /// No description provided for @editBatch.
  ///
  /// In en, this message translates to:
  /// **'Edit batch'**
  String get editBatch;

  /// No description provided for @deleteBatchTitle.
  ///
  /// In en, this message translates to:
  /// **'Move batch to trash?'**
  String get deleteBatchTitle;

  /// No description provided for @deleteBatchBody.
  ///
  /// In en, this message translates to:
  /// **'The batch and its history are kept in trash and can be restored.'**
  String get deleteBatchBody;

  /// No description provided for @useAdjustmentNote.
  ///
  /// In en, this message translates to:
  /// **'This batch has history, so quantity changes must be recorded as adjustments.'**
  String get useAdjustmentNote;

  /// No description provided for @packaging_box.
  ///
  /// In en, this message translates to:
  /// **'Box'**
  String get packaging_box;

  /// No description provided for @packaging_blister.
  ///
  /// In en, this message translates to:
  /// **'Blister'**
  String get packaging_blister;

  /// No description provided for @packaging_bottle.
  ///
  /// In en, this message translates to:
  /// **'Bottle'**
  String get packaging_bottle;

  /// No description provided for @packaging_tube.
  ///
  /// In en, this message translates to:
  /// **'Tube'**
  String get packaging_tube;

  /// No description provided for @packaging_sachet.
  ///
  /// In en, this message translates to:
  /// **'Sachet'**
  String get packaging_sachet;

  /// No description provided for @packaging_vial.
  ///
  /// In en, this message translates to:
  /// **'Vial'**
  String get packaging_vial;

  /// No description provided for @packaging_ampoule.
  ///
  /// In en, this message translates to:
  /// **'Ampoule'**
  String get packaging_ampoule;

  /// No description provided for @packaging_container.
  ///
  /// In en, this message translates to:
  /// **'Container'**
  String get packaging_container;

  /// No description provided for @packaging_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get packaging_other;

  /// No description provided for @quantityChange.
  ///
  /// In en, this message translates to:
  /// **'{previous} → {next}'**
  String quantityChange(Object next, Object previous);

  /// No description provided for @consumedForDose.
  ///
  /// In en, this message translates to:
  /// **'Dose {date}'**
  String consumedForDose(Object date);

  /// No description provided for @reversed.
  ///
  /// In en, this message translates to:
  /// **'Reversed (undo)'**
  String get reversed;

  /// No description provided for @manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// No description provided for @storageReport.
  ///
  /// In en, this message translates to:
  /// **'Storage report'**
  String get storageReport;

  /// No description provided for @needsPurchase.
  ///
  /// In en, this message translates to:
  /// **'Needs purchase'**
  String get needsPurchase;

  /// No description provided for @batchCount.
  ///
  /// In en, this message translates to:
  /// **'Batches'**
  String get batchCount;

  /// No description provided for @earliestExpiration.
  ///
  /// In en, this message translates to:
  /// **'Earliest expiry'**
  String get earliestExpiration;

  /// No description provided for @expiredQuantity.
  ///
  /// In en, this message translates to:
  /// **'Expired quantity'**
  String get expiredQuantity;

  /// No description provided for @lastPurchase.
  ///
  /// In en, this message translates to:
  /// **'Last purchase'**
  String get lastPurchase;

  /// No description provided for @projectedThreeDays.
  ///
  /// In en, this message translates to:
  /// **'Needed next 3 days'**
  String get projectedThreeDays;

  /// No description provided for @remainingDays.
  ///
  /// In en, this message translates to:
  /// **'Remaining days'**
  String get remainingDays;

  /// No description provided for @stockState.
  ///
  /// In en, this message translates to:
  /// **'Stock state'**
  String get stockState;

  /// No description provided for @currentQuantity.
  ///
  /// In en, this message translates to:
  /// **'Current quantity'**
  String get currentQuantity;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @appointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointments;

  /// No description provided for @vitals.
  ///
  /// In en, this message translates to:
  /// **'Vitals'**
  String get vitals;

  /// No description provided for @illnesses.
  ///
  /// In en, this message translates to:
  /// **'Illnesses'**
  String get illnesses;

  /// No description provided for @dietaryRules.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get dietaryRules;

  /// No description provided for @prescriptions.
  ///
  /// In en, this message translates to:
  /// **'Prescriptions'**
  String get prescriptions;

  /// No description provided for @addAppointment.
  ///
  /// In en, this message translates to:
  /// **'Add appointment'**
  String get addAppointment;

  /// No description provided for @doctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctor;

  /// No description provided for @specialty.
  ///
  /// In en, this message translates to:
  /// **'Specialty'**
  String get specialty;

  /// No description provided for @dateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Date and time'**
  String get dateAndTime;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @appointment_scheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get appointment_scheduled;

  /// No description provided for @appointment_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get appointment_completed;

  /// No description provided for @appointment_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get appointment_cancelled;

  /// No description provided for @addVital.
  ///
  /// In en, this message translates to:
  /// **'Add measurement'**
  String get addVital;

  /// No description provided for @vitalType.
  ///
  /// In en, this message translates to:
  /// **'Measurement'**
  String get vitalType;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @systolic.
  ///
  /// In en, this message translates to:
  /// **'Systolic'**
  String get systolic;

  /// No description provided for @diastolic.
  ///
  /// In en, this message translates to:
  /// **'Diastolic'**
  String get diastolic;

  /// No description provided for @measuredAt.
  ///
  /// In en, this message translates to:
  /// **'Measured at'**
  String get measuredAt;

  /// No description provided for @vital_blood_pressure.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure'**
  String get vital_blood_pressure;

  /// No description provided for @vital_heart_rate.
  ///
  /// In en, this message translates to:
  /// **'Heart rate'**
  String get vital_heart_rate;

  /// No description provided for @vital_blood_glucose.
  ///
  /// In en, this message translates to:
  /// **'Blood glucose'**
  String get vital_blood_glucose;

  /// No description provided for @vital_temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get vital_temperature;

  /// No description provided for @vital_weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get vital_weight;

  /// No description provided for @vital_oxygen_saturation.
  ///
  /// In en, this message translates to:
  /// **'Oxygen saturation'**
  String get vital_oxygen_saturation;

  /// No description provided for @vital_respiratory_rate.
  ///
  /// In en, this message translates to:
  /// **'Respiratory rate'**
  String get vital_respiratory_rate;

  /// No description provided for @vital_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get vital_other;

  /// No description provided for @addIllness.
  ///
  /// In en, this message translates to:
  /// **'Add illness'**
  String get addIllness;

  /// No description provided for @condition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get condition;

  /// No description provided for @diagnosedDate.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis date'**
  String get diagnosedDate;

  /// No description provided for @addDietRule.
  ///
  /// In en, this message translates to:
  /// **'Add diet rule'**
  String get addDietRule;

  /// No description provided for @foodItemEn.
  ///
  /// In en, this message translates to:
  /// **'Food (English)'**
  String get foodItemEn;

  /// No description provided for @foodItemAr.
  ///
  /// In en, this message translates to:
  /// **'Food (Arabic)'**
  String get foodItemAr;

  /// No description provided for @ruleType.
  ///
  /// In en, this message translates to:
  /// **'Rule'**
  String get ruleType;

  /// No description provided for @diet_avoid.
  ///
  /// In en, this message translates to:
  /// **'Avoid'**
  String get diet_avoid;

  /// No description provided for @diet_limit.
  ///
  /// In en, this message translates to:
  /// **'Limit'**
  String get diet_limit;

  /// No description provided for @diet_prefer.
  ///
  /// In en, this message translates to:
  /// **'Prefer'**
  String get diet_prefer;

  /// No description provided for @diet_separate_from_medication.
  ///
  /// In en, this message translates to:
  /// **'Separate from medicine'**
  String get diet_separate_from_medication;

  /// No description provided for @dietNoInferenceNote.
  ///
  /// In en, this message translates to:
  /// **'Diet rules are recorded as entered; the app never infers medical rules.'**
  String get dietNoInferenceNote;

  /// No description provided for @addPrescription.
  ///
  /// In en, this message translates to:
  /// **'Add prescription'**
  String get addPrescription;

  /// No description provided for @pickFile.
  ///
  /// In en, this message translates to:
  /// **'Choose image or PDF'**
  String get pickFile;

  /// No description provided for @fileSelected.
  ///
  /// In en, this message translates to:
  /// **'File: {name}'**
  String fileSelected(Object name);

  /// No description provided for @issueDate.
  ///
  /// In en, this message translates to:
  /// **'Issue date'**
  String get issueDate;

  /// No description provided for @fileMissing.
  ///
  /// In en, this message translates to:
  /// **'The prescription file is missing from this device'**
  String get fileMissing;

  /// No description provided for @openFile.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openFile;

  /// No description provided for @prescriptionsPrivateNote.
  ///
  /// In en, this message translates to:
  /// **'Stored privately in the app. Prescriptions are never included in doctor reports.'**
  String get prescriptionsPrivateNote;

  /// No description provided for @filesUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Attaching files is not available on this platform'**
  String get filesUnsupported;

  /// No description provided for @noRecords.
  ///
  /// In en, this message translates to:
  /// **'Nothing recorded yet'**
  String get noRecords;

  /// No description provided for @meals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get meals;

  /// No description provided for @addMeal.
  ///
  /// In en, this message translates to:
  /// **'Add meal'**
  String get addMeal;

  /// No description provided for @editMeal.
  ///
  /// In en, this message translates to:
  /// **'Edit meal'**
  String get editMeal;

  /// No description provided for @mealType.
  ///
  /// In en, this message translates to:
  /// **'Meal type'**
  String get mealType;

  /// No description provided for @meal_breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get meal_breakfast;

  /// No description provided for @meal_lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get meal_lunch;

  /// No description provided for @meal_dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get meal_dinner;

  /// No description provided for @meal_snack.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get meal_snack;

  /// No description provided for @meal_custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get meal_custom;

  /// No description provided for @mealTime.
  ///
  /// In en, this message translates to:
  /// **'Meal time'**
  String get mealTime;

  /// No description provided for @mealDefaultTime.
  ///
  /// In en, this message translates to:
  /// **'Default {time}'**
  String mealDefaultTime(Object time);

  /// No description provided for @mealsNote.
  ///
  /// In en, this message translates to:
  /// **'Changing a meal time moves every dose scheduled relative to it.'**
  String get mealsNote;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @doctorReport.
  ///
  /// In en, this message translates to:
  /// **'Doctor report'**
  String get doctorReport;

  /// No description provided for @summaryReport.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summaryReport;

  /// No description provided for @detailedReport.
  ///
  /// In en, this message translates to:
  /// **'Detailed'**
  String get detailedReport;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @periodAll.
  ///
  /// In en, this message translates to:
  /// **'Everything'**
  String get periodAll;

  /// No description provided for @period7.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get period7;

  /// No description provided for @period30.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get period30;

  /// No description provided for @period90.
  ///
  /// In en, this message translates to:
  /// **'Last 90 days'**
  String get period90;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// No description provided for @reportGeneratedOn.
  ///
  /// In en, this message translates to:
  /// **'Generated {date}'**
  String reportGeneratedOn(Object date);

  /// No description provided for @reportPeriodAll.
  ///
  /// In en, this message translates to:
  /// **'Period: everything'**
  String get reportPeriodAll;

  /// No description provided for @reportPeriodRange.
  ///
  /// In en, this message translates to:
  /// **'Period: {from} – {to}'**
  String reportPeriodRange(Object from, Object to);

  /// No description provided for @adherence.
  ///
  /// In en, this message translates to:
  /// **'Adherence'**
  String get adherence;

  /// No description provided for @overallAdherence.
  ///
  /// In en, this message translates to:
  /// **'Overall adherence'**
  String get overallAdherence;

  /// No description provided for @takenOnTime.
  ///
  /// In en, this message translates to:
  /// **'Taken on time'**
  String get takenOnTime;

  /// No description provided for @takenLate.
  ///
  /// In en, this message translates to:
  /// **'Taken late'**
  String get takenLate;

  /// No description provided for @medicationsSection.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get medicationsSection;

  /// No description provided for @doseHistorySection.
  ///
  /// In en, this message translates to:
  /// **'Dose history'**
  String get doseHistorySection;

  /// No description provided for @vitalsSection.
  ///
  /// In en, this message translates to:
  /// **'Vitals'**
  String get vitalsSection;

  /// No description provided for @appointmentsSection.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointmentsSection;

  /// No description provided for @illnessesSection.
  ///
  /// In en, this message translates to:
  /// **'Illnesses'**
  String get illnessesSection;

  /// No description provided for @dietSection.
  ///
  /// In en, this message translates to:
  /// **'Diet rules'**
  String get dietSection;

  /// No description provided for @patientSection.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get patientSection;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @inventoryReport.
  ///
  /// In en, this message translates to:
  /// **'Storage report'**
  String get inventoryReport;

  /// No description provided for @whatWeHave.
  ///
  /// In en, this message translates to:
  /// **'What medicine do we have?'**
  String get whatWeHave;

  /// No description provided for @whatToBuy.
  ///
  /// In en, this message translates to:
  /// **'What needs to be purchased?'**
  String get whatToBuy;

  /// No description provided for @nothingToBuy.
  ///
  /// In en, this message translates to:
  /// **'Nothing needs to be purchased'**
  String get nothingToBuy;

  /// No description provided for @pdfArabicFontMissing.
  ///
  /// In en, this message translates to:
  /// **'Arabic PDF font is not bundled; Arabic text may not render in the PDF.'**
  String get pdfArabicFontMissing;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup and restore'**
  String get backupTitle;

  /// No description provided for @backupNote.
  ///
  /// In en, this message translates to:
  /// **'Backups are portable ZIP files (not encrypted). Keep them somewhere safe.'**
  String get backupNote;

  /// No description provided for @exportBackup.
  ///
  /// In en, this message translates to:
  /// **'Export current patient'**
  String get exportBackup;

  /// No description provided for @exportBackupBody.
  ///
  /// In en, this message translates to:
  /// **'Everything needed to rebuild this patient\'s profile, including prescription files.'**
  String get exportBackupBody;

  /// No description provided for @importAsNew.
  ///
  /// In en, this message translates to:
  /// **'Import as a new patient'**
  String get importAsNew;

  /// No description provided for @importAsNewBody.
  ///
  /// In en, this message translates to:
  /// **'Creates a separate profile with new IDs.'**
  String get importAsNewBody;

  /// No description provided for @mergeBackup.
  ///
  /// In en, this message translates to:
  /// **'Merge into the same patient'**
  String get mergeBackup;

  /// No description provided for @mergeBackupBody.
  ///
  /// In en, this message translates to:
  /// **'Keeps the latest changes and every unique historical event.'**
  String get mergeBackupBody;

  /// No description provided for @backupSaved.
  ///
  /// In en, this message translates to:
  /// **'Backup ready: {name}'**
  String backupSaved(Object name);

  /// No description provided for @importDone.
  ///
  /// In en, this message translates to:
  /// **'Imported {name}'**
  String importDone(Object name);

  /// No description provided for @mergeDone.
  ///
  /// In en, this message translates to:
  /// **'Merged: {added} added, {updated} updated'**
  String mergeDone(Object added, Object updated);

  /// No description provided for @invalidBackup.
  ///
  /// In en, this message translates to:
  /// **'This file is not a valid BelMiad backup'**
  String get invalidBackup;

  /// No description provided for @newerBackup.
  ///
  /// In en, this message translates to:
  /// **'This backup was made by a newer version of the app'**
  String get newerBackup;

  /// No description provided for @backupPatientMissing.
  ///
  /// In en, this message translates to:
  /// **'This backup\'s patient does not exist here. Import it as a new patient instead.'**
  String get backupPatientMissing;

  /// No description provided for @trash.
  ///
  /// In en, this message translates to:
  /// **'Trash'**
  String get trash;

  /// No description provided for @trashEmpty.
  ///
  /// In en, this message translates to:
  /// **'Trash is empty'**
  String get trashEmpty;

  /// No description provided for @restored.
  ///
  /// In en, this message translates to:
  /// **'Restored'**
  String get restored;

  /// No description provided for @deletedPermanently.
  ///
  /// In en, this message translates to:
  /// **'Deleted permanently'**
  String get deletedPermanently;

  /// No description provided for @permanentDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete permanently?'**
  String get permanentDeleteTitle;

  /// No description provided for @permanentDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get permanentDeleteBody;

  /// No description provided for @deletedOn.
  ///
  /// In en, this message translates to:
  /// **'Deleted {date}'**
  String deletedOn(Object date);

  /// No description provided for @entity_patient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get entity_patient;

  /// No description provided for @entity_medication.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get entity_medication;

  /// No description provided for @entity_inventory_batch.
  ///
  /// In en, this message translates to:
  /// **'Stock batch'**
  String get entity_inventory_batch;

  /// No description provided for @entity_appointment.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get entity_appointment;

  /// No description provided for @entity_vital_measurement.
  ///
  /// In en, this message translates to:
  /// **'Measurement'**
  String get entity_vital_measurement;

  /// No description provided for @entity_illness.
  ///
  /// In en, this message translates to:
  /// **'Illness'**
  String get entity_illness;

  /// No description provided for @entity_dietary_rule.
  ///
  /// In en, this message translates to:
  /// **'Diet rule'**
  String get entity_dietary_rule;

  /// No description provided for @entity_prescription.
  ///
  /// In en, this message translates to:
  /// **'Prescription'**
  String get entity_prescription;

  /// No description provided for @entity_meal.
  ///
  /// In en, this message translates to:
  /// **'Meal'**
  String get entity_meal;

  /// No description provided for @auditLog.
  ///
  /// In en, this message translates to:
  /// **'Activity history'**
  String get auditLog;

  /// No description provided for @auditEmpty.
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get auditEmpty;

  /// No description provided for @systemActor.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get systemActor;

  /// No description provided for @unknownActor.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownActor;

  /// No description provided for @audit_created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get audit_created;

  /// No description provided for @audit_updated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get audit_updated;

  /// No description provided for @audit_deleted.
  ///
  /// In en, this message translates to:
  /// **'Moved to trash'**
  String get audit_deleted;

  /// No description provided for @audit_restored.
  ///
  /// In en, this message translates to:
  /// **'Restored'**
  String get audit_restored;

  /// No description provided for @audit_permanently_deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted permanently'**
  String get audit_permanently_deleted;

  /// No description provided for @audit_archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get audit_archived;

  /// No description provided for @audit_unarchived.
  ///
  /// In en, this message translates to:
  /// **'Unarchived'**
  String get audit_unarchived;

  /// No description provided for @audit_inventory_added.
  ///
  /// In en, this message translates to:
  /// **'Stock added'**
  String get audit_inventory_added;

  /// No description provided for @audit_inventory_edited.
  ///
  /// In en, this message translates to:
  /// **'Stock edited'**
  String get audit_inventory_edited;

  /// No description provided for @audit_inventory_adjusted.
  ///
  /// In en, this message translates to:
  /// **'Stock adjusted'**
  String get audit_inventory_adjusted;

  /// No description provided for @audit_inventory_deleted.
  ///
  /// In en, this message translates to:
  /// **'Stock deleted'**
  String get audit_inventory_deleted;

  /// No description provided for @audit_dose_taken.
  ///
  /// In en, this message translates to:
  /// **'Dose taken'**
  String get audit_dose_taken;

  /// No description provided for @audit_dose_undone.
  ///
  /// In en, this message translates to:
  /// **'Dose undone'**
  String get audit_dose_undone;

  /// No description provided for @audit_dose_skipped.
  ///
  /// In en, this message translates to:
  /// **'Dose skipped'**
  String get audit_dose_skipped;

  /// No description provided for @audit_dose_missed.
  ///
  /// In en, this message translates to:
  /// **'Dose missed'**
  String get audit_dose_missed;

  /// No description provided for @audit_prn_logged.
  ///
  /// In en, this message translates to:
  /// **'As-needed dose logged'**
  String get audit_prn_logged;

  /// No description provided for @audit_batch_manually_selected.
  ///
  /// In en, this message translates to:
  /// **'Batch chosen manually'**
  String get audit_batch_manually_selected;

  /// No description provided for @audit_maximum_daily_overridden.
  ///
  /// In en, this message translates to:
  /// **'Daily maximum overridden'**
  String get audit_maximum_daily_overridden;

  /// No description provided for @audit_caregiver_assigned.
  ///
  /// In en, this message translates to:
  /// **'Caregiver added'**
  String get audit_caregiver_assigned;

  /// No description provided for @audit_caregiver_removed.
  ///
  /// In en, this message translates to:
  /// **'Caregiver removed'**
  String get audit_caregiver_removed;

  /// No description provided for @audit_imported.
  ///
  /// In en, this message translates to:
  /// **'Imported from backup'**
  String get audit_imported;

  /// No description provided for @audit_merged.
  ///
  /// In en, this message translates to:
  /// **'Merged from backup'**
  String get audit_merged;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences'**
  String get notificationSettings;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @notif_dose_reminder.
  ///
  /// In en, this message translates to:
  /// **'Medication reminders'**
  String get notif_dose_reminder;

  /// No description provided for @notif_missed_dose.
  ///
  /// In en, this message translates to:
  /// **'Missed doses'**
  String get notif_missed_dose;

  /// No description provided for @notif_low_stock.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get notif_low_stock;

  /// No description provided for @notif_empty_stock.
  ///
  /// In en, this message translates to:
  /// **'Empty stock'**
  String get notif_empty_stock;

  /// No description provided for @notif_expiration.
  ///
  /// In en, this message translates to:
  /// **'Expiration'**
  String get notif_expiration;

  /// No description provided for @notif_appointment_reminder.
  ///
  /// In en, this message translates to:
  /// **'Appointment reminders'**
  String get notif_appointment_reminder;

  /// No description provided for @notificationsPerPatient.
  ///
  /// In en, this message translates to:
  /// **'Preferences apply to the current patient only.'**
  String get notificationsPerPatient;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @expiryThreshold.
  ///
  /// In en, this message translates to:
  /// **'Expiring-soon warning'**
  String get expiryThreshold;

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String daysCount(Object count);

  /// No description provided for @missedGrace.
  ///
  /// In en, this message translates to:
  /// **'Mark doses missed after'**
  String get missedGrace;

  /// No description provided for @minutesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes'**
  String minutesCount(Object count);

  /// No description provided for @hoursCount.
  ///
  /// In en, this message translates to:
  /// **'{count} hours'**
  String hoursCount(Object count);

  /// No description provided for @inactivityReset.
  ///
  /// In en, this message translates to:
  /// **'Return to home after inactivity'**
  String get inactivityReset;

  /// No description provided for @inactivityResetNote.
  ///
  /// In en, this message translates to:
  /// **'Resets the screen only. This is not a lock and needs no password.'**
  String get inactivityResetNote;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'BelMiad works fully offline. Data is stored only on this device, without accounts, cloud or encryption.'**
  String get aboutBody;

  /// No description provided for @catalogEntries.
  ///
  /// In en, this message translates to:
  /// **'{count} medicines in the offline catalog'**
  String catalogEntries(Object count);

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(Object version);

  /// No description provided for @error_nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get error_nameRequired;

  /// No description provided for @error_invalidTimezone.
  ///
  /// In en, this message translates to:
  /// **'Unknown timezone'**
  String get error_invalidTimezone;

  /// No description provided for @error_doseUnitRequired.
  ///
  /// In en, this message translates to:
  /// **'Please choose a dose unit'**
  String get error_doseUnitRequired;

  /// No description provided for @error_endBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'The end date is before the start date'**
  String get error_endBeforeStart;

  /// No description provided for @error_invalidMaximum.
  ///
  /// In en, this message translates to:
  /// **'The maximum must be greater than zero'**
  String get error_invalidMaximum;

  /// No description provided for @error_quantityRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a quantity greater than zero'**
  String get error_quantityRequired;

  /// No description provided for @error_invalidQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter a quantity like 1, 0.5 or 1.25'**
  String get error_invalidQuantity;

  /// No description provided for @error_invalidTime.
  ///
  /// In en, this message translates to:
  /// **'Please choose a valid time'**
  String get error_invalidTime;

  /// No description provided for @error_mealRequired.
  ///
  /// In en, this message translates to:
  /// **'Please choose a meal'**
  String get error_mealRequired;

  /// No description provided for @error_weekdaysRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one weekday'**
  String get error_weekdaysRequired;

  /// No description provided for @error_invalidRecurrence.
  ///
  /// In en, this message translates to:
  /// **'Check the repeat settings'**
  String get error_invalidRecurrence;

  /// No description provided for @error_invalidScheduleType.
  ///
  /// In en, this message translates to:
  /// **'Choose a timing type'**
  String get error_invalidScheduleType;

  /// No description provided for @error_useAdjustment.
  ///
  /// In en, this message translates to:
  /// **'This batch has history; use Adjust stock to change its quantity'**
  String get error_useAdjustment;

  /// No description provided for @error_negativeStock.
  ///
  /// In en, this message translates to:
  /// **'Stock cannot become negative'**
  String get error_negativeStock;

  /// No description provided for @error_insufficientStock.
  ///
  /// In en, this message translates to:
  /// **'Not enough usable stock'**
  String get error_insufficientStock;

  /// No description provided for @error_invalidDoseTransition.
  ///
  /// In en, this message translates to:
  /// **'This dose can no longer be changed that way'**
  String get error_invalidDoseTransition;

  /// No description provided for @error_doseWindowClosed.
  ///
  /// In en, this message translates to:
  /// **'This dose is past its allowed window and is now missed'**
  String get error_doseWindowClosed;

  /// No description provided for @error_actualQuantityZero.
  ///
  /// In en, this message translates to:
  /// **'Nothing was taken, so the dose was not recorded'**
  String get error_actualQuantityZero;

  /// No description provided for @error_batchNotUsable.
  ///
  /// In en, this message translates to:
  /// **'That batch cannot be used (expired, empty or deleted)'**
  String get error_batchNotUsable;

  /// No description provided for @error_allocationTotalMismatch.
  ///
  /// In en, this message translates to:
  /// **'The chosen batches must add up to the quantity taken'**
  String get error_allocationTotalMismatch;

  /// No description provided for @error_invalidAllocation.
  ///
  /// In en, this message translates to:
  /// **'Invalid batch quantities'**
  String get error_invalidAllocation;

  /// No description provided for @error_batchHasHistory.
  ///
  /// In en, this message translates to:
  /// **'Batches with consumption history cannot be deleted permanently'**
  String get error_batchHasHistory;

  /// No description provided for @error_mealInUse.
  ///
  /// In en, this message translates to:
  /// **'This meal is used by a schedule'**
  String get error_mealInUse;

  /// No description provided for @error_valueRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a value'**
  String get error_valueRequired;

  /// No description provided for @error_doctorRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the doctor\'s name'**
  String get error_doctorRequired;

  /// No description provided for @error_patientAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'This person already has a patient profile'**
  String get error_patientAlreadyExists;

  /// No description provided for @error_invalidPrice.
  ///
  /// In en, this message translates to:
  /// **'Price cannot be negative'**
  String get error_invalidPrice;

  /// No description provided for @error_invalidDate.
  ///
  /// In en, this message translates to:
  /// **'Invalid date'**
  String get error_invalidDate;

  /// No description provided for @error_invalidPackages.
  ///
  /// In en, this message translates to:
  /// **'Package counts cannot be negative'**
  String get error_invalidPackages;

  /// No description provided for @error_invalidReason.
  ///
  /// In en, this message translates to:
  /// **'Choose a reason'**
  String get error_invalidReason;

  /// No description provided for @error_notFound.
  ///
  /// In en, this message translates to:
  /// **'The item no longer exists'**
  String get error_notFound;

  /// No description provided for @error_maximumDailyExceeded.
  ///
  /// In en, this message translates to:
  /// **'The daily maximum would be exceeded'**
  String get error_maximumDailyExceeded;

  /// No description provided for @error_unsupportedTrashEntity.
  ///
  /// In en, this message translates to:
  /// **'This item cannot be moved to trash'**
  String get error_unsupportedTrashEntity;

  /// No description provided for @error_invalidBackup.
  ///
  /// In en, this message translates to:
  /// **'This file is not a valid BelMiad backup'**
  String get error_invalidBackup;

  /// No description provided for @error_newerBackup.
  ///
  /// In en, this message translates to:
  /// **'This backup was made by a newer version of the app'**
  String get error_newerBackup;

  /// No description provided for @error_backupPatientMissing.
  ///
  /// In en, this message translates to:
  /// **'This backup\'s patient does not exist here'**
  String get error_backupPatientMissing;

  /// No description provided for @error_filesUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Files are not supported on this platform'**
  String get error_filesUnsupported;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
