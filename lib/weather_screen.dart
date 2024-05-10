import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'additional_info_item.dart';
import 'hourly_forecast_item.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<Map<String,dynamic>> getCurrentWeather() async {
    try {
      final response = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/forecast?q=London,uk&APPID=423e8b45cc55d30c08a92e2ada81d668"));



      if (response.statusCode != 200) {
        throw "An unexpected error has occurred";
      }
      final data=jsonDecode(response.body);
      return data;
    } catch (e) {
      throw e.toString();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App",

        style:TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            setState(() {

            });
          }, icon: const Icon(Icons.refresh)),
        ],
      ),
      body:  FutureBuilder(
        future: getCurrentWeather(),
        builder: (context,snapshot){
          if (snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError){
            return  Text(snapshot.error.toString());
          }
          final data=snapshot.data!;
          final currentTemperature=data['list'][0]['main']['temp'];
          final String currentCloud=data['list'][0]['weather'][0]['main'];
          final  currentPressure=data['list'][0]['main']['pressure'];
          final  currentHumidity=data['list'][0]['main']['humidity'];
          final  currentWindSpeed=data['list'][0]['wind']['speed'];
          return    Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 15,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white24,
                    child:  Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text("$currentTemperature K",
                            style:const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Icon(
                              currentCloud=="Rain"|| currentCloud=="Clouds"? Icons.cloud:Icons.sunny,
                              size:64),

                          Text(currentCloud,
                            style: const TextStyle(
                              fontSize: 20,
                            ),)
                        ],
                      ),
                    ),

                  ),
                ),
                const SizedBox(height: 20,),
                const Text("Weather ForeCast",
                  style:TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),

                ),
                const SizedBox(height: 8,),

                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:5,
                      itemBuilder:(context,index){
                  final hourlyForeCast=data['list'][index+1];
                  final hourlySky=data['list'][index+1]['weather'][0]['main'];
                  final time=DateTime.parse(hourlyForeCast['dt_txt']);
                  return HourlyForecastItem(temperature: hourlyForeCast['main']['temp'].toString(),
                      icon:hourlySky=="Clouds" || hourlySky=="Rain"?Icons.cloud:Icons.sunny,
                      time:DateFormat('j').format(time),
                  );

                  }
                            ),
                ),
                const SizedBox(height: 20,),
                const Text("Additional Information",
                  style:TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    AdditionalInfoItem(
                      icon:Icons.water_drop,
                      label:"Humidity",
                      value: currentHumidity.toString(),
                    ),
                    AdditionalInfoItem(
                      icon:Icons.air,
                      label:"Wind Speed",
                      value: currentWindSpeed.toString(),
                    ),
                    AdditionalInfoItem(
                      icon:Icons.beach_access,
                      label:"Pressure",
                      value: currentPressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

      ),
    );
  }
}




