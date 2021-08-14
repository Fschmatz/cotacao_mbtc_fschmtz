import 'package:cotacao_mbtc_fschmtz/class/cryptoInternacional.dart';
import 'package:cotacao_mbtc_fschmtz/class/cryptoMBTC.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class CryptoCard extends StatefulWidget {
  String coinNameMbtc;
  String coinNameInternacional;

  CryptoCard(
      {Key? key,
      required this.coinNameMbtc,
      required this.coinNameInternacional})
      : super(key: key);

  @override
  _CryptoCardState createState() => _CryptoCardState();
}

class _CryptoCardState extends State<CryptoCard> {

  late CryptoMBTC coinMbtc;
  late CryptoInternacional coinInternacional;
  String urlCoinApiMbtc = '';
  String urlCoinApiInternacional = '';
  bool loading = true;
  TextStyle valuesStyle = TextStyle(fontSize: 16);
  String horaFormatada = ' ';
  NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
  Icon iconSetaDefault = Icon(Icons.circle,color: Colors.transparent,size: 18,);
  Icon iconSetaUp = Icon(Icons.arrow_upward_outlined,color: Colors.green,size: 18,);
  Icon iconSetaDown = Icon(Icons.arrow_downward_outlined,color: Colors.red,size: 18,);

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
      CryptoMBTC dataMbtc = CryptoMBTC.fromJSON(jsonDecode(responseMbtc.body));
      setState(() {

        if(checkParaCor) {
          if (double.parse(coinMbtc.last) < double.parse(dataMbtc.last)) {
            iconSetaDefault = iconSetaUp;
          }
          else if (double.parse(coinMbtc.last) > double.parse(dataMbtc.last)) {
            iconSetaDefault = iconSetaDown;
          }
        }
        coinMbtc = dataMbtc;
      });
    }
    if (responseInternacional.statusCode == 200) {
      doneInternacional = true;
      CryptoInternacional dataInternacional =
          CryptoInternacional.fromJSON(jsonDecode(responseInternacional.body));
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
                            padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                            child: iconSetaDefault,
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
                       /* Visibility(
                          visible: widget.coinNameMbtc == 'ETH' ||  widget.coinNameMbtc == 'XRP',
                          child: ListTile(
                            leading: Icon(Icons.account_balance_wallet_outlined,size: 20,),
                            trailing: Text(
                              getFormattedValueInternacional(),
                              style: valuesStyle,
                            ),
                          ),
                        ),*/
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
