import 'package:flutter/material.dart';

class Styles {
  static const _textSizeLarge = 25.0;
  static const _textSizeDefault = 12.0;
  static const _fontWeightDefault = FontWeight.w400;
  static final _textColorDefault = _hexToColor('000000');

  static const menuTextStyle =
      TextStyle(fontWeight: _fontWeightDefault, fontSize: _textSizeDefault);

  static const textDefault = TextStyle(
    fontSize: _textSizeDefault,
    fontWeight: _fontWeightDefault,
  );

  static final textLarge = TextStyle(
    fontSize: _textSizeLarge,
    color: _textColorDefault,
  );

  static Color _hexToColor(String code) {
    return Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
  }
}
