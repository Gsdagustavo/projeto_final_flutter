/// Generic failure class to represent validation or repository errors.
///
/// [T] is a type-safe identifier (usually an enum) that describes
/// the specific kind of error. Optionally, [params] can be used to
/// provide contextual information about the failure.
class Failure<T> {
  /// Type of the failure (usually an enum like [TravelRegisterError]).
  final T type;

  /// Optional parameters that provide more context about the failure.
  final Map<String, dynamic>? params;

  /// Creates a [Failure] with the given [type] and optional [params].
  Failure(this.type, {this.params});

  @override
  String toString() => 'Failure(type: $type, params: ${params ?? {}})';
}