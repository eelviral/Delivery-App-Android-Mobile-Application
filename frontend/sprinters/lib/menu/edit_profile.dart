import 'package:flutter/material.dart';
import 'package:sprinters/assets/styles.dart';
import 'package:sprinters/widgets/menu/profile_widgets.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool revealPassword = false;

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                'Edit Profile',
                style: barlowFont.copyWith(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              const Center(
                child: EditProfilePicture(),
              ),
              const SizedBox(
                height: 35.0,
              ),
              editProfileTextField('First Name', 'Archie'),
              editProfileTextField('Last Name', 'Pawling'),
              editProfileTextField('Email', 'example@email.com'),
              editProfileTextField('Password', '********', true),
              editProfileTextField('Phone', '123-456-7890'),
              editProfileTextField('Date of Birth', '01/01/2000'),
              const SizedBox(
                height: 35.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text(
                        'CANCEL',
                        style: barlowFont.copyWith(
                          fontSize: 14.0,
                          letterSpacing: 2.2,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: relaiGreen,
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text(
                      'SAVE',
                      style: barlowFont.copyWith(
                        fontSize: 14.0,
                        letterSpacing: 2.2,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget editProfileTextField(String labelText, String placeholder,
      [bool isPassword = false]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPassword ? revealPassword : false,
        decoration: InputDecoration(
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      revealPassword = !revealPassword;
                    });
                  },
                  icon: const Icon(Icons.remove_red_eye),
                  color: Colors.grey,
                )
              : null,
          contentPadding: const EdgeInsets.only(bottom: 3.0),
          labelText: labelText,
          labelStyle: barlowFont.copyWith(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: barlowFont.copyWith(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
