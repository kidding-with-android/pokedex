import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/models/pokeapiv2.dart';
import 'package:pokedex/stores/pokeapiv2_store.dart';

class AbaStatus extends StatelessWidget {
  final PokeApiV2Store _pokeApiV2Store = GetIt.instance<PokeApiV2Store>();

  List<int> getStatusPokemon(PokeApiV2 pokeApiV2) {
    List<int> _list = [0, 0, 0, 0, 0, 0, 0];
    int sum = 0;

    pokeApiV2.stats.forEach((stat) {
      switch (stat.stat.name) {
        case 'speed':
          _list[0] = stat.baseStat;
          break;
        case 'special-defense':
          _list[1] = stat.baseStat;
          break;
        case 'special-attack':
          _list[2] = stat.baseStat;
          break;
        case 'defense':
          _list[3] = stat.baseStat;
          break;
        case 'attack':
          _list[4] = stat.baseStat;
          break;
        case 'hp':
          _list[5] = stat.baseStat;
          break;
      }
      sum += stat.baseStat;
    });
    _list[6] = sum;

    return _list;
  }

  Widget _statusBar({double widthFactor}) {
    return SizedBox(
      height: 16,
      child: Center(
        child: Container(
          height: 4,
          alignment: Alignment.centerLeft,
          decoration: ShapeDecoration(
            shape: StadiumBorder(),
            color: Colors.grey,
          ),
          child: FractionallySizedBox(
            widthFactor: widthFactor,
            heightFactor: 1.0,
            child: Container(
              decoration: ShapeDecoration(
                shape: StadiumBorder(),
                color: widthFactor > 0.5 ? Colors.teal : Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }

  TableRow _statusRow({String name, int value, int maxValue}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            name,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Center(
            child: Text(
              value.toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: _statusBar(widthFactor: value / maxValue),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Container(
          child: Observer(builder: (context) {
            List<int> _list = getStatusPokemon(_pokeApiV2Store.pokeApiV2);
            return Table(
              columnWidths: {0: FractionColumnWidth(.2), 1: FractionColumnWidth(.2), 2: FractionColumnWidth(.6)},
              children: [
                _statusRow(name: 'Velocidade', value: _list[0], maxValue: 160),
                _statusRow(name: 'Sp. Def', value: _list[1], maxValue: 160),
                _statusRow(name: 'Sp. Atq', value: _list[2], maxValue: 160),
                _statusRow(name: 'Defesa', value: _list[3], maxValue: 160),
                _statusRow(name: 'Ataque', value: _list[4], maxValue: 160),
                _statusRow(name: 'HP', value: _list[5], maxValue: 160),
                _statusRow(name: 'Total', value: _list[6], maxValue: 700),
              ],
            );
          }),
        ),
      ),
    );
  }
}
