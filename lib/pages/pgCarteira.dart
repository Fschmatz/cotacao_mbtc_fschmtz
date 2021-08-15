import 'package:cotacao_mbtc_fschmtz/widgets/carteiraCard.dart';
import 'package:flutter/material.dart';

class PgCarteira extends StatefulWidget {
  @override
  _PgCarteiraState createState() => _PgCarteiraState();
}

class _PgCarteiraState extends State<PgCarteira> {

  List<String> listCarteira = ['ETH','XRP'];
  Key keyETH = UniqueKey();
  Key keyXRP = UniqueKey();

  Future<void> refreshAll() async{
    setState(() {
      keyETH = UniqueKey();
      keyXRP = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshAll,
      color: Theme.of(context).accentColor,
      child: ListView(physics: AlwaysScrollableScrollPhysics(), children: [
        CarteiraCard(key: keyETH,coinNameMbtc: listCarteira[0],),
        CarteiraCard(key: keyXRP,coinNameMbtc: listCarteira[1],),
        const SizedBox(
          height: 20,
        )
      ]),
    );
  }
}
