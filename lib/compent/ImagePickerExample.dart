import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerExample extends StatefulWidget {
  const ImagePickerExample({Key? key}) : super(key: key);

  @override
  _ImagePickerExampleState createState() => _ImagePickerExampleState();
}

class _ImagePickerExampleState extends State<ImagePickerExample> {
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  // 打开相机拍摄照片
  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800, // 限制图片宽度
        maxHeight: 800, // 限制图片高度
        imageQuality: 85, // 图片质量（0-100）
      );

      if (photo != null) {
        setState(() {
          _pickedImage = photo;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('照片拍摄成功')),
        );
      }
    } catch (e) {
      print('拍摄照片错误: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('拍摄照片失败，请重试')),
      );
    }
  }

  // 从相册选择照片
  Future<void> _selectFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _pickedImage = image;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('照片选择成功')),
        );
      }
    } catch (e) {
      print('选择照片错误: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('选择照片失败，请重试')),
      );
    }
  }

  // 显示选择对话框
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('拍照'),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('从相册选择'),
                onTap: () {
                  Navigator.pop(context);
                  _selectFromGallery();
                },
              ),
              if (Theme.of(context).platform == TargetPlatform.iOS)
                ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text('取消'),
                  onTap: () => Navigator.pop(context),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('照片选择示例'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_pickedImage != null)
              Container(
                margin: const EdgeInsets.all(16),
                child: Image.file(
                  File(_pickedImage!.path),
                  fit: BoxFit.cover,
                  width: 200,
                  height: 200,
                ),
              )
            else
              Container(
                margin: const EdgeInsets.all(16),
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.image,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ElevatedButton(
              onPressed: _showImageSourceDialog,
              child: const Text('选择照片'),
            ),
          ],
        ),
      ),
    );
  }
}
