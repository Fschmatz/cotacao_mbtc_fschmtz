import 'package:cotacao_mbtc_fschmtz/configs/pgConfigs.dart';
import 'package:cotacao_mbtc_fschmtz/widgets/coinCard.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //DOCS -> https://www.mercadobitcoin.com.br/api-doc/
  //INTERNACIONAL COIN STATS -> https://documenter.getpostman.com/view/5734027/RzZ6Hzr3?version=latest

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
        key: UniqueKey(), coinNameMbtc: 'XRP', coinNameInternacional: 'ripple'),
  ];

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
        ListView.separated(
          separatorBuilder: (BuildContext context, int index) => const Divider(
            height: 0,
          ),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _coinCards.length,
          itemBuilder: (context, index) {
            return _coinCards[index];
          },
        ),
        const SizedBox(
          height: 20,
        )
      ]),
    );
  }
}
