class ApiException implements Exception {
  ApiException(this.statusCode, this.message, [this.body]);

  final int statusCode;
  final String message;
  final dynamic body;

  @override
  String toString() => 'Error HTTP $statusCode: $message';
}