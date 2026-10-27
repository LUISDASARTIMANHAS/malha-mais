import 'package:flutter/material.dart';

/// Aba com pilha de navegação própria.
///
/// Telas abertas aqui dentro (`Navigator.of(context).push`) ficam restritas à
/// aba, mantendo a barra de navegação visível.
class AbaNavegador extends StatelessWidget {
  const AbaNavegador({super.key, required this.chave, required this.raiz});

  final GlobalKey<NavigatorState> chave;
  final WidgetBuilder raiz;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: chave,
      onGenerateRoute: (_) => MaterialPageRoute<void>(builder: raiz),
    );
  }
}
