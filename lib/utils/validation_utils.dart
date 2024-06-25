// validation_utils.dart

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Por favor, informe um endereço de e-mail.';
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'Por favor, informe um endereço de e-mail válido.';
  }
  return null;
}