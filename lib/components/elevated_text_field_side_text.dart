import 'package:flutter/material.dart';

class ElevatedTextFieldSideText extends StatelessWidget {
  const ElevatedTextFieldSideText({
    Key? key,
    required this.onChanged,
    required this.controller,
    required this.hintText,
    required this.enabled,
    required this.titleText,
  }) : super(key: key);

  final VoidCallback onChanged;
  final TextEditingController controller;
  final String hintText;
  final bool enabled;
  final String titleText;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 2,
          child: Center(
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: Text(titleText),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: StadiumBorder(),
            ),
            child: TextField(
              enabled: enabled,
              autofillHints: const [AutofillHints.email],
              buildCounter: (BuildContext context,
                      {required currentLength,
                      maxLength,
                      required isFocused}) =>
                  null,
              maxLength: 320,
              onChanged: (value) {
                onChanged();
              },
              style: TextStyle(
                color: enabled ? Colors.black : Colors.grey,
              ),
              controller: controller,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                contentPadding: const EdgeInsets.only(left: 40),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
