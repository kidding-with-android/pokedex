import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';

import '../../stores/pokeapi_store.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  PokeApiStore _pokeApiStore;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pokeApiStore = GetIt.instance<PokeApiStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Observer(builder: (context) {
            return TabBar(
              controller: _tabController,
              labelStyle: TextStyle(fontWeight: FontWeight.w700),
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: _pokeApiStore.corPokemon,
              unselectedLabelColor: Color(0xff5f6368),
              isScrollable: true,
              indicator: MD2Indicator(
                indicatorHeight: 3,
                indicatorColor: _pokeApiStore.corPokemon,
                indicatorSize: MD2IndicatorSize.normal,
              ),
              tabs: <Widget>[
                Tab(
                  text: "Sobre",
                ),
                Tab(
                  text: "Evolução",
                ),
                Tab(
                  text: "Status",
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}