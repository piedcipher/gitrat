import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

void main(List<String> arguments) async {
  final username = getInput(arguments);
  final followers = await getAllFollowers(username);
  final file = File(Directory.current.path + '/followers.txt');
  final oldFollowers = await file
      .openRead()
      .transform(utf8.decoder)
      .transform(new LineSplitter())
      .toList();
  final followerOwner = oldFollowers.first;
  if (followerOwner != username) {
    writeFollowers(followers, file, username);
    print("We have recorded your followers. Rats will be shown next time you "
        "run the program.");
    return;
  }

  final rats = await Stream.fromIterable(oldFollowers)
      .skip(1)
      .where((f) => !followers.contains(f))
      .toList();
  if (rats.isNotEmpty) {
    print("These are your rats\n");
    rats.forEach((f) => print(f));
  } else {
    print("Impressive! All your followers are loyal.");
  }

  writeFollowers(followers, file, username);
}

String getInput(List<String> arguments) {
  if (arguments.isEmpty) {
    stdout.write('Please enter a username: ');
    return stdin.readLineSync(retainNewlines: false);
  } else {
    return arguments.first;
  }
}

void writeFollowers(List<String> followers, File sink, String owner) {
  //Adding username so we can figure out whose followers are these
  followers.insert(0, owner);
  sink.openWrite(mode: FileMode.write).writeAll(followers, "\n");
}

Future<List<String>> getAllFollowers(String username, {int pageNo = 1}) async {
  final apiURL =
      'https://api.github.com/users/$username/followers?per_page=100&'
      'page=$pageNo';
  final response = await http.get(apiURL);
  final jsonResponse = jsonDecode(response.body);
  if (jsonResponse is List && jsonResponse.isEmpty) {
    return new List<String>();
  } else {
    var users = await getAllFollowers(username, pageNo: pageNo + 1);
    users.addAll((jsonResponse as List).map((i) => i['login']));
    return users;
  }
}
