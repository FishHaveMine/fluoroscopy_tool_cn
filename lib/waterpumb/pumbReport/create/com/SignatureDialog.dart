import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class BottomSignatureSheet extends StatefulWidget {
  const BottomSignatureSheet({Key? key}) : super(key: key);

  @override
  State<BottomSignatureSheet> createState() => _BottomSignatureSheetState();
}

class _BottomSignatureSheetState extends State<BottomSignatureSheet> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  Future<void> _onConfirm() async {
    if (_controller.isNotEmpty) {
      final Uint8List? data = await _controller.toPngBytes();
      if (data != null) {
        final base64Image = base64Encode(data);
        Navigator.of(context).pop(base64Image);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.6,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const Text('签名',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: Signature(
              controller: _controller,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              TextButton(
                onPressed: _controller.clear,
                child: const Text('清空'),
              ),
              TextButton(
                onPressed: () => _controller.undo(),
                child: const Text('橡皮擦'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _onConfirm,
                child: const Text('确定'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
