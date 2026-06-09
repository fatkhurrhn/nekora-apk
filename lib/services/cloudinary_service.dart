import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class CloudinaryService {
  static const String cloudName = 'deznrlont';
  static const String uploadPreset = 'nekoraUpload';
  static const String apiKey = '413651879422876';

  static Future<String?> uploadImage(File imageFile) async {
    try {
      final uri =
          Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

      final request = http.MultipartRequest('POST', uri);
      request.fields['upload_preset'] = uploadPreset;
      request.fields['api_key'] = apiKey;

      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        return jsonResponse['secure_url'];
      }

      print('Upload failed: ${jsonResponse['error']['message']}');
      return null;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }
}
