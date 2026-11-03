// lib/telas/localwidget/cabecalho_dashboard.dart

import 'package:flutter/material.dart';
import 'package:malhamais/util/tema/cores_malha.dart';
import 'package:malhamais/util/widget/avatar_inicial.dart';
import 'package:malhamais/util/widget/botao_icone_redondo.dart';

/// Cabeçalho do Dashboard: menu, notificações, avatar e saudação.
class CabecalhoDashboard extends StatelessWidget {
  const CabecalhoDashboard({
    super.key,
    required this.nome,
    required this.saudacao,
    required this.aoAbrirMenu,
    required this.aoAbrirNotificacoes,
    required this.aoAbrirPerfil,
    this.temNotificacao = true,
  });

  /// Nome completo (usado só no avatar).
  final String nome;
  final String saudacao;
  final VoidCallback aoAbrirMenu;
  final VoidCallback aoAbrirNotificacoes;
  final VoidCallback aoAbrirPerfil;
  final bool temNotificacao;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            BotaoIconeRedondo(
              icone: Icons.menu,
              dica: 'Open menu',
              aoTocar: aoAbrirMenu,
            ),
            const Spacer(),
            BotaoIconeRedondo(
              icone: Icons.notifications_none,
              dica: 'Notifications',
              aoTocar: aoAbrirNotificacoes,
              mostrarBadge: temNotificacao,
            ),
            const SizedBox(width: 12),
            Tooltip(
              message: 'Profile',
              child: GestureDetector(
                onTap: aoAbrirPerfil,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: CoresMalha.verdeNeon, width: 1.5),
                  ),
                  child: AvatarInicial(nome: nome, raio: 19),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Text(
          saudacao,
          style: tema.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Let's crush your goals today.",
          style: tema.bodyMedium?.copyWith(color: CoresMalha.textoSecundario),
        ),
      ],
    );
  }
}
