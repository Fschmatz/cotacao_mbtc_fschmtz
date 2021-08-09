import 'package:cotacao_mbtc_fschmtz/class/coinInternacional.dart';
import 'package:cotacao_mbtc_fschmtz/class/coinMBTC.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

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
  String horaFormatada = ' ';

  @override
  void initState() {
    urlCoinApiMbtc =
        'https://www.mercadobitcoin.net/api/${widget.coinNameMbtc}/ticker/';
    urlCoinApiInternacional =
        'https://api.coinstats.app/public/v1/coins/${widget.coinNameInternacional}?currency=USD';
    horaFormatada = getHoraFormatada();
    getCoinData();
    super.initState();
  }

  String getHoraFormatada(){
    return DateFormat.Hm().format(DateTime.now());
  }

  Future<void> getCoinData() async {

    bool doneMbtc = false;
    bool doneInternacional = false;

    final responseMbtc = await http.get(Uri.parse(urlCoinApiMbtc));
    final responseInternacional =
        await http.get(Uri.parse(urlCoinApiInternacional));
    if (responseMbtc.statusCode == 200) {
      doneMbtc = true;
      CoinMBTC dataMbtc = CoinMBTC.fromJSON(jsonDecode(responseMbtc.body));
      setState(() {
        coinMbtc = dataMbtc;
      });
    }
    if (responseInternacional.statusCode == 200) {
      doneInternacional = true;
      CoinInternacional dataInternacional =
          CoinInternacional.fromJSON(jsonDecode(responseInternacional.body));
      setState(() {
        coinInternacional = dataInternacional;
      });
    }
    if(doneMbtc && doneInternacional){
      setState(() {
        loading = false;
      });
    }
  }

  String getFormattedValueInternacional() {
    //String valueFormatted;
    if (coinInternacional.name == 'bitcoin') {
      return coinInternacional.value.substring(0, (coinInternacional.value.length - 9));
    } else if (coinInternacional.name == 'ethereum') {
      return coinInternacional.value.substring(0, (coinInternacional.value.length - 10));
    } else if (coinInternacional.name == 'litecoin') {
      return coinInternacional.value.substring(0, (coinInternacional.value.length - 12));
    } else {
      return coinInternacional.value.substring(0, (coinInternacional.value.length - 12));
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
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).accentColor)),
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 600),
              child: loading
                  ? Center(child: SizedBox.shrink())
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
                          trailing: Text(
                            horaFormatada,
                            style: TextStyle(fontSize: 14,color: Theme.of(context)
                                .textTheme
                                .headline6!
                                .color!
                                .withOpacity(0.5),),
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
