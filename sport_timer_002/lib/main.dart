import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'timer_model.dart';
import 'training_page.dart';
import 'package:wakelock/wakelock.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
  
  // set the audio player to not stop another apps
  AudioPlayer.global.setAudioContext(
   const AudioContext(
      android: AudioContextAndroid(
        audioFocus: AndroidAudioFocus.none,
      ),
    ),
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Restrict the app to only portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // Prevent the screen from sleeping
    Wakelock.enable();
    return ChangeNotifierProvider(
      create: (context) => TimerModel(),
      child: MaterialApp(
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  final TextEditingController _trainingTimeController = TextEditingController();
  final TextEditingController _restTimeController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();

  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text(
          'Set Interval Timer',
          style: TextStyle(
            color: Colors.white, // Set the text color
            fontSize: 20.0,
          ),
        ),
        centerTitle: true, // Center the title
      ),
      body: Container(
        color: Colors.blueGrey,
        child: Padding(
          padding: const EdgeInsets.only(top: 100), // all(16.0),
          child: ListView(
            children: [
              Center(
                child: Container(
                  alignment: Alignment.center,
                  width: 200, // Adjust the width as needed
                  child: TextField(
                    controller: _trainingTimeController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Work in seconds',
                        hintStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  alignment: Alignment.center,
                  width: 200, // Adjust the width as needed
                  child: TextField(
                    controller: _restTimeController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Rest in seconds',
                        hintStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  alignment: Alignment.center,
                  width: 200, // Adjust the width as needed
                  child: TextField(
                    controller: _setsController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Sets count',
                        hintStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal)),
                  ),
                ),
              ),
              const SizedBox(height: 100),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        const Size(200, 70), // Set the minimum width and height
                    backgroundColor: Colors.blueGrey,
                  ),
                  onPressed: () {
                    int trainingTime =
                        int.tryParse(_trainingTimeController.text) ?? 0;
                    int restTime = int.tryParse(_restTimeController.text) ?? 0;
                    int sets = int.tryParse(_setsController.text) ?? 0;

                    if (trainingTime > 0 && restTime >= 0 && sets > 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrainingPage(
                            trainingTime: trainingTime,
                            restTime: restTime,
                            sets: sets,
                          ),
                        ),
                      );
                    } else {
                      // Handle invalid input
                      // For simplicity, you can display an error message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Invalid Input'),
                            content: const Text('Please enter valid values.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text(
                    'All Set',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
