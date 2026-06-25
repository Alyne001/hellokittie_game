import 'package:flutter/material.dart';
import '../models/carta.dart';

class BattleScreen extends StatefulWidget {
  final List<Carta> maoJogador;
  final List<Carta> baralho;

  const BattleScreen({
    super.key,
    required this.maoJogador,
    required this.baralho,
  });

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  late List<Carta> maoJogador;
  late List<Carta> baralho;

  @override
  void initState() {
    super.initState();

    maoJogador = List.from(widget.maoJogador);
    baralho = List.from(widget.baralho);
  }

  void comprarCarta() {
    if (baralho.isEmpty) return;

    setState(() {
      maoJogador.add(baralho.removeLast());
    });
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

          Column(
            children: [
              const SizedBox(height: 60),

              const Text(
                "BATALHA INICIADA!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const Spacer(),

              // Baralho
              GestureDetector(
                onTap: comprarCarta,
                child: Image.asset("assets/cards/VersoCarta.png", width: 120),
              ),

              const SizedBox(height: 10),

              Text(
                "Baralho: ${baralho.length} cartas",
                style: const TextStyle(color: Colors.white),
              ),

              const SizedBox(height: 30),

              // Mão do jogador
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: maoJogador.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Image.asset(maoJogador[index].imagem, width: 120),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
