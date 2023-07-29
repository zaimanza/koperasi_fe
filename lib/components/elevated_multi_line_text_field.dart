import 'package:flutter/material.dart';

class ElevatedMultiLineTextField extends StatelessWidget {
  const ElevatedMultiLineTextField({
    Key? key,
    required this.onChanged,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  final VoidCallback onChanged;
  final TextEditingController controller;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: TextFormField(
        minLines: 1,
        maxLines: 30,
        keyboardType: TextInputType.multiline,
        onChanged: (value) {
          onChanged();
        },
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.only(left: 40),
        ),
      ),
    );
  }
}
