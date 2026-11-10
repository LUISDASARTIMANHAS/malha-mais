// lib/util/tema/app_tema.dart

import 'package:flutter/material.dart';

import 'cores_malha.dart';

/// Fábrica dos temas claro e escuro do Malha+.
class AppTema {
  AppTema._();

  static ThemeData escuro() => _montar(Brightness.dark, CoresMalha.escuro);
  static ThemeData claro() => _montar(Brightness.light, CoresMalha.claro);

  static ThemeData _montar(Brightness brilho, CoresMalha c) {
    final esquema = ColorScheme.fromSeed(seedColor: c.neon, brightness: brilho)
        .copyWith(
          primary: c.neon,
          onPrimary: c.sobreNeon,
          secondary: c.roxo,
          tertiary: c.esmeralda,
          surface: c.cartaoApp,
        );
    final raio12 = BorderRadius.circular(12);

    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema,
      scaffoldBackgroundColor: c.fundoApp,
      extensions: [c],
      appBarTheme: AppBarTheme(
        backgroundColor: c.fundoApp,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: esquema.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: raio12),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: raio12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: raio12),
          side: BorderSide(color: c.neon.withValues(alpha: 0.6)),
          foregroundColor: c.neon,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.cartaoApp,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.cartaoApp,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.cartaoApp,
        indicatorColor: c.neon.withValues(alpha: 0.16),
        iconTheme: WidgetStateProperty.resolveWith(
          (estados) => IconThemeData(
            color: estados.contains(WidgetState.selected)
                ? c.neon
                : esquema.onSurfaceVariant,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (estados) => TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: estados.contains(WidgetState.selected)
                ? c.neon
                : esquema.onSurfaceVariant,
          ),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
            (estados) => estados.contains(WidgetState.selected)
                ? c.neon.withValues(alpha: 0.16)
                : null,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (estados) => estados.contains(WidgetState.selected) ? c.neon : null,
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (estados) =>
              estados.contains(WidgetState.selected) ? c.sobreNeon : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (estados) => estados.contains(WidgetState.selected) ? c.neon : null,
        ),
      ),
    );
  }
}
