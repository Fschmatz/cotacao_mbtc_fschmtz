import 'package:cotacao_mbtc_fschmtz/class/coinMBTC.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CoinCard extends StatefulWidget {

  String coinName;
  CoinCard({Key? key,required this .coinName}) : super(key: key);

  @override
  _CoinCardState createState() => _CoinCardState();
}

class _CoinCardState extends State<CoinCard> {

  late CoinMBTC coin;
  String urlCoinApi = '';
  bool loading = true;

  @override
  void initState() {
    urlCoinApi = 'https://www.mercadobitcoin.net/api/${widget.coinName}/ticker/';
    getCoinData();
    super.initState();
  }


  Future<void> getCoinData() async {
    final response = await http.get(Uri.parse(urlCoinApi));
    if (response.statusCode == 200) {
      CoinMBTC data = CoinMBTC.fromJSON(jsonDecode(response.body));
      setState(() {
        coin = data;
        loading = false;
      });
      print(coin);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
    elevation: 0,
      child: loading ?
      Container(
        height: 50,
          child: CircularProgressIndicator()) :
      Column(
        children: [
          ListTile(title: Text(widget.coinName),),
          ListTile(title: Text(coin.last),),
          ListTile(title: Text('valor em dolar'),),
          ListTile(title: Text('Conversão direta'),),
        ],
      ),
    );
  }
}
