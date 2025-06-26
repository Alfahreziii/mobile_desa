import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Untuk memilih gambar dari galeri/kamera
import 'package:http/http.dart' as http;

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _selectedCategory;
  File? _imageFile;
  bool _isLoading = false;
  bool _isPickingImage = false;

  // Daftar kategori (contoh)
  final List<String> _categories = ["Food", "Drink", "Snacks"];

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

  // Fungsi untuk mengunggah produk
  Future<void> _submitProduct() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final price = _priceController.text;

    if (title.isEmpty || description.isEmpty || price.isEmpty || _selectedCategory == null || _imageFile == null) {
      _showErrorDialog("All fields are required.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // URL endpoint API untuk menyimpan data produk
      const String apiUrl = 'http://10.0.2.2:8000/product';

      // Membuat request multipart
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Menambahkan field data
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['price'] = price;
      request.fields['category'] = _selectedCategory!;

      // Menambahkan file gambar
      var imageFile = await http.MultipartFile.fromPath(
        'image', // nama field untuk file pada server
        _imageFile!.path,
      );
      request.files.add(imageFile);

      // Mengirim request
      var response = await request.send();

      // Mengecek hasil response
      if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final decodedResponse = json.decode(responseBody);

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 201) { // Status code 201 untuk berhasil dibuat
          _showSuccessDialog("Product added successfully!");
          _clearForm();
        }else {
          _showErrorDialog("Failed to add product: ${decodedResponse['message']}");
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog("Failed to upload product. Please try againssssss.");
        print("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog("An error occurred: $e");
    }
  }

  // Fungsi untuk menampilkan dialog error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan dialog sukses
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Success"),
        content: Text(message),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membersihkan form setelah sukses
  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _priceController.clear();
    setState(() {
      _selectedCategory = null;
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Product"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: "Title"),
                    ),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: "Description"),
                    ),
                    TextField(
                      controller: _priceController,
                      decoration: InputDecoration(labelText: "Price"),
                      keyboardType: TextInputType.number,
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(labelText: "Category"),
                      items: _categories
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    _imageFile != null
                        ? Image.file(
                            _imageFile!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          )
                        : Text("No image selected"),
                    TextButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.image),
                      label: Text("Select Image"),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitProduct,
                      child: Text("Submit Product"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
