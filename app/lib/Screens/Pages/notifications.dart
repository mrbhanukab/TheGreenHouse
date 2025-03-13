import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thegreenhouse/Components/alert.dart';
import 'package:thegreenhouse/Services/appwrite.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<dynamic> documents = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDocuments();
  }

  Future<void> fetchDocuments() async {
    setState(() {
      _isLoading = true;
    });
    final appwriteService = AppwriteService();
    final response = await appwriteService.getDocuments(
      '674ec23000034d9908fa',
      '674fe20d000658985117',
    );

    if (response != null) {
      setState(() {
        documents = jsonDecode(response)['documents'];
        _isLoading = false;
      });
    }
  }

  String formatDateTime(String dateTime) {
    final date = DateTime.parse(dateTime);
    final formattedDate = DateFormat('MMM dd | hh:mm a').format(date);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: fetchDocuments,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final document = documents[index];
                      final formattedDate = formatDateTime(document['when']);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Alert(
                          type:
                              document['type'] == 'urgent'
                                  ? TYPE.urgent
                                  : document['type'] == 'error'
                                  ? TYPE.error
                                  : TYPE.alert,
                          title: document['title'],
                          msg: document['msg'],
                          dateTime: formattedDate,
                        ),
                      );
                    },
                  ),
                ),
              ),
    );
  }
}
