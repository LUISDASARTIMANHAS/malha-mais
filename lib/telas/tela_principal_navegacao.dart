// lib/telas/tela_principal_navegacao.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:malhamais/navegacao/itens_navegacao.dart';
import 'package:malhamais/util/widget/nav/nav.dart';

/// Área logada: monta o componente [Nav] com as abas do Malha+.
class TelaPrincipalNavegacao extends StatelessWidget {
  const TelaPrincipalNavegacao({
    super.key,
    required this.usuario,
    required this.aoSair,
  });

  final User usuario;
  final Future<void> Function() aoSair;

  @override
  Widget build(BuildContext context) {
    return Nav(
      itens: construirItensNavegacao(usuario: usuario, aoSair: aoSair),
    );
  }
}
