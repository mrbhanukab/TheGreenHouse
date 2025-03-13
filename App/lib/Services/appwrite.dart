import 'dart:convert';

import 'package:http/http.dart' as http;

class AppwriteService {
  final String endpoint = 'https://cloud.appwrite.io/v1';
  final String projectId = '674e70a2003418f8903e';
  final String apiKey =
      'standard_7bd7a03a84ed8b1b875c81eb8d1dbd77fa08008fd4e88d6ad53c545e7448bf3f1d2f601109b6f106fff3b87920203c55db6ee90ff1e8bbad96750079cda627fbacfdd38b594f02dd515a30d1a7c7f2521f7ccd06f749cc093203bbb69bd236c1d574e1333f3182ab7f2781ed18d1bb614696eaa6c62883b742a8ca867e310de5';
  final String databaseId = '674ec23000034d9908fa';

  Future<String?> getDocuments(String databaseID, String collectionId) async {
    final url = Uri.parse(
      '$endpoint/databases/$databaseID/collections/$collectionId/documents',
    );
    final headers = {
      'Content-Type': 'application/json',
      'X-Appwrite-Project': projectId,
      'X-Appwrite-Key': apiKey,
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Error: ${response.statusCode} ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<String?> getDocument(String collectionId, String documentId) async {
    final url = Uri.parse(
      '$endpoint/databases/$databaseId/collections/$collectionId/documents/$documentId',
    );
    final headers = {
      'Content-Type': 'application/json',
      'X-Appwrite-Project': projectId,
      'X-Appwrite-Key': apiKey,
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Error: ${response.statusCode} ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<bool> updateDocument(
    String collectionId,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    final url = Uri.parse(
      '$endpoint/databases/$databaseId/collections/$collectionId/documents/$documentId',
    );
    final headers = {
      'Content-Type': 'application/json',
      'X-Appwrite-Project': projectId,
      'X-Appwrite-Key': apiKey,
    };
    final body = jsonEncode({'data': data});

    try {
      final response = await http.patch(url, headers: headers, body: body);
      return response.statusCode == 200;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> updatePlantMoistureLimit(
    String collectionId,
    String documentId,
    int newLimit,
  ) async {
    final url = Uri.parse(
      '$endpoint/databases/$databaseId/collections/$collectionId/documents/$documentId',
    );
    final headers = {
      'Content-Type': 'application/json',
      'X-Appwrite-Project': projectId,
      'X-Appwrite-Key': apiKey,
    };
    final body = jsonEncode({
      'data': {'moistureLimits': newLimit},
    });

    try {
      final response = await http.patch(url, headers: headers, body: body);
      return response.statusCode == 200;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
