// lib/telas/localwidget/card_resumo_atividade.dart

import 'package:flutter/material.dart';
import 'package:malhamais/dominio/resumo_diario.dart';
import 'package:malhamais/telas/localwidget/mini_card_metrica.dart';
import 'package:malhamais/util/formatadores.dart';
import 'package:malhamais/util/tema/cores_malha.dart';
import 'package:malhamais/util/widget/cartao_malha.dart';
import 'package:malhamais/util/widget/titulo_secao.dart';

/// Card "Activity Summary": distância, calorias ativas e sono.
class CardResumoAtividade extends StatelessWidget {
  const CardResumoAtividade({super.key, required this.resumo});

  final ResumoDiario resumo;

  @override
  Widget build(BuildContext context) {
    return CartaoMalha(
      child: Column(
        children: [
          const TituloSecao(titulo: 'Activity Summary'),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: MiniCardMetrica(
                  icone: Icons.place_outlined,
                  cor: CoresMalha.verdeEsmeralda,
                  valor: Formatadores.decimal(resumo.distanciaKm),
                  unidade: 'km',
                  rotulo: 'Distance',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MiniCardMetrica(
                  icone: Icons.bolt,
                  cor: CoresMalha.verdeNeon,
                  valor: '${resumo.caloriasAtivas}',
                  unidade: 'Kcal',
                  rotulo: 'Active Calories',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MiniCardMetrica(
                  icone: Icons.bedtime_outlined,
                  cor: CoresMalha.roxoNeon,
                  valor: Formatadores.duracao(resumo.sonoMinutos),
                  rotulo: 'Sleep',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
