import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/models/weather_model.dart';

class WeatherService {
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    try {
      // Get permission from the user
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled, handle this case accordingly
        throw Exception('Location services are disabled.');
      }

      // Fetch the current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Convert the location into a list of placemark objects
      List<Placemark> placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      // Extract the city name from the first placemark
      String? city = placemark[0].locality;

      return city ?? "";
    } catch (e) {
      // Handle any errors that occur during the geolocation process
      print('Error getting current city: $e');
      throw Exception('Failed to get current city: $e');
    }
  }
}


// import 'dart:convert';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:weatherapp/models/weather_model.dart';

// class WeatherService {
//   static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
//   final String apiKey;

//   WeatherService(this.apiKey);

//   Future<Weather> getWeather(String cityName) async {
//     final response = await http
//         .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

//     if (response.statusCode == 200) {
//       return Weather.fromJson(
//         jsonDecode(response.body),
//       );
//     } else {
//       throw Exception('Failed to load weather data');
//     }
//   }

//   Future<String> getCurrentCity() async {
//     //get permission from user
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }

//     //fetch the current location
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     //convert the location into a list of placement objects
//     List<Placemark> placemark =
//         await placemarkFromCoordinates(position.latitude, position.longitude);

//     //extract the city name from the first placemark
//     String? city = placemark[0].locality;

//     return city ?? "";
//   }
// }
