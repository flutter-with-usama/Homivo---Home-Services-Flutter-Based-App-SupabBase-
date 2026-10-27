import '../models/counter_model.dart';
import 'counter_repository.dart';

/// Concrete implementation — swap this for a remote/local data source later.
class CounterRepositoryImpl implements CounterRepository {
  @override
  CounterModel getInitialCounter() => const CounterModel();

  @override
  CounterModel increment(CounterModel current) =>
      current.copyWith(count: current.count + 1);

  @override
  CounterModel decrement(CounterModel current) =>
      current.copyWith(count: current.count - 1);
}
