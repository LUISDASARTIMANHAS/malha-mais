// lib/telas/portao_autenticacao.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:malhamais/servicos/servico_autenticacao.dart';

import 'tela_login.dart';
import 'tela_principal_navegacao.dart';

/// Decide entre login e área logada conforme o estado da sessão.
///
/// A tela muda automaticamente ao logar/deslogar, sem navegação manual
/// e sem listeners vazando.
class PortaoAutenticacao extends StatefulWidget {
  const PortaoAutenticacao({super.key});

  @override
  State<PortaoAutenticacao> createState() => _PortaoAutenticacaoState();
}

class _PortaoAutenticacaoState extends State<PortaoAutenticacao> {
  final _servico = ServicoAutenticacao();
  // Guardado no estado para não reassinar o fluxo a cada rebuild.
  late final Stream<User?> _fluxo = _servico.usuarioAtual;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _fluxo,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final usuario = snapshot.data;
        if (usuario == null) return const TelaLogin();
        return TelaPrincipalNavegacao(usuario: usuario, aoSair: _servico.sair);
      },
    );
  }
}
