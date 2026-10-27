// lib/telas/localwidget/placeholder_aba.dart

import 'package:flutter/material.dart';

/// Conteúdo provisório de uma aba ainda não implementada.
class PlaceholderAba extends StatelessWidget {
  const PlaceholderAba({
    super.key,
    required this.icone,
    required this.titulo,
    required this.descricao,
  });

  final IconData icone;
  final String titulo;
  final String descricao;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 72, color: tema.colorScheme.primary),
            const SizedBox(height: 16),
            Text(titulo,
                textAlign: TextAlign.center,
                style: tema.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(descricao,
                textAlign: TextAlign.center, style: tema.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
