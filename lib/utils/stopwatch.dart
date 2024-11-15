import 'dart:async';

class CustomStopwatch {
  late int _totalIterations;
  late int _currentIteration;
  late Timer _timer;
  Duration? _duration;
  late Function(int) _onTick;
  late Function() _onComplete;

  CustomStopwatch({
    required int totalIterations,
    required Function(int) onTick,
    required Function() onComplete,
    Duration? duration,
  }) {
    _totalIterations = totalIterations;
    _onTick = onTick;
    _onComplete = onComplete;
    _currentIteration = 0;
    _duration = duration;
    // _startTimer();
  }

  void startTimer() {
    _timer =
        Timer.periodic(_duration ?? const Duration(seconds: 1), (Timer timer) {
      _currentIteration++;
      _onTick(_currentIteration);

      if (_currentIteration == _totalIterations) {
        _timer.cancel();
        _currentIteration = 0;
        _onComplete();
      }
    });
  }

  void restart() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    _currentIteration = 0;
    startTimer();
  }

  void cancel() {
    _timer.cancel();
  }
}
