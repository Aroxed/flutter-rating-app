import 'package:flutter/material.dart';
import '../models/image_item.dart';
import '../services/image_service.dart';

class ImageListScreen extends StatefulWidget {
  final ImageService? imageService;

  const ImageListScreen({Key? key, this.imageService}) : super(key: key);

  @override
  State<ImageListScreen> createState() => _ImageListScreenState();
}

class _ImageListScreenState extends State<ImageListScreen> {
  late ImageService _imageService;
  List<ImageItem> _images = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _imageService = widget.imageService ?? ImageService();
    _fetchImages();
  }

  @override
  void dispose() {
    if (widget.imageService == null) {
      _imageService.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchImages() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final images = await _imageService.fetchImages();
      setState(() {
        _images = images;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _rateImage(ImageItem image, int rating) async {
    try {
      await _imageService.rateImage(image.id, rating);
      setState(() {
        image.rating = rating;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rating updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update rating: $e')),
        );
      }
    }
  }

  Widget _buildRatingStars(ImageItem image) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < image.rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () => _rateImage(image, index + 1),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Rating App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchImages,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: $_error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchImages,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _images.isEmpty
                  ? const Center(child: Text('No images available'))
                  : ListView.builder(
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        final image = _images[index];
                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Image.network(
                                'http://localhost:3000/uploads/${image.filename}',
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const SizedBox(
                                    height: 200,
                                    child: Center(
                                      child: Icon(
                                        Icons.error_outline,
                                        size: 48,
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _buildRatingStars(image),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
} 