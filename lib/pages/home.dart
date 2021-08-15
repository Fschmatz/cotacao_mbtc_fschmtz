import 'package:cotacao_mbtc_fschmtz/configs/pgConfigs.dart';
import 'package:cotacao_mbtc_fschmtz/pages/pgCarteira.dart';
import 'package:cotacao_mbtc_fschmtz/pages/pgValores.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //DOCS -> https://www.mercadobitcoin.com.br/api-doc/
  //INTERNACIONAL COIN STATS -> https://documenter.getpostman.com/view/5734027/RzZ6Hzr3?version=latest
  //DOLAR https://docs.awesomeapi.com.br/api-de-moedas

  int _currentIndex = 0;
  late List<Widget> _pageList;
  bool loadingHome = true;

  void loadAnimationHome() {
    setState(() {
      loadingHome = !loadingHome;
    });
  }

  @override
  void initState() {
    _pageList = [PgValores(loadAnimationHome: loadAnimationHome),PgCarteira(),PgConfigs()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    TextStyle styleFontNavBar =
    TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: Theme.of(context).accentColor);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Cotação MBTC + Internacional'),
       /* bottom: PreferredSize(
            preferredSize: Size(double.infinity, 3),
            child: loadingHome
                ? LinearProgressIndicator(
                    minHeight: 3,
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        Theme.of(context).accentColor.withOpacity(0.8)),
                    backgroundColor:
                        Theme.of(context).accentColor.withOpacity(0.3),
                  )
                : SizedBox(
                    height: 3,
                  )),*/
      ),
      body: _pageList[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor!,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
            child: GNav(
              rippleColor: Theme.of(context).accentColor.withOpacity(0.4),
              hoverColor: Theme.of(context).accentColor.withOpacity(0.4),
              color: Theme.of(context)
                  .textTheme
                  .headline6!
                  .color!
                  .withOpacity(0.8),
              gap: 5,
              activeColor: Theme.of(context).accentColor,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              duration: Duration(milliseconds: 500),
              tabBackgroundColor:
              Theme.of(context).accentColor.withOpacity(0.3),
              backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor!,
              tabs: [
                GButton(
                  icon: Icons.bar_chart_outlined,
                  text: 'Valores',
                  textStyle: styleFontNavBar,
                ),
                GButton(
                  icon: Icons.payment_outlined,
                  text: 'Carteira',
                  textStyle: styleFontNavBar,
                ),
                GButton(
                  icon: Icons.settings_outlined,
                  text: 'Configurações',
                  textStyle: styleFontNavBar,
                ),
              ],
              selectedIndex: _currentIndex,
              onTabChange: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
