import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountOption extends StatelessWidget {
  final GlobalKey appBarKey;

  const AccountOption({super.key, required this.appBarKey});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return IconButton(
      icon: const Icon(Icons.account_circle_outlined),
      onPressed: () {
        final RenderBox renderBox = appBarKey.currentContext!
            .findRenderObject() as RenderBox;
        final Offset offset = renderBox.localToGlobal(Offset.zero);
        final Size size = renderBox.size;

        showMenu<String>(
          context: context,
          elevation: 5,
          color: Colors.white,
          position: RelativeRect.fromLTRB(
              offset.dx + size.width, offset.dy + size.height, 0, 0),
          items: <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'Account',
              child: Text(user.displayName ?? 'Account'),
            ),
            const PopupMenuItem<String>(
              value: 'Log Out',
              child: Text('Log Out'),
            ),
          ],
        ).then((String? value) {
            if (value == 'Log Out')  _logOut(context);
        });
      },
    );
  }

  void _logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }
}