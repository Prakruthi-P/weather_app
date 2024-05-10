import 'package:flutter/material.dart';
class HourlyForecastItem extends StatelessWidget {
  final  String temperature;
  final IconData icon;
  final String  time;
  const HourlyForecastItem({super.key,
    required this.temperature,
    required this.icon,
    required this.time}
      );


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.white24,
        child:  Padding(
          padding:const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(time,
                style:const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height:5,),
              Icon(icon,size:32),

              Text(temperature,
                style: const TextStyle(
                  fontSize: 12,
                ),)
            ],
          ),
        ),

      ),
    );
  }
}
