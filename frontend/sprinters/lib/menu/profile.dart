import 'package:flutter/material.dart';
import 'package:sprinters/accounts/account.dart';
import 'package:sprinters/assets/styles.dart';
import 'package:sprinters/menu/edit_profile.dart';
import 'package:sprinters/widgets/menu/profile_widgets.dart';

class AccountScreen extends StatefulWidget {
  final Account account;

  const AccountScreen({
    Key? key,
    required this.account,
  }) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
      child: ListView(
        children: [
          const ProfilePicture(),
          const SizedBox(
            height: 5.0,
          ),
          Row(
            children: <Widget>[
              const Expanded(child: SizedBox()),
              Text(
                '${widget.account.firstName} ${widget.account.lastName}',
                style: barlowFont.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditProfile()),
                        );
                      },
                      icon: const Icon(Icons.edit)),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          const Divider(
            color: Colors.black,
            height: 15.0,
            thickness: 3.0,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            'Account Settings',
            style: barlowFont.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          buildAccountOptionRow(context, 'Earnings'),
          buildAccountOptionRow(context, 'Sprinter Stats'),
          buildAccountOptionRow(context, 'Community'),
        ],
      ),
    );
  }

  GestureDetector buildAccountOptionRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                title,
                style: barlowFont,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Option 1',
                    style: barlowFont,
                  ),
                  Text(
                    'Option 2',
                    style: barlowFont,
                  ),
                  Text(
                    'Option 3',
                    style: barlowFont,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Close',
                    style: barlowFont.copyWith(
                        color: relaiGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                )
              ],
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: barlowFont,
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                ),
              ],
            ),
            const SizedBox(
              height: 5.0,
            ),
            const Divider(
              color: Colors.black,
              height: 15.0,
              thickness: 1.0,
            ),
          ],
        ),
      ),
    );
  }
}
