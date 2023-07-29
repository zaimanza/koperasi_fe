import 'package:flutter/material.dart';

class ElevatedTextField extends StatelessWidget {
  const ElevatedTextField({
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
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: TextField(
        buildCounter: (BuildContext context,
                {required currentLength, maxLength, required isFocused}) =>
            null,
        maxLength: 320,
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
