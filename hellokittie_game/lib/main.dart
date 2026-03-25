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
  Offset position = Offset.zero;
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
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    ));

    animation.addListener(() {
      setState(() {
        position = animation.value;
      });
    });
  }

  void resetPosition() {
    animation = Tween<Offset>(
      begin: position,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    ));

    controller.forward(from: 0);
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 👈 evita branco
      body: ClipRect(
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              // 🔥 limite menor pra não mostrar borda
              double dx = (position.dx + details.delta.dx).clamp(-30, 30);
              double dy = (position.dy + details.delta.dy).clamp(-30, 30);
              position = Offset(dx, dy);
            });
          },
          onPanEnd: (_) {
            resetPosition();
          },
          child: Transform.translate(
            offset: position,
            child: SizedBox.expand(
              child: Image.asset(
                'assets/images/mapa_teste_game_HK.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}