import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:cached_network_image/cached_network_image.dart';


class EditProductPage extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> productData;

  const EditProductPage({Key? key, required this.productId, required this.productData}) : super(key: key);

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final List<String> _categories = ["Food", "Drink", "Snacks"];
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  String? _selectedCategory;
  File? _imageFile;
  String? imageUrl;
  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.productData['title']);
    descriptionController = TextEditingController(text: widget.productData['description']);
    priceController = TextEditingController(text: widget.productData['price']);
    _selectedCategory = widget.productData['category'];

    // Check if the image is an URL or a local path
    if (widget.productData['image'] != null) {
      if (widget.productData['image'].startsWith('http')) {
        imageUrl = widget.productData['image'];
      } else {
        imageUrl = 'http://10.0.2.2:8000/products/${widget.productData['image']}';
      }
    }
  }

  // Fungsi untuk memilih gambar
  Future<void> _pickImage() async {
    if (_isPickingImage) return; // Cegah panggilan berulang
    setState(() {
      _isPickingImage = true;
    });

    try {
      final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    } finally {
      setState(() {
        _isPickingImage = false; // Reset status
      });
    }
  }

  Future<void> _updateProduct() async {
    final uri = Uri.parse('http://10.0.2.2:8000/update_product/${widget.productId}');

    var request = http.MultipartRequest('POST', uri);
    request.fields['title'] = titleController.text;
    request.fields['description'] = descriptionController.text;
    request.fields['price'] = priceController.text;
    request.fields['category'] = _selectedCategory ?? '';

    if (_imageFile != null) {
      String mimeType = mime(_imageFile!.path) ?? 'image/jpeg';
      var multipartFile = http.MultipartFile(
        'image',
        _imageFile!.readAsBytes().asStream(),
        _imageFile!.lengthSync(),
        filename: _imageFile!.uri.pathSegments.last,
        contentType: MediaType.parse(mimeType),
      );
      request.files.add(multipartFile);
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Product updated successfully');

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Product updated successfully.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Navigate back
                  },
                ),
              ],
            );
          },
        );
      } else {
        print('Failed to update product');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to update product. Please try again.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error updating product: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('An unexpected error occurred. Please try again.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _imageFile == null
                      ? imageUrl != null
                          ? CachedNetworkImage(
                              imageUrl : imageUrl!,
                              fit: BoxFit.cover,
                            )
                          : Center(child: Text('Tap to pick an image'))
                      : Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Edit Image'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),

              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              ElevatedButton(
                onPressed: _updateProduct,
                child: const Text('Submit'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
