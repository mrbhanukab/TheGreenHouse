import 'package:appwrite/appwrite.dart';

class AppwriteService {
  Client client = Client()
      .setEndpoint("https://cloud.appwrite.io/v1")
      .setProject("<PROJECT_ID>");
}
