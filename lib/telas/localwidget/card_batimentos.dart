// lib/telas/localwidget/card_batimentos.dart

import 'package:flutter/material.dart';
import 'package:malhamais/dominio/resumo_diario.dart';
import 'package:malhamais/telas/localwidget/grafico_batimentos.dart';
import 'package:malhamais/util/tema/cores_malha.dart';
import 'package:malhamais/util/widget/cartao_malha.dart';

/// Card "Heart Rate": leitura atual + gráfico do dia.
class CardBatimentos extends StatelessWidget {
  const CardBatimentos({super.key, required this.resumo});

  final ResumoDiario resumo;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).textTheme;

    return CartaoMalha(
      corBrilho: CoresMalha.verdeNeon,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: CoresMalha.vermelhoCoracao.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: CoresMalha.vermelhoCoracao,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Heart Rate',
                  style: tema.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Semantics(
                label: '${resumo.batimentoAtual} beats per minute',
                excludeSemantics: true,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${resumo.batimentoAtual}',
                      style: tema.headlineMedium?.copyWith(
                        color: CoresMalha.verdeNeon,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'BPM',
                      style: tema.labelMedium?.copyWith(
                        color: CoresMalha.textoSecundario,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GraficoBatimentos(
            amostras: resumo.amostrasBatimento,
            indiceDestaque: resumo.indiceDestaqueBatimento,
          ),
        ],
      ),
    );
  }
}
