// lib/telas/localwidget/perfil/secao_preferencias.dart

import 'package:flutter/material.dart';
import 'package:malhamais/dominio/perfil_usuario.dart';
import 'package:malhamais/telas/localwidget/perfil/cartao_malha.dart';
import 'package:malhamais/util/tema/cores_malha.dart';

/// Seção "Preferências de treino": modalidades selecionáveis.
class SecaoPreferencias extends StatelessWidget {
  const SecaoPreferencias({
    super.key,
    required this.selecionadas,
    required this.aoAlternar,
  });

  final Set<Modalidade> selecionadas;
  final ValueChanged<Modalidade> aoAlternar;

  static const Map<Modalidade, IconData> _icones = {
    Modalidade.corrida: Icons.directions_run,
    Modalidade.ciclismo: Icons.directions_bike,
    Modalidade.musculacao: Icons.fitness_center,
    Modalidade.yoga: Icons.self_improvement,
  };

  @override
  Widget build(BuildContext context) {
    final c = context.cores;

    return CartaoMalha(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TituloSecao(titulo: 'Preferências de treino'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final modalidade in Modalidade.values)
                _chip(c, modalidade, selecionadas.contains(modalidade)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(CoresMalha c, Modalidade modalidade, bool ativa) {
    return FilterChip(
      avatar: Icon(_icones[modalidade], size: 18, color: ativa ? c.neon : null),
      label: Text(modalidade.rotulo),
      labelStyle: TextStyle(
        color: ativa ? c.neon : null,
        fontWeight: ativa ? FontWeight.w600 : FontWeight.normal,
      ),
      selected: ativa,
      showCheckmark: false,
      selectedColor: c.neon.withValues(alpha: 0.16),
      side: BorderSide(color: ativa ? c.neon : c.bordaApp),
      onSelected: (_) => aoAlternar(modalidade),
    );
  }
}
