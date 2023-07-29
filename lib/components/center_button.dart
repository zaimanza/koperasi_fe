import 'package:flutter/material.dart';

class CenterButton extends StatelessWidget {
  const CenterButton({
    Key? key,
    required this.onTap,
    required this.backgroundColor,
    required this.title,
  }) : super(key: key);

  final VoidCallback onTap;
  final Color backgroundColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: const StadiumBorder(),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
