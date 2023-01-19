import 'package:flutter/material.dart';
import 'package:news/api/api_service.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final Future<List<RecordModel>> newsList = ApiService.getNews();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: newsList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return TikTokStyleFullPageScroller(
              contentSize: snapshot.data!.length,
              builder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 150,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        snapshot.data![index].data["title"],
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    snapshot.data![index].data["img_url"] != ""
                        ? Image.network(snapshot.data![index].data["img_url"])
                        : Image.network(
                            "https://ichef.bbci.co.uk/news/976/cpsprodpb/158C5/production/_128316288_mentalhealthgetty.jpg"),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: snapshot.data![index].data["description"] != ""
                          ? Text(
                              snapshot.data![index].data["description"],
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            )
                          : const Text(""),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (snapshot.data![index].data["url"] != "") {
                          await launchUrlString(
                              snapshot.data![index].data["url"]);
                        }
                      },
                      child: const Text(
                        "Full Article",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                );
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
