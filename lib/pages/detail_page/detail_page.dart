import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/consts/consts_app.dart';
import 'package:pokedex/models/pokeapi.dart';
import 'package:pokedex/pages/about_page/about_page.dart';
import 'package:pokedex/stores/pokeapi_store.dart';
import 'package:pokedex/stores/pokeapiv2_store.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class DetailPage extends StatefulWidget {
  final int index;

  DetailPage({Key key, this.index}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

enum AniProps { size, color, rotation }

class _DetailPageState extends State<DetailPage> {
  PageController _pageController;
  PokeApiStore _pokeApiStore;
  PokeApiV2Store _pokeApiV2Store;
  MultiTween<AniProps> _animation;
  double _progress;
  double _multiple;
  double _opacity;
  double _opacityTitleAppBar;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: widget.index, viewportFraction: 0.5);
    _pokeApiStore = GetIt.instance<PokeApiStore>();
    _pokeApiV2Store = GetIt.instance<PokeApiV2Store>();

    _pokeApiV2Store.getInfoPokemon(_pokeApiStore.currentPokemon.name);
    _pokeApiV2Store.getInfoSpecie(_pokeApiStore.currentPokemon.id.toString());

    _animation = MultiTween<AniProps>()
      ..add(AniProps.rotation, 0.0.tweenTo(1.0), 4.seconds, Curves.linear);

    _progress = 0;
    _multiple = 1;
    _opacity = 1;
    _opacityTitleAppBar = 0;
  }

  double interval(double lower, double upper, double progress) {
    assert(lower < upper);

    if (progress > upper) return 1.0;
    if (progress < lower) return 0.0;

    return ((progress - lower) / (upper - lower)).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Observer(
            builder: (context) {
              return AnimatedContainer(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _pokeApiStore.currentPokemonColor.withOpacity(0.7),
                      _pokeApiStore.currentPokemonColor
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    AppBar(
                      centerTitle: true,
                      title: Opacity(
                        opacity: _opacityTitleAppBar,
                        child: Text(
                          _pokeApiStore.currentPokemon.name,
                          style: TextStyle(
                            fontFamily: 'Google',
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      actions: [
                        IconButton(
                          icon: Icon(Icons.favorite_border),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.12,
                      left: 20,
                      child: Text(
                        _pokeApiStore.currentPokemon.name,
                        style: TextStyle(
                          fontFamily: 'Google',
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.16,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              setTipos(_pokeApiStore.currentPokemon.type),
                              Text(
                                '#' +
                                    _pokeApiStore.currentPokemon.num.toString(),
                                style: TextStyle(
                                  fontFamily: 'Google',
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                duration: Duration(milliseconds: 300),
              );
            },
          ),
          SlidingSheet(
            listener: (state) {
              setState(() {
                _progress = state.progress;
                _multiple = 1 - interval(0.60, 0.90, _progress);
                _opacity = _multiple;
                _opacityTitleAppBar = interval(0.60, 0.90, _progress);
              });
            },
            elevation: 0,
            cornerRadius: 30,
            snapSpec: const SnapSpec(
                snap: true,
                snappings: [0.60, 0.90],
                positioning: SnapPositioning.relativeToAvailableSpace),
            builder: (context, state) {
              return Container(
                height: MediaQuery.of(context).size.height -
                    (MediaQuery.of(context).size.height * 0.12),
                child: AboutPage(),
              );
            },
          ),
          Opacity(
            opacity: _opacity,
            child: Padding(
              child: SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    _pokeApiStore.setPokemonAtual(index: index);
                    _pokeApiV2Store
                        .getInfoPokemon(_pokeApiStore.currentPokemon.name);
                    _pokeApiV2Store.getInfoSpecie(
                        _pokeApiStore.currentPokemon.id.toString());
                  },
                  itemCount: _pokeApiStore.pokeAPI.pokemon.length,
                  itemBuilder: (context, index) {
                    Pokemon _pokeitem = _pokeApiStore.getPokemon(index: index);

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        LoopAnimation<MultiTweenValues<AniProps>>(
                          builder: (context, child, value) {
                            return Transform.rotate(
                              angle: value.get(AniProps.rotation) * math.pi,
                              child: AnimatedOpacity(
                                child: Image.asset(
                                  ConstsApp.whitePokeball,
                                  height: 270,
                                  width: 270,
                                ),
                                opacity:
                                    index == _pokeApiStore.currentPokemonIndex
                                        ? 0.2
                                        : 0,
                                duration: Duration(milliseconds: 200),
                              ),
                            );
                          },
                          tween: _animation,
                          duration: _animation.duration,
                        ),
                        IgnorePointer(
                          child: Observer(
                            name: 'Pokemon',
                            builder: (context) {
                              return AnimatedPadding(
                                duration: Duration(milliseconds: 400),
                                curve: Curves.bounceInOut,
                                padding: EdgeInsets.all(
                                    index == _pokeApiStore.currentPokemonIndex
                                        ? 0
                                        : 60),
                                child: Hero(
                                  tag:
                                      index == _pokeApiStore.currentPokemonIndex
                                          ? _pokeitem.name
                                          : 'none' + index.toString(),
                                  child: CachedNetworkImage(
                                    height: 160,
                                    width: 160,
                                    placeholder: (context, url) =>
                                        new Container(
                                      color: Colors.transparent,
                                    ),
                                    color: index ==
                                            _pokeApiStore.currentPokemonIndex
                                        ? null
                                        : Colors.black.withOpacity(0.5),
                                    imageUrl:
                                        'https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/${_pokeitem.num}.png',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              padding: EdgeInsets.only(
                  top: _opacityTitleAppBar == 1
                      ? 1000
                      : ((MediaQuery.of(context).size.height * 0.25) -
                          _progress * 50)),
            ),
          )
        ],
      ),
    );
  }

  Widget setTipos(List<String> types) {
    List<Widget> lista = [];
    types.forEach((nome) {
      lista.add(Row(
        children: [
          Container(
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromARGB(80, 255, 255, 255),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                nome.trim(),
                style: TextStyle(
                  fontFamily: 'Google',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
        ],
      ));
    });

    return Row(
      children: lista,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
