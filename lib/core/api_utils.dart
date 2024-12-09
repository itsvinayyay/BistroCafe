import 'package:food_cafe/core/firebase_service_account_credentials.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

Future<String> getAccessToken() async {
  const serviceAccountJson = serviceAccountCredentials;

  final scopes = [
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/firebase.database',
    'https://www.googleapis.com/auth/firebase.messaging'
  ];

  http.Client client = await auth.clientViaServiceAccount(
    auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
    scopes,
  );

  auth.AccessCredentials credentials =
      await auth.obtainAccessCredentialsViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
          scopes,
          client);

  client.close();

  return credentials.accessToken.data;
}
