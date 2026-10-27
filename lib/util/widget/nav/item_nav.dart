// lib/util/widget/nav/item_nav.dart

import 'package:flutter/material.dart';

/// Descreve um destino do [Nav]: aparência na barra e tela raiz da aba.
class ItemNav {
  const ItemNav({
    required this.rotulo,
    required this.icone,
    required this.construirRaiz,
    this.iconeSelecionado,
  });

  /// Texto exibido abaixo do ícone.
  final String rotulo;

  /// Ícone do destino quando não selecionado.
  final IconData icone;

  /// Ícone quando selecionado (usa [icone] se omitido).
  final IconData? iconeSelecionado;

  /// Constrói a primeira tela da aba (chamado só na primeira visita).
  final WidgetBuilder construirRaiz;
}
