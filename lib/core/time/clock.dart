/// Injectable clock returning the current UTC instant.
typedef Clock = DateTime Function();

DateTime systemClock() => DateTime.now().toUtc();
