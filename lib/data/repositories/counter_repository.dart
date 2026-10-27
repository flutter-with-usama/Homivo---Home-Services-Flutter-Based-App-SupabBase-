import '../models/counter_model.dart';

/// Abstract contract for the counter data source.
abstract class CounterRepository {
  CounterModel getInitialCounter();
  CounterModel increment(CounterModel current);
  CounterModel decrement(CounterModel current);
}
