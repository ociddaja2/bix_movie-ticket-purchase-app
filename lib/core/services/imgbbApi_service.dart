import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ImgbbapiService {
  static const String apiKey = 'YOUR_IMGBB_API_KEY';

  static Future<String?> uploadImage(File imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.imgbb.com/1/upload?key=$apiKey'),
      );

      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseData);
        // Mengambil URL langsung (direct link)
        return jsonResponse['data']['url'];
      }
      return null;
    } catch (e) {
      print("Error upload ke ImgBB: $e");
      return null;
    }
  }
}