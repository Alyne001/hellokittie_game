import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hellokittie_game/screens/game_map.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 🎵 Gerenciador do player de música
  late AudioPlayer audioPlayer;
  double volumeAtual = 0.5; 
  bool estaMutado = false;

  // 🎮 Estado do clique do botão Jogar
  bool jogarPressionado = false;

  @override
  void initState() {
    super.initState();

    audioPlayer = AudioPlayer();
    inicializarEPlayMusica();
  }

  Future<void> inicializarEPlayMusica() async {
    try {
      audioPlayer.setReleaseMode(ReleaseMode.loop); 
      await audioPlayer.setVolume(volumeAtual); 
      await audioPlayer.play(AssetSource('audio/musica_fundo.mp3'));
    } catch (e) {
      print("Erro ao tocar a música: $e");
    }
  }

  // ⚡ Ação ao clicar em Jogar (Corrigida para não travar a animação de clique)
  Future<void> _acaoJogar() async {
    if (jogarPressionado) return; // Evita cliques duplos simultâneos

    // 1. Ativa o frame do botão clicado
    setState(() {
      jogarPressionado = true;
    });

    // 2. Aguarda a transição do AnimatedSwitcher concluir o frame (80ms + margem de segurança)
    await Future.delayed(const Duration(milliseconds: 100));

    // 3. Retorna o botão para o frame normal
    setState(() {
      jogarPressionado = false;
    });

    // 4. Pausa curtíssima para garantir que o frame normal renderize antes de travar a thread na navegação
    await Future.delayed(const Duration(milliseconds: 50));

    if (!mounted) return;

    // 5. Navega para o mapa do jogo de forma limpa
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GameMap()),
    );
  }

  @override
  void dispose() {
    audioPlayer.stop(); 
    audioPlayer.dispose(); 
    super.dispose();
  }

  void abrirConfiguracoes() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 255, 240, 245),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              titlePadding: const EdgeInsets.only(top: 15, left: 20, right: 20),
              title: const Text(
                "Configurações 🎀",
                style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              content: SizedBox(
                width: 300, 
                child: SingleChildScrollView( 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Música de Fundo",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          Switch(
                            activeColor: Colors.pink,
                            value: !estaMutado,
                            onChanged: (value) async {
                              setDialogState(() {
                                estaMutado = !value;
                              });
                              await audioPlayer.setVolume(estaMutado ? 0.0 : volumeAtual);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 5), 
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Volume", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              Text("${(volumeAtual * 100).toInt()}%", style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                          Slider(
                            activeColor: Colors.pink,
                            inactiveColor: Colors.pink.withOpacity(0.2),
                            min: 0.0,
                            max: 1.0,
                            value: volumeAtual,
                            onChanged: estaMutado ? null : (novoVolume) async {
                              setDialogState(() {
                                volumeAtual = novoVolume;
                              });
                              await audioPlayer.setVolume(novoVolume);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Fechar", style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // 🌄 FUNDO ESTÁTICO COM ZOOMS MANUAIS
          Transform.scale(
            // 🛠️ MUDE O ZOOM MANUAL AQUI SE PRECISAR AJUSTAR AO SEU CELULAR
            scale: 1.0, 
            child: SizedBox(
              width: screenSize.width,
              height: screenSize.height,
              child: Image.asset(
                'assets/images/imagem_de_fundo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🌈 ESCURECIMENTO SUTIL DO FUNDO
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // ⚙️ ÍCONE DA ENGRENAGEM
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.white, size: 35),
              onPressed: abrirConfiguracoes,
            ),
          ),

          // 🎮 BOTÃO "JOGAR" COM SUA LÓGICA DE DUELO CORRIGIDA
          Align(
            // 🛠️ AJUSTE A POSIÇÃO MANUALMENTE AQUI:
            // Eixo X: -1.0 (esquerda) até 1.0 (direita)
            // Eixo Y: -1.0 (topo) até 1.0 (base)
            alignment: const Alignment(-0.8, 0.40),
            child: GestureDetector(
              onTap: _acaoJogar,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 80),
                child: Image.asset(
                  jogarPressionado
                      ? "assets/images/BotaoDeJogar_clicado.png" 
                      : "assets/images/BotaoDeJogar.png",
                  key: ValueKey(jogarPressionado),
                  width: 220, 
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}