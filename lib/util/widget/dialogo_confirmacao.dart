// lib/util/widget/dialogo_confirmacao.dart

import 'package:flutter/material.dart';

/// Pergunta de confirmação (sim/não) reutilizável.
///
/// @param context contexto para abrir o diálogo.
/// @param titulo título do diálogo.
/// @param mensagem explicação da ação.
/// @param textoConfirmar rótulo do botão de confirmação.
/// @param textoCancelar rótulo do botão de cancelamento.
/// @return `true` se o usuário confirmou.
Future<bool> confirmarAcao(
  BuildContext context, {
  required String titulo,
  required String mensagem,
  String textoConfirmar = 'Confirmar',
  String textoCancelar = 'Cancelar',
}) async {
  final confirmou = await showDialog<bool>(
    context: context,
    builder: (contexto) => AlertDialog(
      title: Text(titulo),
      content: Text(mensagem),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(contexto).pop(false),
          child: Text(textoCancelar),
        ),
        FilledButton(
          // Largura própria: o tema global usa largura infinita.
          style: FilledButton.styleFrom(minimumSize: const Size(96, 44)),
          onPressed: () => Navigator.of(contexto).pop(true),
          child: Text(textoConfirmar),
        ),
      ],
    ),
  );
  return confirmou ?? false;
}
