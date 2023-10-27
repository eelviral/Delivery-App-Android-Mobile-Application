import 'package:flutter/material.dart';
import 'package:sprinters/assets/styles.dart';

class ImageAlertDialog extends StatefulWidget {
  final String titleText;
  final Widget? content;
  const ImageAlertDialog({Key? key, required this.titleText, this.content})
      : super(key: key);

  @override
  State<ImageAlertDialog> createState() => _ImageAlertDialogState();
}

class _ImageAlertDialogState extends State<ImageAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: const EdgeInsets.only(top: 10.0),
      title: Align(
        alignment: Alignment.center,
        child: Text(
          widget.titleText,
          style: barlowFont.copyWith(
            fontSize: 26.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            color: Colors.grey,
            height: 4.0,
          ),
          const SizedBox(
            height: 10.0,
          ),
          widget.content!,
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancel",
            style: barlowFont.copyWith(
              color: relaiGreen,
            ),
          ),
        ),
      ],
    );
  }
}

class GreenAlertButton extends StatefulWidget {
  final String buttonText;
  final IconData iconData;
  final Function()? onPressed;

  const GreenAlertButton({
    Key? key,
    required this.buttonText,
    required this.iconData,
    this.onPressed,
  }) : super(key: key);

  @override
  State<GreenAlertButton> createState() => _GreenAlertButtonState();
}

class _GreenAlertButtonState extends State<GreenAlertButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25.0,
          vertical: 8.0,
        ),
        child: ElevatedButton.icon(
          icon: Icon(
            widget.iconData,
            color: Colors.black,
          ),
          style: ElevatedButton.styleFrom(
            elevation: 1.0,
            primary: relaiGreen,
          ),
          label: Text(
            widget.buttonText,
            style: barlowFont.copyWith(fontSize: 22.0, color: Colors.black),
          ),
          onPressed: () => widget.onPressed!(),
        ),
      ),
    );
  }
}
