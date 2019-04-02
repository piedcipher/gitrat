import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

void main() async {
  var followers = await getAllFollowers("piedcipher", 1);
  var file = File(Directory.current.path + '/followers.txt');
  var oldFollowers = await file
      .openRead()
      .transform(utf8.decoder)
      .transform(new LineSplitter())
      .toList();
  var rats = await Stream.fromIterable(oldFollowers)
      .where((f) => !followers.contains(f))
      .toList();
  if (rats.isNotEmpty) {
    print("These are your rats\n");
    rats.forEach((f) => print(f));
  }
  file.openWrite(mode: FileMode.write).writeAll(followers, "\n");
}

Future<List<String>> getAllFollowers(String username, int pageNo) async {
  final apiURL =
      'https://api.github.com/users/$username/followers?per_page=100&'
      'page=$pageNo';
  final response = await http.get(apiURL);
  final jsonResponse = jsonDecode(response.body);
  if (jsonResponse is List && jsonResponse.isEmpty) {
    return new List<String>();
  } else {
    var users = await getAllFollowers(username, pageNo + 1);
    users.addAll((jsonResponse as List).map((i) => i['login']));
    return users;
  }
}
