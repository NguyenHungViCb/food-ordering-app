class StringValidations {
  bool isNotNullOrEmpty(String? str) {
    return str != "" && str != null && str.replaceAll(RegExp(r"\s+"), "") != "";
  }
}

class TextFieldValidations {
  static final StringValidations validations = StringValidations();
  static dynamic isNotNullOrEmpty(String name, String? str) {
    if (!validations.isNotNullOrEmpty(str)) {
      return name + "must not be empty";
    }
    return null;
  }
}
