/// Pure data class — no Flutter / Provider dependencies.
class CounterModel {
  final int count;

  const CounterModel({this.count = 0});

  CounterModel copyWith({int? count}) =>
      CounterModel(count: count ?? this.count);
}
