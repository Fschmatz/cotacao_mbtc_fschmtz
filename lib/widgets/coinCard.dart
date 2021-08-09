import 'package:cotacao_mbtc_fschmtz/class/coinInternacional.dart';
import 'package:cotacao_mbtc_fschmtz/class/coinMBTC.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CoinCard extends StatefulWidget {
  String coinNameMbtc;
  String coinNameInternacional;
  //String valorCotacaoDolar;

  CoinCard(
      {Key? key,
      required this.coinNameMbtc,
      required this.coinNameInternacional})
      : super(key: key);

  @override
  _CoinCardState createState() => _CoinCardState();
}

class _CoinCardState extends State<CoinCard> {
  late CoinMBTC coinMbtc;
  late CoinInternacional coinInternacional;
  String urlCoinApiMbtc = '';
  String urlCoinApiInternacional = '';
  bool loading = true;
  TextStyle valuesStyle = TextStyle(fontSize: 16);
  double valorDolar = 0;

  @override
  void initState() {
    urlCoinApiMbtc =
        'https://www.mercadobitcoin.net/api/${widget.coinNameMbtc}/ticker/';
    urlCoinApiInternacional =
        'https://api.coinstats.app/public/v1/coins/${widget.coinNameInternacional}?currency=USD';
   //valorDolar = double.parse(widget.valorCotacaoDolar);
    getCoinData();
    super.initState();
  }

  Future<void> getCoinData() async {
    final responseMbtc = await http.get(Uri.parse(urlCoinApiMbtc));
    final responseInternacional =
        await http.get(Uri.parse(urlCoinApiInternacional));
    if (responseMbtc.statusCode == 200) {
      CoinMBTC dataMbtc = CoinMBTC.fromJSON(jsonDecode(responseMbtc.body));
      setState(() {
        coinMbtc = dataMbtc;
      });
    }
    if (responseInternacional.statusCode == 200) {
      CoinInternacional dataInternacional =
          CoinInternacional.fromJSON(jsonDecode(responseInternacional.body));
      setState(() {
        coinInternacional = dataInternacional;
      });
    }
    setState(() {
      loading = false;
    });
  }

  String getFormattedValueInternacional() {
    //String valueFormatted;
    if (coinInternacional.name == 'bitcoin') {
      return coinInternacional.value.substring(0, (coinMbtc.last.length - 7));
    } else if (coinInternacional.name == 'ethereum') {
      return coinInternacional.value.substring(0, (coinMbtc.last.length - 7));
    } else if (coinInternacional.name == 'litecoin') {
      return coinInternacional.value.substring(0, (coinMbtc.last.length - 6));
    } else {
      return coinInternacional.value.substring(0, (coinMbtc.last.length - 4));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: InkWell(
        onTap: getCoinData,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Column(
          children: [
            ListTile(
              title: Text(widget.coinNameMbtc,
                  //textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).accentColor)),
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 600),
              child: loading
                  ? Container(
                      height: 150,
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Theme.of(context).accentColor,
                      )))
                  : Column(
                      children: [
                        ListTile(
                          title: Text(
                            'R\$',
                            style: valuesStyle,
                          ),
                          trailing: Text(
                            coinMbtc.last
                                .substring(0, (coinMbtc.last.length - 6)),
                            style: valuesStyle,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'U\$',
                            style: valuesStyle,
                          ),
                          trailing: Text(
                            getFormattedValueInternacional(),
                            style: valuesStyle,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'U\$ -> R\$',
                            style: valuesStyle,
                          ),
                          trailing: Text(
                            '666',
                            style: valuesStyle,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
