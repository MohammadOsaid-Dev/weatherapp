import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/weather/weather_modal.dart';
import 'package:weather/weather/weather_services.dart';
import 'package:intl/intl.dart';



class Weatherpage extends StatefulWidget {
  const Weatherpage({super.key});

  @override
  State<Weatherpage> createState() => _WeatherpageState();
}

class _WeatherpageState extends State<Weatherpage> {
  //Api key
  final _weatherService = WeatherService('899ec6dd17f364730dee4f52fff5745b');
  Weather? _weather;
  //
  bool _isLoading = true;
  Timer? _timer;
  String _currentTime = '';
  String? _cityNameWithMaholla;


  @override
  void initState() {
    super.initState();
    _requestPermission();
    _fetchWeather();
    _startTimer();
  }
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateFormat('hh:mm:ss a').format(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  //permission from user
  Future<void> _requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Handle the case where the user denied the permission forever
        return;
      } else if (permission == LocationPermission.denied) {
        // Handle the case where the user denied the permission
        return;
      }
    } else if (permission == LocationPermission.unableToDetermine) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Handle the case where the user denied the permission forever
        return;
      } else if (permission == LocationPermission.denied) {
        // Handle the case where the user denied the permission
        return;
      }
    }

    // Fetch the weather data after getting the permission
    _fetchWeather();
  }
  Future<void> _fetchWeather() async {
    try {
      //current city
      _cityNameWithMaholla = await _weatherService.getCurrentCity();
      //weather for city
      final weather = await _weatherService.getWeather(_cityNameWithMaholla!);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching weather: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }  String getWeatherAnimation(String? mainCondition){
    if (mainCondition==null) return 'assets/sunny.json'; //default
    switch (mainCondition.toLowerCase()){
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstrom':
        return 'assets/lighting.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';

    }
  }
  // Add a new method to get the moon animation
  String getMoonAnimation() {
    final now = DateTime.now();
    final hour = now.hour;
    if (hour >= 18 || hour < 6) { // 6pm to 6am
      return 'assets/night.json'; // moon animation
    } else {
      return 'assets/sunny.json'; // sun animation
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // show loading indicator
          :
      Padding(
        padding: const EdgeInsets.only(top: 40,left: 20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [


            Row(
          children: [
            const Icon(Icons.calendar_month,color: Colors.orangeAccent,),

            Text(DateFormat('EEEE, dd-MMMM-yyyy').format(DateTime.now()),style: const TextStyle(fontSize: 12,color: Colors.white),),
          ],
        ),
            SizedBox(height: 50,),

      Text(_currentTime, style: const TextStyle(fontSize: 28, color: Colors.white),),

    // StreamBuilder(
            //   stream: Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       return Text(DateFormat('hh:mm:ss a').format(snapshot.data!), style: const TextStyle(fontSize: 12, color: Colors.white),);
            //     } else {
            //       return const Text(''); // or some default text
            //     }
            //   },
            // ),
            // Text(DateFormat('hh:mm:ss a').format(DateTime.now()),style: const TextStyle(fontSize: 12,color: Colors.white),),
           SizedBox(height: 20,),

            //city name
            Center(child:
            Text( _cityNameWithMaholla??
              // _weather?.cityName ??
                "Loading city..",style: TextStyle(color: Colors.white),),
            ),

            //Animation
            Lottie.asset(getWeatherAnimation(_weather?.maincondition,)),

            //temp
            Text(_weather?.temperature != null
                ? '${_weather?.temperature.round()}°C'
                : 'Loading...',style: TextStyle(color: Colors.white),),
            // weather condition
            Text(_weather?.maincondition ?? "",style: TextStyle(color: Colors.white),),
            SizedBox(height: 50,),

            // Padding(
            //   padding: const EdgeInsets.only(right: 20),
            //   child: Container(
            //     height: 250,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(20),
            //       boxShadow:[
            //         BoxShadow(
            //           color: Colors.white,
            //         )
            //       ]
            //     ),
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Column(
            //         children: [
            //           Row(
            //             children: [
            //               Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Icon(Icons.wind_power)
            //                 ],
            //               )
            //             ],
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // )

            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow:[
                      BoxShadow(
                        color: Colors.white,
                      )
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.wind_power),
                              _weather?.windSpeed != null
                                  ? Text(' ${_weather?.windSpeed?.round()} km/h\nWind',)
                                  : Text('Loading...'),
                            ],
                          ),
                          SizedBox(width: 15,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.thermostat),
                              _weather?.maxTemp != null
                                  ? Text(' ${_weather?.maxTemp?.round()}°C\n  Max',)
                                  : Text('Loading...'),
                            ],
                          ),
                          SizedBox(width: 15,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.thermostat),
                              _weather?.minTemp != null
                                  ? Text(' ${_weather?.minTemp.round()}°C\nMin',)
                                  : Text('Loading...'),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      Divider(
                        thickness: 1,
                        endIndent: 10,
                        indent: 10,
                      ),
                      SizedBox(height: 15,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.water_drop),
                              _weather?.humidity != null
                                  ? Text(' ${ _weather?.humidity?.round()}%\n Humidity ')
                                  : Text('Loading...'),
                            ],
                          ),
                          SizedBox(width: 15,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.air),
                              _weather?.pressure != null
                                  ? Text(' ${_weather?.pressure?.round()}hPa\n Pressure')
                                  : Text('Loading...'),
                            ],
                          ),
                          SizedBox(width: 15,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.thermostat),
                              _weather?.seaLevel != null
                                  ? Text(' ${_weather?.seaLevel?.round()}m\n Sea-Level')
                                  : Text('Loading...'),
                            ],
                          ),
                        ],
                      ),                    ],
                  ),
                ),
              ),
            )          ],
        ),
      ),
    );
  }
}

