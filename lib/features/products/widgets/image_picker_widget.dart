import 'package:flutter/material.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(File?) onImagePicked;
  final String? initialImageUrl;

  const ImagePickerWidget({super.key, required this.onImagePicked, this.initialImageUrl});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _imageFile;
  String? _networkImageUrl;

  @override
  void initState() {
    super.initState();
    _networkImageUrl = widget.initialImageUrl;
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        _imageFile = File(result.files.single.path!);
        _networkImageUrl = null; // Clear network image if a new image is picked
      });
      widget.onImagePicked(_imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.3)),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _imageFile != null
                ? Image.file(_imageFile!, fit: BoxFit.cover)
                : _networkImageUrl != null
                    ? Image.network(_networkImageUrl!, fit: BoxFit.cover)
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo_outlined, size: 40, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                            const SizedBox(height: 8),
                            Text('Tap to select image', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
                          ],
                        ),
                      ),
          ),
      ),
    );
  }
}
