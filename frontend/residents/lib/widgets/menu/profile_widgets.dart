import 'package:flutter/material.dart';
import 'package:residents/constants/constants.dart';
import 'package:residents/assets/styles.dart';

class ProfilePicture extends StatefulWidget {
  final ImageProvider? imageProvider;

  const ProfilePicture({
    Key? key,
    this.imageProvider,
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
    );
  }
}

class EditProfilePicture extends StatefulWidget {
  final ImageProvider? imageProvider;
  final Function()? onEdit;

  const EditProfilePicture({
    Key? key,
    this.imageProvider,
    this.onEdit,
  }) : super(key: key);

  @override
  State<EditProfilePicture> createState() => _EditProfilePictureState();
}

class _EditProfilePictureState extends State<EditProfilePicture> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ProfilePicture(
          imageProvider: widget.imageProvider,
        ),
        Positioned(
          bottom: 0.0,
          right: 0.0,
          child: GestureDetector(
            onTap: () {
              if (widget.onEdit != null) {
                widget.onEdit!();
              }
            },
            child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).brightness == Brightness.light
                    ? relaiGreen
                    : Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(
                  width: 4.0,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : relaiGreen,
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
