import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
class FBApi {

  String accessToken;
  String uid;

  FBApi(String accessToken, String uid) {
    this.accessToken = accessToken;
    this.uid = uid;
  }

  Future<List<dynamic>> getFriends() async {
    print(this.accessToken);
    Map<String, dynamic> apiData = await http.get('https://graph.facebook.com/${this.uid}/friends?access_token=${this.accessToken}').then((response) {
      // print(response.body);
      return jsonDecode(response.body);
    });
    print(apiData['data']);
    return apiData['data'];
  }
}