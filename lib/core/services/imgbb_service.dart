import 'dart:convert';
import 'package:http/http.dart' as http;

class ImgbbService {
  static const String _apiKey = '608a23fc12a71b0f1cf5c3a94a18fa46';

  /// Upload image to imgbb and return the image URL
  /// [imagePath] is the local file path of the image to be uploaded
  static Future<String> uploadImage(String imagePath) async {
    final uri = Uri.parse('https://api.imgbb.com/1/upload?key=$_apiKey');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        return jsonResponse['data']['url'];
      } else {
        throw Exception('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  /// Delete image from imgbb using the delete URL
  static Future<void> deleteImage(String deleteUrl) async {
    try {
      final response = await http.get(Uri.parse(deleteUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to delete image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting image: $e');
    }
  }
}