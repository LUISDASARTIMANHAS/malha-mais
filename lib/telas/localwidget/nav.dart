import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'aba_navegador.dart';
import 'barra_navegacao.dart';
import 'item_nav.dart';
import 'nav_controller.dart';

/// Navegação por abas reutilizável: barra inferior fixa + uma pilha por aba.
///
/// - Abas são construídas sob demanda (na primeira visita) e preservam estado.
/// - Tocar na aba ativa volta ao início dela.
/// - O botão "voltar" fecha telas da aba, depois volta à aba inicial.
/// - Telas internas podem trocar de aba via [NavEscopo].
///
/// A lista de [itens] é lida na criação: não altere a quantidade depois.
class Nav extends StatefulWidget {
  const Nav({super.key, required this.itens, this.controller});

  final List<ItemNav> itens;

  /// Controlador externo (opcional). Se omitido, o [Nav] cria o próprio.
  final NavController? controller;

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  late final NavController _controller;
  late final bool _donoDoController;
  final Set<int> _visitadas = {};

  @override
  void initState() {
    super.initState();
    _donoDoController = widget.controller == null;
    _controller = widget.controller ??
        NavController(quantidade: widget.itens.length);
    assert(_controller.quantidade == widget.itens.length,
        'O controller e os itens precisam ter a mesma quantidade');
    _visitadas.add(_controller.indice);
    _controller.addListener(_aoMudarAba);
  }

  @override
  void dispose() {
    _controller.removeListener(_aoMudarAba);
    if (_donoDoController) _controller.dispose();
    super.dispose();
  }

  void _aoMudarAba() => setState(() => _visitadas.add(_controller.indice));

  Future<void> _aoVoltar(bool jaTratado, Object? _) async {
    if (jaTratado) return;
    if (await _controller.voltar()) return;
    await SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return NavEscopo(
      controller: _controller,
      child: PopScope<Object?>(
        canPop: false,
        onPopInvokedWithResult: _aoVoltar,
        child: Scaffold(
          body: IndexedStack(
            index: _controller.indice,
            children: [
              for (var i = 0; i < widget.itens.length; i++)
                _visitadas.contains(i)
                    ? AbaNavegador(
                        chave: _controller.chaves[i],
                        raiz: widget.itens[i].construirRaiz,
                      )
                    : const SizedBox.shrink(),
            ],
          ),
          bottomNavigationBar: BarraNavegacao(
            itens: widget.itens,
            indiceSelecionado: _controller.indice,
            aoSelecionar: _controller.irPara,
          ),
        ),
      ),
    );
  }
}
