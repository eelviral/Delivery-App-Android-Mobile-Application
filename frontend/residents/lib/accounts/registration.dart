import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:residents/assets/styles.dart';
import 'package:residents/constants/constants.dart';
import 'package:residents/constants/edit_image_enum.dart';
import 'package:residents/menu/homepage.dart';
import 'package:residents/utilities/connection.dart';
import 'package:residents/widgets/accounts/login_widgets.dart';
import 'package:residents/widgets/menu/edit_image_widgets.dart';
import 'package:residents/widgets/menu/profile_widgets.dart';
import 'package:residents/widgets/menu/view_image.dart';
import 'package:image/image.dart' as img;

class RegistrationPageView extends StatefulWidget {
  final Client client;

  const RegistrationPageView({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  State<RegistrationPageView> createState() => _RegistrationPageViewState();
}

class _RegistrationPageViewState extends State<RegistrationPageView> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _pickedFile;
  CroppedFile? _croppedFile;
  final defaultImageFile = File(defaultProfilePicturePath);

  _cropImage(File? newImageFile) async {
    if (newImageFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: newImageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio7x5,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Photo',
            toolbarColor: Theme.of(context).scaffoldBackgroundColor,
            toolbarWidgetColor: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
            activeControlsWidgetColor: relaiGreen,
            statusBarColor: relaiGreen,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Photo',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );
      if (croppedFile != null) {
        // Make sure image ratio is 1:1
        await _isSquareAspectRatio(File(croppedFile.path))
            .then((isSquare) async {
          if (!isSquare) {
            croppedFile =
                CroppedFile((await _resizeImage(croppedFile!.path)).path);
          }
        });

        setState(() {
          _croppedFile = croppedFile;
        });
      }
    }
  }

  _clear() {
    setState(() {
      _pickedFile = null;
      _croppedFile = null;
    });
  }

  _getImage() {
    showDialog<ImageSource>(
      context: context,
      builder: (context) => ImageAlertDialog(
        titleText: "Choose image source",
        content: Column(
          children: [
            GreenAlertButton(
              buttonText: "Take Photo",
              iconData: Icons.camera_alt_outlined,
              onPressed: () => Navigator.pop(context, ImageSource.camera),
            ),
            GreenAlertButton(
              buttonText: "Photo Library",
              iconData: Icons.photo_library_outlined,
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    ).then(
      (ImageSource? source) async {
        if (source != null) {
          final XFile? image = await _picker.pickImage(
            source: source,
            maxWidth: 1800,
            maxHeight: 1800,
          );
          if (_pickedFile == null) {
            if (image != null) {
              setState(() {
                _pickedFile = File(image.path);
              });
              _cropImage(_pickedFile);
            } else {
              setState(() {
                _pickedFile = defaultImageFile;
              });
            }
          }
        }
      },
    );
  }

  _editImage() {
    showDialog<EditImage>(
      context: context,
      builder: (context) => ImageAlertDialog(
        titleText: "Profile Photo",
        content: Column(
          children: [
            GreenAlertButton(
              buttonText: "Edit",
              iconData: Icons.edit_outlined,
              onPressed: () => Navigator.pop(context, EditImage.edit),
            ),
            GreenAlertButton(
              buttonText: "Add Photo",
              iconData: Icons.camera_alt_outlined,
              onPressed: () => Navigator.pop(context, EditImage.add),
            ),
            GreenAlertButton(
              buttonText: "View",
              iconData: Icons.remove_red_eye_outlined,
              onPressed: () => Navigator.pop(context, EditImage.view),
            ),
            GreenAlertButton(
              buttonText: "Delete",
              iconData: Icons.delete_outline_outlined,
              onPressed: () => Navigator.pop(context, EditImage.delete),
            ),
          ],
        ),
      ),
    ).then((EditImage? edit) {
      if (edit != null) {
        switch (edit) {
          case EditImage.edit:
            {
              setState(() {
                _croppedFile = null;
              });
              _cropImage(_pickedFile);
              if (_croppedFile == null) {
                setState(() {
                  _croppedFile = CroppedFile(_pickedFile!.path);
                });
              }
            }
            break;
          case EditImage.add:
            {
              setState(() {
                _pickedFile = null;
              });
              _getImage();
            }
            break;
          case EditImage.view:
            {
              _viewImage();
            }
            break;
          case EditImage.delete:
            {
              _clear();
            }
            break;
        }
      }
    });
  }

  _viewImage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewImage(
          imageProvider: _croppedFile != null
              ? FileImage(File(_croppedFile!.path))
              : (_pickedFile != null ? FileImage(_pickedFile!) : null),
        ),
      ),
    );
  }

  _editButtonClicked() {
    if (_croppedFile == null) {
      _clear();
      _getImage();
    } else {
      _editImage();
    }
  }

  Future<File> _resizeImage(String imagePath) async {
    img.Image? image = img.decodeImage(File(imagePath).readAsBytesSync());

    if (image != null) {
      img.Image thumbnail = img.copyResize(image, width: 400, height: 400);
      File newImageFile =
          await File(imagePath).writeAsBytes(img.encodePng(thumbnail));
      return newImageFile;
    } else {
      return File(imagePath);
    }
  }

  Future<bool> _isSquareAspectRatio(File imageFile) async {
    final decodedImage = await decodeImageFromList(imageFile.readAsBytesSync());
    if (decodedImage.height / decodedImage.width == 1) {
      return true;
    } else {
      return false;
    }
  }

  void _loadHomepage(dynamic token, String id) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomeScreen(
              client: widget.client,
              token: token,
              id: id,
            )));
  }

  _register(File imageFile, Map<String, String> data) async {
    final connection = ServerConnect(context, widget.client);

    final response = await connection.register(imageFile, data);
    if (response.statusCode == 201) {
      // final  tokenResponse = await connection.verifyToken(response);

      // final Map<String, String>? responseJson = json.decode(response.body);
      // String id;
      // if (responseJson!['id'] != null) {
      //   id = responseJson['id'].toString();
      // } else {
      //   id = '';
      // }

      // if (tokenResponse!.statusCode == 200) {
      //   _loadHomepage(responseJson['token'], id);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Navigator.of(context).pop();
          },
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
                const SizedBox(height: 10.0),
                EditProfilePicture(
                  imageProvider: _croppedFile != null
                      ? FileImage(File(_croppedFile!.path))
                      : (_pickedFile != null ? FileImage(_pickedFile!) : null),
                  onEdit: _editButtonClicked,
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
                  height: 35.0,
                ),
                GreenButton(
                  text: Text(
                    'Create Account',
                    style: barlowFont.copyWith(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : Colors.black,
                      letterSpacing: 1.25,
                    ),
                  ),
                  onPressed: () async {
                    File imageFile = defaultImageFile;
                    if (_croppedFile != null) {
                      imageFile = File(_croppedFile!.path);
                    } else {
                      if (_pickedFile != null) {
                        imageFile = File(_pickedFile!.path);
                      }
                    }

                    // Make sure image ratio is 1:1
                    await _isSquareAspectRatio(imageFile)
                        .then((isSquare) async {
                      if (!isSquare) {
                        imageFile = await _resizeImage(imageFile.path);
                      }
                    });

                    // Convert image to png
                    imageFile = await File(imageFile.path).writeAsBytes(
                        img.encodePng(
                            img.decodeImage(imageFile.readAsBytesSync())!));

                    Map<String, String> data = {
                      'email': _emailController.text,
                      'first_name': _firstNameController.text,
                      'last_name': _lastNameController.text,
                      'phone': _phoneController.text,
                      'password': _passwordController.text,
                      'confirm_password': _confirmController.text,
                    };
                    _register(imageFile, data);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
