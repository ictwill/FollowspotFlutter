String? validateDouble(value) {
  if (value != null && value.isNotEmpty) {
    if (double.tryParse(value) == null) {
      return 'Invalid input';
    } else if (double.parse(value) <= 0.0) {
      return 'Must be greater than zero';
    }
  }
  return null;
}

String deleteTrailing(double number) {
  String string = number.toString();
  if (string.contains('.')) {
    string = string.replaceAll(RegExp(r'0+$'), '');
    string = string.replaceAll(RegExp(r'\.$'), '');
  }
  if (string == '0') {
    return '';
  } else {
    return string;
  }
}

String validateIntensity({int? intensity}) =>
    intensity != null && intensity >= 0 ? '$intensity %' : '';

String validateTime({int? time}) => time != null && time >= 0 ? '$time ct' : '';
