/// Notification categories (spec §27, use-case catalogue "Notifications").
abstract final class NotificationTypes {
  static const doseReminder = 'dose_reminder';
  static const missedDose = 'missed_dose';
  static const lowStock = 'low_stock';
  static const emptyStock = 'empty_stock';
  static const expiration = 'expiration';
  static const appointmentReminder = 'appointment_reminder';

  static const all = [
    doseReminder,
    missedDose,
    lowStock,
    emptyStock,
    expiration,
    appointmentReminder,
  ];
}
