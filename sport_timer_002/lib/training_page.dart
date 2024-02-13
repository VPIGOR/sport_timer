import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'timer_model.dart';
import 'package:audioplayers/audioplayers.dart';

class TrainingPage extends StatefulWidget {
  final int trainingTime;
  final int restTime;
  final int sets;

  const TrainingPage({
    super.key,
    required this.trainingTime,
    required this.restTime,
    required this.sets,
  });

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  bool _isStarted = false;
  bool _isPause = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        color: Colors.blueGrey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TimerDisplay(
                trainingTime: widget.trainingTime,
                restTime: widget.restTime,
                sets: widget.sets,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  minimumSize: const Size(150, 50),
                ),
                onPressed: (!_isStarted && _isPause)
                    ? () {
                        Provider.of<TimerModel>(context, listen: false)
                            .startIntervalCounter(widget.trainingTime,
                                widget.restTime, widget.sets);
                        setState(() {
                          _isStarted = true;
                          _isPause = false;
                        });
                      }
                    : null,
                child: const Text('START'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  minimumSize:
                      const Size(150, 50), // Set the minimum width and height
                ),
                onPressed: !_isPause
                    ? () {
                        Provider.of<TimerModel>(context, listen: false)
                            .stopTimer();
                        setState(() {
                          _isPause = true;
                          _isStarted = false;
                        });
                      }
                    : null,
                child: const Text('STOP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimerDisplay extends StatelessWidget {
  final int trainingTime;
  final int restTime;
  final int sets;

  const TimerDisplay({
    super.key,
    required this.trainingTime,
    required this.restTime,
    required this.sets,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerModel>(
      builder: (context, timerModel, child) {
        final String time = _formatTime(timerModel.isTraining
            ? timerModel.trainingTimeInSeconds
            : timerModel.restTimeInSeconds);

        Color backgroundColor = timerModel.isTraining
            ? const Color.fromARGB(255, 251, 251, 250)
            : const Color.fromARGB(255, 7, 1, 26);

        // Play beep sound in the last two seconds of training and last second of rest
        if (timerModel.restTimeInSeconds == 1 ||
            timerModel.trainingTimeInSeconds == 1) {
          _playShortBeep();
          // beep();
        }

        return Container(
          padding: const EdgeInsets.all(24.0),
          // color: backgroundColor,
          child: Text(
            time,
            style: TextStyle(
                fontSize: 105.0,
                fontWeight: FontWeight.bold,
                color: backgroundColor),
          ),
        );
      },
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _playShortBeep() async {
    await AudioPlayer()
        .play(AssetSource('beep.mp3'), mode: PlayerMode.lowLatency);
  }
}
