import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chatme/shared/constant.dart';

// The full app needs Firebase at startup, so this smoke test only checks
// code that runs without it.
void main() {
  test('primary color is defined', () {
    expect(Constants().primaryColor, const Color(0xFF503599));
  });
}
