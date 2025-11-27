import 'package:flutter/material.dart';
import '../data/services/weather_service.dart';
import '../ui/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherService weatherService = WeatherService();

  // Main city weather data
  String mainCity = "Lagos";
  String mainCountry = "";
  String mainTemp = "--";
  String mainStatus = "--";
  String highLow = "--";
  String icon = "";

  // Other cities list
  final List<String> otherCities = ["Ibadan", "Abuja", "Portharcourt"];
  Map<String, String> otherCitiesTemp = {};

  @override
  void initState() {
    super.initState();
    loadMainCityWeather();
    loadOtherCitiesWeather();
  }

  // Load Lagos by default or selected city
  Future<void> loadMainCityWeather() async {
    final data = await weatherService.fetchWeather(mainCity);
    if (data == null) return;

    setState(() {
      mainCountry = data["sys"]["country"];
      mainTemp = "${data["main"]["temp"].round()}°C";
      mainStatus = data["weather"][0]["description"];
      highLow =
          "H: ${data["main"]["temp_max"].round()}°   L: ${data["main"]["temp_min"].round()}°";
      icon = data["weather"][0]["icon"];
    });
  }

  // Load other cities
  Future<void> loadOtherCitiesWeather() async {
    for (var city in otherCities) {
      final data = await weatherService.fetchWeather(city);
      if (data != null) {
        otherCitiesTemp[city] = "${data["main"]["temp"].round()}°";
      } else {
        otherCitiesTemp[city] = "--";
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF154A62),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ===============================
              // TOP SECTION (YELLOW CONTAINER)
              // ===============================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFC727),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "$mainCity, $mainCountry",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Temperature
                    Text(
                      mainTemp,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),

                    Text(
                      mainStatus,
                      style: const TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      highLow,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      height: 150,
                      child: icon.isNotEmpty
                          ? Image.network(
                              "https://openweathermap.org/img/wn/$icon@4x.png",
                            )
                          : Image.asset("assets/weather/beach.png"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ===============================
              // OTHER CITIES TITLE
              // ===============================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Other cities",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ===============================
              // OTHER CITIES LIST
              // ===============================
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: otherCities.length,
                  itemBuilder: (context, index) {
                    final city = otherCities[index];
                    final temp = otherCitiesTemp[city] ?? "--";
                    return _cityCard(city, temp);
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ===============================
              // CHANGE LOCATION BUTTON
              // ===============================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () async {
                    final selectedCity = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchPage(),
                      ),
                    );

                    if (selectedCity != null) {
                      setState(() {
                        mainCity = selectedCity;
                      });
                      loadMainCityWeather();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.yellow.shade400,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Change location",
                        style: TextStyle(
                          color: Colors.yellow.shade400,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // City card widget
  Widget _cityCard(String name, String temp) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1D5A74),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wb_sunny, color: Colors.yellow, size: 40),
          const SizedBox(height: 10),
          Text(name, style: const TextStyle(color: Colors.white)),
          Text(temp, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
