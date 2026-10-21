import 'package:firebase_auth/firebase_auth.dart';

/// Resultado de uma operação de autenticação.
class ResultadoAutenticacao {
  const ResultadoAutenticacao.sucesso() : mensagemErro = null;
  const ResultadoAutenticacao.erro(String this.mensagemErro);

  final String? mensagemErro;

  bool get sucesso => mensagemErro == null;
}

/// Encapsula o FirebaseAuth e traduz erros em mensagens seguras.
///
/// Mensagens de credencial são propositalmente genéricas para evitar
/// enumeração de usuários (descobrir quais e-mails têm conta).
class ServicoAutenticacao {
  ServicoAutenticacao({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

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
}
