import 'dart:async';

import 'package:dio/dio.dart';
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/constant.dart';
import 'package:flutter_application_1/google_map.dart';
import 'package:flutter_application_1/pharmacy.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' hide MapType;
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/response/duty_pharmacy_response.dart';

class ViewDutyPharmacy extends StatefulWidget {
  const ViewDutyPharmacy({super.key});

  @override
  State<ViewDutyPharmacy> createState() => _DutyPharmacyState();
}

class _DutyPharmacyState extends State<ViewDutyPharmacy> {
  Future<DutyPharmacy> _getDutyPharmacy() async {
    try {
      var response = await Dio().get(
        'https://api.collectapi.com/health/dutyPharmacy?il=bursa',
        options: Options(
          headers: {
            Headers.contentTypeHeader:
                Headers.jsonContentType, // Set the content-length.
            "Authorization":
                "apikey 5vIiiUCOSRN0Lsven7oytM:2QpdPX2c39YZANEygEYDTA"
          },
        ),
      );
      DutyPharmacy _dutyPharmacy = DutyPharmacy();
      if (response.statusCode == 200) {
        _dutyPharmacy = DutyPharmacy.fromJson(response.data);
      }
      return _dutyPharmacy;
    } on DioError catch (e) {
      return Future.error(e.message as Object);
    }
  }

  Completer<GoogleMapController> _controller = Completer();
  double zoomVal = 5.0;

  GlobalKey<ExpandableBottomSheetState> key = new GlobalKey();

  void expand() {
    setState(() {
      persistentContentHeight = 350.0;
    });
    key.currentState?.expand();
  }

  void contract() {
    setState(() {
      key.currentState?.contract();
      persistentContentHeight = 0.0;
      key.currentState?.contract();
    });
  }

  int _contentAmount = 0;
  ExpansionStatus _expansionStatus = ExpansionStatus.contracted;
  var persistentContentHeight = 350.0;

  //MapType _currentMapType = MapType.normal;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: ExpandableBottomSheet(
        key: key,
        onIsContractedCallback: () => print('contracted'),
        onIsExtendedCallback: () => print('extended'),
        animationDurationExtend: Duration(milliseconds: 500),
        animationDurationContract: Duration(milliseconds: 250),
        animationCurveExpand: Curves.bounceOut,
        animationCurveContract: Curves.ease,
        persistentContentHeight: persistentContentHeight,
        background: _buildGoogleMap(context),
        persistentHeader: Container(
          color: Colors.orange,
          constraints: BoxConstraints.expand(height: 20),
          child: Center(
            child: Container(
              height: 4.0,
              width: 50.0,
              color: Color.fromARGB((0.25 * 255).round(), 0, 0, 0),
            ),
          ),
        ),
        expandableContent: bottomSheet(),
        enableToggle: true,
      ),
    );
  }

  Set<Marker> markers = {};

  Widget _buildGoogleMap(BuildContext context) {
    return GoogleMap(
      initialCameraPosition:
          CameraPosition(target: LatLng(40.07335797, 29.51393004), zoom: 12),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: markers,
    );
  }

  Widget _zoomMinusFunction() {
    return Align(
      alignment: Alignment.topRight,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30, right: 8.0),
            child: Row(
              children: [
                Spacer(),
                Column(
                  children: [
                    Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                        ),
                      ),
                      child: IconButton(
                          icon: Icon(
                            FontAwesomeIcons.minus,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            zoomVal--;
                            _minus(zoomVal);
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                        ),
                      ),
                      child: IconButton(
                          icon: Icon(
                            FontAwesomeIcons.plus,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            // setState(() {
                            //   _currentMapType =
                            //       _currentMapType == MapType.normal
                            //           ? MapType.satellite
                            //           : MapType.normal;
                            // });
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(40.07335797, 29.51393004), zoom: zoomVal)));
  }

  Widget bottomSheet() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder<DutyPharmacy>(
          future: _getDutyPharmacy(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              var pharmacy = snapshot.data!;
              addMarkers(pharmacy);
              return Expanded(
                child: ListView.builder(
                  
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        contract();
                        final GoogleMapController controller =
                            await _controller.future;
                        var location =
                            getLatLong(pharmacy.dutyPharmacy?[index].loc);
                        if (location != null)
                          controller.animateCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                                  target: LatLng(location.first, location.last),
                                  zoom: 17)));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: 0, top: 5, left: 10, right: 10),
                        child: Column(
                          children: [
                            Container(
                              
                              width: MediaQuery.of(context).size.width,
                              child: IntrinsicHeight(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(children: [
                                    SvgPicture.asset(
                                      Constants.medicine,
                                      width: 55,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            pharmacy.dutyPharmacy?[index]
                                                    .name ??
                                                "",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              pharmacy.dutyPharmacy?[index]
                                                      .address ??
                                                  "",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            pharmacy.dutyPharmacy?[index]
                                                    .phone ??
                                                "",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            pharmacy.dutyPharmacy?[index]
                                                    .dist ??
                                                "",
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          try {
                                            launchURL(
                                                pharmacy
                                                    .dutyPharmacy?[index].loc,
                                                pharmacy.dutyPharmacy?[index]
                                                        .name ??
                                                    "");
                                          } catch (_) {}
                                        },
                                        icon: Icon(Icons.location_pin))
                                  ]),
                                ),
                              ),
                            ),
                            Divider()
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: pharmacy.dutyPharmacy?.length,
                ),
              );
            } else if (snapshot.hasError) {
              return (Text(snapshot.error.toString()));
            } else {
              return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 350,
                  child: Center(child: CircularProgressIndicator()));
            }
          })),
    );
  }

  void addMarkers(DutyPharmacy pharmacy) {
    pharmacy.dutyPharmacy?.forEach((element) {
      var location = getLatLong(element.loc);
      if (location != null) {
        Marker marker = Marker(
          markerId: MarkerId('marker_${element.name}'),
          position: LatLng(location.first, location.last),
          infoWindow: InfoWindow(title: element.name),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );
        markers.add(marker);
      }
    });
  }
}

launchURL(pharmacyLocation, title) async {
  var location = getLatLong(pharmacyLocation);
  if (location != null &&
      (await MapLauncher.isMapAvailable(MapType.google) ?? false)) {
    await MapLauncher.launchMap(
      mapType: MapType.google,
      coords: Coords(location.first, location.last),
      title: title,
    );
  }
}

getLatLong(pharmacy) {
  if (pharmacy == null) return null;
  try {
    return [
      double.parse(pharmacy.split(",")[0]),
      double.parse(pharmacy.split(",")[1])
    ];
  } catch (e) {
    return null;
  }
}
