import 'package:cotacao_mbtc_fschmtz/class/cryptoInternacional.dart';
import 'package:cotacao_mbtc_fschmtz/class/cryptoMBTC.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class CarteiraCard extends StatefulWidget {
  List<String> coinNameMbtc;

  CarteiraCard(
      {Key? key,
        required this.coinNameMbtc})
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
    bool doneInternacional = false;

    final responseMbtc = await http.get(Uri.parse(urlCoinApiMbtc));
    final responseInternacional =
    await http.get(Uri.parse(urlCoinApiInternacional));
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

  String getFormattedValueMbtc() {
    return (formatter.format(double.parse(coinMbtc.last))).replaceAll('R\$', '');
  }

  String getFormattedValueInternacional() {
    return (formatter.format(double.parse(coinInternacional.value))).replaceAll('R\$', '');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
              title: Text('Carteira'.toUpperCase(),
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
                      getFormattedValueMbtc(),
                      style: valuesStyle,
                    ),
                  ),
                  ListTile(
                    title: Icon(Icons.account_balance_wallet_outlined),
                    trailing: Text(
                      getFormattedValueInternacional(),
                      style: valuesStyle,
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
