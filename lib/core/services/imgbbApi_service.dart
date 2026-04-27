import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ImgbbapiService {
  static const String apiKey = '608a23fc12a71b0f1cf5c3a94a18fa46';

  // Upload gambar ke ImgBB dan dapatkan URL-nya
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
        
        // DEBUG: Copy-paste hasil print ini di browser untuk tes
        print("ImgBB Full Response: $jsonResponse"); 

        // ambil URL dari response
        return jsonResponse['data']['url'];
      } else {
        print("Upload gagal dengan status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error upload ke ImgBB: $e");
      return null;
    }
  }
}