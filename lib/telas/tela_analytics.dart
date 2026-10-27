// lib/telas/tela_analytics.dart

import 'package:flutter/material.dart';

import 'localwidget/placeholder_aba.dart';

/// Aba de estatísticas: evolução, recordes e comparações.
class TelaAnalytics extends StatelessWidget {
  const TelaAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: const PlaceholderAba(
        icone: Icons.insights,
        titulo: 'Sua evolução',
        descricao: 'Gráficos de distância, volume de treino, recordes '
            'e consistência ao longo do tempo.',
      ),
    );
  }
}
