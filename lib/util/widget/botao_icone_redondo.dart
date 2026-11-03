// lib/util/widget/botao_icone_redondo.dart

import 'package:flutter/material.dart';
import 'package:malhamais/util/tema/cores_malha.dart';

/// Botão circular translúcido com ícone e indicador (badge) opcional.
class BotaoIconeRedondo extends StatelessWidget {
  const BotaoIconeRedondo({
    super.key,
    required this.icone,
    required this.dica,
    required this.aoTocar,
    this.mostrarBadge = false,
  });

  final IconData icone;

  /// Texto de acessibilidade (tooltip/leitor de tela).
  final String dica;
  final VoidCallback aoTocar;
  final bool mostrarBadge;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: dica,
      child: Material(
        color: Colors.white.withValues(alpha: 0.06),
        shape: CircleBorder(side: BorderSide(color: CoresMalha.borda)),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: aoTocar,
          child: SizedBox.square(
            dimension: 44,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(icone, color: Colors.white, size: 22),
                if (mostrarBadge)
                  Positioned(
                    top: 10,
                    right: 11,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: CoresMalha.verdeNeon,
                        shape: BoxShape.circle,
                        border: Border.all(color: CoresMalha.fundo, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
