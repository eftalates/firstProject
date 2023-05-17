
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'model/response/lpg_price_response.dart';


class ViewLpgPrice extends StatefulWidget {
  const ViewLpgPrice({super.key});

  @override
  State< ViewLpgPrice> createState() => _LpgPriceState();
}

class _LpgPriceState extends State< ViewLpgPrice> {
  Future<LpgPriceResponse> _getLpgPrice() async {
    try {
      var response =
          await Dio().get('https://api.collectapi.com/gasPrice/turkeyGasoline?city=bursa',options: Options(
    headers: {
      Headers.contentTypeHeader: Headers.jsonContentType, // Set the content-length.
      "Authorization" :"apikey 3DfQpbg8ZkOiksNMo5Mq2O:62xPdw1El2RFMxwZ56ypzH"
    },
  ),);
    LpgPriceResponse _lpgPrice = LpgPriceResponse();
      if (response.statusCode == 200) {
        _lpgPrice =LpgPriceResponse.fromJson(response.data);
      }
      return _lpgPrice;
    } on DioError catch (e) {
      return Future.error(e.message as Object);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<LpgPriceResponse>(
            future: _getLpgPrice(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                var lpg=snapshot.data!;
                return ListView.builder(
                
                  itemBuilder: ( context,  index) {
             
               return ListTile(
                title: Text(lpg.lpgPriceResponse?[index].name ?? ""),
                subtitle:Column(
                 children :[
                   Text(lpg.lpgPriceResponse?[index].address ?? ""),
                   Text(lpg.lpgPriceResponse?[index].phone ?? ""),
                 ],
                ),
                
                
               
               );
                  },
                  itemCount: lpg.lpgPriceResponse?.length,
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
