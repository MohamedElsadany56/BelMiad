/// Base class for business-rule violations surfaced to the user.
class DomainException implements Exception {
  const DomainException(this.code, [this.details = const {}]);

  /// Stable, localizable error code.
  final String code;
  final Map<String, Object?> details;

  @override
  String toString() => 'DomainException($code, $details)';
}

class InvalidDoseTransitionException extends DomainException {
  InvalidDoseTransitionException(String from, String to)
      : super('invalidDoseTransition', {'from': from, 'to': to});
}

class MaximumDailyQuantityExceededException extends DomainException {
  MaximumDailyQuantityExceededException({
    required this.maximumScaled,
    required this.alreadyTakenScaled,
    required this.attemptScaled,
  }) : super('maximumDailyExceeded', {
          'maximum': maximumScaled,
          'taken': alreadyTakenScaled,
          'attempt': attemptScaled,
        });

  final int maximumScaled;
  final int alreadyTakenScaled;
  final int attemptScaled;
}

class InsufficientStockException extends DomainException {
  InsufficientStockException({
    required this.requiredScaled,
    required this.availableScaled,
  }) : super('insufficientStock', {
          'required': requiredScaled,
          'available': availableScaled,
        });

  final int requiredScaled;
  final int availableScaled;
}

class NegativeStockException extends DomainException {
  const NegativeStockException() : super('negativeStock');
}

class DoseWindowClosedException extends DomainException {
  const DoseWindowClosedException() : super('doseWindowClosed');
}

class NotFoundException extends DomainException {
  NotFoundException(String entity) : super('notFound', {'entity': entity});
}

class ValidationException extends DomainException {
  const ValidationException(super.code, [super.details]);
}
