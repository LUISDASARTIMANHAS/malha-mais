import 'package:flutter/material.dart';
import 'package:malhamais/util/widget/avatar_inicial.dart';
import 'package:malhamais/util/widget/dialogo_confirmacao.dart';

/// Aba de perfil: identidade do usuário e sessão.
class TelaPerfil extends StatelessWidget {
  const TelaPerfil({
    super.key,
    required this.nome,
    required this.email,
    required this.aoSair,
  });

  final String nome;
  final String email;
  final Future<void> Function() aoSair;

  Future<void> _aoTocarSair(BuildContext context) async {
    final confirmou = await confirmarAcao(
      context,
      titulo: 'Sair da conta?',
      mensagem: 'Você precisará entrar novamente para treinar.',
      textoConfirmar: 'Sair',
    );
    if (confirmou) await aoSair();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(child: AvatarInicial(nome: nome)),
          const SizedBox(height: 12),
          Text(nome,
              textAlign: TextAlign.center,
              style: tema.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          Text(email,
              textAlign: TextAlign.center, style: tema.textTheme.bodyMedium),
          const SizedBox(height: 32),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: tema.colorScheme.error),
            title: Text('Sair', style: TextStyle(color: tema.colorScheme.error)),
            onTap: () => _aoTocarSair(context),
          ),
        ],
      ),
    );
  }
}
