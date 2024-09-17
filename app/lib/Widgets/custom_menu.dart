import 'package:flutter/material.dart';

class CustomMenu extends StatelessWidget {
  final Function(String) onSelected;
  final GlobalKey appBarKey;

  const CustomMenu({super.key, required this.onSelected, required this.appBarKey});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        final RenderBox renderBox = appBarKey.currentContext!.findRenderObject() as RenderBox;
        final Offset offset = renderBox.localToGlobal(Offset.zero);
        final Size size = renderBox.size;

        showMenu<String>(
          context: context,
          elevation: 5,
          color: Colors.white,
          position: RelativeRect.fromLTRB(0, offset.dy + size.height, 0, 0),
          items: <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'Item 1',
              child: Text('Item 1'),
            ),
            const PopupMenuItem<String>(
              value: 'Item 2',
              child: Text('Item 2'),
            ),
            const PopupMenuItem<String>(
              value: 'Item 3',
              child: Text('Item 3'),
            ),
          ],
        ).then((String? value) {
          if (value != null) {
            onSelected(value);
          }
        });
      },
    );
  }
}