import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:malhamais/telas/tela_analytics.dart';
import 'package:malhamais/telas/tela_dashboard.dart';
import 'package:malhamais/telas/tela_exercicios.dart';
import 'package:malhamais/telas/tela_perfil.dart';
import 'package:malhamais/util/widget/nav/item_nav.dart';

/// Nome para exibir: nome do perfil ou, na falta dele, o e-mail.
///
/// @param usuario usuário autenticado.
/// @return texto de identificação do usuário.
String nomeDeExibicao(User usuario) {
  final nome = usuario.displayName?.trim() ?? '';
  return nome.isEmpty ? (usuario.email ?? '') : nome;
}

/// Monta as 4 abas da área logada (ordem = ordem na barra).
///
/// @param usuario usuário autenticado.
/// @param aoSair ação de encerrar a sessão.
/// @return lista de [ItemNav] para o componente `Nav`.
List<ItemNav> construirItensNavegacao({
  required User usuario,
  required Future<void> Function() aoSair,
}) {
  return [
    ItemNav(
      rotulo: 'Dashboard',
      icone: Icons.dashboard_outlined,
      iconeSelecionado: Icons.dashboard,
      construirRaiz: (_) => const TelaDashboard(),
    ),
    ItemNav(
      rotulo: 'Exercícios',
      icone: Icons.fitness_center_outlined,
      iconeSelecionado: Icons.fitness_center,
      construirRaiz: (_) => const TelaExercicios(),
    ),
    ItemNav(
      rotulo: 'Analytics',
      icone: Icons.insights_outlined,
      iconeSelecionado: Icons.insights,
      construirRaiz: (_) => const TelaAnalytics(),
    ),
    ItemNav(
      rotulo: 'Perfil',
      icone: Icons.person_outline,
      iconeSelecionado: Icons.person,
      construirRaiz: (_) => TelaPerfil(
        nome: nomeDeExibicao(usuario),
        email: usuario.email ?? '',
        aoSair: aoSair,
      ),
    ),
  ];
}
