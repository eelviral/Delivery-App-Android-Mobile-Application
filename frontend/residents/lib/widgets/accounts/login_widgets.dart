import 'package:flutter/material.dart';
import 'package:residents/assets/styles.dart';

class LoginTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  final EdgeInsetsGeometry padding;
  final double? width;
  final IconData? iconData;
  final TextInputType? keyboardType;

  const LoginTextField({
    Key? key,
    required this.controller,
    this.obscureText = false,
    required this.hintText,
    this.padding = const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
    this.width,
    this.iconData,
    this.keyboardType,
  }) : super(key: key);

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: SizedBox(
        width: widget.width,
        child: TextField(
          cursorColor: relaiGreen,
          controller: widget.controller,
          obscureText: widget.obscureText,
          style: barlowFont,
          autocorrect: true,
          autofocus: true,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
              prefixIcon: widget.iconData != null
                  ? Icon(widget.iconData,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white)
                  : null,
              contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: widget.hintText,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: relaiGreen,
                    width: 3.0,
                  ),
                  borderRadius: BorderRadius.circular(32.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.5,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : relaiGreen,
                ),
                borderRadius: BorderRadius.circular(32.0),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ),
      ),
    );
  }
}

class GreenButton extends StatefulWidget {
  final Text? text;
  final Function()? onPressed;

  const GreenButton({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  State<GreenButton> createState() => _GreenButtonState();
}

class _GreenButtonState extends State<GreenButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45.0,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () {
          if (widget.onPressed != null) {
            widget.onPressed!();
          }
        },
        style: ElevatedButton.styleFrom(
          primary: relaiGreen,
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: widget.text,
      ),
    );
  }
}
