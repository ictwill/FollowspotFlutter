import 'package:flutter/material.dart';

class Styles {
  static const _textSizeLarge = 25.0;
  static const _textSizeDefault = 16.0;
  static final _textColorDefault = _hexToColor('000000');

  static final textDefault = TextStyle(
    fontSize: _textSizeDefault,
    color: _textColorDefault,
  );

  static final textLarge = TextStyle(
    fontSize: _textSizeLarge,
    color: _textColorDefault,
  );

  static Color _hexToColor(String code) {
    return Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
  }
}
