import 'dart:developer';
import 'package:climate/model/models.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class APIservice {
  late String cityName;
  getWeatherDetails(bool current, String CurrentCityName) async {
    try {
      Position position = await getCurrentPosition();
      if (current) {
        List<Placemark> placemark = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        Placemark place = placemark[0];
        cityName = place.locality!;
      } else {
        cityName = CurrentCityName;
      }
      var url = Uri.parse(
        // "http://api.weatherapi.com/v1/current.json?key=9a5b6cb02cf04c61938163647232106&q=Noida&aqi=no",
        "http://api.weatherapi.com/v1/current.json?key=9a5b6cb02cf04c61938163647232106&q=$cityName&aqi=no",
      );
      var response = await http.get(url);
      if (response.statusCode == 200) {
        print('200...');
        final weatherModel = weatherModelFromJson(response.body);
        print(weatherModel.location.name);
        print(weatherModel.current.tempC);
        return weatherModel;
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }
}
