import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReusableImagePicker extends StatefulWidget {
  final File? initialImageFile; // Image locale initiale
  final String? imageUrl; // URL distante (Firebase ou autre)
  final ValueChanged<File>? onImageSelected; // Callback vers le parent

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

      // Notifie le parent du changement d’image
      widget.onImageSelected?.call(file);
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
                backgroundColor: Colors.grey[200],
                radius: 22,
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
