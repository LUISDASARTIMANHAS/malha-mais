// lib/telas/tela_dashboard.dart

import 'package:flutter/material.dart';

import 'localwidget/placeholder_aba.dart';

/// Aba inicial: resumo de desempenho, metas e missões ativas.
class TelaDashboard extends StatelessWidget {
  const TelaDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const PlaceholderAba(
        icone: Icons.dashboard,
        titulo: 'Seu painel',
        descricao: 'Resumo do desempenho, progresso das metas, '
            'treino recomendado e missões ativas.',
      ),
    );
  }
}
