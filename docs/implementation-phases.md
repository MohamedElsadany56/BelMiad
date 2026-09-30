# BelMiad Flutter implementation phases

1. **Foundation** — Flutter project, feature-first folders, dependencies. *(Done)*
2. **Theme and localization** — `#0064F6`/white Material 3 theme, dark mode, gen_l10n ARB (English/Arabic), RTL, bundled Arabic font. *(Done)*
3. **Drift database** — specification schema, indexes, soft deletion, settings. *(Done)*
4. **Persons, patients, caregivers** — device caregiver identity, assignments, current patient. *(Done)*
5. **Medications and drug catalog** — FTS5 catalog asset built from CSV, custom medicines, PRN, maximum daily quantity. *(Done)*
6. **Schedules and recurrence** — fixed and meal-relative timing, generic recurrence, per-weekday quantities. *(Done)*
7. **Dose generation** — deterministic per schedule/date, regeneration on changes, missed marking. *(Done)*
8. **Inventory batches** — ledger, adjustments, FEFO, forecasting, expiration. *(Done)*
9. **Dose consumption transactions** — take/PRN/skip/undo with multi-batch allocation. *(Done)*
10. **Notifications** — offline reminders and alerts with deduplication. *(Done)*
11. **Appointments, vitals, diet, illnesses** — *(Done)*
12. **Prescription storage** — app-private files. *(Done)*
13. **Reports and PDF** — summary/detailed doctor reports, storage report. *(Done)*
14. **Backup, import, merge** — versioned ZIP, legacy migration. *(Done)*
15. **Trash and audit** — *(Done)*
16. **Testing** — unit, Drift integration, widget and PDF tests. *(Done)*
17. **Polish and release** — release signing and store assets remain to be configured.
