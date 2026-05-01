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
  Offset targetPosition = Offset.zero;

  late AnimationController controller;
  late Animation<Offset> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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

  void movePlayer(Offset newPosition) {
    targetPosition = newPosition;

    animation = Tween<Offset>(
      begin: playerPosition,
      end: targetPosition,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    controller.forward(from: 0);
  }

  Offset pegarPontoMaisProximo(Offset click, List<Offset> trilha) {
    Offset maisProximo = trilha.first;
    double menorDistancia = (click - maisProximo).distance;

    for (var ponto in trilha) {
      double distancia = (click - ponto).distance;

      if (distancia < menorDistancia) {
        menorDistancia = distancia;
        maisProximo = ponto;
      }
    }

    return maisProximo;
  }

  // 🚀 navegação com animação
  void irParaCasa(Offset destino, String rota) {
    movePlayer(destino);

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;

      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;

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
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final casaCartas = Offset(size.width * 0.25, size.height * 0.3);
    final casaVestiario = Offset(size.width * 0.75, size.height * 0.3);

    final trilha = [
      Offset(size.width * 0.05, size.height * 0.85),
      Offset(size.width * 0.15, size.height * 0.82),
      Offset(size.width * 0.25, size.height * 0.80),
      Offset(size.width * 0.35, size.height * 0.78),
      Offset(size.width * 0.45, size.height * 0.78),
      Offset(size.width * 0.55, size.height * 0.78),
      Offset(size.width * 0.65, size.height * 0.80),
      Offset(size.width * 0.75, size.height * 0.82),
      Offset(size.width * 0.85, size.height * 0.85),
    ];

    if (playerPosition == Offset.zero) {
      playerPosition = trilha.first;
    }

    return Scaffold(
      body: GestureDetector(
        onTapDown: (details) {
          Offset click = details.localPosition;

          double distCartas = (click - casaCartas).distance;
          double distVestiario = (click - casaVestiario).distance;

          // ✅ AGORA RESPEITA A TRILHA
          if (distCartas < 120) {
            Offset destino = pegarPontoMaisProximo(casaCartas, trilha);
            irParaCasa(destino, '/cartas');
          } else if (distVestiario < 120) {
            Offset destino = pegarPontoMaisProximo(casaVestiario, trilha);
            irParaCasa(destino, '/vestiario');
          } else {
            Offset destino = pegarPontoMaisProximo(click, trilha);
            movePlayer(destino);
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
              left: casaCartas.dx - 10,
              top: casaCartas.dy - 10,
              child: Container(width: 20, height: 20, color: Colors.red),
            ),

            // 🔵 VESTIÁRIO
            Positioned(
              left: casaVestiario.dx - 10,
              top: casaVestiario.dy - 10,
              child: Container(width: 20, height: 20, color: Colors.blue),
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
              top: playerPosition.dy - 40,
              child: Image.asset(
                'assets/images/personagem_hellokitty.png',
                width: size.width * 0.06,
              ),
            ),
          ],
        ),
      ),
    );
  }
}