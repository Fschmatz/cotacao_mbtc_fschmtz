import 'dart:convert';

import 'package:cotacao_mbtc_fschmtz/class/dolar.dart';
import 'package:cotacao_mbtc_fschmtz/configs/pgConfigs.dart';
import 'package:cotacao_mbtc_fschmtz/widgets/coinCard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //DOCS -> https://www.mercadobitcoin.com.br/api-doc/
  //INTERNACIONAL COIN STATS -> https://documenter.getpostman.com/view/5734027/RzZ6Hzr3?version=latest
  //DOLAR https://docs.awesomeapi.com.br/api-de-moedas

  bool loadingDolar = true;
  String urlApiDolar = 'https://economia.awesomeapi.com.br/last/USD-BRL';
  late Dolar _dolar;
  String valorDolarCalculado = '';

  @override
  void initState() {
   getValorDolar();
    super.initState();
  }

  List<Widget> _coinCards = [
    CoinCard(
        key: UniqueKey(),
        coinNameMbtc: 'BTC',
        coinNameInternacional: 'bitcoin'),
    CoinCard(
        key: UniqueKey(),
        coinNameMbtc: 'ETH',
        coinNameInternacional: 'ethereum'),
    CoinCard(
        key: UniqueKey(),
        coinNameMbtc: 'LTC',
        coinNameInternacional: 'litecoin'),
    CoinCard(
        key: UniqueKey(),
        coinNameMbtc: 'XRP',
        coinNameInternacional: 'ripple',
    ),
  ];

  Future<void> getValorDolar() async {
    final response = await http.get(Uri.parse(urlApiDolar));

    if (response.statusCode == 200) {
      Dolar dataDolar = Dolar.fromJSON(jsonDecode(response.body));
      setState(() {
        _dolar = dataDolar;
        valorDolarCalculado = ((double.parse(_dolar.high) + double.parse(_dolar.low)) / 2).toStringAsFixed(2);
        loadingDolar = false;
      });
    }
  }

  Widget dolarCard(){

    String valorDolarFormatado = 'R\$ '+valorDolarCalculado;

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 5, 16, 5),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: InkWell(
        onTap: getValorDolar,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 600),
          child: loadingDolar
              ? Container(height: 55,child: Center(child: CircularProgressIndicator(color: Theme.of(context).accentColor,)))
              : ListTile(
                title: Text(
                  'Cotação do Dólar',
                ),
                trailing:Text(
                  valorDolarFormatado,style: TextStyle(fontSize: 16),
                ),
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Cotação MBTC + Internacional'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.settings_outlined,
                color: Theme.of(context)
                    .textTheme
                    .headline6!
                    .color!
                    .withOpacity(0.8),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => PgConfigs(),
                      fullscreenDialog: true,
                    ));
              }),
        ],
      ),
      body: ListView(physics: AlwaysScrollableScrollPhysics(), children: [
        GridView.count(
          shrinkWrap: true,
          primary: false,
          padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
          childAspectRatio: 0.84,
          crossAxisSpacing: 2,
          mainAxisSpacing: 5,
          crossAxisCount: 2,
          children: <Widget>[
            _coinCards[0],
            _coinCards[1],
            _coinCards[2],
            _coinCards[3],
          ],
        ),
        dolarCard(),
        const SizedBox(
          height: 20,
        )
      ]),
    );
  }
}
