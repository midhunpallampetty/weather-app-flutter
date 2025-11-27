import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = "de1fb0d3b8b89a476f56746d13130ced";

  Future<Map<String, dynamic>?> fetchWeather(String city) async {
    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null; // invalid city or error
    }
  }
}
