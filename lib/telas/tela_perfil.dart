// lib/telas/tela_perfil.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:malhamais/dominio/perfil_usuario.dart';
import 'package:malhamais/telas/controle_interacao/controle_tela_perfil.dart';
import 'package:malhamais/telas/localwidget/perfil/cabecalho_perfil.dart';
import 'package:malhamais/telas/localwidget/perfil/cartao_dados_pessoais.dart';
import 'package:malhamais/telas/localwidget/perfil/folhas_perfil.dart';
import 'package:malhamais/telas/localwidget/perfil/lista_configuracoes.dart';
import 'package:malhamais/telas/localwidget/perfil/secao_metas.dart';
import 'package:malhamais/telas/localwidget/perfil/secao_preferencias.dart';
import 'package:malhamais/util/widget/dialogo_confirmacao.dart';

/// Aba de perfil: identidade, dados, metas, preferências e configurações.
class TelaPerfil extends StatefulWidget {
  const TelaPerfil({super.key, required this.usuario, required this.aoSair});

  final User usuario;
  final Future<void> Function() aoSair;

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  late final ControleTelaPerfil _controle;

  @override
  void initState() {
    super.initState();
    _controle = ControleTelaPerfil(usuario: widget.usuario);
  }

  @override
  void dispose() {
    _controle.dispose();
    super.dispose();
  }

  Future<void> _aoTocarSair() async {
    final confirmou = await confirmarAcao(
      context,
      titulo: 'Sair da conta?',
      mensagem: 'Você precisará entrar novamente para treinar.',
      textoConfirmar: 'Sair',
    );
    if (confirmou) await widget.aoSair();
  }

  Future<void> _alternarModalidade(Modalidade modalidade) async {
    final mensageiro = ScaffoldMessenger.of(context);
    final r = await _controle.alternarModalidade(modalidade);
    if (!r.sucesso) {
      mensageiro.showSnackBar(SnackBar(content: Text(r.mensagemErro!)));
    }
  }

  void _dialogo(String titulo, String texto) {
    showDialog<void>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: Text(titulo),
        content: Text(texto),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(contexto).pop(),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        actions: [
          IconButton(
            tooltip: 'Configurações',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => FolhaConfiguracoes.abrir(context, _controle),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _controle,
        builder: (context, _) => _conteudo(),
      ),
    );
  }

  Widget _conteudo() {
    final perfil = _controle.perfil;

    if (perfil == null) {
      if (_controle.erro != null) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_controle.erro!),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _controle.tentarNovamente,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        );
      }
      return const Center(child: CircularProgressIndicator());
    }

    const espaco = SizedBox(height: 20);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            CabecalhoPerfil(
              perfil: perfil,
              aoEditar: () => FolhaEditarPerfil.abrir(context, _controle),
            ),
            espaco,
            CartaoDadosPessoais(
              perfil: perfil,
              aoEditar: () => FolhaEditarDados.abrir(context, _controle),
            ),
            espaco,
            SecaoMetas(
              metas: perfil.metas,
              progresso: _controle.progresso,
              aoEditar: () => FolhaEditarMetas.abrir(context, _controle),
            ),
            espaco,
            SecaoPreferencias(
              selecionadas: perfil.modalidades,
              aoAlternar: _alternarModalidade,
            ),
            espaco,
            ListaConfiguracoes(
              unidades: perfil.unidades,
              aoAbrirDadosPessoais: () =>
                  FolhaEditarDados.abrir(context, _controle),
              aoAbrirNotificacoes: () =>
                  FolhaNotificacoes.abrir(context, _controle),
              aoAbrirPrivacidade: () =>
                  FolhaPrivacidade.abrir(context, _controle),
              aoAbrirDispositivos: () => _dialogo(
                'Dispositivos conectados',
                'Nenhum dispositivo conectado. A integração com relógios e '
                    'sensores ainda não está disponível.',
              ),
              aoAbrirUnidades: () => FolhaUnidades.abrir(context, _controle),
              aoAbrirAjuda: () => _dialogo(
                'Ajuda e suporte',
                'A central de ajuda e o contato com o suporte ainda não '
                    'estão disponíveis.',
              ),
              aoSair: _aoTocarSair,
            ),
          ],
        ),
      ),
    );
  }
}
