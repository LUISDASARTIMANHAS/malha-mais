import 'package:flutter/material.dart';

import 'item_nav.dart';

/// Barra inferior puramente visual (sem lógica de navegação).
class BarraNavegacao extends StatelessWidget {
  const BarraNavegacao({
    super.key,
    required this.itens,
    required this.indiceSelecionado,
    required this.aoSelecionar,
  }) : assert(itens.length >= 2, 'A barra precisa de ao menos 2 destinos');

  final List<ItemNav> itens;
  final int indiceSelecionado;
  final ValueChanged<int> aoSelecionar;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: indiceSelecionado,
      onDestinationSelected: aoSelecionar,
      destinations: [
        for (final item in itens)
          NavigationDestination(
            icon: Icon(item.icone),
            selectedIcon: Icon(item.iconeSelecionado ?? item.icone),
            label: item.rotulo,
          ),
      ],
    );
  }
}
