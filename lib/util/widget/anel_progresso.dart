// lib/util/widget/anel_progresso.dart

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:malhamais/util/tema/cores_malha.dart';

/// Indicador circular com ícone, valor, meta e legenda.
///
/// Adapta-se à largura disponível (até [_ladoMaximo]) e reduz o texto
/// automaticamente em telas pequenas.
class AnelProgresso extends StatelessWidget {
  const AnelProgresso({
    super.key,
    required this.progresso,
    required this.cor,
    required this.icone,
    required this.valor,
    required this.meta,
    required this.legenda,
  });

  /// Fração concluída (0 a 1).
  final double progresso;
  final Color cor;
  final IconData icone;
  final String valor;
  final String meta;
  final String legenda;

  static const double _ladoMaximo = 124;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).textTheme;

    return Semantics(
      label: '$legenda: $valor $meta',
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LayoutBuilder(
            builder: (context, restricoes) {
              final lado = math.min(restricoes.maxWidth, _ladoMaximo);
              return SizedBox.square(
                dimension: lado,
                child: CustomPaint(
                  painter: _PintorAnel(progresso: progresso, cor: cor),
                  child: Padding(
                    padding: EdgeInsets.all(lado * 0.16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icone, color: cor, size: lado * 0.18),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            valor,
                            style: tema.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            meta,
                            style: tema.labelSmall?.copyWith(
                              color: CoresMalha.textoSecundario,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Text(
            legenda,
            style: tema.bodySmall?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PintorAnel extends CustomPainter {
  _PintorAnel({required this.progresso, required this.cor});

  final double progresso;
  final Color cor;

  @override
  void paint(Canvas canvas, Size size) {
    final espessura = size.width * 0.085;
    final raio = (size.width - espessura) / 2;
    final centro = size.center(Offset.zero);

    Paint pincel(Color c) => Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = espessura
      ..strokeCap = StrokeCap.round
      ..color = c;

    canvas.drawCircle(centro, raio, pincel(cor.withValues(alpha: 0.15)));
    if (progresso <= 0) return;

    final retangulo = Rect.fromCircle(center: centro, radius: raio);
    final varredura = 2 * math.pi * progresso.clamp(0.0, 1.0);

    // Glow: o mesmo arco, borrado, por baixo.
    canvas.drawArc(
      retangulo,
      -math.pi / 2,
      varredura,
      false,
      pincel(cor.withValues(alpha: 0.55))
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, espessura * 0.6),
    );
    canvas.drawArc(retangulo, -math.pi / 2, varredura, false, pincel(cor));
  }

  @override
  bool shouldRepaint(_PintorAnel antigo) =>
      antigo.progresso != progresso || antigo.cor != cor;
}
