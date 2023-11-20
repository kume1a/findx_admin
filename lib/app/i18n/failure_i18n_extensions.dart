import 'package:common_models/common_models.dart';

extension EmailFailureI18nX on EmailFailure {
  String translate() {
    return when(
      empty: () => 'Field is required',
      tooLong: () => 'Email length is too long',
      invalid: () => 'Email format is invalid',
      containsWhitespace: () => "Email shouldn't contain whitespace",
    );
  }
}

extension PasswordFailureI18nX on PasswordFailure {
  String? translate() {
    return maybeWhen(
      empty: () => 'Filed is required',
      tooShort: () => 'Password length is too short',
      tooLong: () => 'Password length is too long',
      containsWhitespace: () => "Password shouldn't contain whitespace",
      orElse: () => null,
    );
  }
}
