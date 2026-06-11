import '../models/carta.dart';

final List<Carta> todasCartas = [
  Carta(
    nome: "Kuromi",
    hp: 100,
    tipo: "Zest",
    fraqueza: "Candy",
    imagem: "assets/cards/Kuromi-card.png",

    ataques: [
      Ataque(nome: "Travessuras Sombrias", dano: 40),

      Ataque(nome: "Ataque Maléfico", dano: 60),
    ],
  ),

  Carta(
    nome: "My Melody",
    hp: 90,
    tipo: "Flora",
    fraqueza: "Zest",
    imagem: "assets/cards/MyMelody-card.png",

    ataques: [
      Ataque(nome: "Canção Suave", dano: 40),

      Ataque(nome: "Erva daninha", dano: 20),
    ],
  ),

  Carta(
    nome: "Tuxedo Sam",
    hp: 80,
    tipo: "Charm",
    fraqueza: "Zest",
    imagem: "assets/cards/TuxedoSam-card.png",

    ataques: [
      Ataque(nome: "Aula dde etiqueta", dano: 20),

      Ataque(nome: "Receba inteligência", dano: 35),
    ],
  ),
  Carta(
    nome: "Hello Kitty",
    hp: 90,
    tipo: "Charm",
    fraqueza: "Zest",
    imagem: "assets/cards/HelloKitty-card.png",

    ataques: [
      Ataque(nome: "Curiosidade", dano: 0, efeito: "verTopoDoBaralho"),

      Ataque(nome: "Laços explosivos", dano: 30),
    ],
  ),
  Carta(
    nome: "PomPomPurin",
    hp: 110,
    tipo: "Charm",
    fraqueza: "Push",
    imagem: "assets/cards/PomPomPurin-card.png",

    ataques: [
      Ataque(nome: "Meteoro de cookies", dano: 30),

      Ataque(nome: "Abraço carinhoso", dano: 60),
    ],
  ),
  Carta(
    nome: "Keropi",
    hp: 200,
    tipo: "Flora",
    fraqueza: "Zest",
    imagem: "assets/cards/Keropi-card.png",

    ataques: [
      Ataque(nome: "Lambida", dano: 30),

      Ataque(nome: "Abraço grudento", dano: 40),
    ],
  ),
  Carta(
    nome: "Badtz Maru",
    hp: 100,
    tipo: "Zest",
    fraqueza: "Candy",
    imagem: "assets/cards/BadtzMaru-card.png",

    ataques: [
      Ataque(nome: "Deboche", dano: 20),

      Ataque(nome: "Caos divertido", dano: 40),
    ],
  ),
];
