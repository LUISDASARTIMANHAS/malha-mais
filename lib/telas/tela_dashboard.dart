// lib/telas/tela_dashboard.dart

import 'package:flutter/material.dart';
import 'package:malhamais/telas/controle_interacao/controle_tela_dashboard.dart';
import 'package:malhamais/telas/localwidget/cabecalho_dashboard.dart';
import 'package:malhamais/telas/localwidget/card_batimentos.dart';
import 'package:malhamais/telas/localwidget/card_resumo_atividade.dart';
import 'package:malhamais/telas/localwidget/secao_progresso_diario.dart';
import 'package:malhamais/util/tema/cores_malha.dart';
import 'package:malhamais/util/widget/fundo_brilho.dart';
import 'package:malhamais/util/widget/menu_lateral_malha.dart';
import 'package:malhamais/util/widget/nav/nav_controller.dart';

/// Aba inicial: resumo de desempenho, batimentos e atividade do dia.
class TelaDashboard extends StatefulWidget {
  const TelaDashboard({super.key, required this.nome});

  /// Nome de exibição do usuário logado.
  final String nome;

  @override
  State<TelaDashboard> createState() => _TelaDashboardState();
}

class _TelaDashboardState extends State<TelaDashboard> {
  // Posições das abas na barra (ver itens_navegacao.dart).
  static const int _abaExercicios = 1;
  static const int _abaAnalytics = 2;
  static const int _abaPerfil = 3;

  final _chaveScaffold = GlobalKey<ScaffoldState>();
  late final ControleTelaDashboard _controle;

  @override
  void initState() {
    super.initState();
    _controle = ControleTelaDashboard(nomeCompleto: widget.nome)..carregar();
  }

  @override
  void dispose() {
    _controle.dispose();
    super.dispose();
  }

  void _irParaAba(int indice) {
    final nav = NavEscopo.ler(context);
    _chaveScaffold.currentState?.closeDrawer();
    nav.irPara(indice);
  }

  void _abrirNotificacoes() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('No new notifications')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _chaveScaffold,
      backgroundColor: CoresMalha.fundo,
      drawer: MenuLateralMalha(
        nome: widget.nome,
        itens: [
          ItemMenuLateral(
            icone: Icons.fitness_center,
            rotulo: 'Workouts',
            aoTocar: () => _irParaAba(_abaExercicios),
          ),
          ItemMenuLateral(
            icone: Icons.insights,
            rotulo: 'Analytics',
            aoTocar: () => _irParaAba(_abaAnalytics),
          ),
          ItemMenuLateral(
            icone: Icons.person,
            rotulo: 'Profile',
            aoTocar: () => _irParaAba(_abaPerfil),
          ),
        ],
      ),
      body: FundoBrilho(
        child: SafeArea(
          bottom: false,
          child: ListenableBuilder(
            listenable: _controle,
            builder: (context, _) => _conteudo(),
          ),
        ),
      ),
    );
  }

  Widget _conteudo() {
    final resumo = _controle.resumo;

    if (resumo == null) {
      return _controle.mensagemErro == null
          ? const Center(child: CircularProgressIndicator())
          : _erro();
    }

    return RefreshIndicator(
      color: CoresMalha.verdeNeon,
      backgroundColor: CoresMalha.cartao,
      onRefresh: _controle.carregar,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          CabecalhoDashboard(
            nome: widget.nome,
            saudacao: _controle.saudacao,
            aoAbrirMenu: () => _chaveScaffold.currentState?.openDrawer(),
            aoAbrirNotificacoes: _abrirNotificacoes,
            aoAbrirPerfil: () => _irParaAba(_abaPerfil),
          ),
          const SizedBox(height: 24),
          SecaoProgressoDiario(resumo: resumo, data: _controle.data),
          const SizedBox(height: 16),
          CardBatimentos(resumo: resumo),
          const SizedBox(height: 16),
          CardResumoAtividade(resumo: resumo),
        ],
      ),
    );
  }

  Widget _erro() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_controle.mensagemErro!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(160, 48)),
              onPressed: _controle.carregar,
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
