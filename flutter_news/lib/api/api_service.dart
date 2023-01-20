import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('http://127.0.0.1:8090');

class ApiService {
  static Future<List<RecordModel>> getNews() async {
    final records = await pb.collection('news').getFullList(
          batch: 200,
          sort: '-created',
        );
    return records;
  }

  static Future<String> getDescription(String article) async {
    const apiKey = '3eebcba957d32a3fc8107990ad22531b';
    const url =
        'https://text-analysis12.p.rapidapi.com/summarize-text/api/v1.1';

    if (article != "") {
      var response = await http.post(Uri.parse(url),
          body: jsonEncode(<String, dynamic>{
            "language": "english",
            "summary_percent": 10,
            "text": article,
          }),
          headers: <String, String>{
            'content-type': 'application/json',
            'X-RapidAPI-Key':
                'da18f18ba0mshf2809c081a0bd98p150885jsn589bed44bafc',
            'X-RapidAPI-Host': 'text-analysis12.p.rapidapi.com'
          });
      if (response.statusCode == 200) {
        return jsonDecode(response.body)["summary"];
      }
    }
    throw Error();
  }
}
