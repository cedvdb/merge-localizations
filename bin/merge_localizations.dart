import 'dart:io';

import 'package:merge_localizations/merge_localizations.dart';
import 'package:yaml/yaml.dart' as yaml;

void main() {
  final configFile = File('merge_localizations.yaml');
  if (!configFile.existsSync()) {
    return mergeLocalizations(
      inputDirectories: const ['./lib'],
      outputDirectory: './localizations',
      outputFilename: 'language_en.arb',
      shouldAddContext: true,
    );
  }
  final String configContent = configFile.readAsStringSync();
  final yaml.YamlMap config = yaml.loadYaml(configContent);
  final yaml.YamlList inputDirectories =
      config['input-directories'] ?? ['./lib'];
  final String outputDirectory =
      config['output-directory'] ?? './localizations';
  final String outputFilename = config['output-filename'] ?? 'language_en.arb';
  final bool shouldAddContext = config['should-add-context'] ?? true;
  mergeLocalizations(
    inputDirectories: inputDirectories.cast<String>().toList(),
    outputDirectory: outputDirectory,
    outputFilename: outputFilename,
    shouldAddContext: shouldAddContext,
  );
}
