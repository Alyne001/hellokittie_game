import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameMap(),
    );
  }
}

class GameMap extends StatefulWidget {
  const GameMap({super.key});

  @override
  State<GameMap> createState() => _GameMapState();
}

class _GameMapState extends State<GameMap>
    with SingleTickerProviderStateMixin {
  Offset playerPosition = const Offset(200, 350);
  Offset targetPosition = const Offset(200, 350);static

  late AnimationController controller;
  late Animation<Offset> animation;

  // 🏠 posições das casas (AJUSTADAS)
  final Offset casaCartas = const Offset(150, 300);
  final Offset casaVestiario = const Offset(150, 300);

  final double distanciaMinima = 100;

  bool podeEntrar = true;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    animation = Tween<Offset>(
      begin: playerPosition,
      end: targetPosition,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    animation.addListener(() {
      setState(() {
        playerPosition = animation.value;
      });

      verificarEntrada(context);
    });
  }

  // 🚶 MOVIMENTO LIMITADO AO CHÃO
  void movePlayer(Offset newPosition) {
    double minY = 500; // topo do chão
    double maxY = 700; // limite inferior

    double clampedY = newPosition.dy.clamp(minY, maxY);

    targetPosition = Offset(newPosition.dx, clampedY);

    animation = Tween<Offset>(
      begin: playerPosition,
      end: targetPosition,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    controller.forward(from: 0);
  }

  void verificarEntrada(BuildContext context) {
    double distanciaCartas = (playerPosition - casaCartas).distance;
    double distanciaVestiario =
        (playerPosition - casaVestiario).distance;

    if (distanciaCartas < distanciaMinima && podeEntrar) {
      podeEntrar = false;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const CardBattleScreen(),
        ),
      ).then((_) {
        podeEntrar = true;
      });
    }

    if (distanciaVestiario < distanciaMinima && podeEntrar) {
      podeEntrar = false;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ClosetScreen(),
        ),
      ).then((_) {
        podeEntrar = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTapDown: (details) {
          movePlayer(details.localPosition);
        },
        child: Stack(
          children: [
            // 🗺️ MAPA
            SizedBox.expand(
              child: Image.asset(
                'assets/images/mapa_teste_game_HK.png',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.none,
              ),
            ),

            // 🐱 PERSONAGEM
            Positioned(
              left: playerPosition.dx - 25,
              top: playerPosition.dy - 25,
              child: Image.asset(
                'assets/images/personagem_hellokitty.png',
                width: 50,
                height: 50,
                filterQuality: FilterQuality.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
// 🎴 TELA CASA DE CARTAS
//////////////////////////////////////////////////////////////

class CardBattleScreen extends StatelessWidget {
  const CardBattleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      appBar: AppBar(
        title: const Text("Batalha de Cartas 💖"),
        backgroundColor: Colors.pink,
      ),
      body: const Center(
        child: Text(
          "Aqui vai o jogo de cartas 🎴",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
// 👗 TELA VESTIÁRIO
//////////////////////////////////////////////////////////////

class ClosetScreen extends StatefulWidget {
  const ClosetScreen({super.key});

  @override
  State<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends State<ClosetScreen> {
  int selectedClothes = 0;

  final List<String> clothes = [
    'assets/images/roupa1.png',
    'assets/images/roupa2.png',
    'assets/images/roupa3.png',
    'assets/images/roupa4.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFC1E3),
      appBar: AppBar(
        title: const Text("Vestiário 💖"),
        backgroundColor: Colors.pink,
      ),
      body: Row(
        children: [
          // PERSONAGEM
          Expanded(
            flex: 2,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/personagem_base.png',
                    width: 150,
                    filterQuality: FilterQuality.none,
                  ),
                  Image.asset(
                    clothes[selectedClothes],
                    width: 150,
                    filterQuality: FilterQuality.none,
                  ),
                ],
              ),
            ),
          ),

          // ROUPAS
          Expanded(
            flex: 3,
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: clothes.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedClothes = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedClothes == index
                            ? Colors.pink
                            : Colors.white,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Image.asset(
                      clothes[index],
                      filterQuality: FilterQuality.none,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}