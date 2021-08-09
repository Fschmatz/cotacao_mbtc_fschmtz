import 'package:dynamic_value/dynamic_value.dart';

class Dolar {
  final String high;
  final String low;

  Dolar({required this.high,required this.low});

  factory Dolar.fromJSON(dynamic json) {
    final value = DynamicValue(json);

    return Dolar(
        high: value['USDBRL']['high'].toString(),
        low: value['USDBRL']['low'].toString(),
    );
  }

  //(high + low) /2
}
