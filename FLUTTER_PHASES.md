# BelMiad Flutter implementation phases

1. **Foundation** — Flutter project, theme, routing, feature-first folders, offline asset wiring. *(Started and committed.)*
2. **Local data layer** — Drift SQLite database, migrations, patient context, audit events, trash.
3. **Patients and medicines** — Patient CRUD, caregiver identity, medicine CRUD, catalog search, Arabic/English fields.
4. **Schedules and doses** — Recurrence, PRN, meals, dose state machine, scaled quantities, dose history.
5. **Inventory** — Batch ledger, boxes/strips/units, expiry, FEFO, stock adjustments, low-stock forecast, consumption transactions.
6. **Health records** — Appointments, vitals, illnesses, diet rules, prescription files.
7. **Notifications** — Offline medication, missed-dose, low-stock, and expiry notifications.
8. **Reports and backup** — Doctor reports, inventory reports, PDF export, versioned backup/import/merge.
9. **Localization and polish** — Arabic RTL, accessibility, responsive layouts, empty/error states.
10. **Verification and release** — Unit, integration, and widget tests; build and release configuration.

The Flutter SDK is not currently installed in this environment, so Phase 1 is committed as source scaffolding but cannot yet be run or dependency-resolved here.
