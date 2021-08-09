import 'dart:convert';
import 'package:cotacao_mbtc_fschmtz/class/dolar.dart';
import 'package:cotacao_mbtc_fschmtz/configs/pgConfigs.dart';
import 'package:cotacao_mbtc_fschmtz/widgets/coinCard.dart';
import 'package:cotacao_mbtc_fschmtz/widgets/dolarCard.dart';
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

  bool loadingHome = true;
  Key keyBTC = UniqueKey();
  Key keyETH = UniqueKey();
  Key keyLTC = UniqueKey();
  Key keyXRP = UniqueKey();

  void stopLoadHome() {
    setState(() {
      loadingHome = false;
    });
  }

  Future<void> refreshAll() async{
    setState(() {
      keyBTC = UniqueKey();
      keyETH = UniqueKey();
      keyLTC = UniqueKey();
      keyXRP = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Cotação MBTC + Internacional'),
        bottom: PreferredSize(
            preferredSize: Size(double.infinity, 3),
            child: loadingHome
                ? LinearProgressIndicator(
                    minHeight: 3,
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        Theme.of(context).accentColor.withOpacity(0.8)),
                    backgroundColor:
                        Theme.of(context).accentColor.withOpacity(0.3),
                  )
                : SizedBox(
                    height: 3,
                  )),
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
      body: RefreshIndicator(
        onRefresh: refreshAll,
        color: Theme.of(context).accentColor,
        child: ListView(physics: AlwaysScrollableScrollPhysics(), children: [
          DolarCard(
            stopLoadHome: stopLoadHome,
          ),
          GridView.count(
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
            childAspectRatio: 0.9,
            crossAxisSpacing: 4,
            mainAxisSpacing: 6,
            crossAxisCount: 2,
            children: <Widget>[
              CoinCard(
                  key: keyBTC,
                  coinNameMbtc: 'BTC',
                  coinNameInternacional: 'bitcoin'),
              CoinCard(
                  key: keyETH,
                  coinNameMbtc: 'ETH',
                  coinNameInternacional: 'ethereum'),
              CoinCard(
                  key: keyLTC,
                  coinNameMbtc: 'LTC',
                  coinNameInternacional: 'litecoin'),
              CoinCard(
                key: keyXRP,
                coinNameMbtc: 'XRP',
                coinNameInternacional: 'ripple',
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          )
        ]),
      ),
    );
  }
}
