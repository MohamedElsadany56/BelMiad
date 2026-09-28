# Phase 2 notes

The Drift schema now models patients, medications, medication schedules, inventory batches, dose instances, health records, and audit events. Inventory consumption runs in a transaction and rejects negative stock.

Run `dart run build_runner build --delete-conflicting-outputs` after installing Flutter to generate `app_database.g.dart`.
