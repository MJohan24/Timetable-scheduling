import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:timetable/features/assistant/presentation/utils/nv21_jpeg_encoder.dart';

void main() {
  test('encodes an NV21 frame as a valid in-memory JPEG', () {
    final jpeg = encodeNv21ToJpeg(
      Uint8List.fromList(<int>[76, 76, 76, 76, 255, 84]),
      width: 2,
      height: 2,
    );

    expect(jpeg, isNotEmpty);
    expect(jpeg.take(2), <int>[0xff, 0xd8]);
    final decoded = img.decodeJpg(jpeg);
    expect(decoded, isNotNull);
    expect(decoded!.width, 2);
    expect(decoded.height, 2);
  });

  test('rotates portrait camera frames before JPEG encoding', () {
    final jpeg = encodeNv21ToJpeg(
      Uint8List.fromList(<int>[
        90,
        90,
        90,
        90,
        90,
        90,
        90,
        90,
        128,
        128,
        128,
        128,
      ]),
      width: 4,
      height: 2,
      rotationDegrees: 90,
    );

    final decoded = img.decodeJpg(jpeg);
    expect(decoded, isNotNull);
    expect(decoded!.width, 2);
    expect(decoded.height, 4);
  });
}
