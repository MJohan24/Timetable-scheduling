import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('production UI contains no hardcoded user-facing strings', () {
    final patterns = <RegExp>[
      RegExp(r'''(?:const\s+)?Text\(\s*['\"]([^'\"]+)['\"]'''),
      RegExp(
        r'''(?:tooltip|semanticLabel|hintText|helperText|errorText|label|labelText)\s*:\s*['\"]([^'\"]+)['\"]''',
      ),
      RegExp(r'''\bmessage\s*=\s*['\"]([^'\"]+)['\"]'''),
      RegExp(r'''\.speak\(\s*['\"]([^'\"]+)['\"]'''),
    ];
    const allowed = <String>{
      'KRL',
      'MRT',
      'LRT',
      'QRIS',
      'KRL-2407-0812',
      'KAI Access Prototype',
      'nama@email.com',
    };
    final failures = <String>[];
    final files = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .where(
          (file) => !file.path.contains(
            '${Platform.pathSeparator}l10n${Platform.pathSeparator}',
          ),
        );

    for (final file in files) {
      final source = file.readAsStringSync();
      for (final pattern in patterns) {
        for (final match in pattern.allMatches(source)) {
          final value = match.group(1)!;
          if (allowed.contains(value)) continue;
          if (value.contains('l10n.') || value.contains('AppLocalizations.')) {
            continue;
          }
          final literalPart = value
              .replaceAll(RegExp(r'\$\{[^}]+\}'), '')
              .replaceAll(RegExp(r'\$[A-Za-z_][A-Za-z0-9_.]*'), '')
              .replaceAll(RegExp(r'[\s·•→,:.-]'), '');
          if (literalPart.isEmpty) continue;
          final line =
              '\n'.allMatches(source.substring(0, match.start)).length + 1;
          failures.add('${file.path}:$line: $value');
        }
      }
    }

    expect(failures, isEmpty, reason: failures.join('\n'));
  });
}
