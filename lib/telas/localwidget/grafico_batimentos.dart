// lib/telas/localwidget/grafico_batimentos.dart

import 'package:flutter/material.dart';
import 'package:malhamais/dominio/resumo_diario.dart';
import 'package:malhamais/util/tema/cores_malha.dart';

/// Gráfico de linha suave dos batimentos ao longo do dia (0h a 24h).
///
/// Desenhado com [CustomPaint] (sem dependências externas): grade, eixos,
/// linha com glow neon, preenchimento em degradê e balão na leitura atual.
class GraficoBatimentos extends StatelessWidget {
  const GraficoBatimentos({
    super.key,
    required this.amostras,
    required this.indiceDestaque,
    this.minBpm = 40,
    this.maxBpm = 120,
    this.altura = 190,
  });

  final List<AmostraBatimento> amostras;
  final int indiceDestaque;
  final int minBpm;
  final int maxBpm;
  final double altura;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: altura,
      width: double.infinity,
      child: CustomPaint(
        painter: _PintorBatimentos(
          amostras: amostras,
          indiceDestaque: indiceDestaque,
          minBpm: minBpm,
          maxBpm: maxBpm,
        ),
      ),
    );
  }
}

class _PintorBatimentos extends CustomPainter {
  _PintorBatimentos({
    required this.amostras,
    required this.indiceDestaque,
    required this.minBpm,
    required this.maxBpm,
  });

  final List<AmostraBatimento> amostras;
  final int indiceDestaque;
  final int minBpm;
  final int maxBpm;

  static const double _esquerda = 34;
  static const double _direita = 8;
  static const double _topo = 34;
  static const double _base = 22;
  static const Color _verdeAmarelado = Color(0xFFE6F94A);

  static const TextStyle _estiloEixo = TextStyle(
    color: CoresMalha.textoSecundario,
    fontSize: 10,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final area = Rect.fromLTRB(
      _esquerda,
      _topo,
      size.width - _direita,
      size.height - _base,
    );

    _desenharGrade(canvas, area);
    _desenharHorarios(canvas, area, size);
    if (amostras.length < 2) return;

    final pontos = [
      for (final a in amostras) Offset(_x(a.hora, area), _y(a.bpm, area)),
    ];
    final linha = _caminhoSuave(pontos);

    _desenharPreenchimento(canvas, area, linha, pontos);
    _desenharLinha(canvas, area, linha);

    if (indiceDestaque >= 0 && indiceDestaque < pontos.length) {
      _desenharDestaque(
        canvas,
        area,
        size,
        pontos[indiceDestaque],
        amostras[indiceDestaque].bpm,
      );
    }
  }

  double _x(double hora, Rect area) => area.left + (hora / 24) * area.width;

  double _y(int bpm, Rect area) {
    final fracao = ((bpm - minBpm) / (maxBpm - minBpm)).clamp(0.0, 1.0);
    return area.bottom - fracao.toDouble() * area.height;
  }

  TextPainter _texto(String texto, TextStyle estilo) =>
      TextPainter(
        text: TextSpan(text: texto, style: estilo),
        textDirection: TextDirection.ltr,
      )..layout();

  void _desenharGrade(Canvas canvas, Rect area) {
    final pincel = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 1;

    for (var bpm = minBpm; bpm <= maxBpm; bpm += 20) {
      final y = _y(bpm, area);
      canvas.drawLine(Offset(area.left, y), Offset(area.right, y), pincel);
      final rotulo = _texto('$bpm', _estiloEixo);
      rotulo.paint(
        canvas,
        Offset(_esquerda - 8 - rotulo.width, y - rotulo.height / 2),
      );
    }
  }

  void _desenharHorarios(Canvas canvas, Rect area, Size size) {
    for (final hora in const [0, 6, 12, 18, 24]) {
      final rotulo = _texto(
        '${hora.toString().padLeft(2, '0')}:00',
        _estiloEixo,
      );
      final dx = (_x(hora.toDouble(), area) - rotulo.width / 2)
          .clamp(0.0, size.width - rotulo.width)
          .toDouble();
      rotulo.paint(canvas, Offset(dx, area.bottom + 6));
    }
  }

  /// Curva com tangentes horizontais: suave e sem "overshoot".
  Path _caminhoSuave(List<Offset> p) {
    final caminho = Path()..moveTo(p.first.dx, p.first.dy);
    for (var i = 1; i < p.length; i++) {
      final meio = (p[i - 1].dx + p[i].dx) / 2;
      caminho.cubicTo(meio, p[i - 1].dy, meio, p[i].dy, p[i].dx, p[i].dy);
    }
    return caminho;
  }

  void _desenharPreenchimento(
    Canvas canvas,
    Rect area,
    Path linha,
    List<Offset> p,
  ) {
    final preenchimento = Path.from(linha)
      ..lineTo(p.last.dx, area.bottom)
      ..lineTo(p.first.dx, area.bottom)
      ..close();

    canvas.drawPath(
      preenchimento,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            CoresMalha.verdeNeon.withValues(alpha: 0.22),
            CoresMalha.verdeNeon.withValues(alpha: 0),
          ],
        ).createShader(area),
    );
  }

  void _desenharLinha(Canvas canvas, Rect area, Path linha) {
    final degrade = const LinearGradient(
      colors: [CoresMalha.verdeNeon, _verdeAmarelado],
    ).createShader(area);

    // Glow por baixo.
    canvas.drawPath(
      linha,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..shader = degrade
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
        ..color = Colors.white.withValues(alpha: 0.6),
    );
    canvas.drawPath(
      linha,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..shader = degrade,
    );
  }

  void _desenharDestaque(
    Canvas canvas,
    Rect area,
    Size size,
    Offset ponto,
    int bpm,
  ) {
    // Guia vertical discreta.
    canvas.drawLine(
      ponto,
      Offset(ponto.dx, area.bottom),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.15)
        ..strokeWidth = 1,
    );

    // Marcador com glow.
    canvas.drawCircle(
      ponto,
      9,
      Paint()
        ..color = CoresMalha.verdeNeon.withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    canvas.drawCircle(ponto, 5, Paint()..color = CoresMalha.verdeNeon);
    canvas.drawCircle(
      ponto,
      5,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = CoresMalha.fundo,
    );

    // Balão flutuante.
    final texto = _texto(
      '$bpm BPM',
      const TextStyle(
        color: CoresMalha.fundo,
        fontSize: 12,
        fontWeight: FontWeight.w800,
      ),
    );
    final largura = texto.width + 18;
    final altura = texto.height + 10;
    final esquerda =
        (ponto.dx - largura / 2).clamp(0.0, size.width - largura).toDouble();
    final topo = ponto.dy - 14 - altura;
    final balao = RRect.fromRectAndRadius(
      Rect.fromLTWH(esquerda, topo, largura, altura),
      const Radius.circular(10),
    );

    canvas.drawRRect(
      balao,
      Paint()
        ..color = CoresMalha.verdeNeon.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawRRect(balao, Paint()..color = CoresMalha.verdeNeon);
    texto.paint(canvas, Offset(esquerda + 9, topo + 5));
  }

  @override
  bool shouldRepaint(_PintorBatimentos antigo) =>
      antigo.amostras != amostras ||
      antigo.indiceDestaque != indiceDestaque ||
      antigo.minBpm != minBpm ||
      antigo.maxBpm != maxBpm;
}
