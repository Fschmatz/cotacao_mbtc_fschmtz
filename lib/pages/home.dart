import 'package:cotacao_mbtc_fschmtz/configs/settingsPage.dart';
import 'package:cotacao_mbtc_fschmtz/widgets/coinCard.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //DOCS -> https://www.mercadobitcoin.com.br/api-doc/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Cotação mBTC'),
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
                      builder: (BuildContext context) => SettingsPage(),
                      fullscreenDialog: true,
                    ));
              }),
        ],
      ),
      body: ListView(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          children: [
            GridView.count(
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
              childAspectRatio: 0.84,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                CoinCard(coinName: 'BTC'),
                CoinCard(coinName: 'ETH'),
                CoinCard(coinName: 'LTC'),
                CoinCard(coinName: 'XRP'),
              ],
            ),
            const SizedBox(
              height: 20,
            )
          ]),
    );
  }
}
