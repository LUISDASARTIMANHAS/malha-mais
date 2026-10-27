// lib/util/widget/avatar_inicial.dart

import 'package:flutter/material.dart';

/// Avatar circular com a inicial do nome.
class AvatarInicial extends StatelessWidget {
  const AvatarInicial({super.key, required this.nome, this.raio = 44});

  final String nome;
  final double raio;

  /// Primeira letra do nome em maiúscula (ou `?` se vazio).
  ///
  /// @param nome nome de exibição.
  /// @return inicial a mostrar no avatar.
  static String inicialDe(String nome) {
    final texto = nome.trim();
    return texto.isEmpty ? '?' : texto[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return CircleAvatar(
      radius: raio,
      backgroundColor: tema.colorScheme.primaryContainer,
      child: Text(
        inicialDe(nome),
        style: tema.textTheme.headlineMedium?.copyWith(
          color: tema.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
