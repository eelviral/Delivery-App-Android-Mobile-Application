import 'package:flutter/material.dart';
import 'package:sprinters/assets/styles.dart';

class OkButton extends StatelessWidget {
  const OkButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        "OK",
        style: barlowFont.copyWith(color: relaiGreen),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}

class CustomAlert extends StatefulWidget {
  final String title;
  final String content;

  const CustomAlert({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  State<CustomAlert> createState() => _CustomAlertState();
}

class _CustomAlertState extends State<CustomAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
        style: barlowFont.copyWith(fontWeight: FontWeight.bold),
      ),
      content: Text(
        widget.content,
        style: barlowFont.copyWith(fontSize: 18.0),
      ),
      actions: const [
        OkButton(),
      ],
    );
  }
}
