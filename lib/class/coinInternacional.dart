import 'package:dynamic_value/dynamic_value.dart';

class CoinInternacional {
  final String name;
  final String value;

  CoinInternacional({
    required this.name,
    required this.value
  });

  factory CoinInternacional.fromJSON(dynamic json) {

    final value = DynamicValue(json);

    return CoinInternacional(
        name: value['coin']['id'].toString(),
        value:  value['coin']['price'].toString()
    );
  }

  @override
  String toString() {
    return 'CoinInternacional{name: $name, value: $value}';
  }
}