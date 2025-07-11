import 'package:flutter/material.dart';
import 'package:real_estate/constans/image_url.dart';

class ImageWidget extends StatelessWidget {

  final String url;

  const ImageWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Image.asset(
        url,
        height: 250,
        fit: BoxFit.contain,
      ),
    );
  }
}