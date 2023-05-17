import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/constant.dart';
import 'package:readmore/readmore.dart';
import 'model/response/news_response.dart';

class ViewNews extends StatefulWidget {
  const ViewNews({super.key});

  @override
  State<ViewNews> createState() => _RemoteApiState();
}

class _RemoteApiState extends State<ViewNews> {
  Future<News> _getNews() async {
    try {
      var response = await Dio().get(
        'https://api.collectapi.com/news/getNews?country=tr&tag=general',
        options: Options(
          headers: {
            Headers.contentTypeHeader:
                Headers.jsonContentType, // Set the content-length.
            "Authorization":
                "apikey 3DfQpbg8ZkOiksNMo5Mq2O:62xPdw1El2RFMxwZ56ypzH"
          },
        ),
      );
      News _news = News();
      if (response.statusCode == 200) {
        _news = News.fromJson(response.data);
      }
      return _news;
    } on DioError catch (e) {
      return Future.error(e.message as Object);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
       
        centerTitle: true,
        title: Text('NEWS'),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<News>(
          future: _getNews(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              var news = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 5, top: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFF5F5F5),
                      ),
                      
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            child: Image.network(news.news?[index].image ?? "",
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.fill),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  news.news?[index].name ?? "",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                
                                SizedBox(height: 10),
                                Text(
                                  news.news?[index].source ?? "",
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(height: 10),
                                ReadMoreText(
                                  trimLines: 2,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: 'Show more',
                                  trimExpandedText: 'Show less',
                                  news.news?[index].description ?? "",
                                  style: TextStyle(fontSize: 10),
                                  moreStyle: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: news.news?.length,
              );
            } else if (snapshot.hasError) {
              return (Text(snapshot.error.toString()));
            } else {
              return CircularProgressIndicator();
            }
          })),
    );
  }
}
