// lib/telas/localwidget/secao_progresso_diario.dart

import 'package:flutter/material.dart';
import 'package:malhamais/dominio/resumo_diario.dart';
import 'package:malhamais/util/formatadores.dart';
import 'package:malhamais/util/tema/cores_malha.dart';
import 'package:malhamais/util/widget/anel_progresso.dart';
import 'package:malhamais/util/widget/cartao_malha.dart';
import 'package:malhamais/util/widget/titulo_secao.dart';

/// Card "Daily Progress" com três anéis: calorias, passos e tempo ativo.
class SecaoProgressoDiario extends StatelessWidget {
  const SecaoProgressoDiario({
    super.key,
    required this.resumo,
    required this.data,
  });

  final ResumoDiario resumo;
  final DateTime data;

  @override
  Widget build(BuildContext context) {
    return CartaoMalha(
      corBrilho: CoresMalha.roxoNeon,
      child: Column(
        children: [
          TituloSecao(
            titulo: 'Daily Progress',
            complemento: Formatadores.dataCurta(data),
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AnelProgresso(
                  progresso: resumo.progressoCalorias,
                  cor: CoresMalha.verdeNeon,
                  icone: Icons.local_fire_department,
                  valor: Formatadores.milhar(resumo.calorias),
                  meta: '/ ${Formatadores.milhar(resumo.caloriasMeta)} Kcal',
                  legenda: 'Calories',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AnelProgresso(
                  progresso: resumo.progressoPassos,
                  cor: CoresMalha.verdeEsmeralda,
                  icone: Icons.directions_walk,
                  valor: Formatadores.milhar(resumo.passos),
                  meta: '/ ${Formatadores.milhar(resumo.passosMeta)}',
                  legenda: 'Steps',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AnelProgresso(
                  progresso: resumo.progressoTempoAtivo,
                  cor: CoresMalha.roxoNeon,
                  icone: Icons.timer_outlined,
                  valor: '${resumo.minutosAtivos}',
                  meta: 'min / ${resumo.minutosAtivosMeta}',
                  legenda: 'Active Time',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
