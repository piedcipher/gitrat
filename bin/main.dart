import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

void main() async {
  String apiURL = 'https://api.github.com/users/piedcipher/followers?per_page=100';
  List<String> followers = new List<String>();
  var response = await http.get(apiURL);
  var jsonResponse = json.decode(response.body);
  File file = File(Directory.current.path + '/followers.txt');
  file.openSync(mode: FileMode.append);
  for(int i = 0; i < jsonResponse.length; i++) {
    followers.add(jsonResponse[i]['login']);
  }
  followers.add(jsonResponse.length.toString());
  file.writeAsStringSync(followers.toString() + "\r\n");
}