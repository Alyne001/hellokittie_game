import 'package:flutter/material.dart';

class CardBattleScreen extends StatelessWidget {
  const CardBattleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cartas 💖"),
        backgroundColor: Colors.pink,
      ),
      body: const Center(
        child: Text(
          "Jogo de cartas aqui 🎴",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}