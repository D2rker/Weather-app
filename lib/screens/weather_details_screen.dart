import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';

class WeatherDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              final city =
              Provider.of<WeatherProvider>(context, listen: false).weatherData['name'];
              if (city != null) {
                Provider.of<WeatherProvider>(context, listen: false).fetchWeather(city);
              }
            },
          ),
        ],
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          if (weatherProvider.loading) {
            return Center(child: CircularProgressIndicator());
          }

          if (weatherProvider.errorMessage != null) {
            return Center(child: Text(weatherProvider.errorMessage!)); // Using ! to handle nullable String
          }

          final weatherData = weatherProvider.weatherData;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'City: ${weatherData['name']}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Temperature: ${weatherData['main']['temp']} °C',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 20),
                    Image.network(
                      'http://openweathermap.org/img/w/${weatherData['weather'][0]['icon']}.png',
                      width: 50,
                      height: 50,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Condition: ${weatherData['weather'][0]['description']}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Humidity',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '${weatherData['main']['humidity']} %',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wind Speed',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '${weatherData['wind']['speed']} m/s',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
