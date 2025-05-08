import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/image_item.dart';

class ImageService {
  final String baseUrl;
  final http.Client client;

  ImageService({
    this.baseUrl = 'http://localhost:3000',
    http.Client? client,
  }) : client = client ?? http.Client();

  Future<List<ImageItem>> fetchImages() async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/api/images'));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => ImageItem.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load images: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load images: $e');
    }
  }

  Future<void> rateImage(int imageId, int rating) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/api/images/$imageId/rate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'rating': rating}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to rate image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to rate image: $e');
    }
  }

  void dispose() {
    client.close();
  }
} 