import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sprinters/assets/constants/constants.dart';
import 'package:sprinters/assets/styles.dart';
import 'dart:io';

class ProfilePicture extends StatefulWidget {
  final ImageProvider? image;

  const ProfilePicture({
    Key? key,
    this.image,
  }) : super(key: key);

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        border: Border.all(
          width: 4.0,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        boxShadow: [
          BoxShadow(
            spreadRadius: 2.0,
            blurRadius: 10.0,
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0.0, 10.0),
          ),
        ],
        shape: BoxShape.circle,
        image: DecorationImage(
          image: widget.image ?? const AssetImage(defaultProfilePicturePath),
        ),
      ),
    );
  }
}

class EditProfilePicture extends StatefulWidget {
  final Function(File)? onNewImagePath;
  final ImageProvider? image;

  const EditProfilePicture({
    Key? key,
    this.onNewImagePath,
    this.image,
  }) : super(key: key);

  @override
  State<EditProfilePicture> createState() => _EditProfilePictureState();
}

class _EditProfilePictureState extends State<EditProfilePicture> {
  final ImagePicker _picker = ImagePicker();
  final defaultImageFile = File(defaultProfilePicturePath);

  _getFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (widget.onNewImagePath != null) {
      if (image != null) {
        widget.onNewImagePath!(File(image.path));
      } else {
        widget.onNewImagePath!(defaultImageFile);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ProfilePicture(
          image: widget.image,
        ),
        Positioned(
          bottom: 0.0,
          right: 0.0,
          child: GestureDetector(
            onTap: () {
              _getFromCamera();
            },
            child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: relaiGreen,
                border: Border.all(
                  width: 4.0,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
