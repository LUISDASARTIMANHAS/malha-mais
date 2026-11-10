// lib/telas/localwidget/perfil/cabecalho_perfil.dart

import 'package:flutter/material.dart';
import 'package:malhamais/dominio/perfil_usuario.dart';
import 'package:malhamais/telas/localwidget/perfil/cartao_malha.dart';
import 'package:malhamais/util/tema/cores_malha.dart';
import 'package:malhamais/util/widget/avatar_inicial.dart';

/// Avatar circular com anel neon→roxo e glow; cai na inicial do nome se a
/// foto não existir ou falhar ao carregar.
class AvatarPerfil extends StatelessWidget {
  const AvatarPerfil({
    super.key,
    required this.nome,
    this.fotoUrl,
    this.raio = 48,
  });

  final String nome;
  final String? fotoUrl;
  final double raio;

  @override
  Widget build(BuildContext context) {
    final c = context.cores;
    final inicial = AvatarInicial(nome: nome, raio: raio);

    return Semantics(
      label: 'Foto de perfil de $nome',
      image: true,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [c.neon, c.roxo],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: c.neon.withValues(alpha: c.intensidadeBrilho * 1.6),
              blurRadius: 24,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(shape: BoxShape.circle, color: c.fundo),
          child: ClipOval(
            child: SizedBox.square(
              dimension: raio * 2,
              child: fotoUrl == null
                  ? inicial
                  : Image.network(
                      fotoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => inicial,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Área de destaque: foto, nome, e-mail, plano e botão de editar.
class CabecalhoPerfil extends StatelessWidget {
  const CabecalhoPerfil({
    super.key,
    required this.perfil,
    required this.aoEditar,
  });

  final PerfilUsuario perfil;
  final VoidCallback aoEditar;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final c = context.cores;

    return CartaoMalha(
      corBrilho: c.roxo,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              AvatarPerfil(nome: perfil.nome, fotoUrl: perfil.fotoUrl),
              Positioned(
                right: 0,
                bottom: 0,
                child: Material(
                  color: c.neon,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: aoEditar,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.photo_camera_outlined,
                        size: 18,
                        color: c.sobreNeon,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            perfil.nome,
            textAlign: TextAlign.center,
            style: tema.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            perfil.email,
            textAlign: TextAlign.center,
            style: tema.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          _SeloPlano(premium: perfil.premium),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: aoEditar,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Editar perfil'),
          ),
        ],
      ),
    );
  }
}

class _SeloPlano extends StatelessWidget {
  const _SeloPlano({required this.premium});

  final bool premium;

  @override
  Widget build(BuildContext context) {
    final c = context.cores;
    final cor = premium ? c.neon : c.esmeralda;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cor.withValues(alpha: 0.7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            premium ? Icons.workspace_premium : Icons.person_outline,
            size: 16,
            color: cor,
          ),
          const SizedBox(width: 6),
          Text(
            premium ? 'Membro Premium' : 'Membro Gratuito',
            style: TextStyle(
              color: cor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
