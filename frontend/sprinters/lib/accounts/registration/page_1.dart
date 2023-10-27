import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sprinters/assets/styles.dart';
import 'package:sprinters/widgets/accounts/login_widgets.dart';
import 'package:sprinters/widgets/menu/profile_widgets.dart';
import 'package:image_cropper/image_cropper.dart';

class Registration1 extends StatefulWidget {
  final Function(Map<String, dynamic>)? onNewData;
  final Function()? onNextButtonClicked;
  final Function()? onBackButtonClicked;

  const Registration1({
    Key? key,
    this.onNewData,
    this.onNextButtonClicked,
    this.onBackButtonClicked,
  }) : super(key: key);

  @override
  State<Registration1> createState() => _Registration1State();
}

class _Registration1State extends State<Registration1>
    with AutomaticKeepAliveClientMixin<Registration1> {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  File? imageFile;

  cropImage(File newImageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: newImageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
  }

  updateImagePath(File newImageFile) {
    setState(() {
      imageFile = newImageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1.0,
        leading: TextButton.icon(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 25.0,
            color: relaiGreen,
          ),
          style: TextButton.styleFrom(
            primary: relaiGreen,
            textStyle: barlowFont.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          label: const Text('Back'),
          onPressed: () {
            if (widget.onBackButtonClicked != null) {
              widget.onBackButtonClicked!();
            }
          },
        ),
        centerTitle: true,
        title: Text(
          'Registration',
          style: barlowFont,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'New Account',
                  style: barlowFont.copyWith(
                    fontSize: 32.0,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : relaiGreen,
                  ),
                ),
                Text(
                  '(1/3)',
                  style: barlowFont.copyWith(
                    fontSize: 15.0,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : relaiGreen,
                  ),
                ),
                const SizedBox(height: 10.0),
                EditProfilePicture(
                  onNewImagePath: updateImagePath,
                  image: imageFile != null ? FileImage(imageFile!) : null,
                ),
                const SizedBox(height: 20.0),
                LoginTextField(
                  controller: _firstNameController,
                  hintText: "First Name",
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 20.0),
                LoginTextField(
                  controller: _lastNameController,
                  hintText: "Last Name",
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 20.0),
                LoginTextField(
                  controller: _emailController,
                  hintText: "Email",
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20.0),
                LoginTextField(
                  controller: _phoneController,
                  hintText: "Phone",
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20.0),
                LoginTextField(
                  obscureText: true,
                  controller: _passwordController,
                  hintText: "Password",
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 20.0),
                LoginTextField(
                  obscureText: true,
                  controller: _confirmController,
                  hintText: "Confirm Password",
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary:
                            Theme.of(context).brightness == Brightness.light
                                ? greyButtonColor
                                : relaiGreen,
                      ),
                      onPressed: () {
                        if (widget.onNewData != null) {
                          Map<String, dynamic> data = {
                            'email': _emailController.text,
                            'first_name': _firstNameController.text,
                            'last_name': _lastNameController.text,
                            'phone': _phoneController.text,
                            'password': _passwordController.text,
                            'confirm_password': _confirmController.text,
                          };
                          widget.onNewData!(data);
                        }
                        if (widget.onNextButtonClicked != null) {
                          widget.onNextButtonClicked!();
                        }
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.black,
                      ),
                      label: Text(
                        "Next",
                        style: barlowFont.copyWith(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
