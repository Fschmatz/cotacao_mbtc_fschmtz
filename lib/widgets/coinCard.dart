import 'package:cotacao_mbtc_fschmtz/class/coinInternacional.dart';
import 'package:cotacao_mbtc_fschmtz/class/coinMBTC.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CoinCard extends StatefulWidget {
  String coinNameMbtc;
  String coinNameInternacional;

  CoinCard({Key? key, required this.coinNameMbtc, required this.coinNameInternacional}) : super(key: key);

  @override
  _CoinCardState createState() => _CoinCardState();
}

class _CoinCardState extends State<CoinCard> {
  late CoinMBTC coinMbtc;
  late CoinInternacional coinInternacional;
  String urlCoinApiMbtc = '';
  String urlCoinApiInternacional = '';
  bool loading = true;
  TextStyle trailingStyle = TextStyle(fontSize: 16);

  @override
  void initState() {
    urlCoinApiMbtc =
        'https://www.mercadobitcoin.net/api/${widget.coinNameMbtc}/ticker/';
    urlCoinApiInternacional = 'https://api.coinstats.app/public/v1/coins/${widget.coinNameInternacional}?currency=USD';
    getCoinData();
    super.initState();
  }

  Future<void> getCoinData() async {
    final responseMbtc = await http.get(Uri.parse(urlCoinApiMbtc));
    final responseInternacional = await http.get(Uri.parse(urlCoinApiInternacional));
    if (responseMbtc.statusCode == 200) {
      CoinMBTC dataMbtc = CoinMBTC.fromJSON(jsonDecode(responseMbtc.body));
      setState(() {
        coinMbtc = dataMbtc;
      });
    }
    if (responseInternacional.statusCode == 200) {
      CoinInternacional dataInternacional = CoinInternacional.fromJSON(jsonDecode(responseInternacional.body));
      setState(() {
        coinInternacional = dataInternacional;
      });
    }
    setState(() {
      loading = false;
    });
  }

  String getFormattedValueInternacional(){
    //String valueFormatted;
    if(coinInternacional.name == 'bitcoin'){
      return coinInternacional.value.substring(0, (coinMbtc.last.length - 7));
    }
    else if(coinInternacional.name == 'ethereum'){
      return coinInternacional.value.substring(0, (coinMbtc.last.length - 7));
    }
    else if(coinInternacional.name == 'litecoin'){
      return coinInternacional.value.substring(0, (coinMbtc.last.length - 6));
    }
    else{
      return coinInternacional.value.substring(0, (coinMbtc.last.length - 4));
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
        height: 224,
        child: Center(child: CircularProgressIndicator()))
        : InkWell(
            onTap: getCoinData,
            child: Column(
              children: [
                ListTile(
                  title: Text(widget.coinNameMbtc,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).accentColor
                      )),
                ),
                ListTile(
                  title: Text('Mercado Bitcoin'),
                  trailing: Text('R\$ '+coinMbtc.last.substring(0, (coinMbtc.last.length - 6)),style: trailingStyle,),
                ),
                ListTile(
                  title: Text('Valor Internacional'),
                  trailing: Text('U\$ '+ getFormattedValueInternacional(),style: trailingStyle,),
                ),
                ListTile(
                  title: Text('Conversão U\$ - R\$'),
                  trailing: Text('XXX',style: trailingStyle,),
                ),
              ],
            ),
          );
  }
}
