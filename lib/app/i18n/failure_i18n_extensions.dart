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

extension NameFailureI18nX on NameFailure {
  String? translate() {
    return when(
      empty: () => 'Field is required',
      tooShort: () => 'Name length is too short',
      tooLong: () => 'Name length is too long',
    );
  }
}

extension ValueFailureI18nX on ValueFailure {
  String? translate() {
    return when(
      empty: () => 'Field is required',
      invalid: () => 'Value is invalid',
    );
  }
}

extension PositiveIntFailureI18nX on PositiveIntFailure {
  String? translate() {
    return when(
      empty: () => 'Field is required',
      invalid: () => 'Value is invalid',
      negative: () => "Value shouldn't be negative",
    );
  }
}

extension RequiredStringFailureI18nX on RequiredStringFailure {
  String? translate() {
    return when(
      empty: () => 'Field is required',
      tooLong: () => 'Value is too long',
    );
  }
}
