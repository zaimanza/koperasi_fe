import 'package:flutter/material.dart';

class ElevatedCard extends StatelessWidget {
  const ElevatedCard({
    Key? key,
    required this.title,
    required this.onTap,
    required this.backgroundColor,
    required this.textColor,
  }) : super(key: key);

  final String title;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Card(
          color: backgroundColor,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
