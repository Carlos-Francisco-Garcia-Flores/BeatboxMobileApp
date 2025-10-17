
import 'package:flutter/material.dart';
import 'colors_app.dart';

/// Tema principal de la aplicación
class TemaApp {
  static ThemeData get temaClaro {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: ColoresApp.fondoPrincipal,
      
      // Esquema de colores
      colorScheme: ColorScheme.light(
        primary: ColoresApp.naranja,
        secondary: ColoresApp.textoSecundario,
        surface: ColoresApp.fondoPrincipal,
        error: ColoresApp.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: ColoresApp.textoPrincipal,
        onError: Colors.white,
      ),
      
      // Tema de texto
      textTheme: const TextTheme(
        // Títulos grandes - peso 500
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w500,
          color: ColoresApp.textoPrincipal,
          fontFamily: 'Inter',
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w500,
          color: ColoresApp.textoPrincipal,
          fontFamily: 'Inter',
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: ColoresApp.textoPrincipal,
          fontFamily: 'Inter',
        ),
        
        // Cuerpo de texto - 16px peso normal
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: ColoresApp.textoPrincipal,
          fontFamily: 'Inter',
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: ColoresApp.textoSecundario,
          fontFamily: 'Inter',
        ),
        
        // Botones - 16px peso medio
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontFamily: 'Inter',
        ),
      ),
      
      // Tema de botones elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColoresApp.naranja,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
      ),
      
      // Tema de tarjetas
      cardTheme: const CardThemeData(
        color: ColoresApp.fondoTarjeta,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      
      // Divisores
      dividerTheme: const DividerThemeData(
        color: ColoresApp.fondoDivisor,
        thickness: 1,
      ),
    );
  }
  
  static ThemeData get temaOscuro {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: ColoresApp.fondoPrincipalOscuro,
      brightness: Brightness.dark,
      
      // Esquema de colores oscuro
      colorScheme: ColorScheme.dark(
        primary: ColoresApp.naranja,
        secondary: ColoresApp.textoSecundarioOscuro,
        surface: ColoresApp.fondoPrincipalOscuro,
        error: ColoresApp.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: ColoresApp.textoPrincipalOscuro,
        onError: Colors.white,
      ),
      
      // Tema de texto oscuro
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w500,
          color: ColoresApp.textoPrincipalOscuro,
          fontFamily: 'Inter',
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w500,
          color: ColoresApp.textoPrincipalOscuro,
          fontFamily: 'Inter',
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: ColoresApp.textoPrincipalOscuro,
          fontFamily: 'Inter',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: ColoresApp.textoPrincipalOscuro,
          fontFamily: 'Inter',
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: ColoresApp.textoSecundarioOscuro,
          fontFamily: 'Inter',
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontFamily: 'Inter',
        ),
      ),
      
      // Tema de botones elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColoresApp.naranja,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
      ),
      
      // Tema de tarjetas oscuro
      cardTheme: const CardThemeData(
        color: ColoresApp.fondoTarjetaOscuro,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      
      // Divisores oscuros
      dividerTheme: const DividerThemeData(
        color: ColoresApp.fondoDivisorOscuro,
        thickness: 1,
      ),
    );
  }
  
  // Privado para evitar instanciación
  TemaApp._();
}
