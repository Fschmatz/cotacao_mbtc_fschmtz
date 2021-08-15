import 'package:cotacao_mbtc_fschmtz/class/moedaInternacional.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class DolarEuroCard extends StatefulWidget {
  Function() loadAnimationHome;

  DolarEuroCard({Key? key, required this.loadAnimationHome}) : super(key: key);

  @override
  _DolarEuroCardState createState() => _DolarEuroCardState();
}

class _DolarEuroCardState extends State<DolarEuroCard> {
  bool loading = true;
  String horaFormatada = ' ';
  late MoedaInternacional _dolar;
  late MoedaInternacional _euro;
  String valorDolarCalculado = ' ';
  String valorEuroCalculado = ' ';
  String urlApiDolar = 'https://economia.awesomeapi.com.br/last/USD-BRL';
  String urlApiEuro = 'https://economia.awesomeapi.com.br/last/EUR-BRL';
  NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

  @override
  void initState() {
    getValorDolar();
    super.initState();
  }

  String getHoraFormatada() {
    DateTime now = DateTime.now();
    var outputFormat = DateFormat('dd/MM/yyyy');
    var formatDate = outputFormat.format(now);
    return formatDate + '  ' + (DateFormat.Hm().format(now));
  }

  Future<void> getValorDolar() async {
    final response = await http.get(Uri.parse(urlApiDolar));
    if (response.statusCode == 200) {
      MoedaInternacional dataDolar =
          MoedaInternacional.fromJSON(jsonDecode(response.body), 'USDBRL');
      setState(() {
        _dolar = dataDolar;
        valorDolarCalculado =
            ((double.parse(_dolar.high) + double.parse(_dolar.low)) / 2)
                .toStringAsFixed(2);
      });
    }
    getValorEuro();
  }

  Future<void> getValorEuro() async {
    final response = await http.get(Uri.parse(urlApiEuro));

    if (response.statusCode == 200) {
      MoedaInternacional dataEuro =
          MoedaInternacional.fromJSON(jsonDecode(response.body), 'EURBRL');
      setState(() {
        _euro = dataEuro;
        valorEuroCalculado =
            ((double.parse(_euro.high) + double.parse(_euro.low)) / 2)
                .toStringAsFixed(2);
        loading = false;
      });
    }
    widget.loadAnimationHome();
  }

  String getFormattedValueMoeda(String value) {
    return (formatter.format(double.parse(value)));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: InkWell(
        onTap: getValorDolar,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Container(
          height: 160,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 600),
            child: loading
                ? Center(child: SizedBox.shrink())
                : Column(
                    children: [
                      ListTile(
                        title: Text(
                          'Dólar'.toUpperCase(),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).accentColor),
                        ),
                        trailing: Text(
                          getFormattedValueMoeda(valorDolarCalculado),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Euro'.toUpperCase(),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).accentColor),
                        ),
                        trailing: Text(
                          getFormattedValueMoeda(valorEuroCalculado),
                          style: TextStyle(fontSize: 16),
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
        ),
      ),
    );
  }
}
