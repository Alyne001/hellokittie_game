import 'package:flutter/material.dart';
import 'package:hellokittie_game/screens/game_map.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  late Animation<double> buttonAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    buttonAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void abrirConfiguracoes() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Configurações"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Som"),
                  Switch(value: true, onChanged: (value) {}),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌄 FUNDO ANIMADO
          AnimatedBuilder(
            animation: scaleAnimation,
            builder: (context, child) {
              return Transform.scale(scale: scaleAnimation.value, child: child);
            },
            child: Image.asset(
              'assets/images/imagem_de_fundo.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // 🌈 GRADIENTE
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // ⚙️ CONFIGURAÇÕES
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.white, size: 30),
              onPressed: abrirConfiguracoes,
            ),
          ),

          // 🎮 BOTÃO ANIMADO
          Center(
            child: AnimatedBuilder(
              animation: buttonAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: buttonAnimation.value,
                  child: child,
                );
              },
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 239, 118, 156),
                  shadowColor: const Color.fromARGB(255, 0, 0, 0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GameMap()),
                  );
                },
                child: const Text(
                  "JOGAR",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
