import 'package:flutter/material.dart';

class CardBattleScreen extends StatefulWidget {
  const CardBattleScreen({super.key});

  @override
  State<CardBattleScreen> createState() => _CardBattleScreenState();
}

class _CardBattleScreenState extends State<CardBattleScreen> {
  bool pressionado = false;

  Future<void> _duelar() async {
    setState(() {
      pressionado = true;
    });

    // Tempo da animação
    await Future.delayed(const Duration(milliseconds: 120));

    setState(() {
      pressionado = false;
    });

    print("Duelar clicado!");

    // Navegação futura
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (_) => BattleScreen()),
    // );
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
