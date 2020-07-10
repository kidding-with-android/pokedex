import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/models/pokeapi.dart';
import 'package:pokedex/stores/pokeapi_store.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class PokeDetailPage extends StatefulWidget {
  final int index;

  PokeDetailPage({Key key, this.index}) : super(key: key);

  @override
  _PokeDetailPageState createState() => _PokeDetailPageState();
}

class _PokeDetailPageState extends State<PokeDetailPage> {
  PageController _pageController;
  PokeApiStore _pokeApiStore;
  Pokemon _pokemon;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
    _pokeApiStore = GetIt.instance<PokeApiStore>();
    _pokemon = _pokeApiStore.pokemonAtual;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Observer(builder: (context) {
          return AppBar(
            title: Opacity(
              opacity: 0,
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
              IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: () {},
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
            elevation: 0,
            cornerRadius: 16,
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
          Padding(
            child: SizedBox(
              height: 150,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  _pokeApiStore.setPokemonAtual(index: index);
                },
                itemCount: _pokeApiStore.pokeAPI.pokemon.length,
                itemBuilder: (context, index) {
                  Pokemon _pokeitem = _pokeApiStore.getPokemon(index: index);

                  return CachedNetworkImage(
                    height: 60,
                    width: 60,
                    placeholder: (context, url) => new Container(
                      color: Colors.transparent,
                    ),
                    imageUrl:
                        'https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/${_pokeitem.num}.png',
                  );
                },
              ),
            ),
            padding: EdgeInsets.only(top: 50),
          )
        ],
      ),
    );
  }
}
