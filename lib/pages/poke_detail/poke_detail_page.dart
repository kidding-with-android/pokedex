import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/consts/consts_app.dart';
import 'package:pokedex/models/pokeapi.dart';
import 'package:pokedex/stores/pokeapi_store.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class PokeDetailPage extends StatefulWidget {
  final int index;

  PokeDetailPage({Key key, this.index}) : super(key: key);

  @override
  _PokeDetailPageState createState() => _PokeDetailPageState();
}

enum AniProps { size, color, rotation }

class _PokeDetailPageState extends State<PokeDetailPage> {
  PageController _pageController;
  PokeApiStore _pokeApiStore;
  Pokemon _pokemon;
  MultiTween<AniProps> _animation;
  double _progress;
  double _multiple;
  double _opacity;
  double _opacityTitleAppBar;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
    _pokeApiStore = GetIt.instance<PokeApiStore>();
    _pokemon = _pokeApiStore.pokemonAtual;

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Observer(builder: (context) {
          return AppBar(
            title: Opacity(
              opacity: _opacityTitleAppBar,
              child: Text(
                _pokemon.name,
                style: TextStyle(
                  fontFamily: 'Google',
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                ),
              ),
            ),
            elevation: 0,
            backgroundColor: _pokeApiStore.corPokemon,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Stack(
                alignment: Alignment.center,
                children: [
                  LoopAnimation<MultiTweenValues<AniProps>>(
                    builder: (context, child, value) {
                      return Transform.rotate(
                        angle: value.get(AniProps.rotation) * math.pi,
                        child: Opacity(
                          child: Image.asset(
                            ConstsApp.whitePokeball,
                            height: 50,
                            width: 50,
                          ),
                          opacity: _opacityTitleAppBar * 0.2,
                        ),
                      );
                    },
                    tween: _animation,
                    duration: _animation.duration,
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite_border),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          );
        }),
      ),
      // backgroundColor: _corPokemon,
      body: Stack(
        children: [
          Observer(
            builder: (context) {
              return Container(
                color: _pokeApiStore.corPokemon,
              );
            },
          ),
          Container(
            height: MediaQuery.of(context).size.height / 3,
          ),
          SlidingSheet(
            listener: (state) {
              setState(() {
                _progress = state.progress;
                _multiple = 1 - interval(0.0, 0.7, _progress);
                _opacity = _multiple;
                _opacityTitleAppBar =
                    _multiple = interval(0.55, 0.8, _progress);
              });
            },
            elevation: 0,
            cornerRadius: 30,
            snapSpec: const SnapSpec(
                snap: true,
                snappings: [0.7, 1.0],
                positioning: SnapPositioning.relativeToAvailableSpace),
            builder: (context, state) {
              return Container(
                height: MediaQuery.of(context).size.height,
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
                              child: Hero(
                                tag: _pokeitem.name + 'rotation',
                                child: Opacity(
                                  child: Image.asset(
                                    ConstsApp.whitePokeball,
                                    height: 270,
                                    width: 270,
                                  ),
                                  opacity: 0.2,
                                ),
                              ),
                            );
                          },
                          tween: _animation,
                          duration: _animation.duration,
                        ),
                        Observer(builder: (context) {
                          return AnimatedPadding(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.bounceInOut,
                            padding: EdgeInsets.all(
                                index == _pokeApiStore.posicaoAtual ? 0 : 60),
                            child: Hero(
                              tag: _pokeitem.name,
                              child: CachedNetworkImage(
                                height: 160,
                                width: 160,
                                placeholder: (context, url) => new Container(
                                  color: Colors.transparent,
                                ),
                                color: index == _pokeApiStore.posicaoAtual
                                    ? null
                                    : Colors.black.withOpacity(0.5),
                                imageUrl:
                                    'https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/${_pokeitem.num}.png',
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),
              padding: EdgeInsets.only(top: _opacityTitleAppBar == 1 ? 1000 : (60 - _progress * 50)),
            ),
          )
        ],
      ),
    );
  }
}
