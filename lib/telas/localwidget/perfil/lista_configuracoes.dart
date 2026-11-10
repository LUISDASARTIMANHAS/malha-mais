// lib/telas/localwidget/perfil/lista_configuracoes.dart

import 'package:flutter/material.dart';
import 'package:malhamais/dominio/perfil_usuario.dart';
import 'package:malhamais/telas/localwidget/perfil/cartao_malha.dart';

/// Lista de opções de configuração do perfil.
class ListaConfiguracoes extends StatelessWidget {
  const ListaConfiguracoes({
    super.key,
    required this.unidades,
    required this.aoAbrirDadosPessoais,
    required this.aoAbrirNotificacoes,
    required this.aoAbrirPrivacidade,
    required this.aoAbrirDispositivos,
    required this.aoAbrirUnidades,
    required this.aoAbrirAjuda,
    required this.aoSair,
  });

  final SistemaUnidades unidades;
  final VoidCallback aoAbrirDadosPessoais;
  final VoidCallback aoAbrirNotificacoes;
  final VoidCallback aoAbrirPrivacidade;
  final VoidCallback aoAbrirDispositivos;
  final VoidCallback aoAbrirUnidades;
  final VoidCallback aoAbrirAjuda;
  final VoidCallback aoSair;

  @override
  Widget build(BuildContext context) {
    final erro = Theme.of(context).colorScheme.error;

    final itens = <Widget>[
      _item(Icons.badge_outlined, 'Dados pessoais', aoAbrirDadosPessoais),
      _item(Icons.notifications_outlined, 'Notificações', aoAbrirNotificacoes),
      _item(Icons.lock_outline, 'Privacidade e segurança', aoAbrirPrivacidade),
      _item(
        Icons.watch_outlined,
        'Dispositivos conectados',
        aoAbrirDispositivos,
      ),
      _item(
        Icons.straighten,
        'Unidades',
        aoAbrirUnidades,
        subtitulo: unidades == SistemaUnidades.metrico
            ? 'Métrico (kg, cm)'
            : 'Imperial (lb, in)',
      ),
      _item(Icons.help_outline, 'Ajuda e suporte', aoAbrirAjuda),
      _item(Icons.logout, 'Sair', aoSair, cor: erro, seta: false),
    ];

    return CartaoMalha(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < itens.length; i++) ...[
            itens[i],
            if (i < itens.length - 1) const Divider(height: 1, indent: 56),
          ],
        ],
      ),
    );
  }

  Widget _item(
    IconData icone,
    String titulo,
    VoidCallback aoTocar, {
    String? subtitulo,
    Color? cor,
    bool seta = true,
  }) {
    return ListTile(
      leading: Icon(icone, color: cor),
      title: Text(titulo, style: TextStyle(color: cor)),
      subtitle: subtitulo == null ? null : Text(subtitulo),
      trailing: seta ? const Icon(Icons.chevron_right) : null,
      onTap: aoTocar,
    );
  }
}
