import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'timer_model.dart';
// import 'package:audioplayers/audio_cache.dart';

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
        title: const Text('Training Page'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Provider.of<TimerModel>(context, listen: false).stopTimer();
              Navigator.pop(context);
            },
          ),
        ],
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
                child: const Text('Start'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
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
                child: const Text('Pause'),
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

        Color backgroundColor =
            timerModel.isTraining ? Colors.black : Colors.lightBlueAccent;

        // Play beep sound in the last two seconds of training and last second of rest
        if (timerModel.isTraining &&
            timerModel.trainingTimeInSeconds == 1) {
          _playBeep();
        } else if (!timerModel.isTraining &&
            timerModel.restTimeInSeconds == 1) {
          _playShortBeep();
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

  void _playBeep() {
    // AudioCache audioCache = AudioCache();
    // audioCache.play('beep.mp3'); // Replace 'beep.mp3' with your beep sound file
  }

  void _playShortBeep() {
    // AudioCache audioCache = AudioCache();
    // audioCache.play('short_beep.mp3'); // Replace 'short_beep.mp3' with your short beep sound file
  }
}