import 'package:flutter/material.dart';
import 'package:hellokittie_game/screens/card_battle.dart';
import 'package:hellokittie_game/screens/closet.dart';

class GameMap extends StatefulWidget {
  const GameMap({super.key});

  @override
  State<GameMap> createState() => _GameMapState();
}

class _GameMapState extends State<GameMap>
    with SingleTickerProviderStateMixin {

  Offset playerPosition = Offset.zero;

  late AnimationController controller;
  late Animation<Offset> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    animation.addListener(() {
      setState(() {
        playerPosition = animation.value;
      });
    });
  }

  // 🔹 move para um ponto (com await)
  Future<void> moverParaPonto(Offset ponto) async {
    animation = Tween<Offset>(
      begin: playerPosition,
      end: ponto,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    controller.forward(from: 0);

    await Future.delayed(const Duration(milliseconds: 300));
  }

  // 🔹 pega índice mais próximo
  int pegarIndiceMaisProximo(Offset pos, List<Offset> trilha) {
    int index = 0;
    double menorDist = (pos - trilha[0]).distance;

    for (int i = 0; i < trilha.length; i++) {
      double dist = (pos - trilha[i]).distance;

      if (dist < menorDist) {
        menorDist = dist;
        index = i;
      }
    }

    return index;
  }

  // 🔹 movimento pela trilha (PONTO A PONTO)
  Future<void> moverPelaTrilha(Offset destino, List<Offset> trilha) async {
    int atual = pegarIndiceMaisProximo(playerPosition, trilha);
    int alvo = pegarIndiceMaisProximo(destino, trilha);

    int passo = atual < alvo ? 1 : -1;

    for (int i = atual; i != alvo; i += passo) {
      await moverParaPonto(trilha[i + passo]);
    }
  }

  // 🔹 navegação
  Future<void> irParaCasa(Offset destino, String rota, List<Offset> trilha) async {
    await moverPelaTrilha(destino, trilha);

    if (!mounted) return;

    await Future.delayed(const Duration(milliseconds: 300));

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) {
          if (rota == '/cartas') {
            return const CardBattleScreen();
          } else {
            return const ClosetScreen();
          }
        },
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final casaCartas = Offset(size.width * 0.25, size.height * 0.3);
    final casaVestiario = Offset(size.width * 0.75, size.height * 0.3);

    final trilha = [
      Offset(size.width * 0.05, size.height * 0.70),
      Offset(size.width * 0.10, size.height * 0.70),
      Offset(size.width * 0.15, size.height * 0.70),
      Offset(size.width * 0.20, size.height * 0.70),
      Offset(size.width * 0.25, size.height * 0.70),
      Offset(size.width * 0.30, size.height * 0.70),
      Offset(size.width * 0.35, size.height * 0.70),
      Offset(size.width * 0.40, size.height * 0.70),
      Offset(size.width * 0.45, size.height * 0.70),
      Offset(size.width * 0.50, size.height * 0.70),
      Offset(size.width * 0.55, size.height * 0.70),
      Offset(size.width * 0.60, size.height * 0.70),
      Offset(size.width * 0.70, size.height * 0.70),
      Offset(size.width * 0.75, size.height * 0.70),
      Offset(size.width * 0.80, size.height * 0.70),
      Offset(size.width * 0.85, size.height * 0.70),
      Offset(size.width * 0.65, size.height * 0.70),
    ];

    if (playerPosition == Offset.zero) {
      playerPosition = trilha.first;
    }

    return Scaffold(
      body: GestureDetector(
        onTapDown: (details) async {
          Offset click = details.localPosition;

          double distCartas = (click - casaCartas).distance;
          double distVestiario = (click - casaVestiario).distance;

          if (distCartas <100) {
            Offset destino = casaCartas;
            await irParaCasa(destino, '/cartas', trilha);
          } else if (distVestiario <120) {
            Offset destino = casaVestiario;
            await irParaCasa(destino, '/vestiario', trilha);
          } else {
            Offset destino = click;
            await moverPelaTrilha(destino, trilha);
          }
        },
        child: Stack(
          children: [
            // 🗺️ MAPA
            SizedBox.expand(
              child: Image.asset(
                'assets/images/mapa_teste_game_HK.png',
                fit: BoxFit.cover,
              ),
            ),

            // 🔴 CASA CARTAS
            Positioned(
              left: casaCartas.dx -38,
              top: casaCartas.dy +78,
              child: Container(width: 30, height: 50, color: Colors.red),
            ),

            // 🔵 VESTIÁRIO
            Positioned(
              left: casaVestiario.dx +54,
              top: casaVestiario.dy +78,
              child: Container(width: 35, height: 50, color: Colors.blue),
            ),

            // 🟡 TRILHA
            ...trilha.map((p) => Positioned(
                  left: p.dx - 5,
                  top: p.dy - 5,
                  child: Container(width: 10, height: 10, color: Colors.yellow),
                )),

            // 🐱 PERSONAGEM
            Positioned(
              left: playerPosition.dx - 40,
              top: playerPosition.dy - 55,
              child: Image.asset(
                'assets/images/personagem_hellokitty.png',
                width: size.width * 0.12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}