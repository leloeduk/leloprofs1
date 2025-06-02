import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReusableImagePicker extends StatefulWidget {
  final File? initialImageFile;
  final String? imageUrl;
  final ValueChanged<File>? onImageSelected;

  const ReusableImagePicker({
    super.key,
    this.initialImageFile,
    this.imageUrl,
    this.onImageSelected,
  });

  @override
  State<ReusableImagePicker> createState() => _ReusableImagePickerState();
}

class _ReusableImagePickerState extends State<ReusableImagePicker> {
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.initialImageFile;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _selectedImage = file;
      });

      if (widget.onImageSelected != null) {
        widget.onImageSelected!(file); // Callback vers le parent
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;

    if (_selectedImage != null) {
      imageProvider = FileImage(_selectedImage!);
    } else if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      imageProvider = NetworkImage(widget.imageUrl!);
    } else {
      imageProvider = const AssetImage('assets/logos/leloprof.png');
    }

    return Center(
      child: Stack(
        children: [
          CircleAvatar(radius: 80, backgroundImage: imageProvider),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: _pickImage,
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 20,
                child: Icon(
                  Icons.camera_alt,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
