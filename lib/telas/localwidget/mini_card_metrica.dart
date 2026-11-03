// lib/telas/localwidget/mini_card_metrica.dart

import 'package:flutter/material.dart';
import 'package:malhamais/util/tema/cores_malha.dart';

/// Mini card de uma métrica: ícone colorido, valor, unidade e rótulo.
class MiniCardMetrica extends StatelessWidget {
  const MiniCardMetrica({
    super.key,
    required this.icone,
    required this.cor,
    required this.valor,
    required this.rotulo,
    this.unidade = '',
  });

  final IconData icone;
  final Color cor;
  final String valor;
  final String unidade;
  final String rotulo;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).textTheme;

    return Semantics(
      label: '$rotulo: $valor $unidade',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: CoresMalha.borda),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icone, color: cor, size: 20),
            ),
            const SizedBox(height: 10),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text.rich(
                TextSpan(
                  text: valor,
                  style: tema.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                  children: [
                    if (unidade.isNotEmpty)
                      TextSpan(
                        text: ' $unidade',
                        style: tema.labelSmall?.copyWith(
                          color: CoresMalha.textoSecundario,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                rotulo,
                style: tema.bodySmall?.copyWith(
                  color: CoresMalha.textoSecundario,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
