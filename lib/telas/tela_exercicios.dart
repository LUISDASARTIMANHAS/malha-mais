// lib/telas/tela_exercicios.dart

import 'package:flutter/material.dart';

import 'localwidget/placeholder_aba.dart';

/// Aba de treinos: iniciar atividades, seguir planos e ver o histórico.
class TelaExercicios extends StatelessWidget {
  const TelaExercicios({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercícios')),
      body: const PlaceholderAba(
        icone: Icons.fitness_center,
        titulo: 'Seus treinos',
        descricao: 'Inicie atividades, siga planos, registre exercícios '
            'e consulte o histórico de sessões.',
      ),
    );
  }
}
