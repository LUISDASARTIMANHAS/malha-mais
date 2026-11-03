// lib/util/widget/titulo_secao.dart

import 'package:flutter/material.dart';
import 'package:malhamais/util/tema/cores_malha.dart';

/// Título de seção com texto opcional alinhado à direita (ex.: data).
class TituloSecao extends StatelessWidget {
  const TituloSecao({super.key, required this.titulo, this.complemento});

  final String titulo;
  final String? complemento;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            titulo,
            style: tema.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (complemento != null)
          Text(
            complemento!,
            style: tema.bodySmall?.copyWith(color: CoresMalha.textoSecundario),
          ),
      ],
    );
  }
}
