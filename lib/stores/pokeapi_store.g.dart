// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokeapi_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PokeApiStore on _PokeApiStoreBase, Store {
  Computed<PokeAPI> _$pokeAPIComputed;

  @override
  PokeAPI get pokeAPI =>
      (_$pokeAPIComputed ??= Computed<PokeAPI>(() => super.pokeAPI,
              name: '_PokeApiStoreBase.pokeAPI'))
          .value;
  Computed<Pokemon> _$currentPokemonComputed;

  @override
  Pokemon get currentPokemon => (_$currentPokemonComputed ??= Computed<Pokemon>(
          () => super.currentPokemon,
          name: '_PokeApiStoreBase.currentPokemon'))
      .value;

  final _$_pokeAPIAtom = Atom(name: '_PokeApiStoreBase._pokeAPI');

  @override
  PokeAPI get _pokeAPI {
    _$_pokeAPIAtom.reportRead();
    return super._pokeAPI;
  }

  @override
  set _pokeAPI(PokeAPI value) {
    _$_pokeAPIAtom.reportWrite(value, super._pokeAPI, () {
      super._pokeAPI = value;
    });
  }

  final _$_currentPokemonAtom = Atom(name: '_PokeApiStoreBase._currentPokemon');

  @override
  Pokemon get _currentPokemon {
    _$_currentPokemonAtom.reportRead();
    return super._currentPokemon;
  }

  @override
  set _currentPokemon(Pokemon value) {
    _$_currentPokemonAtom.reportWrite(value, super._currentPokemon, () {
      super._currentPokemon = value;
    });
  }

  final _$currentPokemonColorAtom =
      Atom(name: '_PokeApiStoreBase.currentPokemonColor');

  @override
  Color get currentPokemonColor {
    _$currentPokemonColorAtom.reportRead();
    return super.currentPokemonColor;
  }

  @override
  set currentPokemonColor(Color value) {
    _$currentPokemonColorAtom.reportWrite(value, super.currentPokemonColor, () {
      super.currentPokemonColor = value;
    });
  }

  final _$currentPokemonIndexAtom =
      Atom(name: '_PokeApiStoreBase.currentPokemonIndex');

  @override
  int get currentPokemonIndex {
    _$currentPokemonIndexAtom.reportRead();
    return super.currentPokemonIndex;
  }

  @override
  set currentPokemonIndex(int value) {
    _$currentPokemonIndexAtom.reportWrite(value, super.currentPokemonIndex, () {
      super.currentPokemonIndex = value;
    });
  }

  final _$_PokeApiStoreBaseActionController =
      ActionController(name: '_PokeApiStoreBase');

  @override
  dynamic fetchPokemonList() {
    final _$actionInfo = _$_PokeApiStoreBaseActionController.startAction(
        name: '_PokeApiStoreBase.fetchPokemonList');
    try {
      return super.fetchPokemonList();
    } finally {
      _$_PokeApiStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPokemonAtual({int index}) {
    final _$actionInfo = _$_PokeApiStoreBaseActionController.startAction(
        name: '_PokeApiStoreBase.setPokemonAtual');
    try {
      return super.setPokemonAtual(index: index);
    } finally {
      _$_PokeApiStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Widget getImage({String num}) {
    final _$actionInfo = _$_PokeApiStoreBaseActionController.startAction(
        name: '_PokeApiStoreBase.getImage');
    try {
      return super.getImage(num: num);
    } finally {
      _$_PokeApiStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentPokemonColor: ${currentPokemonColor},
currentPokemonIndex: ${currentPokemonIndex},
pokeAPI: ${pokeAPI},
currentPokemon: ${currentPokemon}
    ''';
  }
}
