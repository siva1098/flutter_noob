import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class WeatherForecast extends StatefulWidget {
  const WeatherForecast({Key? key}) : super(key: key);

  @override
  State<WeatherForecast> createState() => _WeatherForecastState();
}

class _WeatherForecastState extends State<WeatherForecast> {
  WeatherFactory wf = WeatherFactory("d9eabd58e9e0841bb06a1e750cf4f1bd");
  late String location = 'Coimbatore';
  final TextEditingController _cityController =
      TextEditingController(text: 'Coimbatore');

  List<Weather> _data = [];
  List<Weather> _forecast = [];

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    getWeatherFromCity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      resizeToAvoidBottomInset: false,
      body: SafeArea(child: weather()),
    );
  }

  Widget weather() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Divider(
            color: Colors.transparent,
            height: 40,
          ),
          temperature(),
          const Divider(
            color: Colors.transparent,
          ),
          city(),
          const Divider(
            color: Colors.transparent,
          ),
          forecast()
        ],
      ),
    );
  }

  Widget temperature() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.network('https://openweathermap.org/img/wn/' +
            _data[0].weatherIcon!.toString() +
            '@2x.png'),
        Text(
          _data[0].temperature!.celsius!.toStringAsPrecision(2) + '\u2103',
          style: const TextStyle(
              fontSize: 50.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              letterSpacing: 1.3),
        ),
        const Divider(
          thickness: 0.5,
          color: Colors.transparent,
        ),
        Text(
          'Feels like ' +
              _data[0].tempFeelsLike!.celsius!.toStringAsPrecision(2) +
              '\u2103',
          style: const TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: 1),
        ),
        const Divider(
          thickness: 0.5,
          color: Colors.transparent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Low: ${_data[0].tempMin!.celsius!.toStringAsPrecision(2)} \u2103',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            Text(
              'High: ${_data[0].tempMax!.celsius!.toStringAsPrecision(2)} \u2103',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget city() {
    return TextField(
      controller: _cityController,
      onChanged: (String value) {
        setState(() {
          location = value;
        });
      },
      keyboardAppearance: Brightness.dark,
      onSubmitted: (value) => getWeatherFromCity(),
      cursorColor: Colors.transparent,
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.w500,
          color: Colors.black,
          letterSpacing: 1.0),
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        border: InputBorder.none,
      ),
    );
  }

  Widget forecast() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      height: 350,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _forecast.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 175,
            child: Card(
              color: Color((Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(0.3),
              // Colors.primaries[Random().nextInt(Colors.primaries.length)],
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                const SizedBox(
                  height: 40,
                ),
                Text(
                  DateFormat('dd MMM')
                      .format(_forecast[index].date as DateTime),
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  DateFormat('EEEE hh:mm')
                      .format(_forecast[index].date as DateTime),
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
                Image.network(
                  'https://openweathermap.org/img/wn/' +
                      _forecast[index].weatherIcon!.toString() +
                      '@2x.png',
                  width: 100,
                ),
                Text(
                  _forecast[index]
                          .temperature!
                          .celsius!
                          .toStringAsPrecision(2) +
                      '\u2103',
                  style: const TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Divider(
                  thickness: 0.5,
                  color: Colors.transparent,
                ),
                Text(
                  'Feels like ' +
                      _forecast[index]
                          .tempFeelsLike!
                          .celsius!
                          .toStringAsPrecision(2) +
                      '\u2103',
                  style: const TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                  ),
                )
              ]),
            ),
          );
        },
      ),
    );
  }

  void getWeatherFromCity() async {
    Weather w = await wf.currentWeatherByCityName(location);
    List<Weather> fiveDay = await wf.fiveDayForecastByCityName(location);
    setState(() {
      _data = [w];
      _forecast = fiveDay.toList();
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _cityController.dispose();
    super.dispose();
  }
}
