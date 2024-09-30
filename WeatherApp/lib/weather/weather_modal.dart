// class Weather {
//   final String cityName;
//   final double temperature;
//   final String maincondition;
//   Weather({ required this.cityName,required this.maincondition,required this.temperature,});
//
//   factory Weather.fromJson(Map< String, dynamic> json){
//     return Weather(
//       cityName: json['name'],
//       maincondition: json['weather'][0]['main'] ,
//       temperature: json['main']['temp'].toDouble(),
//     );
//   }
// }

// weather_modal.dart

class Weather {
  final String cityName;
  final double temperature;
  final String maincondition;
  final double windSpeed;
  final double maxTemp;
  final double minTemp;
  final double? humidity;
  final double? pressure;
  final double? seaLevel;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.maincondition,
    required this.windSpeed,
    required this.maxTemp,
    required this.minTemp,
    this.humidity,
    this.pressure,
    this.seaLevel,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'],
      maincondition: json['weather'][0]['main'],
      windSpeed: json['wind']['speed'],
      maxTemp: json['main']['temp_max'],
      minTemp: json['main']['temp_min'],
      humidity: json['main']['humidity']?.toDouble(),
      pressure: json['main']['pressure']?.toDouble(),
      seaLevel: json['main']['sea_level']?.toDouble(),
    );
  }
}





