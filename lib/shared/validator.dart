String? phoneValidator(String? value) {
  if (value!.isNotEmpty) {
    if (value.length != 11) return 'Mobile Number must be of 11 digit';
    String phoneNetwork = value.substring(0, 3);
    print(phoneNetwork);
    if (!(phoneNetwork == "010" ||
        phoneNetwork == "011" ||
        phoneNetwork == "012" ||
        phoneNetwork == "015")) {
      return 'Please enter correct phone number.';
    }
  } else
    return 'Please enter your phone number.';
  return null;
}

String? emailValidator(String? value) {
  return value!.isEmpty || !value.contains("@")
      ? 'Please enter a valid email (contains @).'
      : null;
}

String? passwordValidator(String? value) {
  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  if (value!.isEmpty || value.length < 8) {
    return 'Password must be at least 8 characters';
  } else if (!regex.hasMatch(value)) {
    return '''
* Password should contain:
- minimum length of 8 characters
- 1 uppercase letter
- 1 lowercase letter
- 1 special character
    ''';
  }
  return null;
}

String? nameValidator(String? value) {
  return value!.isEmpty ? 'Please enter your full name.' : null;
}

String? zipValidator(String? value) {
  if (value!.isEmpty) {
    return 'Zip code is required';
  } else {
    RegExp regex = RegExp(r'^[0-9]{5}$');
    print(regex.hasMatch(value));
    return (!regex.hasMatch(value)) ? 'Enter a valid zipCode' : null;
  }
}
