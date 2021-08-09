import 'package:cotacao_mbtc_fschmtz/class/coinInternacional.dart';
import 'package:cotacao_mbtc_fschmtz/class/coinMBTC.dart';
import 'package:cotacao_mbtc_fschmtz/class/dolar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class DolarCard extends StatefulWidget {

  Function() stopLoadHome;
  DolarCard({Key? key,required this.stopLoadHome}) : super(key: key);

  @override
  _DolarCardState createState() => _DolarCardState();
}

class _DolarCardState extends State<DolarCard> {

  bool loading = true;
  String horaFormatada = ' ';
  late Dolar _dolar;
  String valorDolarCalculado = ' ';
  String urlApiDolar = 'https://economia.awesomeapi.com.br/last/USD-BRL';
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

    return formatDate +'  '+ (DateFormat.Hm().format(now));

  }

  Future<void> getValorDolar() async {
    final response = await http.get(Uri.parse(urlApiDolar));

    if (response.statusCode == 200) {
      Dolar dataDolar = Dolar.fromJSON(jsonDecode(response.body));
      setState(() {
        _dolar = dataDolar;

        valorDolarCalculado =
            ((double.parse(_dolar.high) + double.parse(_dolar.low)) / 2)
                .toStringAsFixed(2);
        loading = false;
      });
    }
    widget.stopLoadHome();
  }

  String getFormattedValueDolar() {
    return (formatter.format(double.parse(valorDolarCalculado)));
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
          height: 100,
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
                          getFormattedValueDolar(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ListTile(
                      visualDensity: VisualDensity.compact,
                      dense: true,
                      trailing: Text(
                        getHoraFormatada(),
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
        ),
      ),
    );
  }
}
