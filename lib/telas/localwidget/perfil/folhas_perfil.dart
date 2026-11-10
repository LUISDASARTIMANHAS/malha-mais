// lib/telas/localwidget/perfil/folhas_perfil.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:malhamais/dominio/perfil_usuario.dart';
import 'package:malhamais/servicos/servico_perfil.dart';
import 'package:malhamais/telas/controle_interacao/controle_tela_perfil.dart';
import 'package:malhamais/telas/localwidget/perfil/cabecalho_perfil.dart';
import 'package:malhamais/util/tema/controle_tema.dart';
import 'package:malhamais/util/unidades.dart';
import 'package:malhamais/util/validadores.dart';

/// Abre uma folha inferior rolável que respeita o teclado.
///
/// @param context contexto de origem.
/// @param construtor conteúdo da folha.
Future<void> abrirFolha(BuildContext context, WidgetBuilder construtor) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    useRootNavigator: true,
    showDragHandle: true,
    builder: (contexto) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(contexto).bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: construtor(contexto),
      ),
    ),
  );
}

/// Mensagem de erro/aviso inline, anunciada por leitores de tela.
class _Mensagem extends StatelessWidget {
  const _Mensagem(this.texto, {this.erro = true});

  final String? texto;
  final bool erro;

  @override
  Widget build(BuildContext context) {
    if (texto == null) return const SizedBox.shrink();
    final esquema = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Semantics(
        liveRegion: true,
        child: Text(
          texto!,
          textAlign: TextAlign.center,
          style: TextStyle(color: erro ? esquema.error : esquema.primary),
        ),
      ),
    );
  }
}

String _dataBr(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

// ---------------------------------------------------------------------------
// Editar perfil (foto, nome, e-mail)
// ---------------------------------------------------------------------------

class FolhaEditarPerfil extends StatefulWidget {
  const FolhaEditarPerfil({super.key, required this.controle});

  final ControleTelaPerfil controle;

  static Future<void> abrir(
    BuildContext context,
    ControleTelaPerfil controle,
  ) => abrirFolha(context, (_) => FolhaEditarPerfil(controle: controle));

  @override
  State<FolhaEditarPerfil> createState() => _FolhaEditarPerfilState();
}

class _FolhaEditarPerfilState extends State<FolhaEditarPerfil> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nome;
  late final TextEditingController _email;
  String? _erro;
  String? _aviso;

  @override
  void initState() {
    super.initState();
    final perfil = widget.controle.perfil!;
    _nome = TextEditingController(text: perfil.nome);
    _email = TextEditingController(text: perfil.email);
  }

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _executarFoto(Future<ResultadoOperacao> Function() acao) async {
    final r = await acao();
    if (!mounted) return;
    setState(() => _erro = r.mensagemErro);
  }

  Future<void> _salvar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final perfil = widget.controle.perfil!;
    final nome = _nome.text.trim();
    final email = _email.text.trim();
    setState(() {
      _erro = null;
      _aviso = null;
    });

    if (nome != perfil.nome) {
      final r = await widget.controle.salvarNome(nome);
      if (!mounted) return;
      if (!r.sucesso) return setState(() => _erro = r.mensagemErro);
    }
    if (email.toLowerCase() != perfil.email.toLowerCase()) {
      final r = await widget.controle.solicitarTrocaEmail(email);
      if (!mounted) return;
      if (!r.sucesso) return setState(() => _erro = r.mensagemErro);
      return setState(
        () => _aviso =
            'Enviamos um link de confirmação para $email. O e-mail só muda depois de confirmar.',
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return ListenableBuilder(
      listenable: widget.controle,
      builder: (context, _) {
        final perfil = widget.controle.perfil!;
        final ocupado = widget.controle.ocupado;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Editar perfil',
                style: tema.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: AvatarPerfil(nome: perfil.nome, fotoUrl: perfil.fotoUrl),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: ocupado
                        ? null
                        : () => _executarFoto(widget.controle.escolherFoto),
                    icon: const Icon(Icons.photo_library_outlined, size: 18),
                    label: const Text('Alterar foto'),
                  ),
                  if (perfil.fotoUrl != null)
                    TextButton(
                      onPressed: ocupado
                          ? null
                          : () => _executarFoto(widget.controle.removerFoto),
                      child: const Text('Remover'),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nome,
                validator: Validadores.nome,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                maxLength: Validadores.tamanhoMaximoNome,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person_outline),
                  counterText: '',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _email,
                validator: Validadores.email,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                enableSuggestions: false,
                maxLength: Validadores.tamanhoMaximoEmail,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email_outlined),
                  counterText: '',
                ),
              ),
              _Mensagem(_erro),
              _Mensagem(_aviso, erro: false),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: ocupado ? null : _salvar,
                child: ocupado
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : const Text('Salvar', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Editar dados pessoais (idade, gênero, altura, peso, meta)
// ---------------------------------------------------------------------------

class FolhaEditarDados extends StatefulWidget {
  const FolhaEditarDados({super.key, required this.controle});

  final ControleTelaPerfil controle;

  static Future<void> abrir(
    BuildContext context,
    ControleTelaPerfil controle,
  ) => abrirFolha(context, (_) => FolhaEditarDados(controle: controle));

  @override
  State<FolhaEditarDados> createState() => _FolhaEditarDadosState();
}

class _FolhaEditarDadosState extends State<FolhaEditarDados> {
  static const double _alturaMin = 100, _alturaMax = 250;
  static const double _pesoMin = 20, _pesoMax = 400;

  final _formKey = GlobalKey<FormState>();
  late final SistemaUnidades _unidades;
  late final TextEditingController _altura;
  late final TextEditingController _peso;
  late final TextEditingController _meta;
  DateTime? _nascimento;
  Genero? _genero;
  String? _erro;

  @override
  void initState() {
    super.initState();
    final p = widget.controle.perfil!;
    _unidades = p.unidades;
    String? texto(double? v, double Function(double) converter) =>
        v == null ? null : Unidades.formatar(converter(v));
    _altura = TextEditingController(
      text: texto(p.alturaCm, (v) => Unidades.alturaParaExibir(v, _unidades)),
    );
    _peso = TextEditingController(
      text: texto(p.pesoKg, (v) => Unidades.pesoParaExibir(v, _unidades)),
    );
    _meta = TextEditingController(
      text: texto(p.pesoMetaKg, (v) => Unidades.pesoParaExibir(v, _unidades)),
    );
    _nascimento = p.dataNascimento;
    _genero = p.genero;
  }

  @override
  void dispose() {
    _altura.dispose();
    _peso.dispose();
    _meta.dispose();
    super.dispose();
  }

  Future<void> _escolherData() async {
    final agora = DateTime.now();
    final ultima = DateTime(agora.year - 13, agora.month, agora.day);
    final inicial = _nascimento ?? DateTime(agora.year - 25, 1, 1);
    final data = await showDatePicker(
      context: context,
      initialDate: inicial.isAfter(ultima) ? ultima : inicial,
      firstDate: DateTime(1900),
      lastDate: ultima,
      helpText: 'Data de nascimento',
    );
    if (data != null && mounted) setState(() => _nascimento = data);
  }

  double? _paraMetrico(
    TextEditingController c,
    double Function(double, SistemaUnidades) f,
  ) {
    final valor = Validadores.lerDecimal(c.text);
    return valor == null ? null : Unidades.arredondar(f(valor, _unidades));
  }

  Future<void> _salvar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _erro = null);
    final r = await widget.controle.salvarDadosPessoais(
      dataNascimento: _nascimento,
      genero: _genero,
      alturaCm: _paraMetrico(_altura, Unidades.alturaParaCm),
      pesoKg: _paraMetrico(_peso, Unidades.pesoParaKg),
      pesoMetaKg: _paraMetrico(_meta, Unidades.pesoParaKg),
    );
    if (!mounted) return;
    if (r.sucesso) {
      Navigator.of(context).pop();
    } else {
      setState(() => _erro = r.mensagemErro);
    }
  }

  Widget _campoNumero(
    TextEditingController controlador,
    String rotulo,
    String unidade,
    double minMetrico,
    double maxMetrico,
    double Function(double, SistemaUnidades) paraExibir,
    IconData icone,
  ) {
    return TextFormField(
      controller: controlador,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
      maxLength: 7,
      validator: (v) => Validadores.decimalEntre(
        v,
        min: paraExibir(minMetrico, _unidades),
        max: paraExibir(maxMetrico, _unidades),
        obrigatorio: false,
        unidade: unidade,
      ),
      decoration: InputDecoration(
        labelText: '$rotulo ($unidade)',
        prefixIcon: Icon(icone),
        counterText: '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return ListenableBuilder(
      listenable: widget.controle,
      builder: (context, _) => Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Informações pessoais',
              style: tema.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _escolherData,
              icon: const Icon(Icons.cake_outlined),
              label: Text(
                _nascimento == null
                    ? 'Data de nascimento'
                    : 'Nascimento: ${_dataBr(_nascimento!)}',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Genero>(
              initialValue: _genero,
              decoration: const InputDecoration(
                labelText: 'Gênero',
                prefixIcon: Icon(Icons.wc_outlined),
              ),
              items: [
                for (final g in Genero.values)
                  DropdownMenuItem(value: g, child: Text(g.rotulo)),
              ],
              onChanged: (g) => setState(() => _genero = g),
            ),
            const SizedBox(height: 16),
            _campoNumero(
              _altura,
              'Altura',
              Unidades.rotuloAltura(_unidades),
              _alturaMin,
              _alturaMax,
              Unidades.alturaParaExibir,
              Icons.height,
            ),
            const SizedBox(height: 16),
            _campoNumero(
              _peso,
              'Peso',
              Unidades.rotuloPeso(_unidades),
              _pesoMin,
              _pesoMax,
              Unidades.pesoParaExibir,
              Icons.monitor_weight_outlined,
            ),
            const SizedBox(height: 16),
            _campoNumero(
              _meta,
              'Peso meta',
              Unidades.rotuloPeso(_unidades),
              _pesoMin,
              _pesoMax,
              Unidades.pesoParaExibir,
              Icons.flag_outlined,
            ),
            _Mensagem(_erro),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: widget.controle.ocupado ? null : _salvar,
              child: const Text('Salvar', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Editar metas
// ---------------------------------------------------------------------------

class FolhaEditarMetas extends StatefulWidget {
  const FolhaEditarMetas({super.key, required this.controle});

  final ControleTelaPerfil controle;

  static Future<void> abrir(
    BuildContext context,
    ControleTelaPerfil controle,
  ) => abrirFolha(context, (_) => FolhaEditarMetas(controle: controle));

  @override
  State<FolhaEditarMetas> createState() => _FolhaEditarMetasState();
}

class _FolhaEditarMetasState extends State<FolhaEditarMetas> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _passos;
  late final TextEditingController _calorias;
  late final TextEditingController _treinos;
  late final TextEditingController _minutos;
  String? _erro;

  @override
  void initState() {
    super.initState();
    final m = widget.controle.perfil!.metas;
    String? t(int? v) => v?.toString();
    _passos = TextEditingController(text: t(m.passosDiarios));
    _calorias = TextEditingController(text: t(m.caloriasDiarias));
    _treinos = TextEditingController(text: t(m.treinosSemanais));
    _minutos = TextEditingController(text: t(m.minutosAtivosDiarios));
  }

  @override
  void dispose() {
    _passos.dispose();
    _calorias.dispose();
    _treinos.dispose();
    _minutos.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _erro = null);
    final r = await widget.controle.salvarMetas(
      MetasUsuario(
        passosDiarios: int.parse(_passos.text.trim()),
        caloriasDiarias: int.parse(_calorias.text.trim()),
        treinosSemanais: int.parse(_treinos.text.trim()),
        minutosAtivosDiarios: int.parse(_minutos.text.trim()),
      ),
    );
    if (!mounted) return;
    if (r.sucesso) {
      Navigator.of(context).pop();
    } else {
      setState(() => _erro = r.mensagemErro);
    }
  }

  Widget _campo(
    TextEditingController c,
    String rotulo,
    IconData icone,
    int min,
    int max,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 6,
        validator: (v) => Validadores.inteiroEntre(v, min: min, max: max),
        decoration: InputDecoration(
          labelText: rotulo,
          prefixIcon: Icon(icone),
          counterText: '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return ListenableBuilder(
      listenable: widget.controle,
      builder: (context, _) => Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Minhas metas',
              style: tema.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _campo(
              _passos,
              'Passos diários',
              Icons.directions_walk,
              1000,
              100000,
            ),
            _campo(
              _calorias,
              'Calorias diárias (kcal)',
              Icons.local_fire_department_outlined,
              500,
              10000,
            ),
            _campo(_treinos, 'Treinos por semana', Icons.fitness_center, 1, 14),
            _campo(
              _minutos,
              'Tempo ativo diário (min)',
              Icons.timer_outlined,
              5,
              600,
            ),
            _Mensagem(_erro),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: widget.controle.ocupado ? null : _salvar,
              child: const Text('Salvar', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

// Configurações (aparência + unidades), unidades, notificações, privacidade

/// Seletor Métrico/Imperial.
class SeletorUnidades extends StatelessWidget {
  const SeletorUnidades({super.key, required this.controle});

  final ControleTelaPerfil controle;

  @override
  Widget build(BuildContext context) {
    final atual = controle.perfil?.unidades ?? SistemaUnidades.metrico;

    return SegmentedButton<SistemaUnidades>(
      showSelectedIcon: false,
      segments: [
        for (final u in SistemaUnidades.values)
          ButtonSegment(value: u, label: Text(u.rotulo)),
      ],
      selected: {atual},
      onSelectionChanged: (s) => controle.definirUnidades(s.first),
    );
  }
}

/// Folha da engrenagem: aparência (Auto/Escuro/Claro) e unidades.
class FolhaConfiguracoes extends StatelessWidget {
  const FolhaConfiguracoes({super.key, required this.controle});

  final ControleTelaPerfil controle;

  static Future<void> abrir(
    BuildContext context,
    ControleTelaPerfil controle,
  ) => abrirFolha(context, (_) => FolhaConfiguracoes(controle: controle));

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final controleTema = ControleTema.instancia;

    return ListenableBuilder(
      listenable: Listenable.merge([controle, controleTema]),
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Configurações',
            style: tema.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text('Aparência', style: tema.textTheme.labelLarge),
          const SizedBox(height: 8),
          SegmentedButton<ThemeMode>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: ThemeMode.system,
                icon: Icon(Icons.brightness_auto),
                label: Text('Auto'),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                icon: Icon(Icons.dark_mode_outlined),
                label: Text('Escuro'),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                icon: Icon(Icons.light_mode_outlined),
                label: Text('Claro'),
              ),
            ],
            selected: {controleTema.modo},
            onSelectionChanged: (s) => controleTema.definir(s.first),
          ),
          const SizedBox(height: 20),
          Text('Unidades de medida', style: tema.textTheme.labelLarge),
          const SizedBox(height: 8),
          SeletorUnidades(controle: controle),
        ],
      ),
    );
  }
}

/// Folha só de unidades.
class FolhaUnidades extends StatelessWidget {
  const FolhaUnidades({super.key, required this.controle});

  final ControleTelaPerfil controle;

  static Future<void> abrir(
    BuildContext context,
    ControleTelaPerfil controle,
  ) => abrirFolha(context, (_) => FolhaUnidades(controle: controle));

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return ListenableBuilder(
      listenable: controle,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Unidades',
            style: tema.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Peso e altura são guardados em kg/cm e convertidos na exibição.',
            style: tema.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          SeletorUnidades(controle: controle),
        ],
      ),
    );
  }
}

class FolhaNotificacoes extends StatelessWidget {
  const FolhaNotificacoes({super.key, required this.controle});

  final ControleTelaPerfil controle;

  static Future<void> abrir(
    BuildContext context,
    ControleTelaPerfil controle,
  ) => abrirFolha(context, (_) => FolhaNotificacoes(controle: controle));

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    const opcoes = {
      'lembretesTreino': ('Lembretes de treino', Icons.alarm),
      'desafios': ('Desafios e missões', Icons.emoji_events_outlined),
      'conquistas': ('Conquistas', Icons.military_tech_outlined),
    };

    return ListenableBuilder(
      listenable: controle,
      builder: (context, _) {
        final prefs =
            controle.perfil?.notificacoes ?? const PreferenciasNotificacao();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Notificações',
              style: tema.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            for (final entrada in opcoes.entries)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                secondary: Icon(entrada.value.$2),
                title: Text(entrada.value.$1),
                value: prefs.valorDe(entrada.key),
                onChanged: (valor) =>
                    controle.definirNotificacao(entrada.key, valor),
              ),
          ],
        );
      },
    );
  }
}

class FolhaPrivacidade extends StatefulWidget {
  const FolhaPrivacidade({super.key, required this.controle});

  final ControleTelaPerfil controle;

  static Future<void> abrir(
    BuildContext context,
    ControleTelaPerfil controle,
  ) => abrirFolha(context, (_) => FolhaPrivacidade(controle: controle));

  @override
  State<FolhaPrivacidade> createState() => _FolhaPrivacidadeState();
}

class _FolhaPrivacidadeState extends State<FolhaPrivacidade> {
  String? _mensagem;
  bool _erro = false;

  Future<void> _redefinirSenha() async {
    final r = await widget.controle.redefinirSenha();
    if (!mounted) return;
    setState(() {
      _erro = !r.sucesso;
      _mensagem = r.sucesso
          ? 'Enviamos um link para criar uma nova senha no seu e-mail.'
          : r.mensagemErro;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return ListenableBuilder(
      listenable: widget.controle,
      builder: (context, _) {
        final atual =
            widget.controle.perfil?.visibilidade ?? VisibilidadePerfil.amigos;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Privacidade e segurança',
              style: tema.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text('Quem pode ver meu perfil', style: tema.textTheme.labelLarge),
            const SizedBox(height: 8),
            SegmentedButton<VisibilidadePerfil>(
              showSelectedIcon: false,
              segments: [
                for (final v in VisibilidadePerfil.values)
                  ButtonSegment(value: v, label: Text(v.rotulo)),
              ],
              selected: {atual},
              onSelectionChanged: (s) =>
                  widget.controle.definirVisibilidade(s.first),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: widget.controle.ocupado ? null : _redefinirSenha,
              icon: const Icon(Icons.password_outlined),
              label: const Text('Alterar senha por e-mail'),
            ),
            _Mensagem(_mensagem, erro: _erro),
          ],
        );
      },
    );
  }
}
