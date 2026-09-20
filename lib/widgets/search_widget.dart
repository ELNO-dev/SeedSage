import 'package:flutter/material.dart';

class SeedSageSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const SeedSageSearchField({super.key, required this.controller, required this.hintText, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 30,
          child: Image.asset('assets/icons/search_flourish.png', fit: BoxFit.fitWidth),
        ),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: const InputDecoration(
            hintText: null, // can't be const because hintText varies
          ),
        ),
      ],
    );
  }
}
