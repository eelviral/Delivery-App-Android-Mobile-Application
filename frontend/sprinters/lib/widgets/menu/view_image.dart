import 'package:flutter/material.dart';
import 'package:sprinters/assets/styles.dart';
import 'package:sprinters/assets/constants/constants.dart';

class ViewImage extends StatefulWidget {
  final ImageProvider? imageProvider;

  const ViewImage({
    Key? key,
    this.imageProvider,
  }) : super(key: key);

  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1.0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: relaiGreen,
          ),
        ),
      ),
      body: Container(
        width: width,
        height: width,
        decoration: BoxDecoration(
          border: Border.all(
            width: 4.0,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : relaiGreen,
          ),
          boxShadow: [
            BoxShadow(
              spreadRadius: 2.0,
              blurRadius: 10.0,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withOpacity(0.1)
                  : Colors.black.withOpacity(0.55),
              offset: const Offset(0.0, 10.0),
            ),
          ],
          shape: BoxShape.circle,
          image: DecorationImage(
            image: widget.imageProvider ??
                const AssetImage(defaultProfilePicturePath),
          ),
        ),
      ),
    );
  }
}
