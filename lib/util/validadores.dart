// lib/util/validadores.dart

import 'package:email_validator/email_validator.dart';
import 'package:flutter/widgets.dart' show FormFieldValidator;
import 'package:malhamais/util/unidades.dart';

/// Requisitos de uma senha nova, avaliados em tempo real no cadastro.
class RequisitosSenha {
  const RequisitosSenha(this.senha);

  final String senha;

  bool get tamanho => senha.length >= Validadores.tamanhoMinimoSenha;
  bool get minuscula => senha.contains(RegExp(r'[a-z]'));
  bool get maiuscula => senha.contains(RegExp(r'[A-Z]'));
  bool get numero => senha.contains(RegExp(r'\d'));

  /// Quantidade de requisitos atendidos (0 a 4).
  int get atendidos =>
      [tamanho, minuscula, maiuscula, numero].where((ok) => ok).length;

  bool get valida => atendidos == 4;
}

/// Validadores reutilizáveis para campos de formulário.
///
/// Cada método retorna `null` quando o valor é válido ou a mensagem de erro.
class Validadores {
  Validadores._();

  static const int tamanhoMaximoEmail = 254;
  static const int tamanhoMinimoSenha = 8;
  static const int tamanhoMaximoSenha = 128;
  static const int tamanhoMaximoNome = 60;

  static final RegExp _padraoNome = RegExp(
    r"^\p{L}[\p{L}\p{M} '.-]*$",
    unicode: true,
  );

  /// Converte texto com vírgula ou ponto em número (rejeita NaN/infinito).
  ///
  /// @param texto valor digitado.
  /// @return número ou `null` se inválido.
  static double? lerDecimal(String texto) {
    final numero = double.tryParse(texto.trim().replaceAll(',', '.'));
    return numero != null && numero.isFinite ? numero : null;
  }

  /// Valida decimal dentro de um intervalo.
  ///
  /// @param valor texto digitado.
  /// @param min limite inferior (na unidade exibida).
  /// @param max limite superior (na unidade exibida).
  /// @param obrigatorio se `false`, vazio é aceito.
  /// @param unidade rótulo mostrado na mensagem.
  /// @return mensagem de erro ou `null`.
  static String? decimalEntre(
    String? valor, {
    required double min,
    required double max,
    bool obrigatorio = true,
    String unidade = '',
  }) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) return obrigatorio ? 'Informe um valor' : null;
    final numero = lerDecimal(texto);
    if (numero == null) return 'Número inválido';
    if (numero < min || numero > max) {
      return 'Use um valor entre ${Unidades.formatar(min)} e '
              '${Unidades.formatar(max)} $unidade'
          .trim();
    }
    return null;
  }

  /// Valida inteiro dentro de um intervalo.
  ///
  /// @param valor texto digitado.
  /// @param min limite inferior.
  /// @param max limite superior.
  /// @return mensagem de erro ou `null`.
  static String? inteiroEntre(
    String? valor, {
    required int min,
    required int max,
  }) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) return 'Informe um valor';
    final numero = int.tryParse(texto);
    if (numero == null) return 'Digite um número inteiro';
    if (numero < min || numero > max) return 'Use um valor entre $min e $max';
    return null;
  }

  /// Valida o nome de exibição (letras, espaços, apóstrofo, ponto e hífen).
  ///
  /// @param valor texto digitado pelo usuário.
  /// @return mensagem de erro ou `null`.
  static String? nome(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.length < 2) return 'Informe seu nome';
    if (texto.length > tamanhoMaximoNome || !_padraoNome.hasMatch(texto)) {
      return 'Use apenas letras no nome';
    }
    return null;
  }

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

  /// Valida uma senha nova conforme a política do cadastro.
  ///
  /// @param valor texto digitado pelo usuário.
  /// @return mensagem de erro ou `null`.
  static String? senhaNova(String? valor) {
    if (valor == null || valor.isEmpty) return 'Crie uma senha';
    if (valor.length > tamanhoMaximoSenha) return 'Senha longa demais';
    if (!RequisitosSenha(valor).valida) {
      return 'A senha não atende a todos os requisitos';
    }
    return null;
  }

  /// Cria o validador do campo "confirmar senha".
  ///
  /// @param obterSenha função que devolve a senha digitada no outro campo.
  /// @return validador pronto para uso em um `TextFormField`.
  static FormFieldValidator<String> confirmacao(String Function() obterSenha) {
    return (String? valor) {
      if (valor == null || valor.isEmpty) return 'Repita a senha';
      if (valor != obterSenha()) return 'As senhas não coincidem';
      return null;
    };
  }
}
