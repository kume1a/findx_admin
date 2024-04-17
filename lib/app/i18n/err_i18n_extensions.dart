import 'package:common_models/common_models.dart';

extension EmailI18nX on Email {
  String? translateErr() {
    return errToString(
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
  String? translateErr() {
    return errToString(
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
  String? translateErr() {
    return errToString(
      (f) => f.when(
        empty: () => 'Field is required',
        tooShort: () => 'Name length is too short',
        tooLong: () => 'Name length is too long',
      ),
    );
  }
}

extension PositiveIntI18nX on PositiveInt {
  String? translateErr() {
    return errToString(_tranlsatePositiveNumberError);
  }
}

extension RequiredDoubleI18n on PositiveDouble {
  String? translateErr() {
    return errToString(_tranlsatePositiveNumberError);
  }
}

extension RequiredIntI18nX on RequiredInt {
  String? translateErr() {
    return errToString(
      (f) => f.when(
        empty: () => 'Field is required',
        invalid: () => 'Value is invalid',
      ),
    );
  }
}

extension RequiredStringI18nX on RequiredString {
  String? translateErr() {
    return errToString(
      (f) => f.when(
        empty: () => 'Field is required',
        tooLong: () => 'Value is too long',
      ),
    );
  }
}

extension PercentI18nX on Percent {
  String? translateErr() {
    return errToString(
      (f) => f.when(
        empty: () => 'Field is required',
        invalid: () => 'Value is invalid',
        outOfRange: () => 'Value is out of range, should be between 0 and 100',
      ),
    );
  }
}

String _tranlsatePositiveNumberError(PositiveNumberError f) {
  return f.when(
    empty: () => 'Field is required',
    invalid: () => 'Value is invalid',
    negative: () => "Value shouldn't be negative",
  );
}
