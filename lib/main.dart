import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'gradient/text.dart';
import 'package:intl/intl.dart';
import 'gradient/icon.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kelompok 3',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Tugas Kelompok 3 Cuaca'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  double _temperature = 0.0;
  int _humidity = 0;
  double _wind = 0.0;
  double _visibility = 0.0;
  String _date = DateFormat('d MMMM yyyy').format(DateTime.now());
  bool _isLoading = true;

  List<dynamic> _hourlyWeather = [];
  List<dynamic> _dailyWeather = [];

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _fetchWeather() async {
    const apiKey = 'd6831890fb819621251711e2f1f2ca48';
    const city = 'Jakarta';
    const countryCode = 'ID';
    const apiUrl =
        'http://api.openweathermap.org/data/2.5/forecast?q=$city,$countryCode&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _hourlyWeather = data['list'];
        _dailyWeather = data['list']
            .where((element) =>
                DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(
                    element['dt'] * 1000,
                    isUtc: true)) ==
                '12:00')
            .toList();

        setState(() {
          _temperature = data['list'][0]['main']['temp'];
          _humidity = data['list'][0]['main']['humidity'];
          _wind = data['list'][0]['wind']['speed'];
          _visibility = data['list'][0]['visibility'] / 1000;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF86a9e6),
                      Color(0xFF6072d9),
                    ],
                    begin: FractionalOffset.topLeft,
                    end: FractionalOffset.bottomRight,
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DefaultTextStyle(
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                    child: Text(_date),
                                  ),
                                  const SizedBox(height: 8.0),
                                  const DefaultTextStyle(
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      child: Text('Jakarta, Indonesia'))
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 64.0),
                          Column(
                            children: [
                              DefaultTextStyle(
                                style: const TextStyle(),
                                child: GradientText(
                                  '$_temperature°',
                                  style: const TextStyle(
                                      fontSize: 164,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -8),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFe1e8f7),
                                      Color(0xFF768fe0),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                              Transform(
                                transform:
                                    Matrix4.translationValues(0, -110, 0),
                                child: Image.asset(
                                  '../assets/image/cloud.png',
                                  width: 250,
                                  height: 250,
                                ),
                              ),
                              Transform(
                                transform:
                                    Matrix4.translationValues(0, -110, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: -10,
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Card(
                                    color: Colors.white,
                                    shadowColor: Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            children: [
                                              const RadiantGradientMask(
                                                child: Icon(
                                                  CupertinoIcons.wind,
                                                  size: 30.0,
                                                  color: Color(0xFF91ace6),
                                                ),
                                              ),
                                              const SizedBox(height: 12.0),
                                              DefaultTextStyle(
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  child: Text('$_wind km/h')),
                                              const SizedBox(height: 4.0),
                                              const DefaultTextStyle(
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                  child: Text('Wind'))
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              const RadiantGradientMask(
                                                child: Icon(
                                                  CupertinoIcons.drop,
                                                  size: 30.0,
                                                  color: Color(0xFF91ace6),
                                                ),
                                              ),
                                              const SizedBox(height: 12.0),
                                              DefaultTextStyle(
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  child: Text('$_humidity%')),
                                              const SizedBox(height: 4.0),
                                              const DefaultTextStyle(
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                  child: Text('Humidity'))
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              const RadiantGradientMask(
                                                child: Icon(
                                                  CupertinoIcons.eye,
                                                  size: 30.0,
                                                  color: Color(0xFF91ace6),
                                                ),
                                              ),
                                              const SizedBox(height: 12.0),
                                              DefaultTextStyle(
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  child:
                                                      Text('$_visibility km')),
                                              const SizedBox(height: 4.0),
                                              const DefaultTextStyle(
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                  child: Text('Visibility'))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -100),
                      child: Card(
                        color: Colors.white,
                        shadowColor: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text(
                                    'Today',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const Text(
                                    'Next 7 Days',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildHourlyForecast(),
                              const SizedBox(height: 16),
                              _buildDailyForecast(),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ))));
  }

  Widget _buildHourlyForecast() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _hourlyWeather.length,
        itemBuilder: (context, index) {
          final hourlyData = _hourlyWeather[index];
          final temperature = hourlyData['main']['temp'];
          final icon = hourlyData['weather'][0]['icon'];
          final time = DateFormat('HH:mm').format(
            DateTime.fromMillisecondsSinceEpoch(hourlyData['dt'] * 1000,
                isUtc: true),
          );

          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: 100,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$temperature°',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Image.network(
                      '../assets/image/cloud.png',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      time,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDailyForecast() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _dailyWeather.length,
        itemBuilder: (context, index) {
          final dailyData = _dailyWeather[index];
          final temperature = dailyData['main']['temp'];
          final icon = dailyData['weather'][0]['icon'];
          final date = DateFormat('EEE').format(
            DateTime.fromMillisecondsSinceEpoch(dailyData['dt'] * 1000,
                isUtc: true),
          );

          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: 100,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$temperature°',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Image.network(
                      '../assets/image/cloud.png',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      date,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
