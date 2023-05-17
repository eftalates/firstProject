import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/response/all_currency_response.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'constant/constant.dart';

class ViewCurrency extends StatefulWidget {
  const ViewCurrency({super.key});

  @override
  State<ViewCurrency> createState() => _AllCurrency();
}

class _AllCurrency extends State<ViewCurrency>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  Future<AllCurrency> _getAllCurrency() async {
    try {
      var response = await Dio().get(
        'https://api.collectapi.com/economy/allCurrency?',
        options: Options(
          headers: {
            Headers.contentTypeHeader:
                Headers.jsonContentType, // Set the content-length.
            "Authorization":
                "apikey 5vIiiUCOSRN0Lsven7oytM:2QpdPX2c39YZANEygEYDTA"
          },
        ),
      );

      AllCurrency _currency = AllCurrency();
      if (response.statusCode == 200) {
        _currency = AllCurrency.fromJson(response.data);
      }
      return _currency;
    } on DioError catch (e) {
      return Future.error(e.message as Object);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Market'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
            iconSize: 30,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_outlined),
            iconSize: 30,
          ),
        ],
        bottom: TabBar(
            controller: _controller, tabs: [Text("All"), Text("Favorites")]),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: TabBarView(controller: _controller, children: [
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: FutureBuilder<AllCurrency>(
              future: _getAllCurrency(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  var currency = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 5, top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white70,
                              border: Border.all(color: Colors.black)),
                          height: 90,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 30,
                                width: 20,
                                child: SvgPicture.asset(Constants.euro),
                              ),
                              Column(
                                children: [
                                  Text(
                                    currency.allCurrency?[index].code ?? "",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    currency.allCurrency?[index].time ?? "",
                                    style: TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                              Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 10, right: 10),
                                      child: Text(currency
                                              .allCurrency?[index].sellingstr ??
                                          ""),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 10, right: 10),
                                      child: Text(currency
                                              .allCurrency?[index].buyingstr ??
                                          ""),
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: currency.allCurrency?.length,
                  );
                } else if (snapshot.hasError) {
                  return (Text(snapshot.error.toString()));
                } else {
                  return CircularProgressIndicator();
                }
              }),
            ),
          ),
          FutureBuilder<AllCurrency>(
            future: _getAllCurrency(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                var currency = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(currency.allCurrency?[index].name ?? ""),
                        subtitle: Column(
                          children: [
                            Text(currency.allCurrency?[index].date ?? ""),
                            Text(currency.allCurrency?[index].code ?? ""),
                          ],
                        ));
                  },
                  itemCount: currency.allCurrency?.length,
                );
              } else if (snapshot.hasError) {
                return (Text(snapshot.error.toString()));
              } else {
                return CircularProgressIndicator();
              }
            }),
          ),
        ]),
      ),
    );
  }
}
