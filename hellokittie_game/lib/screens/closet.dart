import 'package:flutter/material.dart';

class ClosetScreen extends StatefulWidget {
  const ClosetScreen({super.key});

  @override
  State<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends State<ClosetScreen> {
  int savedClothes = 0;
  int selectedClothes = 0;

  bool salvarPressionado = false;
  bool cancelarPressionado = false;

  final int roupaPadraoOculta = 0; 

  final List<String> clothes = [
    'assets/images/roupa1.png',
    'assets/images/roupa2.png',
    'assets/images/roupa3.png',
    'assets/images/roupa4.png',
  ];

  final List<String> personagens = [
    'assets/images/personagem_hellokitty01.png',
    'assets/images/personagem_hellokitty02.png',
    'assets/images/personagem_hellokitty03.png',
    'assets/images/personagem_hellokitty04.png',
  ];

  Future<void> _acaoCancelar() async {
    setState(() {
      cancelarPressionado = true;
    });

    await Future.delayed(const Duration(milliseconds: 120));

    setState(() {
      cancelarPressionado = false;
      selectedClothes = roupaPadraoOculta; 
    });
  }

  Future<void> _acaoSalvar() async {
    setState(() {
      salvarPressionado = true;
    });

    await Future.delayed(const Duration(milliseconds: 120));

    setState(() {
      salvarPressionado = false;
      savedClothes = selectedClothes;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Visual salvo com sucesso! 🎀'),
        backgroundColor: Colors.pink,
        duration: Duration(seconds: 1),
      ),
    );

    Navigator.pop(context, savedClothes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final largura = constraints.maxWidth;
          final altura = constraints.maxHeight;

          const double larguraSlot = 128; 
          const double alturaSlot = 93;   

          final posicaoRoupa1 = Offset(largura * 0.14, altura * 0.032);
          final posicaoRoupa2 = Offset(largura * 0.32, altura * 0.032);
          final posicaoRoupa3 = Offset(largura * 0.51, altura * 0.032);
          final posicaoRoupa4 = Offset(largura * 0.70, altura * 0.032);

          double ajusteY = 0.0;

          if (selectedClothes == 0) {
            ajusteY = 0.0;     
          } else if (selectedClothes == 1) {
            ajusteY = 0.0;     
          } else if (selectedClothes == 2) {
            ajusteY = 0.0;     
          } else if (selectedClothes == 3) {
            ajusteY = 0.0;     
          }

          return Stack(
            children: [
              // FUNDO
              Positioned.fill(
                child: Image.asset(
                  'assets/images/vestiario_fundo.png',
                  fit: BoxFit.fill,
                ),
              ),

              // BOTÃO CANCELAR
              Positioned(
                top: 25,
                left: 15,
                child: GestureDetector(
                  onTap: _acaoCancelar,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 80),
                    child: Image.asset(
                      cancelarPressionado
                          ? "assets/images/BotaoDeCancelar_clicado.png"
                          : "assets/images/BotaoDeCancelar.png",
                      key: ValueKey(cancelarPressionado),
                      width: 60, 
                    ),
                  ),
                ),
              ),

              // BOTÃO SALVAR ROUPA
              Positioned(
                top: 25,
                right: 20,
                child: GestureDetector(
                  onTap: _acaoSalvar,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 80),
                    child: Image.asset(
                      salvarPressionado
                          ? "assets/images/BotaoDeSalvar_clicado.png"
                          : "assets/images/BotaoDeSalvar.png",
                      key: ValueKey(salvarPressionado),
                      width: 140, 
                    ),
                  ),
                ),
              ),

              // PERSONAGEM NO TAPETE
              Positioned(
                top: altura * (0.23 + ajusteY),  
                left: largura * 0.45, 
                child: SizedBox(
                  width: largura * 0.11, 
                  height: altura * 0.45, 
                  child: Image.asset(
                    personagens[selectedClothes],
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter, 
                  ),
                ),
              ), 

              // QUADRADOS DE SELEÇÃO
              Positioned(
                bottom: posicaoRoupa1.dy,
                left: posicaoRoupa1.dx,
                child: roupaSlot(0, larguraSlot, alturaSlot),
              ),
              Positioned(
                bottom: posicaoRoupa2.dy,
                left: posicaoRoupa2.dx,
                child: roupaSlot(1, larguraSlot, alturaSlot),
              ),
              Positioned(
                bottom: posicaoRoupa3.dy,
                left: posicaoRoupa3.dx,
                child: roupaSlot(2, larguraSlot, alturaSlot),
              ),
              Positioned(
                bottom: posicaoRoupa4.dy,
                left: posicaoRoupa4.dx,
                child: roupaSlot(3, larguraSlot, alturaSlot),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget roupaSlot(int index, double width, double height) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedClothes = index;
        });
      },
      child: Container(
        width: width,   
        height: height, 
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedClothes == index ? Colors.pinkAccent : Colors.white24,
            width: 4,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8), 
          child: Image.asset(
            clothes[index],
            fit: BoxFit.contain, 
          ),
        ),
      ),
    );
  }
}