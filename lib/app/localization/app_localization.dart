import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeProvider = StateNotifierProvider<LocaleController, Locale>(
  (ref) => LocaleController(),
);

class LocaleController extends StateNotifier<Locale> {
  LocaleController() : super(const Locale('en')) {
    _load();
  }

  Future<void> _load() async {
    final preferences = await SharedPreferences.getInstance();
    final savedLanguageCode = preferences.getString('language_code');
    if (savedLanguageCode == 'ar' || savedLanguageCode == 'en') {
      state = Locale(savedLanguageCode);
    }
  }

  Future<void> toggle() async {
    final next = state.languageCode == 'ar' ? 'en' : 'ar';
    state = Locale(next);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('language_code', next);
  }
}

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
    'backup': 'Backup',
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
    'backup': 'النسخ الاحتياطي',
    'arabic': 'عربي',
    'english': 'English',
  };
}
