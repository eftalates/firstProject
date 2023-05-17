import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/response/gasoline_price_response.dart';
import 'package:flutter_application_1/model/response/lpg_price_response.dart';
import 'package:flutter_svg/svg.dart';
import 'constant/constant.dart';
import 'model/response/diesel_price_responce.dart';
import 'package:supercharged/supercharged.dart';

class Fuel {
  String? name;
  String? type;
  String? value;

  Fuel(this.name, this.type, this.value);
}

class ViewFuelPrice extends StatefulWidget {
  const ViewFuelPrice({super.key});

  @override
  State<ViewFuelPrice> createState() => _ViewFuelPriceState();
}

class _ViewFuelPriceState extends State<ViewFuelPrice> {
  Future<Map<String?, List<Fuel>>> _getFuelPrices() async {
    List<Fuel?> fuel = [];
    try {
      var _dieselResponse = await Dio().get(
        'https://api.collectapi.com/gasPrice/turkeyDiesel?&city=bursa',
        options: Options(
          headers: {
            Headers.contentTypeHeader:
                Headers.jsonContentType, // Set the content-length.
            "Authorization":
                "apikey 5vIiiUCOSRN0Lsven7oytM:2QpdPX2c39YZANEygEYDTA"
          },
        ),
      );

      var _lpgResponse = await Dio().get(
        'https://api.collectapi.com/gasPrice/turkeyLpg?&city=bursa',
        options: Options(
          headers: {
            Headers.contentTypeHeader:
                Headers.jsonContentType, // Set the content-length.
            "Authorization":
                "apikey 5vIiiUCOSRN0Lsven7oytM:2QpdPX2c39YZANEygEYDTA"
          },
        ),
      );

      var _gasResponse = await Dio().get(
        'https://api.collectapi.com/gasPrice/turkeyGasoline?city=bursa',
        options: Options(
          headers: {
            Headers.contentTypeHeader:
                Headers.jsonContentType, // Set the content-length.
            "Authorization":
                "apikey 5vIiiUCOSRN0Lsven7oytM:2QpdPX2c39YZANEygEYDTA"
          },
        ),
      );
      if (_dieselResponse.statusCode == 200) {
        fuel.addAll(DieselPriceResponse.fromJson(_dieselResponse.data)
                .dieselPrices
                ?.map((e) {
              return Fuel(e.marka, "Dizel", e.dizel?.toString());
            }) ??
            <Fuel>[]);
      }
      if (_lpgResponse.statusCode == 200) {
        fuel.addAll(
            LpgPriceResponse.fromJson(_lpgResponse.data).lpgPrices?.map((e) {
                  return Fuel(e.marka, "Lpg", e.lpg);
                }) ??
                <Fuel>[]);
      }
      if (_gasResponse.statusCode == 200) {
        fuel.addAll(GasolinePriceResponse.fromJson(_gasResponse.data)
                .gasolinePrices
                ?.map((e) {
              return Fuel(e.marka, "Benzin", e.benzin?.toString());
            }) ??
            <Fuel>[]);
      }

      Map<String?, List<Fuel>> grouped =
          fuel.groupBy((element) => element?.name);

      return grouped;
    } on DioError catch (e) {
      return Future.error(e.message as Object);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String?, List<Fuel>>>(
            future: _getFuelPrices(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                var fuel = snapshot.data!;
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    return Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: SvgPicture.asset(
                                      "assets/${fuel.entries.toList()[i].key?.replaceAll(" ", "").toLowerCase()}.svg",
                                      fit: BoxFit.scaleDown,
                                      placeholderBuilder: (context) =>
                                          Container(),
                                    )),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  fuel.entries.toList()[i].key ?? "",
                                  style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w600),
                                ),
                                Spacer(),
                                Icon(Icons.oil_barrel_outlined)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                            height: 20,
                          ),
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: fuel.entries.toList()[i].value.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: RotatedBox(
                                          quarterTurns: 3,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 4),
                                            child: Container(
                                              margin: EdgeInsets.only(bottom: 12),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4, horizontal: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.circular(4),
                                                
                                              ),
                                              child: Text(
                                                fuel.entries
                                                        .toList()[i]
                                                        .value[index]
                                                        .type ??
                                                    "",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        fuel.entries
                                                .toList()[i]
                                                .value[index]
                                                .value ??
                                            "",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                );
                              })
                        ],
                      ),
                    );
                  },
                  itemCount: fuel.length,
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
