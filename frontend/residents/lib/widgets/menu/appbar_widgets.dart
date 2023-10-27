import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:residents/assets/styles.dart';
import 'package:residents/utilities/connection.dart';

class NotificationBell extends StatefulWidget {
  const NotificationBell({Key? key}) : super(key: key);

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  bool _notificationReceived = false;
  bool notificationReceived(bool notificationReceived) =>
      _notificationReceived = !_notificationReceived;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() =>
          _notificationReceived = notificationReceived(_notificationReceived)),
      child: SizedBox(
        height: 32,
        width: 32,
        child: Icon(
          _notificationReceived
              ? Icons.notifications_active
              : Icons.notifications,
          size: 32,
        ),
      ),
    );
  }
}

class HelpButton extends StatefulWidget {
  const HelpButton({Key? key}) : super(key: key);

  @override
  State<HelpButton> createState() => _HelpButtonState();
}

class _HelpButtonState extends State<HelpButton> {
  bool _infoCheck = false;
  bool infoCheck(bool infoCheck) => _infoCheck = !_infoCheck;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {setState(() => _infoCheck = infoCheck(_infoCheck))},
      child: SizedBox(
        height: 32,
        width: 32,
        child: Icon(
          _infoCheck ? Icons.cancel_outlined : Icons.info_outline,
          size: 32,
        ),
      ),
    );
  }
}

class SignOutButton extends StatefulWidget {
  final Client client;

  const SignOutButton({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  State<SignOutButton> createState() => _SignOutButtonState();
}

class _SignOutButtonState extends State<SignOutButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: OutlinedButton(
        onPressed: () {
          final connection = ServerConnect(context, widget.client);
          connection.logout();
        },
        style: OutlinedButton.styleFrom(
            side: const BorderSide(
              width: 1.5,
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(3.0)),
        child: Text(
          'SIGN OUT',
          style: barlowFont.copyWith(
            fontSize: 14.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class RelaiAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Row? leftRow;
  final List<Widget>? rightWidgets;

  @override
  final Size preferredSize;

  const RelaiAppBar({
    Key? key,
    this.leftRow,
    this.rightWidgets,
    this.preferredSize = const Size.fromHeight(kToolbarHeight),
  }) : super(key: key);

  @override
  State<RelaiAppBar> createState() => _RelaiAppBarState();
}

class _RelaiAppBarState extends State<RelaiAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leadingWidth: 100,
      backgroundColor: relaiGreen,
      leading: widget.leftRow,
      centerTitle: true,
      title: Image.asset(
        'assets/images/relai-white-text.png',
        fit: BoxFit.contain,
        height: 32,
      ),
      actions: widget.rightWidgets,
    );
  }
}
