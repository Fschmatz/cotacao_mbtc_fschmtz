import 'package:dynamic_value/dynamic_value.dart';

class MoedaInternacional {
  final String high;
  final String low;

  MoedaInternacional({required this.high,required this.low});

  factory MoedaInternacional.fromJSON(dynamic json,String moeda) {
    final value = DynamicValue(json);

    return MoedaInternacional(
        high: value[moeda]['high'].toString(),
        low: value[moeda]['low'].toString(),
    );
  }

  //(high + low) /2
}
