// lib/dominio/perfil_usuario.dart

enum Genero {
  feminino('Feminino'),
  masculino('Masculino'),
  outro('Outro'),
  naoInformar('Prefiro não informar');

  const Genero(this.rotulo);
  final String rotulo;
}

enum Modalidade {
  corrida('Corrida'),
  ciclismo('Ciclismo'),
  musculacao('Musculação'),
  yoga('Yoga');

  const Modalidade(this.rotulo);
  final String rotulo;
}

enum SistemaUnidades {
  metrico('Métrico'),
  imperial('Imperial');

  const SistemaUnidades(this.rotulo);
  final String rotulo;
}

enum VisibilidadePerfil {
  publico('Público'),
  amigos('Amigos'),
  privado('Privado');

  const VisibilidadePerfil(this.rotulo);
  final String rotulo;
}

int? _inteiro(Object? v) => v is num && v.isFinite ? v.toInt() : null;
double? _decimal(Object? v) => v is num && v.isFinite ? v.toDouble() : null;

T? _enumPorNome<T extends Enum>(List<T> valores, Object? nome) {
  for (final valor in valores) {
    if (valor.name == nome) return valor;
  }
  return null;
}

/// Só aceita URLs https (evita esquemas inesperados vindos do banco).
String? _urlSegura(Object? v) {
  if (v is! String) return null;
  final uri = Uri.tryParse(v);
  return uri != null && uri.scheme == 'https' && uri.host.isNotEmpty ? v : null;
}

/// Objetivos do usuário. `null` = ainda não definido.
class MetasUsuario {
  const MetasUsuario({
    this.passosDiarios,
    this.caloriasDiarias,
    this.treinosSemanais,
    this.minutosAtivosDiarios,
  });

  final int? passosDiarios;
  final int? caloriasDiarias;
  final int? treinosSemanais;
  final int? minutosAtivosDiarios;

  factory MetasUsuario.fromMap(Object? bruto) {
    final m = bruto is Map ? bruto : const {};
    return MetasUsuario(
      passosDiarios: _inteiro(m['passosDiarios']),
      caloriasDiarias: _inteiro(m['caloriasDiarias']),
      treinosSemanais: _inteiro(m['treinosSemanais']),
      minutosAtivosDiarios: _inteiro(m['minutosAtivosDiarios']),
    );
  }

  Map<String, Object> toMap() => {
    if (passosDiarios != null) 'passosDiarios': passosDiarios!,
    if (caloriasDiarias != null) 'caloriasDiarias': caloriasDiarias!,
    if (treinosSemanais != null) 'treinosSemanais': treinosSemanais!,
    if (minutosAtivosDiarios != null)
      'minutosAtivosDiarios': minutosAtivosDiarios!,
  };
}

/// Progresso real do dia/semana (escrito apenas pelo servidor).
class ProgressoAtual {
  const ProgressoAtual({
    this.passos = 0,
    this.calorias = 0,
    this.minutosAtivos = 0,
    this.treinosNaSemana = 0,
  });

  static const vazio = ProgressoAtual();

  final int passos;
  final int calorias;
  final int minutosAtivos;
  final int treinosNaSemana;

  factory ProgressoAtual.fromMap(Map<String, dynamic>? m) {
    if (m == null) return vazio;
    return ProgressoAtual(
      passos: _inteiro(m['passos']) ?? 0,
      calorias: _inteiro(m['calorias']) ?? 0,
      minutosAtivos: _inteiro(m['minutosAtivos']) ?? 0,
      treinosNaSemana: _inteiro(m['treinosNaSemana']) ?? 0,
    );
  }
}

/// Preferências de notificação (tudo ligado por padrão).
class PreferenciasNotificacao {
  const PreferenciasNotificacao({
    this.lembretesTreino = true,
    this.desafios = true,
    this.conquistas = true,
  });

  static const List<String> chaves = [
    'lembretesTreino',
    'desafios',
    'conquistas',
  ];

  final bool lembretesTreino;
  final bool desafios;
  final bool conquistas;

  factory PreferenciasNotificacao.fromMap(Object? bruto) {
    final m = bruto is Map ? bruto : const {};
    bool ler(String chave) => m[chave] is bool ? m[chave] as bool : true;
    return PreferenciasNotificacao(
      lembretesTreino: ler('lembretesTreino'),
      desafios: ler('desafios'),
      conquistas: ler('conquistas'),
    );
  }

  /// @param chave uma das [chaves].
  /// @return valor atual da preferência.
  bool valorDe(String chave) => switch (chave) {
    'lembretesTreino' => lembretesTreino,
    'desafios' => desafios,
    'conquistas' => conquistas,
    _ => true,
  };
}

/// Perfil do usuário (documento `usuarios/{uid}` + dados do Auth).
class PerfilUsuario {
  const PerfilUsuario({
    required this.nome,
    required this.email,
    this.fotoUrl,
    this.premium = false,
    this.dataNascimento,
    this.genero,
    this.alturaCm,
    this.pesoKg,
    this.pesoMetaKg,
    this.metas = const MetasUsuario(),
    this.modalidades = const {},
    this.unidades = SistemaUnidades.metrico,
    this.visibilidade = VisibilidadePerfil.amigos,
    this.notificacoes = const PreferenciasNotificacao(),
  });

  final String nome;
  final String email;
  final String? fotoUrl;

  /// Somente leitura: definido pelo servidor.
  final bool premium;
  final DateTime? dataNascimento;
  final Genero? genero;
  final double? alturaCm;
  final double? pesoKg;
  final double? pesoMetaKg;
  final MetasUsuario metas;
  final Set<Modalidade> modalidades;
  final SistemaUnidades unidades;
  final VisibilidadePerfil visibilidade;
  final PreferenciasNotificacao notificacoes;

  /// Lê o documento de forma defensiva (qualquer campo pode faltar ou vir
  /// com tipo errado).
  ///
  /// @param dados mapa do Firestore (pode ser nulo).
  /// @param nomePadrao nome usado se o documento não tiver um.
  /// @param email e-mail vindo do Firebase Auth.
  factory PerfilUsuario.fromMap(
    Map<String, dynamic>? dados, {
    required String nomePadrao,
    required String email,
  }) {
    final m = dados ?? const <String, dynamic>{};
    final nomeBruto = m['nome'];
    final modalidadesBrutas = m['modalidades'];

    return PerfilUsuario(
      nome: nomeBruto is String && nomeBruto.trim().isNotEmpty
          ? nomeBruto.trim()
          : nomePadrao,
      email: email,
      fotoUrl: _urlSegura(m['fotoUrl']),
      premium: m['premium'] == true,
      dataNascimento: m['dataNascimento'] is String
          ? DateTime.tryParse(m['dataNascimento'] as String)
          : null,
      genero: _enumPorNome(Genero.values, m['genero']),
      alturaCm: _decimal(m['alturaCm']),
      pesoKg: _decimal(m['pesoKg']),
      pesoMetaKg: _decimal(m['pesoMetaKg']),
      metas: MetasUsuario.fromMap(m['metas']),
      modalidades: {
        if (modalidadesBrutas is List)
          for (final item in modalidadesBrutas)
            if (_enumPorNome(Modalidade.values, item) != null)
              _enumPorNome(Modalidade.values, item)!,
      },
      unidades:
          _enumPorNome(SistemaUnidades.values, m['unidades']) ??
          SistemaUnidades.metrico,
      visibilidade:
          _enumPorNome(VisibilidadePerfil.values, m['visibilidade']) ??
          VisibilidadePerfil.amigos,
      notificacoes: PreferenciasNotificacao.fromMap(m['notificacoes']),
    );
  }

  /// Idade calculada a partir da data de nascimento.
  int? get idade {
    final nascimento = dataNascimento;
    if (nascimento == null) return null;
    final hoje = DateTime.now();
    var anos = hoje.year - nascimento.year;
    final fezAniversario =
        hoje.month > nascimento.month ||
        (hoje.month == nascimento.month && hoje.day >= nascimento.day);
    if (!fezAniversario) anos--;
    return anos < 0 ? null : anos;
  }

  /// Formata a data como `yyyy-MM-dd` (formato salvo no banco).
  ///
  /// @param data data a formatar.
  static String dataParaIso(DateTime data) =>
      '${data.year.toString().padLeft(4, '0')}-'
      '${data.month.toString().padLeft(2, '0')}-'
      '${data.day.toString().padLeft(2, '0')}';
}
