// lib/telas/controle_interacao/controle_tela_perfil.dart

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malhamais/dominio/perfil_usuario.dart';
import 'package:malhamais/servicos/servico_perfil.dart';

/// Controla estado e ações da [TelaPerfil].
class ControleTelaPerfil extends ChangeNotifier {
  ControleTelaPerfil({
    required User usuario,
    ServicoPerfil? servico,
    ImagePicker? seletor,
  }) : _usuario = usuario,
       _servico = servico ?? ServicoPerfil(),
       _seletor = seletor ?? ImagePicker() {
    _assinar();
  }

  final User _usuario;
  final ServicoPerfil _servico;
  final ImagePicker _seletor;

  StreamSubscription<PerfilUsuario>? _subPerfil;
  StreamSubscription<ProgressoAtual>? _subProgresso;

  PerfilUsuario? _perfil;
  ProgressoAtual _progresso = ProgressoAtual.vazio;
  String? _erro;
  bool _ocupado = false;
  bool _descartado = false;

  PerfilUsuario? get perfil => _perfil;
  ProgressoAtual get progresso => _progresso;
  String? get erro => _erro;
  bool get ocupado => _ocupado;

  void _assinar() {
    _subPerfil = _servico
        .observarPerfil(_usuario)
        .listen(
          (perfil) {
            _perfil = perfil;
            _erro = null;
            _notificar();
          },
          onError: (_) {
            _erro = 'Não foi possível carregar seu perfil.';
            _notificar();
          },
        );
    _subProgresso = _servico.observarProgresso(_usuario.uid).listen(
      (progresso) {
        _progresso = progresso;
        _notificar();
      },
      // Sem progresso disponível, as barras ficam em zero.
      onError: (_) {},
    );
  }

  /// Reassina os fluxos após uma falha de carregamento.
  void tentarNovamente() {
    _subPerfil?.cancel();
    _subProgresso?.cancel();
    _erro = null;
    _notificar();
    _assinar();
  }

  Future<ResultadoOperacao> _executar(
    Future<ResultadoOperacao> Function() acao,
  ) async {
    if (_ocupado)
      return const ResultadoOperacao.erro('Aguarde a operação atual.');
    _ocupado = true;
    _notificar();
    try {
      return await acao();
    } finally {
      _ocupado = false;
      _notificar();
    }
  }

  /// Salva dados físicos (campos nulos são ignorados).
  ///
  /// @param alturaCm altura em cm (já convertida).
  /// @param pesoKg peso em kg (já convertido).
  /// @param pesoMetaKg meta de peso em kg (já convertida).
  Future<ResultadoOperacao> salvarDadosPessoais({
    DateTime? dataNascimento,
    Genero? genero,
    double? alturaCm,
    double? pesoKg,
    double? pesoMetaKg,
  }) {
    return _executar(
      () => _servico.salvarCampos(_usuario.uid, {
        if (dataNascimento != null)
          'dataNascimento': PerfilUsuario.dataParaIso(dataNascimento),
        if (genero != null) 'genero': genero.name,
        if (alturaCm != null) 'alturaCm': alturaCm,
        if (pesoKg != null) 'pesoKg': pesoKg,
        if (pesoMetaKg != null) 'pesoMetaKg': pesoMetaKg,
      }),
    );
  }

  /// @param metas objetivos completos a salvar.
  Future<ResultadoOperacao> salvarMetas(MetasUsuario metas) => _executar(
    () => _servico.salvarCampos(_usuario.uid, {'metas': metas.toMap()}),
  );

  /// @param modalidade modalidade a marcar/desmarcar.
  Future<ResultadoOperacao> alternarModalidade(Modalidade modalidade) {
    final ativa = !(_perfil?.modalidades.contains(modalidade) ?? false);
    return _servico.alternarModalidade(_usuario.uid, modalidade, ativa);
  }

  Future<ResultadoOperacao> definirUnidades(SistemaUnidades unidades) =>
      _servico.salvarCampos(_usuario.uid, {'unidades': unidades.name});

  Future<ResultadoOperacao> definirVisibilidade(VisibilidadePerfil v) =>
      _servico.salvarCampos(_usuario.uid, {'visibilidade': v.name});

  /// @param chave uma das [PreferenciasNotificacao.chaves].
  /// @param valor novo estado.
  Future<ResultadoOperacao> definirNotificacao(String chave, bool valor) {
    if (!PreferenciasNotificacao.chaves.contains(chave)) {
      return Future.value(const ResultadoOperacao.erro('Opção inválida.'));
    }
    return _servico.salvarCampos(_usuario.uid, {
      'notificacoes': {chave: valor},
    });
  }

  Future<ResultadoOperacao> salvarNome(String nome) =>
      _executar(() => _servico.atualizarNome(_usuario, nome));

  Future<ResultadoOperacao> solicitarTrocaEmail(String email) =>
      _executar(() => _servico.solicitarTrocaEmail(_usuario, email));

  Future<ResultadoOperacao> redefinirSenha() {
    final email = _perfil?.email ?? '';
    if (email.isEmpty) {
      return Future.value(const ResultadoOperacao.erro('E-mail indisponível.'));
    }
    return _executar(() => _servico.enviarRedefinicaoSenha(email));
  }

  /// Abre a galeria e envia a foto escolhida.
  Future<ResultadoOperacao> escolherFoto() async {
    try {
      final arquivo = await _seletor.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (arquivo == null) return const ResultadoOperacao.sucesso();
      final bytes = await arquivo.readAsBytes();
      return _executar(() => _servico.enviarFoto(_usuario, bytes));
    } catch (_) {
      return const ResultadoOperacao.erro('Não foi possível abrir a galeria.');
    }
  }

  Future<ResultadoOperacao> removerFoto() =>
      _executar(() => _servico.removerFoto(_usuario));

  void _notificar() {
    if (!_descartado) notifyListeners();
  }

  @override
  void dispose() {
    _descartado = true;
    _subPerfil?.cancel();
    _subProgresso?.cancel();
    super.dispose();
  }
}
