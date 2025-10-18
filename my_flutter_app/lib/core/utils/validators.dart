String? requiredField(String? value, {String message = 'Campo obligatorio'}) {
  if (value == null || value.trim().isEmpty) {
    return message;
  }
  return null;
}

String? maxLength(String? value, int max, {String? message}) {
  if (value != null && value.length > max) {
    return message ?? 'No debe exceder $max caracteres';
  }
  return null;
}

String? positiveNumber(String? value, {String message = 'Debe ser mayor a 0'}) {
  if (value == null || value.trim().isEmpty) {
    return message;
  }
  final number = double.tryParse(value);
  if (number == null || number <= 0) {
    return message;
  }
  return null;
}

String? nonNegativeNumber(String? value, {String message = 'No puede ser negativo'}) {
  if (value == null || value.trim().isEmpty) {
    return message;
  }
  final number = double.tryParse(value);
  if (number == null || number < 0) {
    return message;
  }
  return null;
}

int parseInt(String value) => int.tryParse(value) ?? 0;
double parseDouble(String value) => double.tryParse(value) ?? 0;
