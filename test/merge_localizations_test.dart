import 'dart:io';

import 'package:merge_localizations/merge_localizations.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    mergeLocalizations(
      inputDirectories: ['./test/example/lib'],
      outputDirectory: './test/example/localizations',
      outputFilename: 'language_en.arb',
      shouldAddContext: true,
    );
    expect(
      File('./test/example/localizations/language_en.arb').readAsStringSync(),
      expectedContent,
    );
  });
}

const expectedContent = '''{
  "@@__THIS_FILE_IS_AUTOGENERATED": "Please do not modify",
  "@@@__home.arb__@@@": "",
  "home": "Home",
  "@home": {
    "description": "home"
  },
  "@@@__theme.arb__@@@": "",
  "dark": "Dark",
  "@dark": {
    "description": "context: theme"
  },
  "light": "Light",
  "@light": {
    "description": "context: theme"
  }
}''';
