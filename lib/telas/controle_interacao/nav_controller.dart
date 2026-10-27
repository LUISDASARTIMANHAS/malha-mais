import 'package:flutter/material.dart';

/// Controla a aba ativa e a pilha de telas de cada aba do [Nav].
class NavController extends ChangeNotifier {
  NavController({required int quantidade, int indiceInicial = 0})
      : assert(quantidade > 0, 'O Nav precisa de ao menos uma aba'),
        assert(indiceInicial >= 0 && indiceInicial < quantidade),
        inicial = indiceInicial,
        _indice = indiceInicial,
        chaves = List.generate(quantidade, (_) => GlobalKey<NavigatorState>());

  /// Aba exibida ao abrir e para onde o botão "voltar" retorna.
  final int inicial;

  /// Chave do [Navigator] de cada aba.
  final List<GlobalKey<NavigatorState>> chaves;

  int _indice;

  /// Aba atualmente visível.
  int get indice => _indice;

  /// Quantidade de abas.
  int get quantidade => chaves.length;

  /// Vai para uma aba; se já estiver nela, volta ao início da pilha.
  ///
  /// @param indice posição da aba de destino.
  void irPara(int indice) {
    RangeError.checkValidIndex(indice, chaves, 'indice');
    if (indice == _indice) {
      voltarAoInicio(indice);
      return;
    }
    _indice = indice;
    notifyListeners();
  }

  /// Fecha todas as telas empilhadas de uma aba, deixando só a raiz.
  ///
  /// @param aba aba alvo (padrão: a ativa).
  void voltarAoInicio([int? aba]) {
    chaves[aba ?? _indice].currentState?.popUntil((rota) => rota.isFirst);
  }

  /// Trata o botão "voltar" do sistema dentro do app.
  ///
  /// Ordem: fecha tela da aba ativa → volta à aba inicial.
  ///
  /// @return `true` se tratou o gesto; `false` se o app pode sair.
  Future<bool> voltar() async {
    final fechouTela = await chaves[_indice].currentState?.maybePop();
    if (fechouTela ?? false) return true;
    if (_indice != inicial) {
      _indice = inicial;
      notifyListeners();
      return true;
    }
    return false;
  }
}

/// Disponibiliza o [NavController] para as telas dentro do [Nav].
///
/// Permite que qualquer tela troque de aba, ex.:
/// `NavEscopo.ler(context).irPara(1)`.
class NavEscopo extends InheritedNotifier<NavController> {
  const NavEscopo({
    super.key,
    required NavController controller,
    required super.child,
  }) : super(notifier: controller);

  /// Obtém o controlador e reconstrói a tela quando a aba ativa mudar.
  ///
  /// @param context contexto de um descendente do [Nav].
  static NavController of(BuildContext context) {
    final escopo =
        context.dependOnInheritedWidgetOfExactType<NavEscopo>();
    assert(escopo != null, 'NavEscopo não encontrado acima deste contexto');
    return escopo!.notifier!;
  }

  /// Obtém o controlador sem reconstruir a tela (ideal para ações/botões).
  ///
  /// @param context contexto de um descendente do [Nav].
  static NavController ler(BuildContext context) {
    final escopo =
        context.getInheritedWidgetOfExactType<NavEscopo>();
    assert(escopo != null, 'NavEscopo não encontrado acima deste contexto');
    return escopo!.notifier!;
  }
}
