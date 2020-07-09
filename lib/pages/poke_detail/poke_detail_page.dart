import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/consts/consts_api.dart';
import 'package:pokedex/models/pokeapi.dart';
import 'package:pokedex/stores/pokeapi_store.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class PokeDetailPage extends StatelessWidget {
  final int index;

  Color _corPokemon;

  PokeDetailPage({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pokeApiStore = Provider.of<PokeApiStore>(context);
    Pokemon _pokemon = _pokeApiStore.getPokemon(index: index);

    _corPokemon = ConstsAPI.getColorType(type: _pokemon.type[0]);

    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: _corPokemon,
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
      backgroundColor: _corPokemon,
      body: Stack(
        children: [
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
