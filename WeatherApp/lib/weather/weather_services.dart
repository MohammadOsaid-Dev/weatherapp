import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart'as http;
import 'package:get/get.dart';
import 'package:weather/weather/weather_modal.dart';


class WeatherService{
  static const Base_URL='http://api.openweathermap.org/data/2.5/weather?';
  final String apiKey;

  WeatherService(this.apiKey);


  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(Uri.parse('$Base_URL&q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Weather.fromJson(json);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  //permission from user

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return "";
      } else if (permission == LocationPermission.denied) {
        return "";
      }
    } else if (permission == LocationPermission.unableToDetermine) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return "";
      } else if (permission == LocationPermission.denied) {
        return "";
      }
    }

    // fetch current location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // convert the location into a list placemark objects
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    // Extract the city name from first placemark
    String? city = placemarks[0].locality;
    return city ?? "";
  }
}

