// lib/telas/localwidget/perfil/cartao_dados_pessoais.dart

import 'package:flutter/material.dart';
import 'package:malhamais/dominio/perfil_usuario.dart';
import 'package:malhamais/telas/localwidget/perfil/cartao_malha.dart';
import 'package:malhamais/util/unidades.dart';

/// Cartão "Informações pessoais" (idade, gênero, altura, peso e meta).
class CartaoDadosPessoais extends StatelessWidget {
  const CartaoDadosPessoais({
    super.key,
    required this.perfil,
    required this.aoEditar,
  });

  final PerfilUsuario perfil;
  final VoidCallback aoEditar;

  @override
  Widget build(BuildContext context) {
    final s = perfil.unidades;
    String peso(double? kg) => kg == null
        ? '—'
        : '${Unidades.formatar(Unidades.pesoParaExibir(kg, s))} ${Unidades.rotuloPeso(s)}';
    final altura = perfil.alturaCm;

    return CartaoMalha(
      child: Column(
        children: [
          TituloSecao(
            titulo: 'Informações pessoais',
            aoEditar: aoEditar,
            tooltipEditar: 'Editar informações pessoais',
          ),
          LinhaInfo(
            icone: Icons.cake_outlined,
            rotulo: 'Idade',
            valor: perfil.idade == null ? '—' : '${perfil.idade} anos',
          ),
          LinhaInfo(
            icone: Icons.wc_outlined,
            rotulo: 'Gênero',
            valor: perfil.genero?.rotulo ?? '—',
          ),
          LinhaInfo(
            icone: Icons.height,
            rotulo: 'Altura',
            valor: altura == null
                ? '—'
                : '${Unidades.formatar(Unidades.alturaParaExibir(altura, s))} ${Unidades.rotuloAltura(s)}',
          ),
          LinhaInfo(
            icone: Icons.monitor_weight_outlined,
            rotulo: 'Peso',
            valor: peso(perfil.pesoKg),
          ),
          LinhaInfo(
            icone: Icons.flag_outlined,
            rotulo: 'Peso meta',
            valor: peso(perfil.pesoMetaKg),
          ),
        ],
      ),
    );
  }
}
