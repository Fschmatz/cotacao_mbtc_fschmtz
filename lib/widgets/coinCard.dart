import 'package:cotacao_mbtc_fschmtz/class/coinInternacional.dart';
import 'package:cotacao_mbtc_fschmtz/class/coinMBTC.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class CoinCard extends StatefulWidget {
  String coinNameMbtc;
  String coinNameInternacional;

  CoinCard(
      {Key? key,
      required this.coinNameMbtc,
      required this.coinNameInternacional})
      : super(key: key);

  @override
  _CoinCardState createState() => _CoinCardState();
}

class _CoinCardState extends State<CoinCard> {

  late CoinMBTC coinMbtc;
  late CoinInternacional coinInternacional;
  String urlCoinApiMbtc = '';
  String urlCoinApiInternacional = '';
  bool loading = true;
  TextStyle valuesStyle = TextStyle(fontSize: 16);
  String horaFormatada = ' ';
  Color corMudancasValor = Colors.transparent;
  NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

  @override
  void initState() {
    urlCoinApiMbtc =
        'https://www.mercadobitcoin.net/api/${widget.coinNameMbtc}/ticker/';
    urlCoinApiInternacional =
        'https://api.coinstats.app/public/v1/coins/${widget.coinNameInternacional}?currency=USD';
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
      CoinMBTC dataMbtc = CoinMBTC.fromJSON(jsonDecode(responseMbtc.body));
      setState(() {

        if(checkParaCor) {
          if (double.parse(coinMbtc.last) < double.parse(dataMbtc.last)) {
            corMudancasValor = Colors.green;
          }
          else if (double.parse(coinMbtc.last) > double.parse(dataMbtc.last)) {
            corMudancasValor = Colors.red;
          }
        }
        coinMbtc = dataMbtc;
      });
    }
    if (responseInternacional.statusCode == 200) {
      doneInternacional = true;
      CoinInternacional dataInternacional =
          CoinInternacional.fromJSON(jsonDecode(responseInternacional.body));
      setState(() {
        coinInternacional = dataInternacional;
      });
    }
    if(doneMbtc && doneInternacional){
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
              title: Text(widget.coinNameMbtc,
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
                          title: Text(
                            'U\$',
                            style: valuesStyle,
                          ),
                          trailing: Text(
                            getFormattedValueInternacional(),
                            style: valuesStyle,
                          ),
                        ),
                        ListTile(
                          visualDensity: VisualDensity.compact,
                          leading: Padding(
                            padding: const EdgeInsets.fromLTRB(6, 8, 10, 5),
                            child: Icon(Icons.circle,size: 10,color: corMudancasValor),
                          ),
                          trailing: Text(
                            horaFormatada,
                            style: TextStyle(fontSize: 14,color: Theme.of(context)
                                .textTheme
                                .headline6!
                                .color!
                                .withOpacity(0.5),),
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
