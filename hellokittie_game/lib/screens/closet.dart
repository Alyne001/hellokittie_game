import 'package:flutter/material.dart';

class ClosetScreen extends StatefulWidget {
  const ClosetScreen({super.key});

  @override
  State<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends State<ClosetScreen> {

  // personagem salva
  int savedClothes = 0;

  // personagem selecionada
  int selectedClothes = 0;

  // MINIATURAS DAS ROUPAS
  final List<String> clothes = [
    'assets/images/roupa1.png',
    'assets/images/roupa2.png',
    'assets/images/roupa3.png',
    'assets/images/roupa4.png',
  ];

  // PERSONAGENS COMPLETAS
  final List<String> personagens = [
    'assets/images/personagem_hellokitty01.png',
    'assets/images/personagem_hellokitty02.png',
    'assets/images/personagem_hellokitty03.png',
    'assets/images/personagem_hellokitty04.png',
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFFFC1E3),

      appBar: AppBar(
        title: const Text("Vestiário "),
        backgroundColor: const Color.fromARGB(255, 220, 114, 149),
      ),

      body: Row(
        children: [

          // LADO DA PERSONAGEM
          Expanded(
            flex: 2,

            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                 // PERSONAGEM
                SizedBox(
                 width: 180,
                 height: 180,
                 child: Center(
                  child: Image.asset(
                    personagens[selectedClothes],
                    fit: BoxFit.contain,
                    ),
                    ),
                    ),

                    const SizedBox(height: 20),

      
                    // BOTÕES
                    Row(
                     mainAxisAlignment: MainAxisAlignment.center,

                      children: [

                      // CANCELAR
                       ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,

                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),

                      onPressed: () {

                        setState(() {

                          // volta personagem salva
                          selectedClothes = savedClothes;
                        });
                      },

                      child: const Text(
                        "Cancelar",

                        style: TextStyle(
                          color: Colors.pink,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),

                    // SALVAR
                    ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,

                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),

                      onPressed: () {

                        setState(() {

                          // salva personagem escolhida
                          savedClothes = selectedClothes;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(

                          const SnackBar(
                            content: Text("Roupa salva 💖"),
                          ),
                        );
                      },

                      child: const Text(
                        "Salvar",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ),

          // ARMÁRIO
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

                        width: 4,
                      ),

                      borderRadius: BorderRadius.circular(15),

                      color: Colors.white,
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),

                      child: Image.asset(
                        clothes[index],
                        fit: BoxFit.contain,
                      ),
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