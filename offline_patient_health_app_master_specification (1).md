# Offline Patient Health & Medication Management App

## Master AI-Agent Prompt, Requirements, System Design & Use Cases

**Purpose:** Single source of truth for implementing the V1 Flutter
application.\
**Target:** AI coding agent / senior developer.\
**V1:** Fully offline-first. No backend, authentication, encryption,
Firebase, Supabase, or cloud dependency.

------------------------------------------------------------------------

# 1. Master AI Agent Prompt

Implement a production-quality offline-first Flutter/Dart mobile
application for **patients, family caregivers, and private nurses**.

Use:

-   Flutter / Dart
-   Drift + SQLite
-   Riverpod
-   go_router
-   Freezed
-   json_serializable
-   flutter_local_notifications + native alarm capabilities where needed
-   Flutter `gen_l10n` + ARB
-   SQLite FTS5
-   app-private local file storage
-   local PDF generation
-   portable backup/export/import

The **local SQLite database is the source of truth**.

Use a **feature-first layered architecture**:

``` text
presentation
application/use-cases
domain
data/repositories
database
services
```

Do not put business logic in widgets.

V1 must work completely offline.

The app supports:

-   multiple patients on one phone
-   patient/caregiver/nurse workflows
-   medications
-   medication schedules
-   PRN medications
-   medication inventory and stock batches
-   dose tracking
-   meals and meal-relative dosing
-   appointments
-   vitals
-   illnesses
-   dietary rules
-   prescription images
-   notifications
-   low-stock forecasting
-   expiration warnings
-   doctor reports
-   storage/inventory reports
-   audit history
-   trash/recovery
-   backup/import/merge
-   Arabic/English
-   RTL/LTR

------------------------------------------------------------------------

# 2. Product & User Decisions

## Users

Primary use cases:

1.  Patient
2.  Family caregiver
3.  Private nurse

A person may be both patient and caregiver.

A patient may exist without being the app user.

A caregiver may create a patient profile for someone else.

A patient may have multiple caregivers.

A caregiver may manage multiple patients.

## Device identity

Each physical phone has one caregiver identity.

The caregiver must identify/select themselves before
caregiver-attributed editing.

This is **not authentication** and provides no security boundary.

There is no ownership restriction in V1: the person using the phone can
create/edit/delete data.

Historical actions must retain the actor even if a caregiver
relationship is later removed.

## Current patient

The application has a current patient selector, e.g.:

> Mother

All patient-specific screens operate on the selected patient. Switching
patients refreshes all patient-specific data.

------------------------------------------------------------------------

# 3. Security Decisions

Explicitly **do not implement**:

-   PIN
-   password
-   biometric authentication
-   local database encryption
-   prescription encryption
-   backup encryption
-   mandatory login/authentication

There is an inactivity reset, but it is **not a security lock**.

On timeout:

-   reset current screen/session
-   return to the appropriate start screen
-   do not authenticate the user

------------------------------------------------------------------------

# 4. Architecture

## Technology

``` text
Flutter
Dart
├── Riverpod
├── go_router
├── Drift
├── SQLite
├── Freezed
├── json_serializable
├── flutter_local_notifications
├── gen_l10n / ARB
└── local file storage
```

## Static Egyptian Drug Catalog

The project includes an `egyptian-drugs.csv` source dataset containing 25K+ Egyptian medicine records.

For the application runtime, keep the catalog intentionally minimal. **Only these user-facing fields are required:**

- `commercial_name_en`
- `commercial_name_ar`
- `price_egp`

Do **not** store scientific name, manufacturer, drug class, route, or other source columns in the runtime catalog unless a future feature explicitly requires them.

The source CSV may contain additional columns, but the import pipeline must project only the three required fields.

Use a separate read-only SQLite database for the catalog where practical. The catalog is reference data, not patient data.

Search must support:

- English commercial-name search
- Arabic commercial-name search
- partial terms
- typo-tolerant/friendly matching where practical

Use SQLite FTS5 rather than repeatedly scanning all 25K+ rows with `LIKE`.

Keep the original display strings unchanged. Create separate normalized/search strings for indexing so Arabic normalization never corrupts what the user sees.

The CSV must be UTF-8 encoded, with a comma delimiter and a header row:

```csv
commercial_name_en,commercial_name_ar,price_egp
```

Generate `catalog_id` internally during import; do not require it in the CSV.

The importer must:

1. Read the CSV as a stream/row iterator.
2. Validate the required columns.
3. Parse `price_egp` as a numeric decimal.
4. Preserve Arabic as Unicode.
5. Normalize only the search/index copy.
6. Trim surrounding whitespace.
7. Ignore or report malformed rows without loading the entire file into memory.
8. Batch SQLite inserts inside transactions.
9. Build/rebuild the FTS5 index after bulk import.
10. Deduplicate identical commercial-name/language/price records when appropriate.
11. Report rejected rows and their reasons.

Do not load all 25K+ records into a Flutter list/provider at startup.

For UI search:

- wait until the user has entered a useful query length (normally 2+ characters)
- debounce text input (around 200–300 ms)
- query SQLite directly
- return a small result window, e.g. 20–50 rows
- paginate/load more only when requested
- select only the columns needed by the result card
- never `SELECT *` for search results
- never fetch the entire catalog before filtering

For exact/strong matches, rank exact name matches before prefix/FTS matches.

Suggested runtime tables:

```sql
CREATE TABLE drug_catalog (
  catalog_id TEXT PRIMARY KEY,
  commercial_name_en TEXT NOT NULL,
  commercial_name_ar TEXT NOT NULL,
  price_egp REAL NOT NULL
);

CREATE VIRTUAL TABLE drug_catalog_fts USING fts5(
  commercial_name_en,
  commercial_name_ar,
  content='drug_catalog',
  content_rowid='rowid'
);
```

For 25K+ records, this size is small enough for SQLite/FTS5 and should not require a server or network search service.

### Arabic search normalization

Maintain the original Arabic value for display and a normalized value for search. The normalization pipeline may include:

- Unicode normalization
- trimming/repeated-whitespace cleanup
- removal of Arabic tatweel (`ـ`)
- normalization of common Alef variants
- normalization of `ى`/`ي` where appropriate for search
- removal of harmless Arabic diacritics
- Unicode-aware case folding for Latin text

Do not overwrite the original Arabic name with the normalized value.

### Important encoding rule

If an incoming CSV contains mojibake such as:

```text
Ø¥ÙƒØ³ØªØ±Ø§
```

do not silently treat it as valid Arabic. Detect suspicious encoding and either repair it using a controlled UTF-8/legacy-encoding recovery step or report the row for correction. Never invent an Arabic medicine name.

### Recommended search query strategy

Prefer FTS5 for normal searches:

```sql
SELECT
  c.catalog_id,
  c.commercial_name_en,
  c.commercial_name_ar,
  c.price_egp
FROM drug_catalog_fts f
JOIN drug_catalog c ON c.rowid = f.rowid
WHERE drug_catalog_fts MATCH ?
ORDER BY bm25(drug_catalog_fts)
LIMIT ? OFFSET ?;
```

For a prefix-oriented search, tokenize the user's query and use an FTS5 prefix expression such as:

```text
panad*
```

or the equivalent generated by the search service.

Do not build SQL by string-concatenating raw user input. Bind the final FTS query parameter.

For an empty query, show recent/popular/explicitly selected entries instead of scanning the whole table.

### Catalog import performance

Target behavior:

```text
CSV
 ↓
stream reader
 ↓
validate/project 3 fields
 ↓
batch INSERT in transaction
 ↓
FTS index build
 ↓
read-only catalog SQLite
 ↓
Flutter search → SQLite → 20–50 results
```

The application must not parse the CSV on every launch. Import/build the SQLite catalog once during development/build preparation and ship the resulting read-only database as an asset.

## Project structure

``` text
lib/
├── app/
│   ├── router/
│   ├── theme/
│   ├── localization/
│   └── app.dart
├── core/
│   ├── database/
│   ├── time/
│   ├── notifications/
│   ├── files/
│   ├── backup/
│   ├── errors/
│   └── utilities/
├── features/
│   ├── patients/
│   ├── caregivers/
│   ├── medications/
│   ├── inventory/
│   ├── schedules/
│   ├── doses/
│   ├── meals/
│   ├── appointments/
│   ├── vitals/
│   ├── illnesses/
│   ├── dietary_rules/
│   ├── prescriptions/
│   ├── reports/
│   ├── notifications/
│   ├── backup/
│   └── trash/
└── main.dart
```

------------------------------------------------------------------------

# 5. Time & Timezone

Store actual event timestamps in UTC.

Recurring schedules are local wall-clock schedules.

Store the patient's IANA timezone, e.g.:

``` text
Africa/Cairo
```

When traveling, preserve the same local clock time and recalculate UTC.

V1 does not need special DST optimization, but the architecture must not
assume UTC-only schedules.

------------------------------------------------------------------------

# 6. Medication Requirements

A medication belongs to one patient.

It can reference the static drug catalog or be completely custom.

Support:

-   English name
-   Arabic name
-   scientific name through catalog
-   strength
-   dosage form
-   route
-   dose unit
-   English instructions
-   Arabic instructions
-   start date
-   end date
-   PRN
-   maximum daily quantity
-   status
-   soft deletion

Medication instructions in English and Arabic are entered independently.
Do not auto-translate.

A medication can exist without inventory.

Distinguish:

> Stock not recorded

from:

> Stock = 0

------------------------------------------------------------------------

# 7. Medication Schedules

One medication can have multiple schedules.

Examples:

``` text
08:00 → 1 tablet
14:00 → 1 tablet
22:00 → 2 tablets
```

Different days may have different quantities.

Support generic recurrence:

-   daily
-   weekly
-   selected weekdays
-   every N days
-   custom recurrence

Do not infer pregnancy/contraceptive schedules from sex or age. Use a
generic recurrence engine.

------------------------------------------------------------------------

# 8. PRN Medications

PRN medications are supported.

Do not invent future PRN consumption unless the user configured a
planned frequency.

Actual PRN usage is recorded when taken.

If maximum daily quantity exists, enforce/check it.

Example:

``` text
Maximum = 4 tablets/day
Already taken = 3
Attempt = 2
```

Warn that the configured maximum would be exceeded.

------------------------------------------------------------------------

# 9. Dose State Machine

Statuses:

``` text
SCHEDULED
TAKEN
MISSED
SKIPPED
```

Late is **not** a state.

Store/calculated:

``` text
late_minutes
```

Transitions:

``` text
SCHEDULED → TAKEN
SCHEDULED → MISSED
SCHEDULED → SKIPPED
TAKEN → SCHEDULED   // undo
```

MISSED and SKIPPED are terminal.

A missed dose cannot later be marked taken.

A dose can be taken late if it is still within the permitted
interaction/grace rules.

------------------------------------------------------------------------

# 10. Dose Quantity

Never use floating point for medication quantities.

Use scaled integers.

Recommended:

``` text
quantity_scale = 1000
```

Examples:

``` text
0.25 tablet = 250
0.5 tablet  = 500
1 tablet    = 1000
1.5 tablets = 1500
2 tablets   = 2000
```

------------------------------------------------------------------------

# 11. Meals & Relative Dosing

Meals:

-   breakfast
-   lunch
-   dinner
-   snack
-   custom meals

Medication timing:

-   before meal
-   with meal
-   after meal
-   arbitrary minute offset
-   fixed time

Example:

``` text
30 minutes before breakfast
45 minutes after lunch
```

Changing a meal time must update relative medication timing.

If meal time is not set, use the meal's default time.

------------------------------------------------------------------------

# 12. Inventory System

Inventory is a **real batch ledger**, not one remaining-quantity field.

A medication may have unlimited inventory batches.

Example:

``` text
Panadol 500 mg

Batch A:
10 tablets
expires 2026-10-01

Batch B:
20 tablets
expires 2027-02-01
```

Total = 30 tablets, but batches remain separate.

Each batch retains:

-   purchase date
-   purchase price
-   expiration
-   packaging
-   quantity
-   consumption history

------------------------------------------------------------------------

# 13. Add Inventory Use Cases

Inventory can be added:

1.  Medication Details → Inventory → Add Stock
2.  Inventory → Add Stock → Select Medication
3.  After creating medication → optionally Add Stock

Fields:

-   medication
-   available quantity
-   purchase date
-   purchase price
-   expiration date
-   packaging type
-   package count
-   units per package

Packaging examples:

-   box
-   blister
-   bottle
-   tube
-   sachet
-   vial
-   ampoule
-   container
-   other

------------------------------------------------------------------------

# 14. Inventory Quantity Rules

Use scaled integers.

For:

``` text
2 boxes × 20 tablets
```

available quantity = 40 tablets.

Never allow:

``` text
available_quantity_scaled < 0
```

When quantity reaches zero:

``` text
is_depleted = true
```

Do not automatically delete depleted batches.

------------------------------------------------------------------------

# 15. Automatic Batch Selection

Use FEFO:

> First Expire, First Out

Selection order:

1.  valid/non-expired
2.  earliest expiration
3.  earliest purchase date
4.  deterministic stable ID

Do not automatically select expired stock.

Expired batches remain visible.

If manual expired-stock use is ever enabled, it must require explicit
user action and warning.

------------------------------------------------------------------------

# 16. Manual Batch Selection

Users may override automatic selection.

One dose can consume multiple batches.

Example:

``` text
Required = 5 tablets
Batch A = 2
Batch B = 10

Consume:
Batch A = 2
Batch B = 3
```

Represent this using:

`dose_inventory_consumption`

Never store only one inventory batch ID on the dose.

------------------------------------------------------------------------

# 17. Insufficient Stock

Example:

``` text
Required = 2 tablets
Available = 1 tablet
```

Ask:

> How much did you actually take?

Allow:

-   0
-   0.5
-   1
-   custom

If user records 1:

``` text
status = TAKEN
required = 2
actual = 1
```

This is a partially fulfilled dose.

If actual = 0:

-   do not mark TAKEN
-   do not create consumption
-   allow Skip or leave scheduled

------------------------------------------------------------------------

# 18. Taking a Dose Transaction

The following must happen in one DB transaction:

1.  Validate dose
2.  Validate actual quantity
3.  Check maximum daily quantity
4.  Select eligible inventory batches
5.  Create consumption records
6.  Decrement inventory
7.  Mark dose TAKEN
8.  Calculate late minutes
9.  Create audit event
10. Update relevant notification state

If any operation fails:

``` text
ROLLBACK EVERYTHING
```

------------------------------------------------------------------------

# 19. Undo Dose Transaction

Undoing a TAKEN dose must:

1.  Load dose
2.  Verify TAKEN
3.  Load exact consumption records
4.  Restore exact original batches
5.  Remove/reverse consumption
6.  Return dose to SCHEDULED
7.  Clear taken_at
8.  Clear actual quantity
9.  Clear late minutes
10. Create audit event

Never restore quantity to an arbitrary batch.

------------------------------------------------------------------------

# 20. Inventory Editing & Adjustment

If a batch has historical consumption, do not silently rewrite original
purchase quantities.

Use a stock adjustment operation.

Support:

``` text
+ Add quantity
- Remove quantity
```

Reasons:

-   manual correction
-   damaged medication
-   lost medication
-   returned medication
-   count correction
-   other

Record:

-   previous quantity
-   adjustment
-   new quantity
-   reason
-   actor
-   timestamp

Create audit event.

------------------------------------------------------------------------

# 21. Low Stock

Low stock is forecast-based.

Do NOT use only a fixed threshold such as `< 10`.

Calculate:

``` text
projected_3_day_requirement
```

from upcoming scheduled doses over the next 3 days.

If:

``` text
current usable stock < projected_3_day_requirement
```

then:

``` text
LOW STOCK
```

Respect:

-   recurrence
-   dose quantities
-   start/end dates
-   patient timezone
-   schedule changes

Do not invent PRN usage.

------------------------------------------------------------------------

# 22. Remaining Days

For regular schedules:

``` text
stock / daily requirement
```

For irregular schedules, simulate future doses.

Example:

``` text
Stock = 10

Day 1 = 2
Day 2 = 1
Day 3 = 2
Day 4 = 2
Day 5 = 1
Day 6 = 2
```

The stock lasts through Day 6.

Use actual future schedules, not a simplistic average when accuracy
matters.

------------------------------------------------------------------------

# 23. Stock States

Recommended derived states:

``` text
NO_STOCK_RECORDED
EMPTY
LOW
NORMAL
EXPIRING_SOON
EXPIRED_ONLY
```

Internal flags may include:

``` text
isLowStock
isEmpty
hasExpiredBatch
hasExpiringBatch
```

Do not duplicate stock-state calculations across widgets.

------------------------------------------------------------------------

# 24. Expiration

Track:

-   expired
-   expires today
-   expires soon

Recommended default:

``` text
within 30 days
```

Expiration threshold should be configurable.

A medication may be both:

``` text
LOW STOCK + EXPIRING SOON
```

------------------------------------------------------------------------

# 25. Inventory UI

## Inventory dashboard

Show:

-   total medications
-   medications with stock
-   low stock
-   empty stock
-   expiring soon

Medication item:

``` text
Panadol 500 mg
18 tablets
~9 days remaining
Normal
```

or:

``` text
Augmentin 625 mg
4 tablets
~1 day remaining
Low stock
```

## Medication inventory details

Show:

-   total quantity
-   remaining days
-   stock state
-   active batches
-   expiration
-   purchase information
-   inventory history
-   consumption history

------------------------------------------------------------------------

# 26. Inventory Reports

Storage/inventory report should include:

-   medication
-   current quantity
-   unit
-   batch count
-   earliest expiration
-   estimated remaining days
-   stock state
-   low-stock state
-   purchase information
-   expired quantity

It should answer:

> What medication do we have?

and:

> What needs to be purchased?

------------------------------------------------------------------------

# 27. Inventory Notifications

Support:

### Low stock

> Mother has 2 days of Panadol remaining.

### Empty

> Mother has no Panadol remaining.

### Expiration

> Panadol for Mother expires in 10 days.

### Expired

> Panadol for Mother has expired.

Notifications:

-   work offline
-   are global
-   are patient-specific
-   respect per-patient preferences
-   go to the current phone/caregiver
-   include patient name
-   are deduplicated

Do not regenerate duplicates every app launch.

------------------------------------------------------------------------

# 28. Dose & Inventory Relationship

Inventory is consumed only when an actual dose is TAKEN with actual
quantity \> 0.

MISSED doses do not consume inventory.

SKIPPED doses do not consume inventory.

A TAKEN dose may consume one or more batches.

The exact allocation must be stored historically.

------------------------------------------------------------------------

# 29. Appointments, Vitals, Illnesses, Diet

## Appointments

Fields:

-   doctor
-   specialty
-   scheduled time
-   location
-   notes
-   status

## Vitals

Fields:

-   type
-   value 1
-   value 2
-   unit
-   measured_at
-   notes

## Illnesses

Fields:

-   condition
-   diagnosis date
-   notes

## Dietary rules

Fields:

-   food item English
-   food item Arabic
-   rule type
-   notes

Do not infer medical rules automatically.

------------------------------------------------------------------------

# 30. Prescriptions

Store prescription files in app-private storage.

DB stores:

``` text
file_path
```

Prescription record:

-   doctor
-   issue date
-   local file path

Prescription images are not included in doctor reports.

------------------------------------------------------------------------

# 31. Doctor Reports

Two report levels:

1.  Summary
2.  Detailed

Both:

-   in-app
-   PDF

Include:

-   patient
-   medications
-   dose history
-   adherence status
-   vitals
-   appointments
-   relevant health information

Dose history distinguishes:

-   taken on time
-   taken late
-   missed
-   skipped

Do not include actor identity.

Do not include prescription images.

History period is user-selectable.

Default:

``` text
everything
```

------------------------------------------------------------------------

# 32. Deletion & Trash

Patient:

``` text
Delete
→ Move to Trash
→ Restore / Permanently Delete
```

Patient deletion requires confirmation.

Medication deletion is soft/archive-based.

Historical doses remain.

Inventory consumption history remains meaningful.

Inventory batches can be moved to Trash.

Do not silently destroy historical information.

------------------------------------------------------------------------

# 33. Audit

Audit actions include:

-   patient changes
-   medication changes
-   inventory added
-   inventory edited
-   inventory adjusted
-   inventory deleted
-   dose taken
-   dose undone
-   dose skipped
-   batch manually selected

Audit fields:

-   patient
-   actor
-   entity type
-   entity ID
-   action
-   timestamp
-   metadata JSON

Historical actor identity survives caregiver relationship removal.

------------------------------------------------------------------------

# 34. Backup / Import / Merge

## Backup

Back up everything necessary to reconstruct the patient profile:

-   persons
-   patients
-   caregivers
-   illnesses
-   medications
-   inventory
-   meals
-   schedules
-   doses
-   consumption
-   appointments
-   vitals
-   dietary rules
-   prescriptions metadata
-   prescription files
-   notification preferences
-   audit
-   trash as appropriate

Use a versioned portable package such as:

``` text
backup.zip
├── manifest.json
├── persons.json
├── patients.json
├── medications.json
├── inventory.json
├── schedules.json
├── doses.json
├── appointments.json
├── vitals.json
├── illnesses.json
├── dietary_rules.json
├── prescriptions.json
├── notifications.json
├── audit.json
└── files/
```

No backup encryption.

## Import

Import as a new patient profile.

Generate new IDs while preserving relationships.

## Merge

For the same patient:

> Keep the latest data.

Use `updated_at` for mutable-record conflicts.

Preserve unique historical events.

Do not blindly sum duplicate inventory batches.

Deduplicate stable historical IDs/events.

------------------------------------------------------------------------

# 35. Localization

Support:

-   Arabic
-   English

Global app language.

Arabic must have proper:

-   RTL
-   Arabic-capable font
-   localized strings
-   localized dates/times
-   appropriate layout direction

Medication instructions support separate English and Arabic text.

------------------------------------------------------------------------

# 36. Database Model

Use the following schema as the baseline:

``` dbml
Table persons {
  person_id varchar [pk]
  full_name varchar [not null]
  phone varchar
  email varchar
  preferred_language varchar
  created_at timestamp [not null]
  updated_at timestamp [not null]
  deleted_at timestamp
}

Table patients {
  patient_id varchar [pk, ref: - persons.person_id]
  date_of_birth date
  blood_type varchar
  emergency_contact_name varchar
  emergency_contact_phone varchar
  notes text
  timezone varchar [not null]
  created_at timestamp [not null]
  updated_at timestamp [not null]
}

Table caregiver_assignments {
  assignment_id varchar [pk]
  patient_id varchar [not null, ref: > patients.patient_id]
  caregiver_person_id varchar [not null, ref: > persons.person_id]
  relationship varchar
  created_at timestamp [not null]
  updated_at timestamp [not null]
  removed_at timestamp
}

Table patient_illnesses {
  illness_id varchar [pk]
  patient_id varchar [not null, ref: > patients.patient_id]
  condition_name varchar [not null]
  diagnosed_date date
  notes text
  created_at timestamp [not null]
  updated_at timestamp [not null]
  deleted_at timestamp
}

Table drug_catalog {
  catalog_id varchar [pk]
  commercial_name_en varchar [not null]
  commercial_name_ar varchar [not null]
  price_egp decimal [not null]
}

Table medications {
  medication_id varchar [pk]
  patient_id varchar [not null, ref: > patients.patient_id]
  catalog_id varchar [ref: > drug_catalog.catalog_id]
  custom_name_en varchar
  custom_name_ar varchar
  dose_unit varchar [not null]
  instructions_en text
  instructions_ar text
  start_date date
  end_date date
  is_prn boolean [not null]
  maximum_daily_quantity integer
  status varchar [not null]
  created_at timestamp [not null]
  updated_at timestamp [not null]
  deleted_at timestamp
}

Table medication_inventory_batches {
  inventory_batch_id varchar [pk]
  medication_id varchar [not null, ref: > medications.medication_id]
  purchase_date date
  purchase_price decimal
  expiration_date date
  packaging_type varchar
  units_per_package integer
  packages_count integer
  available_quantity_scaled integer [not null]
  quantity_scale integer [not null]
  is_depleted boolean [not null]
  created_at timestamp [not null]
  updated_at timestamp [not null]
  deleted_at timestamp
}

Table meals {
  meal_id varchar [pk]
  patient_id varchar [not null, ref: > patients.patient_id]
  name_en varchar [not null]
  name_ar varchar [not null]
  meal_type varchar [not null]
  default_time time
  is_active boolean [not null]
  created_at timestamp [not null]
  updated_at timestamp [not null]
}

Table medication_schedules {
  schedule_id varchar [pk]
  medication_id varchar [not null, ref: > medications.medication_id]
  schedule_type varchar [not null]
  fixed_time time
  meal_id varchar [ref: > meals.meal_id]
  timing_relation varchar
  offset_minutes integer
  dose_quantity_scaled integer [not null]
  quantity_scale integer [not null]
  recurrence_rule text [not null]
  valid_from date
  valid_until date
  is_active boolean [not null]
  created_at timestamp [not null]
  updated_at timestamp [not null]
  deleted_at timestamp
}

Table dose_instances {
  dose_instance_id varchar [pk]
  patient_id varchar [not null, ref: > patients.patient_id]
  medication_id varchar [not null, ref: > medications.medication_id]
  schedule_id varchar [ref: > medication_schedules.schedule_id]
  scheduled_at timestamp [not null]
  required_quantity_scaled integer [not null]
  quantity_scale integer [not null]
  actual_quantity_scaled integer
  status varchar [not null]
  taken_at timestamp
  skipped_at timestamp
  missed_at timestamp
  late_minutes integer
  logged_by_person_id varchar [ref: > persons.person_id]
  created_at timestamp [not null]
  updated_at timestamp [not null]
}

Table dose_inventory_consumption {
  consumption_id varchar [pk]
  dose_instance_id varchar [not null, ref: > dose_instances.dose_instance_id]
  inventory_batch_id varchar [not null, ref: > medication_inventory_batches.inventory_batch_id]
  quantity_scaled integer [not null]
  quantity_scale integer [not null]
  created_at timestamp [not null]
}

Table appointments {
  appointment_id varchar [pk]
  patient_id varchar [not null, ref: > patients.patient_id]
  doctor_name varchar [not null]
  specialty varchar
  scheduled_time timestamp [not null]
  location varchar
  notes text
  status varchar [not null]
  created_at timestamp [not null]
  updated_at timestamp [not null]
  deleted_at timestamp
}

Table vitals_measurements {
  measurement_id varchar [pk]
  patient_id varchar [not null, ref: > patients.patient_id]
  measurement_type varchar [not null]
  value_1 decimal
  value_2 decimal
  unit varchar
  measured_at timestamp [not null]
  notes text
  created_at timestamp [not null]
  updated_at timestamp [not null]
  deleted_at timestamp
}

Table dietary_rules {
  diet_rule_id varchar [pk]
  patient_id varchar [not null, ref: > patients.patient_id]
  food_item_en varchar [not null]
  food_item_ar varchar
  rule_type varchar [not null]
  notes text
  created_at timestamp [not null]
  updated_at timestamp [not null]
  deleted_at timestamp
}

Table prescriptions {
  prescription_id varchar [pk]
  patient_id varchar [not null, ref: > patients.patient_id]
  doctor_name varchar
  issue_date date
  file_path varchar [not null]
  created_at timestamp [not null]
  updated_at timestamp [not null]
  deleted_at timestamp
}

Table notifications {
  notification_id varchar [pk]
  patient_id varchar [not null, ref: > patients.patient_id]
  recipient_person_id varchar [ref: > persons.person_id]
  notification_type varchar [not null]
  scheduled_at timestamp [not null]
  delivered_at timestamp
  status varchar [not null]
  dose_instance_id varchar [ref: > dose_instances.dose_instance_id]
  appointment_id varchar [ref: > appointments.appointment_id]
  inventory_batch_id varchar [ref: > medication_inventory_batches.inventory_batch_id]
  title_en varchar
  title_ar varchar
  body_en text
  body_ar text
  created_at timestamp [not null]
  updated_at timestamp [not null]
}

Table patient_notification_preferences {
  preference_id varchar [pk]
  patient_id varchar [not null, ref: > patients.patient_id]
  notification_type varchar [not null]
  enabled boolean [not null]
  created_at timestamp [not null]
  updated_at timestamp [not null]
}

Table audit_events {
  audit_event_id varchar [pk]
  patient_id varchar [ref: > patients.patient_id]
  actor_person_id varchar [ref: > persons.person_id]
  entity_type varchar [not null]
  entity_id varchar [not null]
  action varchar [not null]
  occurred_at timestamp [not null]
  metadata_json text
}

Table trash_items {
  trash_item_id varchar [pk]
  patient_id varchar [ref: > patients.patient_id]
  entity_type varchar [not null]
  entity_id varchar [not null]
  deleted_at timestamp [not null]
  permanently_deleted_at timestamp
  snapshot_json text
}
```

------------------------------------------------------------------------

# 37. Core Services

Create application/domain services such as:

## InventoryService

``` text
addBatch()
updateBatch()
deleteBatch()
adjustQuantity()
getBatchesForMedication()
getTotalQuantity()
getAvailableBatches()
selectBatchesForDose()
consumeForDose()
restoreDoseConsumption()
```

## StockForecastService

``` text
calculateDailyRequirement()
calculateUpcomingRequirement()
calculateRemainingDays()
calculateStockStatus()
```

## InventoryNotificationService

``` text
evaluateLowStock()
evaluateExpiration()
scheduleInventoryNotifications()
cancelInventoryNotifications()
```

Repositories should hide Drift implementation details from UI.

------------------------------------------------------------------------

# 38. Key Inventory Repository API

``` dart
abstract class InventoryRepository {
  Future<List<InventoryBatch>> getBatchesForMedication(
    String medicationId,
  );

  Future<InventoryBatch?> getBatch(String batchId);

  Future<void> addBatch(InventoryBatch batch);

  Future<void> updateBatch(InventoryBatch batch);

  Future<void> deleteBatch(String batchId);

  Future<void> adjustQuantity({
    required String batchId,
    required int deltaScaled,
    required String reason,
  });

  Future<int> getTotalAvailableQuantityScaled(
    String medicationId,
  );

  Future<List<InventoryBatch>> getAvailableBatches(
    String medicationId,
  );
}
```

Critical dose/inventory operations must expose transaction-aware use
cases rather than letting UI mutate tables independently.

------------------------------------------------------------------------

# 39. Complete Use-Case Catalogue

## Patient

-   create patient
-   edit patient
-   delete patient
-   restore patient
-   permanently delete patient
-   switch current patient
-   add illness
-   add vitals
-   add appointment
-   add dietary rule
-   add prescription
-   view reports
-   export profile
-   import profile
-   merge profile

## Caregiver

-   select caregiver
-   select patient
-   manage multiple patients
-   add medication
-   edit medication
-   manage schedules
-   add stock
-   adjust stock
-   consume stock through dose confirmation
-   manually choose stock batch
-   undo dose
-   receive missed-dose notification
-   receive low-stock notification
-   generate reports

## Medication

-   create
-   edit
-   archive
-   restore
-   delete
-   configure instructions
-   configure multiple schedules
-   configure recurrence
-   configure PRN
-   configure maximum daily quantity
-   view inventory
-   view dose history

## Inventory

-   add batch
-   view batches
-   view total stock
-   edit batch
-   adjust stock
-   delete batch
-   restore batch
-   consume stock
-   manually select batch
-   calculate remaining days
-   calculate low stock
-   detect expiration
-   view consumption history
-   generate storage report

## Dose

-   generate dose instance
-   remind
-   mark taken
-   mark late
-   mark skipped
-   mark missed
-   record partial actual quantity
-   consume inventory
-   undo taken dose
-   preserve history

## Notifications

-   medication reminder
-   missed dose
-   low stock
-   empty stock
-   expiration
-   appointment reminder
-   per-patient preferences
-   deduplication

## Reports

-   summary doctor report
-   detailed doctor report
-   PDF generation
-   in-app report
-   storage/inventory report

## Backup

-   export
-   import
-   restore files
-   validate schema
-   migrate old backup versions
-   merge same patient
-   preserve historical events

------------------------------------------------------------------------

# 40. Critical Edge Cases

Test all of these:

1.  Medication has no inventory.
2.  Medication has zero inventory.
3.  Medication has multiple batches.
4.  Batch has no expiration date.
5.  Batch is expired.
6.  Batch expires today.
7.  Batch expires soon.
8.  Dose is larger than one batch.
9.  Dose requires multiple batches.
10. Total inventory is insufficient.
11. Actual quantity is fractional.
12. Actual quantity is zero.
13. Dose is undone.
14. Dose is attempted to be undone twice.
15. Batch becomes depleted.
16. User manually selects a batch.
17. PRN dose is logged.
18. Maximum daily quantity would be exceeded.
19. Schedule has different quantities by day.
20. Meal time changes.
21. Patient timezone changes.
22. Medication reaches end date.
23. Medication is deleted.
24. Inventory batch is deleted.
25. Patient is moved to Trash.
26. Patient is restored.
27. Backup is imported.
28. Same patient is merged.
29. Notification generation runs repeatedly.
30. DB transaction fails halfway through.
31. Multiple patients exist on one phone.
32. Caregiver relationship is removed.
33. Historical action still needs its actor.
34. Prescription file is missing.
35. Backup contains an older schema version.

------------------------------------------------------------------------

# 41. Testing Requirements

Unit-test:

-   scaled quantity arithmetic
-   package conversion
-   recurrence
-   dose generation
-   meal timing
-   late calculation
-   missed calculation
-   FEFO
-   multi-batch consumption
-   insufficient stock
-   partial dose
-   undo
-   low-stock forecast
-   remaining days
-   expiration
-   PRN
-   maximum daily quantity
-   merge
-   backup serialization

Integration-test:

-   Drift transactions
-   notification scheduling
-   backup/import
-   file storage
-   PDF reports

Widget-test:

-   patient selector
-   medication screens
-   inventory dashboard
-   stock adjustment
-   dose confirmation
-   Arabic RTL
-   English LTR

------------------------------------------------------------------------

# 42. Implementation Phases

1.  Project foundation
2.  Theme/localization
3.  Drift database and migrations
4.  Person/patient/caregiver
5.  Medication and drug catalog
6.  Schedules/recurrence
7.  Dose generation
8.  Inventory/batches
9.  Dose consumption transactions
10. Notifications
11. Appointments/vitals/diet/illness
12. Prescription storage
13. Reports/PDF
14. Backup/import/merge
15. Trash/audit
16. Testing
17. UI polish/accessibility/performance/release

------------------------------------------------------------------------

# 43. Non-Negotiable Architectural Rules

1.  SQLite is the source of truth.
2.  V1 has no backend dependency.
3.  No authentication/security layer.
4.  No local encryption.
5.  No backup encryption.
6.  Business logic does not belong in widgets.
7.  Inventory is batch-based.
8.  Quantities use scaled integers.
9.  Dose/inventory mutations are transactional.
10. Undo restores exact original batches.
11. Historical records are not silently destroyed.
12. Soft deletion/trash is used where required.
13. Patient context is explicit.
14. Actor identity is recorded for historical actions.
15. Late is calculated, not a dose status.
16. PRN is not artificially forecast.
17. Low stock uses upcoming 3-day requirements.
18. Remaining days use actual future schedules.
19. Expired stock remains visible.
20. Notifications work offline.
21. Notification generation is deduplicated.
22. Arabic/RTL is first-class.
23. Backup format is versioned.
24. Merge keeps latest mutable data and preserves unique history.
25. Never silently discard user data.
26. Do not add cloud infrastructure unless explicitly requested.

------------------------------------------------------------------------

# 44. Final Definition of Done

The V1 implementation is complete when:

-   patients work offline
-   multiple patients work on one device
-   caregiver identity can be selected
-   no authentication is required
-   medications can exist without inventory
-   multiple schedules work
-   generic recurrence works
-   PRN works
-   maximum daily quantity works
-   meal-relative timing works
-   dose generation works
-   SCHEDULED/TAKEN/MISSED/SKIPPED works
-   late minutes are calculated
-   missed doses cannot be retroactively taken
-   dose undo works
-   inventory is batch-based
-   fractional quantities work
-   FEFO works
-   manual batch selection works
-   multi-batch consumption works
-   insufficient stock supports actual quantity
-   stock cannot become negative
-   stock adjustment works
-   low-stock forecasting works
-   remaining-day forecasting works
-   expiration works
-   offline notifications work
-   audit history works
-   trash works
-   summary/detailed doctor reports work
-   PDF reports work
-   prescription storage works
-   backup works
-   import works
-   same-patient merge works
-   Arabic/English work
-   RTL/LTR work
-   patient isolation works
-   critical operations are transactional
-   major edge cases have automated tests

------------------------------------------------------------------------


---

# 46. Egyptian Drug CSV Asset & Catalog Implementation

The repository should contain:

```text
assets/
└── data/
    └── egyptian-drugs.csv
```

The provided dataset is expected to contain more than 25,000 medicine records.

## Source CSV contract

Required columns:

```text
commercial_name_en
commercial_name_ar
price_egp
```

Example:

```csv
commercial_name_en,commercial_name_ar,price_egp
"1 2 3 (ONE TWO THREE) 20 F.C.TABS.","1 2 3",10
"1 2 3 (ONE TWO THREE) EXTRA 20 F.C.TABS.","1 2 3 إكسترا",64
"1 2 3 (ONE TWO THREE) SUSP. 120 ML","1 2 3",7
"2HC F.C.T 20 TABLETS","2 هك ف.ك.ت",37
```

The sample above is illustrative. The application must use the real CSV data supplied with the project.

## Runtime projection

The source dataset may contain:

```text
commercial_name_en
commercial_name_ar
scientific_name
manufacturer
drug_class
route
price_egp
```

but V1 runtime storage only needs:

```text
commercial_name_en
commercial_name_ar
price_egp
```

This reduces database size, object mapping, memory use, and query cost.

## Catalog use cases

### UC-DRUG-01: Search medicine

User enters:

```text
panadol
```

The app searches the local FTS5 database and returns a small result page.

Display:

```text
Panadol Extra
بانادول إكسترا
EGP 85
```

Do not load all matches into memory.

### UC-DRUG-02: Arabic search

User enters:

```text
بانادول
```

Search the Arabic indexed field.

### UC-DRUG-03: Partial search

User enters:

```text
pana
```

Return matching commercial names using FTS5/prefix search.

### UC-DRUG-04: Select medicine

When the user selects a catalog result, create a patient medication referencing:

```text
catalog_id
```

Copying the catalog name into the medication is optional; the catalog remains the source of reference information.

### UC-DRUG-05: Custom medication

If no catalog result is suitable, allow:

```text
Add custom medication
```

The medication can exist without `catalog_id`.

### UC-DRUG-06: Price display

Show the catalog `price_egp` as reference information.

Do not use catalog price as the actual inventory purchase price.

Actual inventory uses:

```text
purchase_price
```

because the patient may have purchased the medicine at a different price.

### UC-DRUG-07: Catalog refresh

V1 does not require an online catalog update.

A future release can replace the bundled SQLite catalog with a newer generated asset.

Patient data must never be overwritten by catalog replacement.

## Search performance requirements

For 25K+ records:

```text
BAD:
SELECT * FROM drug_catalog;
filter in Dart;
display results;

BAD:
SELECT * FROM drug_catalog
WHERE commercial_name_en LIKE '%query%';

GOOD:
FTS5 MATCH
ORDER BY relevance
LIMIT 20;
```

Use:

- FTS5
- indexed row identifiers
- prepared/bound statements
- debounce
- pagination
- small result limits

Suggested limits:

```text
initial results: 20
maximum one query page: 50
debounce: 250 ms
minimum useful query: 2 characters
```

These are defaults, not hard UI restrictions.

## Avoid unnecessary rebuilds

The search provider should depend on:

```text
current search query
current locale
```

not on the complete catalog table.

Do not expose the entire catalog through a Riverpod provider.

Prefer:

```text
SearchQuery
    ↓
DrugCatalogRepository.search()
    ↓
Drift/SQLite FTS5
    ↓
List<DrugSearchResult>
    ↓
UI
```

## Drift design

Keep the catalog database separate from the patient database when practical:

```text
PatientDatabase
    ├── patients
    ├── medications
    ├── schedules
    ├── inventory
    └── doses

DrugCatalogDatabase (read-only)
    ├── drug_catalog
    └── drug_catalog_fts
```

This separation prevents large static catalog data from mixing with mutable patient data.

## Asset build pipeline

Preferred development/build process:

```text
egyptian-drugs.csv
       ↓
validate CSV
       ↓
normalize search fields
       ↓
bulk import
       ↓
build FTS5 index
       ↓
drug_catalog.sqlite
       ↓
Flutter asset
```

Do not perform this conversion during every application startup.

## Validation rules

Reject/report a row when:

- English commercial name is missing
- Arabic commercial name is missing
- price is not numeric
- CSV has invalid quoting
- row has an invalid column count

A zero price should not automatically be interpreted as missing. Handle it according to the source-data policy.

Trim whitespace but preserve the actual commercial name spelling/casing.

## Deduplication

Do not blindly deduplicate by English name alone.

Two records with the same commercial name can legitimately have different prices.

A safer import identity is:

```text
normalized commercial_name_en
+
normalized commercial_name_ar
+
price_egp
```

If future catalog requirements need package/strength differentiation, those fields must be retained explicitly rather than inferred from names.

## Query examples

### Exact English match

Prefer exact match when the normalized input equals the normalized English commercial name.

### Prefix search

For:

```text
pan
```

search the indexed token prefix rather than scanning all rows.

### Arabic search

Normalize the query using the same normalization function used when generating the search index.

The normalization function must be deterministic:

```text
normalizeForDrugSearch(input)
```

The same input should always produce the same searchable representation.

## Performance acceptance criteria

The catalog implementation passes when:

- 25K+ records can be imported without excessive memory use.
- The app does not load all records at startup.
- Search returns only a bounded result set.
- English search works.
- Arabic search works.
- Prefix/partial search works.
- The UI remains responsive while typing.
- Catalog search is completely offline.
- Catalog price is displayed without being confused with actual purchase price.
- Selecting a catalog item does not copy unnecessary source columns into patient data.

# 47. Final Product Principle

This is not only a medication reminder.

It is an offline personal health-management system centered on:

``` text
Patient
  ↓
Health Profile
  ↓
Medication
  ├── Schedule
  ├── Dose History
  └── Inventory
        ├── Batch
        ├── Expiration
        ├── Purchase
        └── Consumption
```

The system must always be able to answer:

1.  What medication does this patient have?
2.  How much is available?
3.  Which physical batches make up that quantity?
4.  When was each batch purchased?
5.  When does each batch expire?
6.  How much has been consumed?
7.  Which dose consumed it?
8.  Who performed the action?
9.  How many days remain?
10. When should the caregiver be warned?

Prioritize **correctness, data integrity, offline reliability,
recoverability, accessibility, and maintainability** over premature
complexity.
