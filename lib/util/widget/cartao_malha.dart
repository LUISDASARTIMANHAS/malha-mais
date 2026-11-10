// lib/util/widget/cartao_malha.dart

import 'package:flutter/material.dart';
import 'package:malhamais/util/tema/cores_malha.dart';

/// Card padrão do Malha+: fundo azul-marinho, borda discreta e glow opcional.
class CartaoMalha extends StatelessWidget {
  const CartaoMalha({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.corBrilho,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  /// Se informada, adiciona um glow sutil nessa cor.
  final Color? corBrilho;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: cores.cartaoApp,
        borderRadius: BorderRadius.circular(CoresMalha.raioCartao),
        border: Border.all(color: cores.bordaApp),
        boxShadow: corBrilho == null
            ? null
            : [
                BoxShadow(
                  color: corBrilho!.withValues(alpha: 0.10),
                  blurRadius: 24,
                  spreadRadius: -4,
                ),
              ],
      ),
      child: child,
    );
  }
}
