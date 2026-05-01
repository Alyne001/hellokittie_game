import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xFFFFC1E3), // rosa
      appBar: AppBar(
        title: const Text("Vestiário "),
        backgroundColor: const Color.fromARGB(255, 206, 99, 135),
        centerTitle: true,
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
                  ),
                  Image.asset(
                    clothes[selectedClothes],
                    width: 150,
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                    child: Image.asset(clothes[index]),
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