import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';
import 'package:pokedex/consts/consts_api.dart';
import 'package:pokedex/consts/consts_app.dart';
import 'package:pokedex/models/pokeapi.dart';
part 'pokeapi_store.g.dart';

class PokeApiStore = _PokeApiStoreBase with _$PokeApiStore;

abstract class _PokeApiStoreBase with Store {
  @observable
  PokeAPI _pokeAPI;

  @observable
  Pokemon _currentPokemon;

  @observable
  Color currentPokemonColor;

  @observable
  int currentPokemonIndex;

  @computed
  PokeAPI get pokeAPI => _pokeAPI;

  @computed
  Pokemon get currentPokemon => _currentPokemon;

  @action
  fetchPokemonList() {
    loadPokeAPI().then((pokeList) => {_pokeAPI = pokeList});
  }

  Pokemon getPokemon({int index}) {
    return _pokeAPI.pokemon[index];
  }

  @action
  setPokemonAtual({int index}) {
    _currentPokemon = _pokeAPI.pokemon[index];
    currentPokemonColor = ConstsApp.getColorType(type: _currentPokemon.type[0]);
    currentPokemonIndex = index;
  }

  @action
  Widget getImage({String num}) {
    return CachedNetworkImage(
      placeholder: (context, url) => new Container(
        color: Colors.transparent,
      ),
      imageUrl:
          'https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/$num.png',
    );
  }

  Future<PokeAPI> loadPokeAPI() async {
    try {
      final response = await http.get(ConstsAPI.pokeapiURL);
      var decodeJson = jsonDecode(response.body);
      return PokeAPI.fromJson(decodeJson);
    } catch (error, stacktrace) {
      print("Erro ao carregar lista" + stacktrace.toString());
      return null;
    }
  }
}
