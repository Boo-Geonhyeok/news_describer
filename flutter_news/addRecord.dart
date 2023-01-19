import 'dart:convert';
import 'dart:io';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;

final pb = PocketBase('http://127.0.0.1:8090');

void addRecord() async {
  var input = await File(
          "/Users/ghboo/go/src/github.com/Boo-Geonhyeok/news/go_news_scraper/output.json")
      .readAsString();
  final parsedNews = jsonDecode(input);
  for (var news in parsedNews) {
    if (news['Url'][0] != 'h') {
      news['Url'] = "https://www.bbc.com" + news['Url'];
    }

    await pb.collection("news").create(body: <String, dynamic>{
      "topic": news["Topic"],
      "title": news["Title"],
      "article": news["Article"],
      "date": news["Date"],
      "description": news["Description"],
      "url": news['Url'],
      "img_url": news["ImgUrl"]
    });
  }
}

void getNews() async {
  final records = await pb.collection('news').getFullList(
        batch: 200,
        sort: '-created',
      );
  print(records[0].data["date"]);
}

void aa() async {
  var article =
      "Hannah Johnston's son William died suddenly after having a seizure. Tests were carried out, but no reason was found as to why he had one. His death was put down as Sudden Unexplained Death in Childhood (SUDC), a category of death where no known cause is given.As MPs debate SUDC for the first time, Hannah and other bereaved parents are raising awareness of the tragedy with the hope of preventing other families from going through the same.";
  var headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer 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',
  };
  var data = jsonEncode({
    "model": "text-davinci-edit-001",
    "input": article,
    "instruction": "Summarize it."
  });
  var url = Uri.parse('https://api.openai.com/v1/edits');
  var res = await http.post(url, headers: headers, body: data);
  if (res.statusCode == 200) {
    final parsedResponse = jsonDecode(res.body);
    print(parsedResponse["choices"][0]["text"]);
  }
  throw Exception('http.post error: statusCode= ${res.statusCode}');
}

void main() {
  addRecord();
}
