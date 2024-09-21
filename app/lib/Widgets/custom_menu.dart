import 'package:flutter/material.dart';

class CustomMenu extends StatefulWidget {
  final Function(String) onSelected;
  final GlobalKey appBarKey;
  final List<String> greenhouseNames;

  const CustomMenu({
    super.key,
    required this.onSelected,
    required this.appBarKey,
    required this.greenhouseNames,
  });

  @override
  _CustomMenuState createState() => _CustomMenuState();
}

class _CustomMenuState extends State<CustomMenu> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        if (widget.greenhouseNames.isNotEmpty) {
          final RenderBox renderBox = widget.appBarKey.currentContext!.findRenderObject() as RenderBox;
          final Offset offset = renderBox.localToGlobal(Offset.zero);
          final Size size = renderBox.size;

          showMenu<String>(
            context: context,
            elevation: 5,
            color: Colors.white,
            position: RelativeRect.fromLTRB(0, offset.dy + size.height, 0, 0),
            items: widget.greenhouseNames.map((name) {
              return PopupMenuItem<String>(
                value: name,
                child: Text(name),
              );
            }).toList(),
          ).then((String? value) {
            if (value != null) {
              widget.onSelected(value);
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No greenhouses available'),
            ),
          );
        }
      },
    );
  }
}