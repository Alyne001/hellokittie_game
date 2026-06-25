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

  // Guarda o índice da roupa atual (0 = Padrão, 1 = Roupa 1)
  int roupaAtual = 0; 

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    // Precache automático na memória das roupas 0 e 1 para evitar travamentos
    for (int r = 0; r <= 1; r++) {
      for (var frame in obterWalkRightFrames(r)) {
        precacheImage(AssetImage(frame), context);
      }
      for (var frame in obterWalkLeftFrames(r)) {
        precacheImage(AssetImage(frame), context);
      }
    }
  }

  String currentFrame = 'assets/images/fra1esquerda.png';
  bool andando = false;
  int frameIndex = 0;
  bool olhandoDireita = true;

  // 🎀 FUNÇÃO DOS FRAMES DIREITA: Mapeia perfeitamente sua nomenclatura
  List<String> obterWalkRightFrames(int roupaId) {
    if (roupaId == 1) {
      // Roupa 1: busca fra1.1direita.png até fra1.8direita.png (8 frames)
      return List.generate(8, (i) => 'assets/images/fra1.${i + 1}direita.png');
    } else {
      // Roupa padrão (0) ou qualquer outra não implementada: fra1 até fra7 (7 frames)
      return List.generate(7, (i) => 'assets/images/fra${i + 1}direita.png');
    }
  }

  // 🎀 FUNÇÃO DOS FRAMES ESQUERDA: Mapeia perfeitamente sua nomenclatura
  List<String> obterWalkLeftFrames(int roupaId) {
    if (roupaId == 1) {
      // Roupa 1: busca fra1.1esquerda.png até fra1.8esquerda.png (8 frames)
      return List.generate(8, (i) => 'assets/images/fra1.${i + 1}esquerda.png');
    } else {
      // Roupa padrão (0) ou qualquer outra não implementada: fra1 até fra7 (7 frames)
      return List.generate(7, (i) => 'assets/images/fra${i + 1}esquerda.png');
    }
  }

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

  void iniciarAnimacao() {
    if (andando) return; 
    andando = true;
    
    Future.microtask(() async {
      while (andando) {
        List<String> frames = olhandoDireita ? obterWalkRightFrames(roupaAtual) : obterWalkLeftFrames(roupaAtual);
        if (!mounted) return;
        
        // Evita que o index estoure caso mude de uma lista de 8 frames para uma de 7
        if (frameIndex >= frames.length) {
          frameIndex = 0;
        }

        setState(() {
          currentFrame = frames[frameIndex];
        });
        
        frameIndex = (frameIndex + 1) % frames.length;
        await Future.delayed(const Duration(milliseconds: 90));
      }
    });
  }

  void pararAnimacao() {
    andando = false;
    frameIndex = 0;
    if (mounted) {
      setState(() {
        // Para a animação exibindo o primeiro frame correto da roupa selecionada
        currentFrame = olhandoDireita 
            ? obterWalkRightFrames(roupaAtual).first 
            : obterWalkLeftFrames(roupaAtual).first;
      });
    }
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
    olhandoDireita = alvo > atual;

    iniciarAnimacao();

    for (int i = atual; i != alvo; i += passo) {
      Offset proximoPonto = trilha[i + passo];
      
      animation = Tween<Offset>(
        begin: playerPosition,
        end: proximoPonto,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ));

      await controller.forward(from: 0);
    }

    pararAnimacao();
  }

  Future<void> irParaCasa(Offset destino, String rota, List<Offset> trilha) async {
    await moverPelaTrilha(destino, trilha);
    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 300));
    
    final roupaRetornada = await Navigator.push(
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

    // 🔥 ATUALIZAÇÃO: Quando o closet fecha, força o mapa a atualizar o frame imediatamente
    if (roupaRetornada != null && mounted) {
      setState(() {
        roupaAtual = roupaRetornada;
        frameIndex = 0; 
        
        List<String> frames = olhandoDireita ? obterWalkRightFrames(roupaAtual) : obterWalkLeftFrames(roupaAtual);
        currentFrame = frames.first; 
      });
      print("Sucesso! Roupa ID: $roupaAtual carregada. Frame inicial configurado para: $currentFrame");
    }
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
            casaCartas.dx + 20,  
            casaCartas.dy + 140, 
          );

          final portaVestiario = Offset(
            casaVestiario.dx + 10, 
            casaVestiario.dy + 140,  
          );

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
                      SizedBox.expand(
                        child: Image.asset(
                          'assets/images/mapa_teste_game_HK.png',
                          fit: BoxFit.fill, 
                        ),
                      ),
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