import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path/path.dart';

void mergeLocalizations({
  required List<String> inputDirectories,
  required String outputDirectory,
  required String outputFilename,
  required bool shouldAddContext,
}) {
  final String outputFilePath = path.join(outputDirectory, outputFilename);

  final outputFile = File(outputFilePath);

  final files = _findArbFiles(
    searchedDirectories: inputDirectories,
    omittedDirectory: outputDirectory,
  );

  if (files.isEmpty) {
    print('No files found in [${inputDirectories.join(', ')}]');
  }

  for (final file in files) {
    print('merging ${file.path}');
  }

  final allContent = _concatenateAllArbFiles(files, shouldAddContext);

  if (outputFile.existsSync()) {
    outputFile.deleteSync();
  }
  outputFile.createSync(recursive: true);
  outputFile.writeAsStringSync(allContent, mode: FileMode.write);
}

String _concatenateAllArbFiles(List<File> files, bool shoudAddContext) {
  var content = <String, dynamic>{
    '@@__THIS_FILE_IS_AUTOGENERATED': 'Please do not modify',
  };
  for (final file in files) {
    final jsonStr = File(file.path).readAsStringSync();
    final Map<String, dynamic> json = jsonDecode(jsonStr);
    final values = shoudAddContext ? addContext(json, file.path) : json;
    content = {
      ...content,
      '@@@__${path.basename(file.path)}__@@@': '',
      ...values,
    };
  }
  const encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(content);
}

Map<String, dynamic> addContext(Map<String, dynamic> json, String filePath) {
  final Map<String, dynamic> values = {};

  json.forEach((key, value) {
    values[key] = value;
    final context = 'context: ${path.basenameWithoutExtension(filePath)}';
    final isMetadata = key.startsWith('@');
    final metadataKey = '@$key';
    final hasMetadata = json.containsKey(metadataKey);
    if (isMetadata) {
      return;
    }
    // add context to localizations
    if (!hasMetadata) {
      values[metadataKey] = {'description': context};
    }
  });
  return values;
}

List<File> _findArbFiles({
  required List<String> searchedDirectories,
  required String omittedDirectory,
}) {
  print(
      'Searching arb files in [${searchedDirectories.join(', ')}] omitting ${path.canonicalize(omittedDirectory)}');
  final fileSystemEntities = <FileSystemEntity>[];
  for (final dir in searchedDirectories) {
    final files = Directory(dir).listSync(recursive: true);
    fileSystemEntities.addAll(files);
  }
  return fileSystemEntities
      .where((entity) => entity.path.endsWith('.arb'))
      .map((entity) => File(entity.path))
      // this omition is naive but will do for now
      .where((file) {
    final filePath = path.canonicalize(file.path);
    print(filePath);
    print(path.canonicalize(omittedDirectory));
    return !filePath.contains(path.canonicalize(omittedDirectory));
  }).toList();
}
