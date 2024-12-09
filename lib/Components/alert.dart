import 'package:flutter/material.dart';

enum TYPE { alert, error, urgent }

class Alert extends StatelessWidget {
  final TYPE type;
  final String title;
  final String msg;
  final String dateTime;

  const Alert({
    super.key,
    required this.type,
    this.title = '',
    this.msg = '',
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    IconData icon;
    switch (type) {
      case TYPE.urgent:
        backgroundColor = Colors.red;
        icon = Icons.crisis_alert;
        break;
      case TYPE.error:
        backgroundColor = Colors.yellow;
        icon = Icons.error;
        break;
      case TYPE.alert:
        backgroundColor = Colors.green;
        icon = Icons.notifications;
        break;
    }

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF040415), width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(icon, size: 65),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                Text(
                  msg,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 1,
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  dateTime,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
