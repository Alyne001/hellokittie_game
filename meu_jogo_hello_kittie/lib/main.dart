import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'components/hello_kitty.dart';

class KittyGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    final kitty = HelloKitty();
    add(kitty);
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: GameWidget(game: KittyGame()),
      ),
    ),
  );
}