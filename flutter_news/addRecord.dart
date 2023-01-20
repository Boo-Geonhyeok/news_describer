import 'dart:convert';
import 'dart:io';
import 'package:pocketbase/pocketbase.dart';

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

void main() {
  addRecord();
}
