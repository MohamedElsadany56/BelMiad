import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));

class AppStrings {
  const AppStrings(this.locale);

  final Locale locale;

  bool get isArabic => locale.languageCode == 'ar';

  String text(String key) {
    final values = isArabic ? _arabic : _english;
    return values[key] ?? key;
  }

  static const _english = <String, String>{
    'appName': 'BelMiad',
    'dashboard': 'Dashboard',
    'medicines': 'Medicines',
    'stock': 'Stock & batches',
    'schedule': 'Medicine schedule',
    'patients': 'Patients',
    'records': 'Health records',
    'settings': 'Settings',
    'reports': 'Reports',
    'arabic': 'عربي',
    'english': 'English',
  };

  static const _arabic = <String, String>{
    'appName': 'بالميعاد',
    'dashboard': 'الرئيسية',
    'medicines': 'الأدوية',
    'stock': 'المخزون والدفعات',
    'schedule': 'جدول الأدوية',
    'patients': 'المرضى',
    'records': 'السجل الصحي',
    'settings': 'الإعدادات',
    'reports': 'التقارير',
    'arabic': 'عربي',
    'english': 'English',
  };
}
