// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'بالميعاد';

  @override
  String get appTagline => 'أدويتك في موعدها، بدون إنترنت';

  @override
  String get ok => 'حسناً';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get add => 'إضافة';

  @override
  String get close => 'إغلاق';

  @override
  String get confirm => 'تأكيد';

  @override
  String get search => 'بحث';

  @override
  String get done => 'تم';

  @override
  String get next => 'التالي';

  @override
  String get back => 'رجوع';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get optional => 'اختياري';

  @override
  String get requiredField => 'مطلوب';

  @override
  String get notSet => 'غير محدد';

  @override
  String get none => 'لا يوجد';

  @override
  String get restore => 'استعادة';

  @override
  String get permanentlyDelete => 'حذف نهائي';

  @override
  String get archive => 'أرشفة';

  @override
  String get unarchive => 'إلغاء الأرشفة';

  @override
  String get undo => 'تراجع';

  @override
  String get share => 'مشاركة';

  @override
  String get details => 'التفاصيل';

  @override
  String get history => 'السجل';

  @override
  String get all => 'الكل';

  @override
  String get today => 'اليوم';

  @override
  String get tomorrow => 'غداً';

  @override
  String get yesterday => 'أمس';

  @override
  String get loadMore => 'عرض المزيد';

  @override
  String errorGeneric(Object message) {
    return 'حدث خطأ: $message';
  }

  @override
  String get savedMessage => 'تم الحفظ';

  @override
  String get deletedMessage => 'نُقل إلى سلة المحذوفات';

  @override
  String get navToday => 'اليوم';

  @override
  String get navMedications => 'الأدوية';

  @override
  String get navInventory => 'المخزون';

  @override
  String get navHealth => 'الصحة';

  @override
  String get navMore => 'المزيد';

  @override
  String get welcomeTitle => 'أهلاً بك في بالميعاد';

  @override
  String get welcomeBody =>
      'تابع الأدوية والجرعات والمخزون والسجل الصحي لك أو لمن ترعاهم. كل البيانات تبقى على هذا الهاتف وتعمل بدون إنترنت.';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get whoAreYou => 'من يستخدم هذا الهاتف؟';

  @override
  String get whoAreYouHint =>
      'يُسجَّل اسمك مع الإجراءات التي تقوم بها (الجرعات وتغييرات المخزون). هذا ليس تسجيل دخول ولا يحتاج كلمة مرور.';

  @override
  String get yourName => 'اسمك';

  @override
  String get firstPatientTitle => 'من ترعى؟';

  @override
  String get patientIsMe => 'نفسي';

  @override
  String get patientIsSomeoneElse => 'شخص آخر';

  @override
  String get relationshipLabel => 'صلة القرابة (مثل: الأم)';

  @override
  String get continueAction => 'متابعة';

  @override
  String get patients => 'المرضى';

  @override
  String get patient => 'المريض';

  @override
  String get addPatient => 'إضافة مريض';

  @override
  String get editPatient => 'تعديل بيانات المريض';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get phone => 'الهاتف';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get dateOfBirth => 'تاريخ الميلاد';

  @override
  String get sex => 'النوع';

  @override
  String get sexMale => 'ذكر';

  @override
  String get sexFemale => 'أنثى';

  @override
  String get bloodType => 'فصيلة الدم';

  @override
  String get emergencyContactName => 'اسم جهة اتصال الطوارئ';

  @override
  String get emergencyContactPhone => 'هاتف جهة اتصال الطوارئ';

  @override
  String get notes => 'ملاحظات';

  @override
  String get timezone => 'المنطقة الزمنية';

  @override
  String get timezoneHint =>
      'تحتفظ مواعيد الجرعات بنفس الوقت المحلي عند تغيير المنطقة الزمنية.';

  @override
  String get switchPatient => 'تبديل المريض';

  @override
  String get currentPatient => 'المريض الحالي';

  @override
  String get noPatients => 'لا يوجد مرضى بعد';

  @override
  String get noPatientSelected => 'اختر مريضاً أو أضف مريضاً للمتابعة';

  @override
  String get deletePatientTitle => 'نقل المريض إلى سلة المحذوفات؟';

  @override
  String deletePatientBody(Object name) {
    return 'سيُنقل $name وكل بياناته إلى سلة المحذوفات. يمكنك استعادته لاحقاً أو حذفه نهائياً.';
  }

  @override
  String ageYears(Object years) {
    return '$years سنة';
  }

  @override
  String get caregivers => 'مقدمو الرعاية';

  @override
  String get addCaregiver => 'إضافة مقدم رعاية';

  @override
  String get removeCaregiver => 'إزالة مقدم الرعاية';

  @override
  String removeCaregiverBody(Object name) {
    return 'لن يظهر $name كمقدم رعاية بعد الآن. تبقى إجراءاته السابقة في السجل.';
  }

  @override
  String get selectPerson => 'اختر شخصاً';

  @override
  String get newPerson => 'شخص جديد';

  @override
  String get relationship => 'صلة القرابة';

  @override
  String get relationshipSelf => 'نفسه';

  @override
  String get deviceCaregiver => 'مقدم الرعاية على هذا الهاتف';

  @override
  String get changeCaregiver => 'تغيير مقدم الرعاية';

  @override
  String caregiverSwitched(Object name) {
    return 'يتم التسجيل الآن باسم $name';
  }

  @override
  String get medications => 'الأدوية';

  @override
  String get medication => 'الدواء';

  @override
  String get addMedication => 'إضافة دواء';

  @override
  String get editMedication => 'تعديل الدواء';

  @override
  String get searchCatalog => 'ابحث في دليل الأدوية المصرية';

  @override
  String get searchCatalogHint => 'اكتب حرفين على الأقل بالعربية أو الإنجليزية';

  @override
  String get noCatalogResults => 'لا توجد نتائج في الدليل';

  @override
  String get addCustomMedication => 'إضافة دواء غير موجود بالدليل';

  @override
  String catalogPrice(Object price) {
    return 'سعر الدليل: $price جنيه';
  }

  @override
  String get referencePriceNote =>
      'سعر استرشادي فقط. يُسجَّل سعر الشراء الفعلي مع المخزون.';

  @override
  String get recentlySelected => 'المختارة مؤخراً';

  @override
  String get fromCatalog => 'من الدليل';

  @override
  String get nameEn => 'الاسم (إنجليزي)';

  @override
  String get nameAr => 'الاسم (عربي)';

  @override
  String get scientificName => 'الاسم العلمي';

  @override
  String get strength => 'التركيز (مثل 500 مجم)';

  @override
  String get dosageForm => 'الشكل الدوائي';

  @override
  String get route => 'طريقة الاستخدام';

  @override
  String get doseUnit => 'وحدة الجرعة';

  @override
  String get instructionsEn => 'التعليمات (إنجليزي)';

  @override
  String get instructionsAr => 'التعليمات (عربي)';

  @override
  String get instructionsSeparateNote =>
      'تُكتب التعليمات بالعربية والإنجليزية بشكل منفصل ولا تُترجم تلقائياً.';

  @override
  String get startDate => 'تاريخ البدء';

  @override
  String get endDate => 'تاريخ الانتهاء';

  @override
  String get prn => 'عند اللزوم';

  @override
  String get prnHint => 'تُسجَّل الجرعات عند تناولها ولا تُنشأ تذكيرات.';

  @override
  String get maximumDaily => 'الحد الأقصى يومياً';

  @override
  String get maximumDailyHint => 'تنبيه قبل تجاوز الحد الأقصى اليومي';

  @override
  String get statusActive => 'نشط';

  @override
  String get statusArchived => 'مؤرشف';

  @override
  String get showArchived => 'عرض المؤرشفة';

  @override
  String get deleteMedicationTitle => 'نقل الدواء إلى سلة المحذوفات؟';

  @override
  String get deleteMedicationBody =>
      'يُحتفظ بسجل الجرعات والمخزون ويمكن استعادته.';

  @override
  String get noMedications => 'لا توجد أدوية بعد';

  @override
  String get overview => 'نظرة عامة';

  @override
  String get schedules => 'المواعيد';

  @override
  String get inventory => 'المخزون';

  @override
  String get doseHistory => 'سجل الجرعات';

  @override
  String get addStockNowTitle => 'إضافة مخزون الآن؟';

  @override
  String get addStockNowBody =>
      'يمكنك تسجيل الكمية المتوفرة من هذا الدواء الآن أو لاحقاً من تبويب المخزون.';

  @override
  String get later => 'لاحقاً';

  @override
  String get prnBadge => 'عند اللزوم';

  @override
  String maxPerDay(Object quantity) {
    return 'بحد أقصى $quantity يومياً';
  }

  @override
  String get unit_tablet => 'قرص';

  @override
  String get unit_capsule => 'كبسولة';

  @override
  String get unit_ml => 'مل';

  @override
  String get unit_drop => 'نقطة';

  @override
  String get unit_puff => 'بخة';

  @override
  String get unit_sachet => 'كيس';

  @override
  String get unit_injection => 'حقنة';

  @override
  String get unit_patch => 'لصقة';

  @override
  String get unit_suppository => 'لبوس';

  @override
  String get unit_application => 'دهان';

  @override
  String get unit_mg => 'مجم';

  @override
  String get unit_g => 'جم';

  @override
  String get unit_unit => 'وحدة';

  @override
  String get addSchedule => 'إضافة موعد';

  @override
  String get editSchedule => 'تعديل الموعد';

  @override
  String get scheduleType => 'التوقيت';

  @override
  String get fixedTime => 'وقت محدد';

  @override
  String get mealRelative => 'مرتبط بوجبة';

  @override
  String get time => 'الوقت';

  @override
  String get meal => 'الوجبة';

  @override
  String get beforeMeal => 'قبل الأكل';

  @override
  String get withMeal => 'مع الأكل';

  @override
  String get afterMeal => 'بعد الأكل';

  @override
  String get offsetMinutes => 'دقائق';

  @override
  String get quantity => 'الكمية';

  @override
  String get recurrence => 'التكرار';

  @override
  String get daily => 'كل يوم';

  @override
  String get weekly => 'أيام محددة من الأسبوع';

  @override
  String get everyNDays => 'كل عدد من الأيام';

  @override
  String get customCycle => 'دورة مخصصة';

  @override
  String get intervalDays => 'كل كم يوم';

  @override
  String get intervalWeeks => 'كل كم أسبوع';

  @override
  String get onDays => 'أيام التناول';

  @override
  String get offDays => 'أيام التوقف';

  @override
  String get cycleStart => 'تاريخ بدء الدورة';

  @override
  String get differentQuantityByDay => 'كمية مختلفة في بعض الأيام';

  @override
  String get validFrom => 'من تاريخ';

  @override
  String get validUntil => 'حتى تاريخ';

  @override
  String get noSchedules => 'لا توجد مواعيد';

  @override
  String get deleteScheduleTitle => 'حذف الموعد؟';

  @override
  String get deleteScheduleBody =>
      'تُحذف الجرعات المستقبلية لهذا الموعد وتبقى الجرعات السابقة في السجل.';

  @override
  String get prnPlannedNote =>
      'لأدوية عند اللزوم، المواعيد هي معدل استخدام متوقع يُستخدم لتوقع المخزون فقط.';

  @override
  String get scheduleEveryDay => 'كل يوم';

  @override
  String scheduleEveryNDays(Object count) {
    return 'كل $count أيام';
  }

  @override
  String scheduleWeekdays(Object days) {
    return 'أيام $days';
  }

  @override
  String scheduleEveryNWeeks(Object count, Object days) {
    return 'كل $count أسابيع أيام $days';
  }

  @override
  String scheduleCycle(Object off, Object on) {
    return '$on يوم تناول ثم $off يوم توقف';
  }

  @override
  String scheduleBeforeMeal(Object meal, Object minutes) {
    return 'قبل $meal بـ $minutes دقيقة';
  }

  @override
  String scheduleAfterMeal(Object meal, Object minutes) {
    return 'بعد $meal بـ $minutes دقيقة';
  }

  @override
  String scheduleWithMeal(Object meal) {
    return 'مع $meal';
  }

  @override
  String get todayTitle => 'اليوم';

  @override
  String get noDoses => 'لا توجد جرعات في هذا اليوم';

  @override
  String get take => 'تناول';

  @override
  String get taken => 'تم التناول';

  @override
  String get skip => 'تخطي';

  @override
  String get skipped => 'تم التخطي';

  @override
  String get missed => 'فائتة';

  @override
  String get scheduled => 'مجدولة';

  @override
  String get pending => 'قادمة';

  @override
  String get undoTake => 'إلغاء التناول';

  @override
  String get undoTakeBody =>
      'تعود الجرعة إلى مجدولة وتُعاد الكمية بالضبط إلى نفس الدفعات.';

  @override
  String get skipDoseTitle => 'تخطي هذه الجرعة؟';

  @override
  String get skipDoseBody => 'لا يمكن تناول الجرعة المتخطاة لاحقاً.';

  @override
  String takenAt(Object time) {
    return 'تم التناول الساعة $time';
  }

  @override
  String lateBy(Object minutes) {
    return 'متأخرة $minutes دقيقة';
  }

  @override
  String get onTime => 'في الموعد';

  @override
  String get logPrn => 'تسجيل جرعة عند اللزوم';

  @override
  String get howMuchTaken => 'ما الكمية التي تم تناولها فعلاً؟';

  @override
  String get insufficientStockTitle => 'المخزون غير كافٍ';

  @override
  String insufficientStockBody(Object available, Object required) {
    return 'المطلوب $required والمتاح الصالح للاستخدام $available فقط.';
  }

  @override
  String get customAmount => 'كمية أخرى';

  @override
  String get leaveScheduled => 'إبقاؤها مجدولة';

  @override
  String get zeroTakenNote =>
      'لم يتم تناول شيء. لن تُسجَّل الجرعة ولن يُخصم من المخزون.';

  @override
  String get maxExceededTitle => 'سيتم تجاوز الحد الأقصى اليومي';

  @override
  String maxExceededBody(Object attempt, Object maximum, Object taken) {
    return 'الحد الأقصى $maximum يومياً. تم تناول $taken اليوم. هذه الجرعة: $attempt.';
  }

  @override
  String get recordAnyway => 'التسجيل رغم ذلك';

  @override
  String get doseWindowClosed =>
      'انتهت المهلة المسموحة لهذه الجرعة وأصبحت فائتة.';

  @override
  String get chooseBatches => 'دفعات المخزون';

  @override
  String get automaticFefo => 'تلقائي (الأقرب انتهاءً أولاً)';

  @override
  String get manualSelection => 'اختيار الدفعات';

  @override
  String allocatedOf(Object allocated, Object required) {
    return 'تم تخصيص $allocated من $required';
  }

  @override
  String get stockNotRecordedNote =>
      'المخزون غير مسجل لهذا الدواء؛ لن يُخصم شيء من المخزون.';

  @override
  String get requiredQuantity => 'المطلوب';

  @override
  String get actualQuantity => 'الكمية المتناولة';

  @override
  String get confirmTake => 'تسجيل التناول';

  @override
  String get doseTaken => 'تم تسجيل الجرعة';

  @override
  String get doseSkippedMessage => 'تم تخطي الجرعة';

  @override
  String get doseUndone => 'أُعيدت الجرعة إلى مجدولة';

  @override
  String get upcomingAppointment => 'الموعد الطبي القادم';

  @override
  String get alerts => 'تنبيهات';

  @override
  String dosesDone(Object done, Object total) {
    return 'تم تناول $done من $total جرعة';
  }

  @override
  String partialDose(Object actual, Object required) {
    return 'جزئية: $actual من $required';
  }

  @override
  String get prnTaken => 'عند اللزوم';

  @override
  String get inventoryTitle => 'المخزون';

  @override
  String get totalMedications => 'الأدوية';

  @override
  String get withStock => 'متوفر';

  @override
  String get lowStock => 'مخزون منخفض';

  @override
  String get emptyStock => 'نفد';

  @override
  String get expiringSoon => 'قارب على الانتهاء';

  @override
  String get stockNotRecorded => 'المخزون غير مسجل';

  @override
  String get stockNormal => 'طبيعي';

  @override
  String get stockLow => 'مخزون منخفض';

  @override
  String get stockEmpty => 'نفد';

  @override
  String get stockExpiredOnly => 'منتهي الصلاحية فقط';

  @override
  String get stockExpiring => 'قارب على الانتهاء';

  @override
  String daysRemaining(Object count) {
    return 'يكفي حوالي $count يوم';
  }

  @override
  String get dayRemaining => 'يكفي حوالي يوم واحد';

  @override
  String get lessThanDay => 'أقل من يوم';

  @override
  String get noForecast => 'لا يوجد استخدام مجدول';

  @override
  String get addStock => 'إضافة مخزون';

  @override
  String get selectMedication => 'اختر الدواء';

  @override
  String get byPackages => 'بالعبوات';

  @override
  String get byQuantity => 'بالكمية';

  @override
  String get packagingType => 'نوع العبوة';

  @override
  String get packagesCount => 'عدد العبوات';

  @override
  String get unitsPerPackage => 'عدد الوحدات في العبوة';

  @override
  String get availableQuantity => 'الكمية المتوفرة';

  @override
  String packagesTotal(Object quantity) {
    return 'الإجمالي: $quantity';
  }

  @override
  String get purchaseDate => 'تاريخ الشراء';

  @override
  String get purchasePrice => 'سعر الشراء (جنيه)';

  @override
  String get expirationDate => 'تاريخ انتهاء الصلاحية';

  @override
  String get totalQuantity => 'الإجمالي الصالح';

  @override
  String get batches => 'الدفعات';

  @override
  String get noBatches => 'لا توجد دفعات مسجلة';

  @override
  String get depleted => 'نفدت';

  @override
  String get expired => 'منتهية الصلاحية';

  @override
  String get expiresToday => 'تنتهي اليوم';

  @override
  String expiresInDays(Object count) {
    return 'تنتهي خلال $count يوم';
  }

  @override
  String expiresOn(Object date) {
    return 'تنتهي $date';
  }

  @override
  String get noExpiry => 'بدون تاريخ انتهاء';

  @override
  String get adjustStock => 'تعديل المخزون';

  @override
  String get addQuantity => 'إضافة كمية';

  @override
  String get removeQuantity => 'خصم كمية';

  @override
  String get reason => 'السبب';

  @override
  String get reason_manual_correction => 'تصحيح يدوي';

  @override
  String get reason_damaged => 'دواء تالف';

  @override
  String get reason_lost => 'دواء مفقود';

  @override
  String get reason_returned => 'دواء مُرتجع';

  @override
  String get reason_count_correction => 'تصحيح الجرد';

  @override
  String get reason_other => 'أخرى';

  @override
  String get adjustmentHistory => 'التعديلات';

  @override
  String get consumptionHistory => 'الاستهلاك';

  @override
  String get editBatch => 'تعديل الدفعة';

  @override
  String get deleteBatchTitle => 'نقل الدفعة إلى سلة المحذوفات؟';

  @override
  String get deleteBatchBody =>
      'تُحفظ الدفعة وسجلها في سلة المحذوفات ويمكن استعادتها.';

  @override
  String get useAdjustmentNote =>
      'لهذه الدفعة سجل استهلاك، لذا تُسجَّل تغييرات الكمية كتعديلات.';

  @override
  String get packaging_box => 'علبة';

  @override
  String get packaging_blister => 'شريط';

  @override
  String get packaging_bottle => 'زجاجة';

  @override
  String get packaging_tube => 'أنبوب';

  @override
  String get packaging_sachet => 'كيس';

  @override
  String get packaging_vial => 'فيال';

  @override
  String get packaging_ampoule => 'أمبول';

  @override
  String get packaging_container => 'عبوة';

  @override
  String get packaging_other => 'أخرى';

  @override
  String quantityChange(Object next, Object previous) {
    return '$previous ← $next';
  }

  @override
  String consumedForDose(Object date) {
    return 'جرعة $date';
  }

  @override
  String get reversed => 'أُلغيت (تراجع)';

  @override
  String get manual => 'يدوي';

  @override
  String get storageReport => 'تقرير المخزون';

  @override
  String get needsPurchase => 'يحتاج شراء';

  @override
  String get batchCount => 'الدفعات';

  @override
  String get earliestExpiration => 'أقرب انتهاء';

  @override
  String get expiredQuantity => 'الكمية المنتهية';

  @override
  String get lastPurchase => 'آخر شراء';

  @override
  String get projectedThreeDays => 'المطلوب لـ 3 أيام';

  @override
  String get remainingDays => 'الأيام المتبقية';

  @override
  String get stockState => 'حالة المخزون';

  @override
  String get currentQuantity => 'الكمية الحالية';

  @override
  String get unit => 'الوحدة';

  @override
  String get health => 'الصحة';

  @override
  String get appointments => 'المواعيد الطبية';

  @override
  String get vitals => 'القياسات الحيوية';

  @override
  String get illnesses => 'الأمراض';

  @override
  String get dietaryRules => 'النظام الغذائي';

  @override
  String get prescriptions => 'الروشتات';

  @override
  String get addAppointment => 'إضافة موعد طبي';

  @override
  String get doctor => 'الطبيب';

  @override
  String get specialty => 'التخصص';

  @override
  String get dateAndTime => 'التاريخ والوقت';

  @override
  String get date => 'التاريخ';

  @override
  String get location => 'المكان';

  @override
  String get status => 'الحالة';

  @override
  String get appointment_scheduled => 'مجدول';

  @override
  String get appointment_completed => 'تم';

  @override
  String get appointment_cancelled => 'ملغي';

  @override
  String get addVital => 'إضافة قياس';

  @override
  String get vitalType => 'نوع القياس';

  @override
  String get value => 'القيمة';

  @override
  String get systolic => 'الانقباضي';

  @override
  String get diastolic => 'الانبساطي';

  @override
  String get measuredAt => 'وقت القياس';

  @override
  String get vital_blood_pressure => 'ضغط الدم';

  @override
  String get vital_heart_rate => 'نبض القلب';

  @override
  String get vital_blood_glucose => 'سكر الدم';

  @override
  String get vital_temperature => 'درجة الحرارة';

  @override
  String get vital_weight => 'الوزن';

  @override
  String get vital_oxygen_saturation => 'تشبع الأكسجين';

  @override
  String get vital_respiratory_rate => 'معدل التنفس';

  @override
  String get vital_other => 'أخرى';

  @override
  String get addIllness => 'إضافة مرض';

  @override
  String get condition => 'المرض';

  @override
  String get diagnosedDate => 'تاريخ التشخيص';

  @override
  String get addDietRule => 'إضافة قاعدة غذائية';

  @override
  String get foodItemEn => 'الطعام (إنجليزي)';

  @override
  String get foodItemAr => 'الطعام (عربي)';

  @override
  String get ruleType => 'القاعدة';

  @override
  String get diet_avoid => 'تجنب';

  @override
  String get diet_limit => 'تقليل';

  @override
  String get diet_prefer => 'يُفضَّل';

  @override
  String get diet_separate_from_medication => 'بعيداً عن الدواء';

  @override
  String get dietNoInferenceNote =>
      'تُسجَّل القواعد الغذائية كما أُدخلت؛ لا يستنتج التطبيق أي قواعد طبية.';

  @override
  String get addPrescription => 'إضافة روشتة';

  @override
  String get pickFile => 'اختر صورة أو ملف PDF';

  @override
  String fileSelected(Object name) {
    return 'الملف: $name';
  }

  @override
  String get issueDate => 'تاريخ الروشتة';

  @override
  String get fileMissing => 'ملف الروشتة غير موجود على هذا الجهاز';

  @override
  String get openFile => 'فتح';

  @override
  String get prescriptionsPrivateNote =>
      'تُحفظ داخل التطبيق فقط ولا تُضاف أبداً إلى تقارير الطبيب.';

  @override
  String get filesUnsupported => 'إرفاق الملفات غير متاح على هذه المنصة';

  @override
  String get noRecords => 'لا توجد سجلات بعد';

  @override
  String get meals => 'الوجبات';

  @override
  String get addMeal => 'إضافة وجبة';

  @override
  String get editMeal => 'تعديل الوجبة';

  @override
  String get mealType => 'نوع الوجبة';

  @override
  String get meal_breakfast => 'الإفطار';

  @override
  String get meal_lunch => 'الغداء';

  @override
  String get meal_dinner => 'العشاء';

  @override
  String get meal_snack => 'وجبة خفيفة';

  @override
  String get meal_custom => 'مخصصة';

  @override
  String get mealTime => 'وقت الوجبة';

  @override
  String mealDefaultTime(Object time) {
    return 'الافتراضي $time';
  }

  @override
  String get mealsNote => 'تغيير وقت الوجبة ينقل كل الجرعات المرتبطة بها.';

  @override
  String get reports => 'التقارير';

  @override
  String get doctorReport => 'تقرير الطبيب';

  @override
  String get summaryReport => 'ملخص';

  @override
  String get detailedReport => 'مفصل';

  @override
  String get period => 'الفترة';

  @override
  String get periodAll => 'كل الفترات';

  @override
  String get period7 => 'آخر 7 أيام';

  @override
  String get period30 => 'آخر 30 يوماً';

  @override
  String get period90 => 'آخر 90 يوماً';

  @override
  String get exportPdf => 'تصدير PDF';

  @override
  String reportGeneratedOn(Object date) {
    return 'أُنشئ في $date';
  }

  @override
  String get reportPeriodAll => 'الفترة: كل الفترات';

  @override
  String reportPeriodRange(Object from, Object to) {
    return 'الفترة: $from – $to';
  }

  @override
  String get adherence => 'الالتزام';

  @override
  String get overallAdherence => 'نسبة الالتزام العامة';

  @override
  String get takenOnTime => 'في الموعد';

  @override
  String get takenLate => 'متأخرة';

  @override
  String get medicationsSection => 'الأدوية';

  @override
  String get doseHistorySection => 'سجل الجرعات';

  @override
  String get vitalsSection => 'القياسات الحيوية';

  @override
  String get appointmentsSection => 'المواعيد الطبية';

  @override
  String get illnessesSection => 'الأمراض';

  @override
  String get dietSection => 'القواعد الغذائية';

  @override
  String get patientSection => 'المريض';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get inventoryReport => 'تقرير المخزون';

  @override
  String get whatWeHave => 'ما الأدوية المتوفرة لدينا؟';

  @override
  String get whatToBuy => 'ما الذي يحتاج إلى شراء؟';

  @override
  String get nothingToBuy => 'لا يوجد ما يحتاج إلى شراء';

  @override
  String get pdfArabicFontMissing =>
      'خط PDF العربي غير مضمّن؛ قد لا يظهر النص العربي في ملف PDF.';

  @override
  String get backup => 'النسخ الاحتياطي';

  @override
  String get backupTitle => 'النسخ الاحتياطي والاستعادة';

  @override
  String get backupNote =>
      'النسخ الاحتياطية ملفات ZIP قابلة للنقل وغير مشفرة. احفظها في مكان آمن.';

  @override
  String get exportBackup => 'تصدير المريض الحالي';

  @override
  String get exportBackupBody =>
      'كل ما يلزم لإعادة بناء ملف هذا المريض، بما في ذلك ملفات الروشتات.';

  @override
  String get importAsNew => 'استيراد كمريض جديد';

  @override
  String get importAsNewBody => 'يُنشئ ملفاً منفصلاً بمعرفات جديدة.';

  @override
  String get mergeBackup => 'دمج مع نفس المريض';

  @override
  String get mergeBackupBody =>
      'يحتفظ بأحدث التعديلات وكل الأحداث التاريخية الفريدة.';

  @override
  String backupSaved(Object name) {
    return 'النسخة جاهزة: $name';
  }

  @override
  String importDone(Object name) {
    return 'تم استيراد $name';
  }

  @override
  String mergeDone(Object added, Object updated) {
    return 'تم الدمج: أُضيف $added وحُدِّث $updated';
  }

  @override
  String get invalidBackup => 'هذا الملف ليس نسخة احتياطية صالحة لبالميعاد';

  @override
  String get newerBackup => 'هذه النسخة من إصدار أحدث من التطبيق';

  @override
  String get backupPatientMissing =>
      'مريض هذه النسخة غير موجود هنا. استوردها كمريض جديد.';

  @override
  String get trash => 'سلة المحذوفات';

  @override
  String get trashEmpty => 'سلة المحذوفات فارغة';

  @override
  String get restored => 'تمت الاستعادة';

  @override
  String get deletedPermanently => 'تم الحذف نهائياً';

  @override
  String get permanentDeleteTitle => 'حذف نهائي؟';

  @override
  String get permanentDeleteBody => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String deletedOn(Object date) {
    return 'حُذف في $date';
  }

  @override
  String get entity_patient => 'مريض';

  @override
  String get entity_medication => 'دواء';

  @override
  String get entity_inventory_batch => 'دفعة مخزون';

  @override
  String get entity_appointment => 'موعد طبي';

  @override
  String get entity_vital_measurement => 'قياس';

  @override
  String get entity_illness => 'مرض';

  @override
  String get entity_dietary_rule => 'قاعدة غذائية';

  @override
  String get entity_prescription => 'روشتة';

  @override
  String get entity_meal => 'وجبة';

  @override
  String get auditLog => 'سجل النشاط';

  @override
  String get auditEmpty => 'لا يوجد نشاط بعد';

  @override
  String get systemActor => 'التطبيق';

  @override
  String get unknownActor => 'غير معروف';

  @override
  String get audit_created => 'إنشاء';

  @override
  String get audit_updated => 'تعديل';

  @override
  String get audit_deleted => 'نقل إلى سلة المحذوفات';

  @override
  String get audit_restored => 'استعادة';

  @override
  String get audit_permanently_deleted => 'حذف نهائي';

  @override
  String get audit_archived => 'أرشفة';

  @override
  String get audit_unarchived => 'إلغاء الأرشفة';

  @override
  String get audit_inventory_added => 'إضافة مخزون';

  @override
  String get audit_inventory_edited => 'تعديل مخزون';

  @override
  String get audit_inventory_adjusted => 'تسوية مخزون';

  @override
  String get audit_inventory_deleted => 'حذف مخزون';

  @override
  String get audit_dose_taken => 'تناول جرعة';

  @override
  String get audit_dose_undone => 'إلغاء تناول جرعة';

  @override
  String get audit_dose_skipped => 'تخطي جرعة';

  @override
  String get audit_dose_missed => 'جرعة فائتة';

  @override
  String get audit_prn_logged => 'تسجيل جرعة عند اللزوم';

  @override
  String get audit_batch_manually_selected => 'اختيار دفعة يدوياً';

  @override
  String get audit_maximum_daily_overridden => 'تجاوز الحد الأقصى اليومي';

  @override
  String get audit_caregiver_assigned => 'إضافة مقدم رعاية';

  @override
  String get audit_caregiver_removed => 'إزالة مقدم رعاية';

  @override
  String get audit_imported => 'استيراد من نسخة احتياطية';

  @override
  String get audit_merged => 'دمج من نسخة احتياطية';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get notificationSettings => 'تفضيلات الإشعارات';

  @override
  String get markAllRead => 'تحديد الكل كمقروء';

  @override
  String get noNotifications => 'لا توجد إشعارات';

  @override
  String get notif_dose_reminder => 'تذكيرات الأدوية';

  @override
  String get notif_missed_dose => 'الجرعات الفائتة';

  @override
  String get notif_low_stock => 'المخزون المنخفض';

  @override
  String get notif_empty_stock => 'نفاد المخزون';

  @override
  String get notif_expiration => 'انتهاء الصلاحية';

  @override
  String get notif_appointment_reminder => 'تذكيرات المواعيد الطبية';

  @override
  String get notificationsPerPatient =>
      'تنطبق التفضيلات على المريض الحالي فقط.';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get theme => 'المظهر';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeSystem => 'حسب النظام';

  @override
  String get expiryThreshold => 'التنبيه بقرب انتهاء الصلاحية';

  @override
  String daysCount(Object count) {
    return '$count يوم';
  }

  @override
  String get missedGrace => 'اعتبار الجرعة فائتة بعد';

  @override
  String minutesCount(Object count) {
    return '$count دقيقة';
  }

  @override
  String hoursCount(Object count) {
    return '$count ساعات';
  }

  @override
  String get inactivityReset => 'العودة للرئيسية بعد عدم الاستخدام';

  @override
  String get inactivityResetNote =>
      'يعيد الشاشة فقط. ليس قفلاً ولا يحتاج كلمة مرور.';

  @override
  String get off => 'إيقاف';

  @override
  String get about => 'عن التطبيق';

  @override
  String get aboutBody =>
      'يعمل بالميعاد بالكامل بدون إنترنت. تُحفظ البيانات على هذا الجهاز فقط بدون حسابات أو سحابة أو تشفير.';

  @override
  String catalogEntries(Object count) {
    return '$count دواء في الدليل المحلي';
  }

  @override
  String version(Object version) {
    return 'الإصدار $version';
  }

  @override
  String get error_nameRequired => 'من فضلك أدخل الاسم';

  @override
  String get error_invalidTimezone => 'منطقة زمنية غير معروفة';

  @override
  String get error_doseUnitRequired => 'من فضلك اختر وحدة الجرعة';

  @override
  String get error_endBeforeStart => 'تاريخ الانتهاء قبل تاريخ البدء';

  @override
  String get error_invalidMaximum => 'يجب أن يكون الحد الأقصى أكبر من صفر';

  @override
  String get error_quantityRequired => 'من فضلك أدخل كمية أكبر من صفر';

  @override
  String get error_invalidQuantity => 'أدخل كمية مثل 1 أو 0.5 أو 1.25';

  @override
  String get error_invalidTime => 'من فضلك اختر وقتاً صحيحاً';

  @override
  String get error_mealRequired => 'من فضلك اختر الوجبة';

  @override
  String get error_weekdaysRequired => 'اختر يوماً واحداً على الأقل';

  @override
  String get error_invalidRecurrence => 'راجع إعدادات التكرار';

  @override
  String get error_invalidScheduleType => 'اختر نوع التوقيت';

  @override
  String get error_useAdjustment =>
      'لهذه الدفعة سجل؛ استخدم تعديل المخزون لتغيير الكمية';

  @override
  String get error_negativeStock => 'لا يمكن أن يصبح المخزون سالباً';

  @override
  String get error_insufficientStock => 'المخزون الصالح غير كافٍ';

  @override
  String get error_invalidDoseTransition =>
      'لم يعد من الممكن تغيير هذه الجرعة بهذه الطريقة';

  @override
  String get error_doseWindowClosed =>
      'انتهت المهلة المسموحة لهذه الجرعة وأصبحت فائتة';

  @override
  String get error_actualQuantityZero =>
      'لم يتم تناول شيء، لذلك لم تُسجَّل الجرعة';

  @override
  String get error_batchNotUsable =>
      'لا يمكن استخدام هذه الدفعة (منتهية أو فارغة أو محذوفة)';

  @override
  String get error_allocationTotalMismatch =>
      'يجب أن يساوي مجموع الدفعات المختارة الكمية المتناولة';

  @override
  String get error_invalidAllocation => 'كميات الدفعات غير صحيحة';

  @override
  String get error_batchHasHistory =>
      'لا يمكن حذف دفعة لها سجل استهلاك نهائياً';

  @override
  String get error_mealInUse => 'هذه الوجبة مستخدمة في أحد المواعيد';

  @override
  String get error_valueRequired => 'من فضلك أدخل القيمة';

  @override
  String get error_doctorRequired => 'من فضلك أدخل اسم الطبيب';

  @override
  String get error_patientAlreadyExists => 'لهذا الشخص ملف مريض بالفعل';

  @override
  String get error_invalidPrice => 'لا يمكن أن يكون السعر سالباً';

  @override
  String get error_invalidDate => 'تاريخ غير صحيح';

  @override
  String get error_invalidPackages => 'لا يمكن أن يكون عدد العبوات سالباً';

  @override
  String get error_invalidReason => 'اختر السبب';

  @override
  String get error_notFound => 'العنصر لم يعد موجوداً';

  @override
  String get error_maximumDailyExceeded => 'سيتم تجاوز الحد الأقصى اليومي';

  @override
  String get error_unsupportedTrashEntity =>
      'لا يمكن نقل هذا العنصر إلى سلة المحذوفات';

  @override
  String get error_invalidBackup =>
      'هذا الملف ليس نسخة احتياطية صالحة لبالميعاد';

  @override
  String get error_newerBackup => 'هذه النسخة من إصدار أحدث من التطبيق';

  @override
  String get error_backupPatientMissing => 'مريض هذه النسخة غير موجود هنا';

  @override
  String get error_filesUnsupported => 'الملفات غير مدعومة على هذه المنصة';
}
