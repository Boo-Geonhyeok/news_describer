class NewsModel {
  String topic, title, article, date, url;
  NewsModel.fromJson(Map<String, dynamic> json)
      : topic = json["topic"],
        title = json["title"],
        article = json["article"],
        date = json["date"],
        url = json["url"];
}
