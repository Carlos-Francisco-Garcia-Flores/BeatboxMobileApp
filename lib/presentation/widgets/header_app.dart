import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/viewmodels/auth_viewmodel.dart';
import 'logo_app.dart';

/// Widget reutilizable para el header de la aplicación
class HeaderApp extends StatelessWidget {
  const HeaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 🔹 Obtenemos el usuario actual desde el ViewModel
    final authViewModel = Provider.of<AuthViewModel>(context);
    final nombreUsuario = authViewModel.user?.username ?? 'Invitado';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: theme.cardColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 🔹 Logo de la app
          const LogoApp(width: 100, height: 40),

          // 🔹 Nombre de usuario dinámico
          Row(
            children: [
              const Icon(Icons.person_outline, color: Colors.orange, size: 22),
              const SizedBox(width: 6),
              Text(
                nombreUsuario,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
