// lib/telas/localwidget/perfil/secao_metas.dart

import 'package:flutter/material.dart';
import 'package:malhamais/dominio/perfil_usuario.dart';
import 'package:malhamais/telas/localwidget/perfil/cartao_malha.dart';
import 'package:malhamais/util/tema/cores_malha.dart';
import 'package:malhamais/util/unidades.dart';

/// Seção "Minhas metas" com barras de progresso (verde e roxo alternados).
class SecaoMetas extends StatelessWidget {
  const SecaoMetas({
    super.key,
    required this.metas,
    required this.progresso,
    required this.aoEditar,
  });

  final MetasUsuario metas;
  final ProgressoAtual progresso;
  final VoidCallback aoEditar;

  @override
  Widget build(BuildContext context) {
    final c = context.cores;

    return CartaoMalha(
      child: Column(
        children: [
          TituloSecao(
            titulo: 'Minhas metas',
            aoEditar: aoEditar,
            tooltipEditar: 'Editar metas',
          ),
          const SizedBox(height: 4),
          _LinhaMeta(
            icone: Icons.directions_walk,
            rotulo: 'Passos diários',
            atual: progresso.passos,
            meta: metas.passosDiarios,
            unidade: '',
            cor: c.neon,
          ),
          _LinhaMeta(
            icone: Icons.local_fire_department_outlined,
            rotulo: 'Calorias diárias',
            atual: progresso.calorias,
            meta: metas.caloriasDiarias,
            unidade: 'kcal',
            cor: c.roxo,
          ),
          _LinhaMeta(
            icone: Icons.fitness_center,
            rotulo: 'Treinos semanais',
            atual: progresso.treinosNaSemana,
            meta: metas.treinosSemanais,
            unidade: '',
            cor: c.neon,
          ),
          _LinhaMeta(
            icone: Icons.timer_outlined,
            rotulo: 'Tempo ativo diário',
            atual: progresso.minutosAtivos,
            meta: metas.minutosAtivosDiarios,
            unidade: 'min',
            cor: c.roxo,
          ),
        ],
      ),
    );
  }
}

class _LinhaMeta extends StatelessWidget {
  const _LinhaMeta({
    required this.icone,
    required this.rotulo,
    required this.atual,
    required this.meta,
    required this.unidade,
    required this.cor,
  });

  final IconData icone;
  final String rotulo;
  final int atual;
  final int? meta;
  final String unidade;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final alvo = meta;
    final fracao = (alvo == null || alvo <= 0)
        ? 0.0
        : (atual / alvo).clamp(0.0, 1.0).toDouble();
    final texto = alvo == null
        ? 'Definir meta'
        : '${formatarMilhar(atual)} / ${formatarMilhar(alvo)} $unidade'.trim();

    return Semantics(
      label: '$rotulo: $texto',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icone, size: 18, color: cor),
                const SizedBox(width: 8),
                Expanded(child: Text(rotulo, style: tema.textTheme.bodyMedium)),
                Text(
                  texto,
                  style: tema.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: fracao,
                minHeight: 8,
                color: cor,
                backgroundColor: cor.withValues(alpha: 0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
