# BelMiad — بالميعاد

Offline-first patient health and medication management app for patients,
family caregivers and private nurses, built with Flutter. Everything is
stored on the device in SQLite; there is no backend, account, cloud or
encryption (by design, see the specification).

## Features

- **Patients and caregivers** — multiple patients on one phone, a current
  patient switcher, device caregiver identity (attribution only, no login),
  caregiver assignments that keep historical actors after removal.
- **Medicines** — offline Egyptian drug catalog (25,065 entries, English and
  Arabic FTS5 search) or custom medicines, separate English/Arabic
  instructions, PRN, maximum daily quantity, archive/restore, trash.
- **Dose plans** — set several times of day once (quick presets such as
  "3 times a day after meals" or "every 8 hours"), each at a fixed time or
  relative to a meal, with its own quantity; daily, selected weekdays every
  N weeks, every N days, custom on/off cycles, per-weekday quantities,
  start/end dates, patient timezone.
- **Meals** — the same time every day or a different time per weekday
  (e.g. breakfast 08:00 on Saturday, 09:00 on Friday); meal-relative doses
  move automatically.
- **Doses** — SCHEDULED/TAKEN/MISSED/SKIPPED with calculated late minutes,
  a grace window before doses become missed, undo, partial and zero
  quantities, PRN logging and the daily-maximum warning.
- **Inventory** — batch ledger with nested packaging (boxes of strips of
  tablets, bottles in ml, tubes, ampoules, loose units), storage-only
  medicines that are stocked without being part of the treatment, purchase
  date and price, expiration, FEFO or manual multi-batch consumption stored per dose,
  exact-batch undo, audited adjustments, forecast-based low stock (next 3
  days), remaining days simulated from real schedules, expiration states.
- **Health records** — appointments, vitals (blood pressure and sugar can be
  marked fasting, before/after a meal or after a medicine), illnesses,
  dietary rules, and prescriptions captured with the camera (after asking
  for permission) or picked from files, saved as a photo or a multi-page
  PDF in app-private storage and grouped by doctor, date or file type.
- **Today** — live clock in the patient's timezone and the day's doses.
- **Notifications** — offline dose reminders, missed doses, low/empty stock,
  expiring/expired batches and appointment reminders, per-patient
  preferences, deduplicated across launches, plus an in-app centre.
- **Reports** — summary and detailed doctor reports and a storage report,
  in-app and as PDF (Arabic and English).
- **Backup** — versioned `backup.zip` export per patient, import as a new
  patient, merge into the same patient, legacy v1 migration.
- **Trash and audit** — restore or permanently delete; full activity history.
- **Arabic/English** with RTL/LTR, blue (`#0064F6`) and white theme, light
  mode by default and dark mode.

## Getting started

```bash
flutter pub get
flutter run
```

Code generation (Drift, Freezed, json_serializable) and localizations are
committed; regenerate after changing tables, freezed models or ARB files:

```bash
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

### Android APK

Requires the Android SDK (API 37 platform) and JDK 17+ (Android Studio's
bundled JBR works). Point Flutter at them once, then build:

```bash
flutter config --android-sdk <path-to-sdk> --jdk-dir <path-to-jdk>
flutter build apk --release
```

The APK is written to `build/app/outputs/flutter-apk/app-release.apk`. Use
`--split-per-abi` for smaller per-device APKs. Release builds are currently
signed with the debug key, which is fine for installing on your own devices
but not for store publishing.

### Drug catalog asset

`assets/data/drug_catalog.sqlite` is generated from
`assets/data/egyptian-drugs.csv` at development time (never at app start):

```bash
dart run tool/build_catalog.dart
```

After regenerating, bump `catalogAssetVersion` in
`lib/features/catalog/data/drug_catalog_database.dart` so devices copy the
new catalog. Patient data lives in a separate database and is never touched.

### Tests

```bash
flutter test
```

Unit, Drift integration, widget and PDF tests cover scaled quantities,
recurrence, meal timing, FEFO, multi-batch consumption, partial/zero doses,
undo, rollback on failure, PRN maximums, forecasting, expiration, dose
generation, timezone changes, notification deduplication, backup/merge,
catalog search, RTL/LTR and dose confirmation.

## Architecture

Feature-first layers: `presentation → application → domain → data → database`.
Business rules live in domain/application services; widgets never mutate
tables directly. Critical dose/inventory operations run in single Drift
transactions.

```text
lib/
├── app/          theme, router, providers, localization labels, widgets
├── core/         database, time, files, notifications, settings, errors
├── features/     patients, caregivers, medications, catalog, schedules,
│                 doses, inventory, meals, health, notifications, reports,
│                 backup, trash, audit, dashboard, settings
└── l10n/         ARB files and generated localizations
```

## Platform notes

- Android needs notification and exact-alarm permissions (declared in the
  manifest); scheduled notifications survive reboots.
- The web build uses Drift WASM (`web/sqlite3.wasm`, `web/drift_worker.js`);
  OS notifications are not available there, but the in-app centre works.
- Fonts: Noto Naskh Arabic (SIL OFL, `assets/fonts/OFL.txt`) is bundled so
  Arabic renders offline in the UI and PDFs.

`index.html`, `app.js` and `styles.css` in the repository root are the
earlier browser prototype and are not part of the Flutter app.
