import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

void main(final List<String> arguments) async {
  final String username = getInput(arguments);
  final List<String> followers = await getAllFollowers(username);
  final File file = File('followers.txt');
  if (!file.existsSync()) {
    file.writeAsStringSync('');
  }

  final List<String> oldFollowers = await file
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .toList();
  final String followerOwner =
      oldFollowers.isNotEmpty ? oldFollowers.first : '';
  if (followerOwner != username) {
    writeFollowers(followers, file, username);
    print(
        'We have recorded your followers. Rats will be shown next time you run the program.');
    return;
  }

  final List<String> rats = await Stream.fromIterable(oldFollowers)
      .skip(1)
      .where((f) => !followers.contains(f))
      .toList();
  if (rats.isNotEmpty) {
    print('These are your rats\n');
    rats.forEach((f) => print(f));
  } else {
    print('Impressive! All your followers are loyal.');
  }

  writeFollowers(followers, file, username);
}

String getInput(final List<String> arguments) {
  if (arguments.isEmpty) {
    stdout.write('Please enter a username: ');
    return stdin.readLineSync(retainNewlines: false);
  } else {
    return arguments.first;
  }
}

void writeFollowers(List<String> followers, File sink, String owner) {
  // Adding username so we can figure out whose followers are these
  followers.insert(0, owner);
  sink.openWrite(mode: FileMode.write).writeAll(followers, "\n");
}

Future<List<String>> getAllFollowers(String username, {int pageNo = 1}) async {
  final String apiURL =
      'https://api.github.com/users/$username/followers?per_page=100&'
      'page=$pageNo';
  final http.Response response = await http.get(apiURL);
  final List<dynamic> jsonResponse = jsonDecode(response.body);
  if (jsonResponse is List && jsonResponse.isEmpty) {
    return List<String>();
  } else {
    List<String> users = await getAllFollowers(username, pageNo: pageNo + 1);
    users.addAll((jsonResponse).map((i) => i['login']));
    return users;
  }
}
