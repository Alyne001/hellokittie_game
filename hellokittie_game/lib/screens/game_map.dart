import 'package:flutter/material.dart';
import 'package:hellokittie_game/screens/card_battle.dart';
import 'package:hellokittie_game/screens/closet.dart';

class GameMap extends StatefulWidget {
  const GameMap({super.key});

  @override
  State<GameMap> createState() => _GameMapState();
}

class _GameMapState extends State<GameMap> with SingleTickerProviderStateMixin {
  Offset playerPosition = Offset.zero;

  late AnimationController controller;
  late Animation<Offset> animation;

    @override
    void didChangeDependencies() async {
    super.didChangeDependencies();

    for (var frame in walkRightFrames) {
      precacheImage(AssetImage(frame), context);
    }

    for (var frame in walkLeftFrames) {
     precacheImage(AssetImage(frame), context);
    }
  }

  // FRAME ATUAL
  String currentFrame = 'assets/images/fra1esquerda.png';

  bool andando = false;
  int frameIndex = 0;
  bool olhandoDireita = true;

  // FRAMES DIREITA
  final List<String> walkRightFrames = [
    'assets/images/fra1direita.png',
    'assets/images/fra2direita.png',
    'assets/images/fra3direita.png',
    'assets/images/fra4direita.png',
    'assets/images/fra5direita.png',
    'assets/images/fra6direita.png',
    'assets/images/fra7direita.png',
  ];

  // FRAMES ESQUERDA
  final List<String> walkLeftFrames = [
    'assets/images/fra1esquerda.png',
    'assets/images/fra2esquerda.png',
    'assets/images/fra3esquerda.png',
    'assets/images/fra4esquerda.png',
    'assets/images/fra5esquerda.png',
    'assets/images/fra6esquerda.png',
    'assets/images/fra7esquerda.png',
    
  ];

    @override
    void initState() {
     super.initState();

     controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ),
    );

    controller.addListener(() {
      setState(() {
       playerPosition = animation.value;
     });
   });
  }

  // ANIMAÇÃO DE ANDAR
  Future<void> iniciarAnimacao() async {
    andando = true;

    while (andando) {
      List<String> frames = olhandoDireita ? walkRightFrames : walkLeftFrames;

      setState(() {
        currentFrame = frames[frameIndex];
      });

      frameIndex++;

      if (frameIndex >= frames.length) {
        frameIndex = 0;
      }

      await Future.delayed(const Duration(milliseconds: 75));
    }
  }

  //parar animação
  void pararAnimacao() {
    andando = false;

    frameIndex = 0;

    setState(() {
      currentFrame = olhandoDireita
          ? walkRightFrames.first
          : walkLeftFrames.first;
    });
  }

  // MOVE PARA UM PONTO
    Future<void> moverParaPonto(Offset ponto) async {
  olhandoDireita = ponto.dx > playerPosition.dx;

  if (!andando) {
    iniciarAnimacao();
  }

  animation = Tween<Offset>(
    begin: playerPosition,
    end: ponto,
  ).animate(
    CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ),
  );

  controller.forward(from: 0);

  await controller.forward(from: 0);
}

    // PEGA ÍNDICE MAIS PRÓXIMO
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

    // MOVIMENTO PELA TRILHA
    Future<void> moverPelaTrilha(Offset destino, List<Offset> trilha) async {
      int atual = pegarIndiceMaisProximo(playerPosition, trilha);

      int alvo = pegarIndiceMaisProximo(destino, trilha);

      int passo = atual < alvo ? 1 : -1;

      for (int i = atual; i != alvo; i += passo) {
        await moverParaPonto(trilha[i + passo]);
      }

      pararAnimacao();
    }

    // NAVEGAÇÃO
    Future<void> irParaCasa(
      Offset destino,
      String rota,
      List<Offset> trilha,
    ) async {
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
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }

    @override
    void dispose() {
      controller.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      final size = MediaQuery.of(context).size;

      final casaCartas = Offset(size.width * 0.25, size.height * 0.3);

      final casaVestiario = Offset(size.width * 0.75, size.height * 0.3);

      final portaCartas = Offset(
        casaCartas.dx - 23,
        casaCartas.dy + 103,
      );

      final portaVestiario = Offset(
        casaVestiario.dx + 71.5,
        casaVestiario.dy + 103,
      );

      final trilha = [
        Offset(size.width * 0.05, size.height * 0.70),
        Offset(size.width * 0.075, size.height * 0.70),
        Offset(size.width * 0.10, size.height * 0.70),
        Offset(size.width * 0.125, size.height * 0.70),
        Offset(size.width * 0.15, size.height * 0.70),
        Offset(size.width * 0.175, size.height * 0.70),
        Offset(size.width * 0.20, size.height * 0.70),
        Offset(size.width * 0.225, size.height * 0.70),
        Offset(size.width * 0.25, size.height * 0.70),
        Offset(size.width * 0.275, size.height * 0.70),
        Offset(size.width * 0.30, size.height * 0.70),
        Offset(size.width * 0.325, size.height * 0.70),
        Offset(size.width * 0.35, size.height * 0.70),
        Offset(size.width * 0.375, size.height * 0.70),
        Offset(size.width * 0.40, size.height * 0.70),
        Offset(size.width * 0.425, size.height * 0.70),
        Offset(size.width * 0.45, size.height * 0.70),
        Offset(size.width * 0.475, size.height * 0.70),
        Offset(size.width * 0.50, size.height * 0.70),
        Offset(size.width * 0.525, size.height * 0.70),
        Offset(size.width * 0.55, size.height * 0.70),
        Offset(size.width * 0.575, size.height * 0.70),
        Offset(size.width * 0.60, size.height * 0.70),
        Offset(size.width * 0.625, size.height * 0.70),
        Offset(size.width * 0.65, size.height * 0.70),
        Offset(size.width * 0.675, size.height * 0.70),
        Offset(size.width * 0.70, size.height * 0.70),
        Offset(size.width * 0.725, size.height * 0.70),
        Offset(size.width * 0.75, size.height * 0.70),
        Offset(size.width * 0.775, size.height * 0.70),
        Offset(size.width * 0.80, size.height * 0.70),
        Offset(size.width * 0.825, size.height * 0.70),
        Offset(size.width * 0.85, size.height * 0.70),
      ];

      if (playerPosition == Offset.zero) {
        playerPosition = trilha.first;
      }

      return Scaffold(
        body: GestureDetector(
          onTapDown: (details) async {
            Offset click = details.localPosition;

            double distCartas = (click - portaCartas).distance;

            double distVestiario = (click - portaVestiario).distance;

            if (distCartas < 25) {
              Offset destino = casaCartas;

              await irParaCasa(destino, '/cartas', trilha);

            } else if (distVestiario < 25) {
              Offset destino = casaVestiario;

              await irParaCasa(destino, '/vestiario', trilha);
            } else {
              Offset destino = click;

              await moverPelaTrilha(destino, trilha);
            }
          },

          child: Stack(
            children: [
              // MAPA
              SizedBox.expand(
                child: Image.asset(
                  'assets/images/mapa_teste_game_HK.png',
                  fit: BoxFit.fill,
                ),
              ),

              // PERSONAGEM
              Positioned(
                left: playerPosition.dx - 40,
                top: playerPosition.dy - 55,

                child: SizedBox(
                  width: 90,
                  height: 90,

                  child: Center(
                    child: Image.asset(
                      currentFrame,
                      fit: BoxFit.contain,
                      filterQuality:
                          FilterQuality.none, // melhor para pixel art
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

