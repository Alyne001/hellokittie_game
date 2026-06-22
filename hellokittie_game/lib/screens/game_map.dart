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

  final double mapAspectRatio = 2400 / 1080;

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

  String currentFrame = 'assets/images/fra1esquerda.png';
  bool andando = false;
  int frameIndex = 0;
  bool olhandoDireita = true;

  final List<String> walkRightFrames = [
    'assets/images/fra1direita.png',
    'assets/images/fra2direita.png',
    'assets/images/fra3direita.png',
    'assets/images/fra4direita.png',
    'assets/images/fra5direita.png',
    'assets/images/fra6direita.png',
    'assets/images/fra7direita.png',
  ];

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
      duration: const Duration(milliseconds: 200),
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

  Future<void> iniciarAnimacao() async {
    andando = true;
    while (andando) {
      List<String> frames = olhandoDireita ? walkRightFrames : walkLeftFrames;
      if (!mounted) return;
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

  void pararAnimacao() {
    andando = false;
    frameIndex = 0;
    setState(() {
      currentFrame = olhandoDireita ? walkRightFrames.first : walkLeftFrames.first;
    });
  }

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
    await controller.forward(from: 0);
  }

  int pegarIndiceMaisProximo(Offset pos, List<Offset> trilha) {
    int index = 0;
    if (trilha.isEmpty) return index;
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

  Future<void> moverPelaTrilha(Offset destino, List<Offset> trilha) async {
    int atual = pegarIndiceMaisProximo(playerPosition, trilha);
    int alvo = pegarIndiceMaisProximo(destino, trilha);
    if (atual == alvo) return;
    int passo = atual < alvo ? 1 : -1;
    for (int i = atual; i != alvo; i += passo) {
      await moverParaPonto(trilha[i + passo]);
    }
    pararAnimacao();
  }

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
    return Scaffold(
      backgroundColor: Colors.black, 
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;

          double mapWidth, mapHeight;

          if (screenWidth / screenHeight > mapAspectRatio) {
            mapHeight = screenHeight;
            mapWidth = screenHeight * mapAspectRatio;
          } else {
            mapWidth = screenWidth;
            mapHeight = screenWidth / mapAspectRatio;
          }

          double zoomFactor = 1.2; 
          mapWidth *= zoomFactor;
          mapHeight *= zoomFactor;

          final casaCartas = Offset(mapWidth * 0.34, mapHeight * 0.31); 
          final casaVestiario = Offset(mapWidth * 0.66, mapHeight * 0.31);

          final portaCartas = Offset(
            casaCartas.dx +20,  // Esquerda (-) / Direita (+)
            casaCartas.dy +140, // Cima (-) / Baixo (+)
          );

          final portaVestiario = Offset(
            casaVestiario.dx +10, // Esquerda (-) / Direita (+)
            casaVestiario.dy +140,  // Cima (-) / Baixo (+)
          );
          // ========================================================

          final double alturaTrilha = mapHeight * 0.74; 
          final List<Offset> trilha = [];

          for (double x = 0.05; x <= 0.95; x += 0.02) {
            trilha.add(Offset(mapWidth * x, alturaTrilha));
          }

          if (playerPosition == Offset.zero && trilha.isNotEmpty) {
            playerPosition = trilha[5];
          }

          return ClipRect(
            child: OverflowBox(
              alignment: Alignment.center, 
              maxWidth: mapWidth,
              maxHeight: mapHeight,
              child: SizedBox(
                width: mapWidth,
                height: mapHeight,
                child: GestureDetector(
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
      // IMAGEM DE FUNDO DO MAPA
      SizedBox.expand(
        child: Image.asset(
          'assets/images/mapa_teste_game_HK.png',
          fit: BoxFit.fill, 
        ),
      ),

      // 🌟 OS QUADRADINHOS VERMELHOS E OS QUADRADOS DE DEBUG FORAM REMOVIDOS DAQUI

      // PERSONAGEM (HELLO KITTY)
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
              filterQuality: FilterQuality.none, 
            ),
          ),
        ),
      ),
    ],
  ),
),
              ),
            ),
          );
        },
      ),
    );
  }
}