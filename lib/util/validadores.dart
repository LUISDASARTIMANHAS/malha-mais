import 'package:email_validator/email_validator.dart';

/// Validadores reutilizáveis para campos de formulário.
///
/// Cada método retorna `null` quando o valor é válido ou a mensagem de erro.
class Validadores {
  Validadores._();

  static const int tamanhoMaximoEmail = 254;
  static const int tamanhoMaximoSenha = 128;

  /// Valida o formato de e-mail.
  ///
  /// @param valor texto digitado pelo usuário.
  /// @return mensagem de erro ou `null`.
  static String? email(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) return 'Informe o e-mail';
    if (texto.length > tamanhoMaximoEmail || !EmailValidator.validate(texto)) {
      return 'Informe um e-mail válido';
    }
    return null;
  }

  /// Valida a senha no login.
  ///
  /// Não revela a política de senha (isso é papel do cadastro).
  /// A senha NÃO é aparada com trim: espaços podem fazer parte dela.
  ///
  /// @param valor texto digitado pelo usuário.
  /// @return mensagem de erro ou `null`.
  static String? senhaLogin(String? valor) {
    if (valor == null || valor.isEmpty) return 'Informe a senha';
    if (valor.length > tamanhoMaximoSenha) return 'Senha inválida';
    return null;
  }
}
