import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerModel extends ChangeNotifier {
  int _trainingTimeInSeconds = 0;
  int _restTimeInSeconds = 0;
  bool _isTraining = false;
  bool _isRest = false;
  Timer? _trainingTimer;
  Timer? _restTimer;
  bool _stop = false;
  int? _remainingTime; 

  int get trainingTimeInSeconds => _trainingTimeInSeconds;
  int get restTimeInSeconds => _restTimeInSeconds;
  bool get isTraining => _isTraining;
  bool get isRest => _isRest;

  void startTrainingTimer(int initialTime) {
    _stop = false;
    _isTraining = true;
    _isRest = false;
    _trainingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isTraining) {
        _isRest = true;
        timer.cancel();
      } else {
        if (_trainingTimeInSeconds <= 0) {
          _isTraining = false;
          _isRest = true;
          timer.cancel();
        } else {
          _trainingTimeInSeconds--;
          notifyListeners();
        }
      }
    });
  }

  void startRestTimer(int initialTime) {
    _isTraining = false;
    _isRest = true;
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isRest) {
        _isTraining = true;
        timer.cancel();
      } else {
        if (_restTimeInSeconds <= 0) {
          _isTraining = true;
          _isRest = false;
          timer.cancel();
        } else {
          _restTimeInSeconds--;
          notifyListeners();
        }
      }
    });
  }

  void startIntervalCounter(int trainingTime, int restTime, int sets) {
    stopTimer();
    _remainingTime = null;

    int totalDuration = (trainingTime + restTime) * sets;
    int currentDuration = 0;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentDuration >= totalDuration || _stop == true) {
        stopTimer();
        timer.cancel();
      } else {
        if (_isTraining) {
          if (_trainingTimeInSeconds <= 0) {
            _isTraining = false;
            _isRest = true;
            _trainingTimeInSeconds = restTime;
          } else {
            _trainingTimeInSeconds--;
          }
        } else {
          if (_restTimeInSeconds <= 0) {
            _isTraining = true;
            _isRest = false;
            _restTimeInSeconds = trainingTime;
          } else {
            _restTimeInSeconds--;
          }
        }

        currentDuration++;
        notifyListeners();
      }
    });

    if (_remainingTime != null) {
      if (_isTraining) {
        startTrainingTimer(_remainingTime!);
      } else {
        startRestTimer(_remainingTime!);
      }
    } else {
      startTrainingTimer(trainingTime);
    }
  }

  void pauseTimer() {
    if (_trainingTimer != null && _restTimer != null) {
      _trainingTimer?.cancel();
      _restTimer?.cancel();
      _remainingTime = _isTraining ? _trainingTimeInSeconds : _restTimeInSeconds;
    }
    notifyListeners();
  }

  void stopTimer() {
    _stop = true;
    if (_isTraining) {
      _trainingTimeInSeconds = 0;
      _trainingTimer?.cancel();
    } else {
      _restTimeInSeconds = 0;
      _restTimer?.cancel();
    }
    _remainingTime = null;
    notifyListeners();
  }

  void resumeTimer() {
    if (_remainingTime != null) {
      if (_isTraining) {
        startTrainingTimer(_remainingTime!);
      } else {
        startRestTimer(_remainingTime!);
      }
    }
  }
}
