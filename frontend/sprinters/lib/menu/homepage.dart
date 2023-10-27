import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sprinters/accounts/account.dart';
import 'package:sprinters/assets/styles.dart';
import 'package:sprinters/utilities/connection.dart';
import 'package:sprinters/menu/profile.dart';
import 'package:sprinters/menu/map.dart';
import 'package:sprinters/widgets/menu/appbar_widgets.dart';

class HomeScreen extends StatefulWidget {
  final Client client;
  final String token;
  final String id;

  const HomeScreen({
    Key? key,
    required this.client,
    required this.token,
    required this.id,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex = 1;
  bool _infoCheck = false;
  bool infoCheck(bool infoCheck) => _infoCheck = !_infoCheck;
  bool _notificationReceived = false;
  bool notificationReceived(bool notificationReceived) =>
      _notificationReceived = !_notificationReceived;
  Account? account;

  @override
  void initState() {
    getAccount();
    super.initState();
  }

  void getAccount() async {
    account = null;
    final connection = ServerConnect(context, widget.client);
    final response = await connection.accountResponse(widget.token, widget.id);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      account = Account.fromMap(data);
      setState(() {});
    } else {
      account = null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const helpButton = HelpButton();
    const notificationBell = NotificationBell();
    final mainAppBar = RelaiAppBar(
      leftRow: Row(
        children: const [
          SizedBox(width: 16),
          helpButton,
          SizedBox(width: 8),
          notificationBell,
          SizedBox(width: 8),
        ],
      ),
    );
    final List<RelaiAppBar> appBars = <RelaiAppBar>[
      mainAppBar,
      mainAppBar,
      RelaiAppBar(
        leftRow: Row(
          children: const [
            SizedBox(width: 16),
            notificationBell,
          ],
        ),
        rightWidgets: [
          SignOutButton(client: widget.client),
        ],
      ),
    ];

    final List<Widget> widgetOptions = <Widget>[
      Text(
        'Index 0: QR Center',
        style: barlowFont,
      ),
      MapScreen(
        client: widget.client,
        token: widget.token,
      ),
      account == null
          ? Text(
              'Currently unable to obtain account info.',
              style: barlowFont,
            )
          : AccountScreen(account: account!)
    ];

    return Scaffold(
      appBar: appBars.elementAt(_selectedIndex),
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'QR Center',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            label: 'Sprint',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_outlined),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: relaiGreen,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
