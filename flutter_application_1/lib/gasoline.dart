
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'model/response/gasoline_price_response.dart';

class ViewGasolinePrice extends StatefulWidget {
  const ViewGasolinePrice({super.key});

  @override
  State< ViewGasolinePrice> createState() => _GasolinePriceState();
}

class _GasolinePriceState extends State< ViewGasolinePrice> {
  Future<GasolinePriceResponse> _getDieselPrice() async {
    try {
      var response =
          await Dio().get('https://api.collectapi.com/gasPrice/turkeyGasoline?city=bursa',options: Options(
    headers: {
      Headers.contentTypeHeader: Headers.jsonContentType, // Set the content-length.
      "Authorization" :"apikey 3DfQpbg8ZkOiksNMo5Mq2O:62xPdw1El2RFMxwZ56ypzH"
    },
  ),);
     GasolinePriceResponse _dieselPrice = GasolinePriceResponse();
      if (response.statusCode == 200) {
        _dieselPrice = GasolinePriceResponse.fromJson(response.data);
      }
      return _dieselPrice;
    } on DioError catch (e) {
      return Future.error(e.message as Object);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<GasolinePriceResponse>(
            future: _getDieselPrice(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                var gasoline=snapshot.data!;
                return ListView.builder(
                
                  itemBuilder: ( context,  index) {
             
               return ListTile(
                title: Text(gasoline.gasolinePriceResponse?[index].name ?? ""),
                subtitle:Column(
                 children :[
                   Text(gasoline.gasolinePriceResponse?[index].address ?? ""),
                   Text(gasoline.gasolinePriceResponse?[index].phone ?? ""),
                 ],
                ),
                
                
               
               );
                  },
                  itemCount: gasoline.gasolinePriceResponse?.length,
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
