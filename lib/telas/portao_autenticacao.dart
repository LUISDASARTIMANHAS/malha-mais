import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:malhamais/servicos/servico_autenticacao.dart';

import 'tela_login.dart';

/// Decide entre login e área logada conforme o estado da sessão.
///
/// Substitui a navegação manual com `push(replace: true)`: a tela muda
/// automaticamente ao logar/deslogar, sem listeners vazando.
class PortaoAutenticacao extends StatelessWidget {
  const PortaoAutenticacao({super.key});

  @override
  Widget build(BuildContext context) {
    final servico = ServicoAutenticacao();

    return StreamBuilder<User?>(
      stream: servico.usuarioAtual,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final usuario = snapshot.data;
        if (usuario == null) return const TelaLogin();
        return _HomeProvisoria(email: usuario.email ?? '', servico: servico);
      },
    );
  }
}

/// Placeholder até a Home real (seleção de categoria) ser construída.
class _HomeProvisoria extends StatelessWidget {
  const _HomeProvisoria({required this.email, required this.servico});

  final String email;
  final ServicoAutenticacao servico;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Malha+'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
            onPressed: servico.sair,
          ),
        ],
      ),
      body: Center(child: Text('Logado como $email')),
    );
  }
}
