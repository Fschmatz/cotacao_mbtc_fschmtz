import 'package:dynamic_value/dynamic_value.dart';

class CryptoInternacional {
  final String name;
  final String value;

  CryptoInternacional({
    required this.name,
    required this.value
  });

  factory CryptoInternacional.fromJSON(dynamic json) {

    final value = DynamicValue(json);

    return CryptoInternacional(
        name: value['coin']['id'].toString(),
        value:  value['coin']['price'].toString()
    );
  }

  @override
  String toString() {
    return 'CoinInternacional{name: $name, value: $value}';
  }
}