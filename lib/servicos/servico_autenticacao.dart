import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Resultado de uma operação de autenticação.
class ResultadoAutenticacao {
  const ResultadoAutenticacao.sucesso() : mensagemErro = null;
  const ResultadoAutenticacao.erro(String this.mensagemErro);

  final String? mensagemErro;

  bool get sucesso => mensagemErro == null;
}

/// Encapsula Firebase Auth/Firestore e traduz erros em mensagens seguras.
///
/// Mensagens de credencial são propositalmente genéricas para evitar
/// enumeração de usuários (descobrir quais e-mails têm conta).
class ServicoAutenticacao {
  ServicoAutenticacao({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  /// Fluxo com o usuário autenticado (`null` quando deslogado).
  Stream<User?> get usuarioAtual => _auth.authStateChanges();

  /// Autentica com e-mail e senha.
  ///
  /// @param email e-mail já aparado.
  /// @param senha senha exatamente como digitada.
  /// @return [ResultadoAutenticacao] com sucesso ou mensagem de erro.
  Future<ResultadoAutenticacao> entrar({
    required String email,
    required String senha,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      return const ResultadoAutenticacao.sucesso();
    } on FirebaseAuthException catch (e) {
      return ResultadoAutenticacao.erro(_traduzirErro(e.code));
    } catch (_) {
      return const ResultadoAutenticacao.erro(
        'Não foi possível entrar. Tente novamente.',
      );
    }
  }

  /// Cria a conta, o perfil em `usuarios/{uid}` e dispara a verificação de e-mail.
  ///
  /// A conta já nasce autenticada. Falhas ao montar o perfil não derrubam o
  /// cadastro (o perfil pode ser completado depois).
  ///
  /// @param nome nome de exibição já aparado.
  /// @param email e-mail já aparado.
  /// @param senha senha exatamente como digitada.
  /// @return [ResultadoAutenticacao] com sucesso ou mensagem de erro.
  Future<ResultadoAutenticacao> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    try {
      final credencial = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      final usuario = credencial.user;
      if (usuario != null) await _montarPerfil(usuario, nome);
      return const ResultadoAutenticacao.sucesso();
    } on FirebaseAuthException catch (e) {
      return ResultadoAutenticacao.erro(_traduzirErroCadastro(e.code));
    } catch (_) {
      return const ResultadoAutenticacao.erro(
        'Não foi possível criar a conta. Tente novamente.',
      );
    }
  }

  /// Envia e-mail de redefinição de senha.
  ///
  /// Sempre retorna sucesso para falhas de "usuário inexistente",
  /// evitando revelar se o e-mail está cadastrado.
  ///
  /// @param email e-mail já aparado e validado.
  Future<ResultadoAutenticacao> recuperarSenha(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return const ResultadoAutenticacao.sucesso();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        return const ResultadoAutenticacao.sucesso();
      }
      return ResultadoAutenticacao.erro(_traduzirErro(e.code));
    } catch (_) {
      return const ResultadoAutenticacao.erro('Falha ao enviar o e-mail.');
    }
  }

  /// Encerra a sessão.
  Future<void> sair() => _auth.signOut();

  /// Cada etapa é independente: uma falha não impede as demais.
  Future<void> _montarPerfil(User usuario, String nome) async {
    await _tentar(() => usuario.updateDisplayName(nome));
    await _tentar(
      () => _firestore.collection('usuarios').doc(usuario.uid).set({
        'nome': nome,
        'email': usuario.email,
        'criadoEm': FieldValue.serverTimestamp(),
      }),
    );
    await _tentar(usuario.sendEmailVerification);
  }

  Future<void> _tentar(Future<void> Function() acao) async {
    try {
      await acao();
    } catch (_) {
      // Melhor esforço: o perfil pode ser completado depois.
    }
  }

  String _traduzirErro(String codigo) {
    switch (codigo) {
      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-email':
        return 'E-mail ou senha incorretos';
      case 'user-disabled':
        return 'Esta conta está desativada';
      case 'too-many-requests':
        return 'Muitas tentativas. Aguarde alguns minutos e tente de novo';
      case 'network-request-failed':
        return 'Sem conexão com a internet';
      default:
        return 'Não foi possível entrar. Tente novamente';
    }
  }

  /// Mensagem de e-mail duplicado é genérica de propósito (anti-enumeração).
  String _traduzirErroCadastro(String codigo) {
    switch (codigo) {
      case 'email-already-in-use':
      case 'invalid-email':
        return 'Não foi possível criar a conta com esses dados. '
            'Se já tem conta, entre ou recupere a senha';
      case 'weak-password':
        return 'Escolha uma senha mais forte';
      case 'too-many-requests':
        return 'Muitas tentativas. Aguarde alguns minutos e tente de novo';
      case 'network-request-failed':
        return 'Sem conexão com a internet';
      default:
        return 'Não foi possível criar a conta. Tente novamente';
    }
  }
}
