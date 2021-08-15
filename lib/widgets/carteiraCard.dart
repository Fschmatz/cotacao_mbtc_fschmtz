import 'package:cotacao_mbtc_fschmtz/class/cryptoInternacional.dart';
import 'package:cotacao_mbtc_fschmtz/class/cryptoMBTC.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class CarteiraCard extends StatefulWidget {

  String coinNameMbtc;

  CarteiraCard(
      {Key? key,required this.coinNameMbtc})
      : super(key: key);

  @override
  _CarteiraCardState createState() => _CarteiraCardState();
}

class _CarteiraCardState extends State<CarteiraCard> {

  late CryptoMBTC coinMbtc;
  late CryptoInternacional coinInternacional;
  String urlCoinApiMbtc = '';
  String urlCoinApiInternacional = '';
  bool loading = true;
  TextStyle valuesStyle = TextStyle(fontSize: 16);
  String horaFormatada = ' ';
  NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');


  @override
  void initState() {
    urlCoinApiMbtc =
    'https://www.mercadobitcoin.net/api/${widget.coinNameMbtc}/ticker/';
    getCoinData(false);
    super.initState();
  }

  String getHoraFormatada(){
    return DateFormat.Hm().format(DateTime.now());
  }

  Future<void> getCoinData(bool checkParaCor) async {
    horaFormatada = getHoraFormatada();
    bool doneMbtc = false;

    final responseMbtc = await http.get(Uri.parse(urlCoinApiMbtc));

    if (responseMbtc.statusCode == 200) {
      doneMbtc = true;
      CryptoMBTC dataMbtc = CryptoMBTC.fromJSON(jsonDecode(responseMbtc.body));
      setState(() {
        coinMbtc = dataMbtc;
      });
    }
    if(doneMbtc){
      setState(() {
        loading = false;
      });
    }
  }

  //TEMPORARIO
  String getFormattedValueMbtcCalculado() {
    return (formatter.format(double.parse(coinMbtc.last))).replaceAll('R\$', '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      child: Card(
        margin: const EdgeInsets.fromLTRB(16, 10, 16, 6),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: InkWell(
          onTap: () => getCoinData(true),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Column(
            children: [
              ListTile(
                title: Text(widget.coinNameMbtc.toUpperCase(),
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
                        getFormattedValueMbtcCalculado(),
                        style: valuesStyle,
                      ),
                    ),
                    ListTile(
                      visualDensity: VisualDensity.compact,
                      dense: true,
                      trailing: Text(
                        getHoraFormatada(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context)
                              .textTheme
                              .headline6!
                              .color!
                              .withOpacity(0.5),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
