// lib/util/formatadores.dart

/// Funções puras de formatação de texto (sem dependência de `intl`).
class Formatadores {
  Formatadores._();

  static const List<String> _dias = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];
  static const List<String> _meses = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// Inteiro com separador de milhar. Ex.: `1850` -> `1,850`.
  ///
  /// @param valor número a formatar.
  /// @return texto formatado.
  static String milhar(int valor) {
    final digitos = valor.abs().toString();
    final saida = StringBuffer();
    for (var i = 0; i < digitos.length; i++) {
      if (i > 0 && (digitos.length - i) % 3 == 0) saida.write(',');
      saida.write(digitos[i]);
    }
    return valor < 0 ? '-$saida' : saida.toString();
  }

  /// Decimal com casas fixas. Ex.: `2.4` -> `2.4`.
  ///
  /// @param valor número a formatar.
  /// @param casas quantidade de casas decimais.
  /// @return texto formatado.
  static String decimal(double valor, {int casas = 1}) =>
      valor.toStringAsFixed(casas);

  /// Duração em minutos. Ex.: `452` -> `7h 32m`.
  ///
  /// @param minutos total de minutos.
  /// @return texto formatado.
  static String duracao(int minutos) {
    final horas = minutos ~/ 60;
    final resto = minutos % 60;
    return horas == 0 ? '${resto}m' : '${horas}h ${resto}m';
  }

  /// Data curta. Ex.: `Tue, Nov 3`.
  ///
  /// @param data data a formatar.
  /// @return texto formatado.
  static String dataCurta(DateTime data) =>
      '${_dias[data.weekday - 1]}, ${_meses[data.month - 1]} ${data.day}';

  /// Saudação conforme o horário.
  ///
  /// @param agora instante atual.
  /// @return `Good morning`, `Good afternoon` ou `Good evening`.
  static String saudacao(DateTime agora) {
    if (agora.hour < 12) return 'Good morning';
    if (agora.hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  /// Primeiro nome; se vier um e-mail, usa a parte antes do `@`.
  ///
  /// @param nome nome completo ou e-mail.
  /// @return primeiro nome (vazio se não houver).
  static String primeiroNome(String nome) {
    final base = nome.trim().split('@').first.trim();
    if (base.isEmpty) return '';
    return base.split(RegExp(r'\s+')).first;
  }
}
