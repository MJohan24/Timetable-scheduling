import 'dart:typed_data';

import 'package:image/image.dart' as img;

Uint8List encodeNv21ToJpeg(
  Uint8List bytes, {
  required int width,
  required int height,
  int rotationDegrees = 0,
  int quality = 72,
}) {
  if (width <= 0 || height <= 0 || width.isOdd || height.isOdd) {
    throw ArgumentError('NV21 dimensions must be positive and even.');
  }
  final frameSize = width * height;
  final expectedLength = frameSize + frameSize ~/ 2;
  if (bytes.length < expectedLength) {
    throw ArgumentError('NV21 frame data is incomplete.');
  }

  var image = img.Image(width: width, height: height);
  for (var y = 0; y < height; y++) {
    final yOffset = y * width;
    final uvOffset = frameSize + (y >> 1) * width;
    for (var x = 0; x < width; x++) {
      final luminance = bytes[yOffset + x];
      final chromaOffset = uvOffset + (x & ~1);
      final v = bytes[chromaOffset] - 128;
      final u = bytes[chromaOffset + 1] - 128;
      final c = luminance < 16 ? 0 : luminance - 16;
      final red = _clamp8((298 * c + 409 * v + 128) >> 8);
      final green = _clamp8((298 * c - 100 * u - 208 * v + 128) >> 8);
      final blue = _clamp8((298 * c + 516 * u + 128) >> 8);
      image.setPixelRgb(x, y, red, green, blue);
    }
  }

  final normalizedRotation = rotationDegrees % 360;
  if (normalizedRotation != 0) {
    image = img.copyRotate(image, angle: normalizedRotation);
  }
  return Uint8List.fromList(img.encodeJpg(image, quality: quality));
}

int _clamp8(int value) => value.clamp(0, 255);
