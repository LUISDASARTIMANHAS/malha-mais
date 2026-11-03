// lib/util/widget/fundo_brilho.dart

import 'package:flutter/material.dart';
import 'package:malhamais/util/tema/cores_malha.dart';

/// Fundo escuro com manchas suaves de luz roxa e verde no topo.
class FundoBrilho extends StatelessWidget {
  const FundoBrilho({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: CoresMalha.fundo,
      child: Stack(
        children: [
          const Positioned(
            top: -90,
            left: -70,
            child: _Mancha(cor: CoresMalha.roxoNeon, tamanho: 280),
          ),
          const Positioned(
            top: -70,
            right: -90,
            child: _Mancha(cor: CoresMalha.verdeNeon, tamanho: 260),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

class _Mancha extends StatelessWidget {
  const _Mancha({required this.cor, required this.tamanho});

  final Color cor;
  final double tamanho;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: tamanho,
        height: tamanho,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [cor.withValues(alpha: 0.26), cor.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}
