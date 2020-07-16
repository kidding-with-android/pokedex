import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/models/pokeapi.dart';
import 'package:pokedex/stores/pokeapi_store.dart';

class EvolutionTab extends StatelessWidget {
  final PokeApiStore _pokeApiStore = GetIt.instance<PokeApiStore>();

  Widget _resizePokemon({Widget child, double size = 80.0}) {
    return SizedBox(
      height: size,
      width: size,
      child: child,
    );
  }

  List<Widget> _getEvolution(Pokemon pokemon, Color cor) {
    List<Widget> _list = [];

    if (pokemon.prevEvolution != null) {
      pokemon.prevEvolution.forEach((evo) {
        _list.add(_resizePokemon(child: _pokeApiStore.getImage(num: evo.num)));
        _list.add(Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Text(
            evo.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
        _list.add(Icon(Icons.keyboard_arrow_down));
      });
    }

    _list.add(Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(90),
            color: cor.withOpacity(0.2)),
        child: _resizePokemon(
            child: _pokeApiStore.getImage(num: pokemon.num), size: 100.0)));
    _list.add(Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Text(
        pokemon.name,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));

    if (pokemon.nextEvolution != null) {
      pokemon.nextEvolution.forEach((evo) {
        _list.add(Icon(Icons.keyboard_arrow_down));
        _list.add(_resizePokemon(child: _pokeApiStore.getImage(num: evo.num)));
        _list.add(Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Text(
            evo.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
      });
    }

    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Container(
          child: Observer(builder: (context) {
            Pokemon pokemon = _pokeApiStore.currentPokemon;
            Color cor = _pokeApiStore.currentPokemonColor;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _getEvolution(pokemon, cor),
              ),
            );
          }),
        ),
      ),
    );
  }
}
