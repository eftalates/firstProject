import 'package:flutter/material.dart';
import 'package:flutter_application_1/fuel_prices.dart';
import 'package:flutter_application_1/model/response/all_currency_response.dart';
import 'google_map.dart';
import 'news.dart';
import 'pharmacy.dart';
import 'weather.dart';
import 'currency.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        
        useMaterial3: true,
       colorSchemeSeed: Colors.black,
      scaffoldBackgroundColor: Colors.blue.shade200,
      ),
      debugShowCheckedModeBanner: false,
      
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    
    ViewNews(),
    ViewWeather(),
    ViewCurrency(),
    ViewDutyPharmacy(),
    //GoogleMapPage(),
    ViewFuelPrice(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
       
    
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Fixed 
        backgroundColor: Colors.black, // <-- This works for fixed
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sunny),
            label: 'Weathers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: 'Currency',
          ),
         BottomNavigationBarItem(
            icon: Icon(Icons.local_pharmacy),
            label: 'Pharmacy',
         ),
         BottomNavigationBarItem(
            icon: Icon(Icons.car_crash),
            label: 'Fuel Oil',
         ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
