import 'package:cotacao_mbtc_fschmtz/widgets/cryptoCard.dart';
import 'package:cotacao_mbtc_fschmtz/widgets/dolarEuroCard.dart';
import 'package:flutter/material.dart';

class PgValores extends StatefulWidget {

  Function() loadAnimationHome;

  PgValores({Key? key,required this.loadAnimationHome}) : super(key: key);

  @override
  _PgValoresState createState() => _PgValoresState();
}

class _PgValoresState extends State<PgValores> {

  Key keyBTC = UniqueKey();
  Key keyETH = UniqueKey();
  Key keyLTC = UniqueKey();
  Key keyXRP = UniqueKey();
  Key keyDolarEuro = UniqueKey();

  Future<void> refreshAll() async{
    //ATIVA ANIM DO REFRESH ALL
    widget.loadAnimationHome();

    setState(() {
      keyDolarEuro = UniqueKey();
      keyBTC = UniqueKey();
      keyETH = UniqueKey();
      keyLTC = UniqueKey();
      keyXRP = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: refreshAll,
        color: Theme.of(context).accentColor,
        child: ListView(physics: AlwaysScrollableScrollPhysics(), children: [
          DolarEuroCard(
            key: keyDolarEuro,
            loadAnimationHome: widget.loadAnimationHome,
          ),
          GridView.count(
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
            childAspectRatio: 0.85,
            crossAxisSpacing: 4,
            mainAxisSpacing: 6,
            crossAxisCount: 2,
            children: <Widget>[
              CryptoCard(
                  key: keyBTC,
                  coinNameMbtc: 'BTC',
                  coinNameInternacional: 'bitcoin'),
              CryptoCard(
                  key: keyETH,
                  coinNameMbtc: 'ETH',
                  coinNameInternacional: 'ethereum'),
              CryptoCard(
                  key: keyLTC,
                  coinNameMbtc: 'LTC',
                  coinNameInternacional: 'litecoin'),
              CryptoCard(
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
      );
  }
}
