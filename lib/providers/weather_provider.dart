import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic> _weatherData = {}; // Initialize as an empty map
  bool _loading = false;
  String? _errorMessage; // Make nullable

  Map<String, dynamic> get weatherData => _weatherData;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage; // Make nullable

  WeatherProvider() {
    _loadLastSearchedCity();
  }

  Future<void> fetchWeather(String city) async {
    _loading = true;
    notifyListeners();

    try {
      _weatherData = await _weatherService.fetchWeather(city);
      _errorMessage = null; // Nullable assignment
      _saveLastSearchedCity(city);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> _saveLastSearchedCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('last_searched_city', city);
  }

  Future<void> _loadLastSearchedCity() async {
    final prefs = await SharedPreferences.getInstance();
    final city = prefs.getString('last_searched_city');
    if (city != null) {
      fetchWeather(city);
    }
  }
}
