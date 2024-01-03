import 'package:flutter/material.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '${dateTime.minute} : ${dateTime.second}',
            style: Theme.of(context).textTheme.headline4,
          ),
          const Divider(),
          TimePickerSpinner(
           // locale: const Locale('en', ''),
            time: dateTime,
            // is24HourMode: false,
            // isShowSeconds: false,
            itemHeight: 80,
            normalTextStyle: const TextStyle(
              fontSize: 24,
            ),
            highlightedTextStyle:
                const TextStyle(fontSize: 24, color: Colors.blue),
           // isForce2Digits: true,
            onTimeChange: (time) {
              setState(() {
                dateTime = time;
              });
            },
          )
        ],
      ),
    );
  }
}
