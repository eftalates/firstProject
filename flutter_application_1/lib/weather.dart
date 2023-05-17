import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/constant/constant.dart';
import 'package:flutter_application_1/model/response/weather_response.dart';
import 'package:flutter_svg/flutter_svg.dart';
class ViewWeather extends StatefulWidget {
  const ViewWeather({super.key});

  @override
  State<ViewWeather> createState() => _RemoteApiState();
}

class _RemoteApiState extends State<ViewWeather> {
  Future<Weather> _getWeather() async {
    try {
      var response = await Dio().get(
        'https://api.collectapi.com/weather/getWeather?data.lang=tr&data.city=Bursa',
        options: Options(
          headers: {
            Headers.contentTypeHeader:
                Headers.jsonContentType, // Set the content-length.
            "Authorization":
                "apikey 3DfQpbg8ZkOiksNMo5Mq2O:62xPdw1El2RFMxwZ56ypzH"
          },
        ),
      );
      Weather _weather = Weather();
      if (response.statusCode == 200) {
        _weather = Weather.fromJson(response.data);
      }
      return _weather;
    } on DioError catch (e) {
      return Future.error(e.message as Object);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E335A),
      appBar: AppBar(
   
        title: Text('BURSA',style: TextStyle(color: Colors.white)),backgroundColor: Color(0xFF2E335A),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.pending_outlined,),
            iconSize: 35,
            color: Colors.white,
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<Weather>(
            future: _getWeather(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                var weather = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10, top: 10),
                      child: Stack(
                        children: [
                          SvgPicture.asset(Constants.weather,color: Color(0xFF5936B4),),
                          Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    num.tryParse(weather.weather?[index].degree ?? "")?.toInt().toString() ??
                                        "",
                                    style: TextStyle(fontSize: 60,color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    weather.weather?[index].day ?? "",
                                    style: TextStyle(fontSize: 20,color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                    padding:
                                        EdgeInsets.only(top:20, right: 10),
                                    child: Image.network(
                                        weather.weather?[index].icon ?? "",height: 90,)),
                                Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 20, right: 20,top: 30),
                                  child: Text(
                                      weather.weather?[index].description ??
                                          "",style: TextStyle(color: Colors.white),),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        ],
                      ),
                    );
                  },
                  itemCount: weather.weather?.length,
                );
              } else if (snapshot.hasError) {
                return (Text(snapshot.error.toString()));
              } else {
                return CircularProgressIndicator();
              }
            })),
      ),
    );
  }
}
