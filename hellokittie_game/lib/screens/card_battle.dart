import 'dart:math';

import 'package:flutter/material.dart';
import '../data/datacards.dart';
import '../models/carta.dart';
import 'battle_screen.dart';

class CardBattleScreen extends StatefulWidget {
  const CardBattleScreen({super.key});

  @override
  State<CardBattleScreen> createState() => _CardBattleScreenState();
}

class _CardBattleScreenState extends State<CardBattleScreen> {
  bool pressionado = false;

  List<Carta> gerarBaralho() {
    final baralho = List<Carta>.from(todasCartas);

    baralho.shuffle(Random());

    return baralho;
  }

  Future<void> _duelar() async {
    setState(() {
      pressionado = true;
    });

    await Future.delayed(const Duration(milliseconds: 120));

    setState(() {
      pressionado = false;
    });

    final baralho = gerarBaralho();

    final maoJogador = [
      baralho.removeLast(),
      baralho.removeLast(),
      baralho.removeLast(),
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BattleScreen(maoJogador: maoJogador, baralho: baralho),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/CabanaDeBatalha.png",
              fit: BoxFit.cover,
            ),
          ),

          Align(
            alignment: const Alignment(0, 0.78),
            child: GestureDetector(
              onTap: _duelar,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 80),
                child: Image.asset(
                  pressionado
                      ? "assets/images/BotãoDeDuelo_clicado.png"
                      : "assets/images/BotãoDeDuelo.png",
                  key: ValueKey(pressionado),
                  width: 220,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
