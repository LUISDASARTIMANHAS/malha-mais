// lib/util/widget/menu_lateral_malha.dart

import 'package:flutter/material.dart';
import 'package:malhamais/util/tema/cores_malha.dart';
import 'package:malhamais/util/widget/avatar_inicial.dart';

/// Item do menu lateral.
class ItemMenuLateral {
  const ItemMenuLateral({
    required this.icone,
    required this.rotulo,
    required this.aoTocar,
  });

  final IconData icone;
  final String rotulo;
  final VoidCallback aoTocar;
}

/// Menu lateral (hambúrguer) com identificação do usuário e atalhos.
class MenuLateralMalha extends StatelessWidget {
  const MenuLateralMalha({super.key, required this.nome, required this.itens});

  final String nome;
  final List<ItemMenuLateral> itens;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).textTheme;

    return Drawer(
      backgroundColor: CoresMalha.cartao,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  AvatarInicial(nome: nome, raio: 26),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tema.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            for (final item in itens)
              ListTile(
                leading: Icon(item.icone, color: CoresMalha.verdeNeon),
                title: Text(item.rotulo),
                onTap: item.aoTocar,
              ),
          ],
        ),
      ),
    );
  }
}
