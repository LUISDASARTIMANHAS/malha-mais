// lib/telas/localwidget/perfil/cartao_malha.dart

import 'package:flutter/material.dart';
import 'package:malhamais/util/tema/cores_malha.dart';

/// Cartão base do Malha+: cantos arredondados, borda sutil e glow opcional.
class CartaoMalha extends StatelessWidget {
  const CartaoMalha({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.corBrilho,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  /// Cor do glow (omitida = sem brilho).
  final Color? corBrilho;

  @override
  Widget build(BuildContext context) {
    final c = context.cores;
    final raio = BorderRadius.circular(24);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: raio,
        boxShadow: corBrilho == null
            ? null
            : [
                BoxShadow(
                  color: corBrilho!.withValues(alpha: c.intensidadeBrilho),
                  blurRadius: 28,
                  spreadRadius: -6,
                ),
              ],
      ),
      // Material para o efeito de toque (ListTile) aparecer sobre o cartão.
      child: Material(
        color: c.cartao,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: raio,
          side: BorderSide(color: c.borda),
        ),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Título de seção com botão de editar opcional.
class TituloSecao extends StatelessWidget {
  const TituloSecao({
    super.key,
    required this.titulo,
    this.aoEditar,
    this.tooltipEditar = 'Editar',
  });

  final String titulo;
  final VoidCallback? aoEditar;
  final String tooltipEditar;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            titulo,
            style: tema.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (aoEditar != null)
          IconButton(
            tooltip: tooltipEditar,
            onPressed: aoEditar,
            icon: Icon(
              Icons.edit_outlined,
              size: 20,
              color: context.cores.neon,
            ),
          ),
      ],
    );
  }
}

/// Linha "ícone discreto + rótulo + valor".
class LinhaInfo extends StatelessWidget {
  const LinhaInfo({
    super.key,
    required this.icone,
    required this.rotulo,
    required this.valor,
  });

  final IconData icone;
  final String rotulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final c = context.cores;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: c.esmeralda.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icone, size: 18, color: c.esmeralda),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(rotulo, style: tema.textTheme.bodyMedium)),
          Text(
            valor,
            style: tema.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
