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

  // Guarda o índice da roupa atual que a Hello Kitty está vestindo
  int roupaAtual = 0; 

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

  // Se no futuro você tiver artes da Hello Kitty andando com roupas diferentes,
  // você poderá usar listas dinâmicas aqui baseadas na variável 'roupaAtual'.
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
      duration: const Duration(milliseconds: 200), // Tempo de transição entre cada ponto da trilha
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

  // 🔥 CORREÇÃO: Gerenciamento limpo do loop de animação dos frames
  void iniciarAnimacao() {
    if (andando) return; 
    andando = true;
    
    Future.microtask(() async {
      while (andando) {
        List<String> frames = olhandoDireita ? walkRightFrames : walkLeftFrames;
        if (!mounted) return;
        setState(() {
          currentFrame = frames[frameIndex];
        });
        frameIndex = (frameIndex + 1) % frames.length;
        await Future.delayed(const Duration(milliseconds: 90)); // Passos sincronizados com o movimento
      }
    });
  }

  void pararAnimacao() {
    andando = false;
    frameIndex = 0;
    if (mounted) {
      setState(() {
        currentFrame = olhandoDireita ? walkRightFrames.first : walkLeftFrames.first;
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

  // 🔥 CORREÇÃO: Movimentação contínua ponto a ponto sem trancos de renderização
  Future<void> moverPelaTrilha(Offset destino, List<Offset> trilha) async {
    int atual = pegarIndiceMaisProximo(playerPosition, trilha);
    int alvo = pegarIndiceMaisProximo(destino, trilha);
    if (atual == alvo) return;

    int passo = atual < alvo ? 1 : -1;
    olhandoDireita = alvo > atual; // Define o lado correto baseado na direção geral

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

      await controller.forward(from: 0); // Avança de forma suave até o próximo ponto
    }

    pararAnimacao();
  }

  Future<void> irParaCasa(Offset destino, String rota, List<Offset> trilha) async {
    await moverPelaTrilha(destino, trilha);
    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 300));
    
    // 🔥 ATUALIZAÇÃO: Espera o retorno do ID da roupa vinda do Closet
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

    // Se o usuário salvou uma roupa no closet, atualiza o mapa
    if (roupaRetornada != null && mounted) {
      setState(() {
        roupaAtual = roupaRetornada;
        // Dica: Quando tiver as imagens da HK com roupa no mapa, 
        // você pode atualizar as listas de frames aqui baseado no ID recebido.
        print("Hello Kitty trocou de visual no mapa! Nova roupa ID: $roupaAtual");
      });
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
                      // IMAGEM DE FUNDO DO MAPA
                      SizedBox.expand(
                        child: Image.asset(
                          'assets/images/mapa_teste_game_HK.png',
                          fit: BoxFit.fill, 
                        ),
                      ),

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