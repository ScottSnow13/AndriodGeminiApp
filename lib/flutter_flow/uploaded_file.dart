import 'dart:convert'; // Importing dart:convert for JSON serialization.
import 'dart:typed_data' show Uint8List; // Importing Uint8List from dart:typed_data for handling byte data.

class FFUploadedFile {
  const FFUploadedFile({
    this.name,
    this.bytes,
    this.height,
    this.width,
    this.blurHash,
  });

  final String? name; // Name of the uploaded file.
  final Uint8List? bytes; // Byte data of the uploaded file.
  final double? height; // Height of the uploaded file (if applicable).
  final double? width; // Width of the uploaded file (if applicable).
  final String? blurHash; // Blur hash of the uploaded file.

  // Override toString method to provide a string representation of the object.
  @override
  String toString() =>
      'FFUploadedFile(name: $name, bytes: ${bytes?.length ?? 0}, height: $height, width: $width, blurHash: $blurHash,)';

  // Method to serialize the object to JSON.
  String serialize() => jsonEncode(
        {
          'name': name,
          'bytes': bytes,
          'height': height,
          'width': width,
          'blurHash': blurHash,
        },
      );

  // Static method to deserialize a JSON string into an FFUploadedFile object.
  static FFUploadedFile deserialize(String val) {
    final serializedData = jsonDecode(val) as Map<String, dynamic>;
    final data = {
      'name': serializedData['name'] ?? '',
      'bytes': serializedData['bytes'] ?? Uint8List.fromList([]),
      'height': serializedData['height'],
      'width': serializedData['width'],
      'blurHash': serializedData['blurHash'],
    };
    return FFUploadedFile(
      name: data['name'] as String,
      bytes: Uint8List.fromList(data['bytes'].cast<int>().toList()),
      height: data['height'] as double?,
      width: data['width'] as double?,
      blurHash: data['blurHash'] as String?,
    );
  }

  // Override hashCode getter.
  @override
  int get hashCode => Object.hash(
        name,
        bytes,
        height,
        width,
        blurHash,
      );

  // Override equality operator.
  @override
  bool operator ==(other) =>
      other is FFUploadedFile &&
      name == other.name &&
      bytes == other.bytes &&
      height == other.height &&
      width == other.width &&
      blurHash == other.blurHash;
}
