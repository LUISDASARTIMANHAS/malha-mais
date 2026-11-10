// lib/servicos/servico_perfil.dart

import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:malhamais/dominio/perfil_usuario.dart';

/// Resultado de uma operação do perfil.
class ResultadoOperacao {
  const ResultadoOperacao.sucesso() : mensagemErro = null;
  const ResultadoOperacao.erro(String this.mensagemErro);

  final String? mensagemErro;

  bool get sucesso => mensagemErro == null;
}

/// Acesso a perfil, progresso e foto (Firestore, Auth e Storage).
class ServicoPerfil {
  ServicoPerfil({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    FirebaseStorage? storage,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance,
       _storage = storage ?? FirebaseStorage.instance;

  static const int _tamanhoMaximoFoto = 2 * 1024 * 1024;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _firestore.collection('usuarios').doc(uid);

  /// Perfil em tempo real.
  ///
  /// @param usuario usuário autenticado.
  Stream<PerfilUsuario> observarPerfil(User usuario) {
    return _doc(usuario.uid).snapshots().map(
      (snap) => PerfilUsuario.fromMap(
        snap.data(),
        nomePadrao: _nomePadrao(usuario),
        email: _auth.currentUser?.email ?? usuario.email ?? '',
      ),
    );
  }

  /// Progresso real das metas (documento escrito só pelo servidor).
  ///
  /// @param uid id do usuário.
  Stream<ProgressoAtual> observarProgresso(String uid) => _doc(uid)
      .collection('resumo')
      .doc('atual')
      .snapshots()
      .map((snap) => ProgressoAtual.fromMap(snap.data()));

  /// Grava campos do perfil (merge). As regras do Firestore validam o conteúdo.
  ///
  /// @param uid id do usuário.
  /// @param campos campos a atualizar.
  Future<ResultadoOperacao> salvarCampos(
    String uid,
    Map<String, Object?> campos,
  ) => _proteger(() => _doc(uid).set(campos, SetOptions(merge: true)));

  /// Marca/desmarca uma modalidade de forma atômica.
  ///
  /// @param uid id do usuário.
  /// @param modalidade modalidade alvo.
  /// @param ativa `true` para adicionar.
  Future<ResultadoOperacao> alternarModalidade(
    String uid,
    Modalidade modalidade,
    bool ativa,
  ) {
    final operacao = ativa
        ? FieldValue.arrayUnion([modalidade.name])
        : FieldValue.arrayRemove([modalidade.name]);
    return salvarCampos(uid, {'modalidades': operacao});
  }

  /// Atualiza o nome no Auth e no perfil.
  Future<ResultadoOperacao> atualizarNome(User usuario, String nome) {
    return _proteger(() async {
      await usuario.updateDisplayName(nome);
      await _doc(usuario.uid).set({'nome': nome}, SetOptions(merge: true));
    });
  }

  /// Pede a troca de e-mail: o e-mail só muda depois do clique no link.
  Future<ResultadoOperacao> solicitarTrocaEmail(User usuario, String novo) {
    return _proteger(
      () => usuario.verifyBeforeUpdateEmail(novo),
      enfileiravel: false,
    );
  }

  /// Envia o e-mail de redefinição de senha.
  Future<ResultadoOperacao> enviarRedefinicaoSenha(String email) {
    return _proteger(
      () => _auth.sendPasswordResetEmail(email: email),
      enfileiravel: false,
    );
  }

  /// Envia a foto de perfil (valida tamanho e formato pelos bytes).
  ///
  /// @param usuario usuário autenticado.
  /// @param bytes conteúdo da imagem.
  Future<ResultadoOperacao> enviarFoto(User usuario, Uint8List bytes) async {
    if (bytes.length > _tamanhoMaximoFoto) {
      return const ResultadoOperacao.erro('A imagem excede 2 MB.');
    }
    final tipo = _tipoImagem(bytes);
    if (tipo == null) {
      return const ResultadoOperacao.erro(
        'Formato não suportado. Use JPEG ou PNG.',
      );
    }
    return _proteger(
      () async {
        final ref = _storage.ref('avatares/${usuario.uid}/perfil');
        await ref.putData(bytes, SettableMetadata(contentType: tipo));
        final url = await ref.getDownloadURL();
        // O "v" evita cache de uma foto antiga (o caminho é sempre o mesmo).
        await _doc(usuario.uid).set({
          'fotoUrl': '$url&v=${DateTime.now().millisecondsSinceEpoch}',
        }, SetOptions(merge: true));
      },
      limite: const Duration(seconds: 40),
      enfileiravel: false,
    );
  }

  /// Remove a foto de perfil.
  Future<ResultadoOperacao> removerFoto(User usuario) {
    return _proteger(() async {
      await _doc(
        usuario.uid,
      ).set({'fotoUrl': FieldValue.delete()}, SetOptions(merge: true));
      try {
        await _storage.ref('avatares/${usuario.uid}/perfil').delete();
      } on FirebaseException {
        // Arquivo já inexistente: nada a fazer.
      }
    });
  }

  String _nomePadrao(User usuario) {
    final nome = usuario.displayName?.trim() ?? '';
    return nome.isNotEmpty ? nome : (usuario.email ?? '');
  }

  /// Detecta o tipo real pelos primeiros bytes (não confia em extensão).
  String? _tipoImagem(Uint8List b) {
    if (b.length > 3 && b[0] == 0xFF && b[1] == 0xD8 && b[2] == 0xFF) {
      return 'image/jpeg';
    }
    if (b.length > 4 &&
        b[0] == 0x89 &&
        b[1] == 0x50 &&
        b[2] == 0x4E &&
        b[3] == 0x47) {
      return 'image/png';
    }
    return null;
  }

  /// Executa uma ação traduzindo falhas em mensagens seguras.
  ///
  /// Escritas do Firestore ficam na fila quando offline; por isso, para
  /// [enfileiravel] = `true`, o timeout conta como sucesso (o app já mostra
  /// o dado local e sincroniza depois).
  Future<ResultadoOperacao> _proteger(
    Future<void> Function() acao, {
    Duration limite = const Duration(seconds: 8),
    bool enfileiravel = true,
  }) async {
    try {
      await acao().timeout(limite);
      return const ResultadoOperacao.sucesso();
    } on TimeoutException {
      return enfileiravel
          ? const ResultadoOperacao.sucesso()
          : const ResultadoOperacao.erro(
              'A operação demorou demais. Verifique sua conexão.',
            );
    } on FirebaseException catch (e) {
      return ResultadoOperacao.erro(_traduzir(e.code));
    } catch (_) {
      return const ResultadoOperacao.erro('Algo deu errado. Tente novamente.');
    }
  }

  String _traduzir(String codigo) {
    switch (codigo) {
      case 'permission-denied':
      case 'unauthorized':
        return 'Você não tem permissão para esta alteração.';
      case 'requires-recent-login':
        return 'Por segurança, saia e entre novamente para concluir esta ação.';
      case 'network-request-failed':
      case 'unavailable':
        return 'Sem conexão com a internet.';
      case 'too-many-requests':
        return 'Muitas tentativas. Aguarde alguns minutos.';
      case 'email-already-in-use':
      case 'invalid-email':
        return 'Não foi possível usar esse e-mail.';
      default:
        return 'Algo deu errado. Tente novamente.';
    }
  }
}
