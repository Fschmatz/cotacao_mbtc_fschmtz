import 'package:dynamic_value/dynamic_value.dart';

class CryptoMBTC {
  final String high;
  final String low;
  final String vol;
  final String last;
  final String buy;
  final String sell;
  final String open;

  CryptoMBTC({
    required this.high,
    required this.low,
    required this.vol,
    required this.last,
    required this.buy,
    required this.sell,
    required this.open
  });

  factory CryptoMBTC.fromJSON(dynamic json) {

    final value = DynamicValue(json);

    return CryptoMBTC(
      high: value['ticker']['high'].toString(),
      low:  value['ticker']['low'].toString(),
      vol:  value['ticker']['vol'].toString(),
      last:  value['ticker']['last'].toString(),
      buy:  value['ticker']['buy'].toString(),
      sell:  value['ticker']['sell'].toString(),
      open:  value['ticker']['open'].toString()
    );
  }

  @override
  String toString() {
    return 'CoinMBTC{high: $high, low: $low, vol: $vol, last: $last, buy: $buy, sell: $sell, open: $open}';
  }
}