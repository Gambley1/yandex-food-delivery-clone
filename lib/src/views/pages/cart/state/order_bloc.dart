import 'package:papa_burger/src/config/config.dart';
import 'package:rxdart/rxdart.dart' show BehaviorSubject;

class OrderBloc {
  OrderBloc() {
    _orderProgressBarSubject.listen(logI);
  }

  final _orderProgressBarSubject = BehaviorSubject<double>.seeded(0);

  double get initialCount => _orderProgressBarSubject.value;

  Stream<double> get orderProgress => _orderProgressBarSubject.stream;

  bool get isClosed => _orderProgressBarSubject.isClosed;

  void addCount(double value) => _orderProgressBarSubject.add(value);

  void dispose() => _orderProgressBarSubject.close();
}
