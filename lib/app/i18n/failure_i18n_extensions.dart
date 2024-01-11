import 'package:common_models/common_models.dart';

extension EmailI18nX on Email {
  String? translateFailure() {
    return failureToString(
      (f) => f.when(
        empty: () => 'Field is required',
        tooLong: () => 'Email length is too long',
        invalid: () => 'Email format is invalid',
        containsWhitespace: () => "Email shouldn't contain whitespace",
      ),
    );
  }
}

extension PasswordI18nX on Password {
  String? translateFailure() {
    return failureToString(
      (f) => f.maybeWhen(
        empty: () => 'Filed is required',
        tooShort: () => 'Password length is too short',
        tooLong: () => 'Password length is too long',
        containsWhitespace: () => "Password shouldn't contain whitespace",
        orElse: () => null,
      ),
    );
  }
}

extension NameI18nX on Name {
  String? translateFailure() {
    return failureToString(
      (f) => f.when(
        empty: () => 'Field is required',
        tooShort: () => 'Name length is too short',
        tooLong: () => 'Name length is too long',
      ),
    );
  }
}

extension PositiveIntI18nX on PositiveInt {
  String? translateFailure() {
    return failureToString(
      (f) => f.when(
        empty: () => 'Field is required',
        invalid: () => 'Value is invalid',
        negative: () => "Value shouldn't be negative",
      ),
    );
  }
}

extension RequiredStringI18nX on RequiredString {
  String? translateFailure() {
    return failureToString(
      (f) => f.when(
        empty: () => 'Field is required',
        tooLong: () => 'Value is too long',
      ),
    );
  }
}
