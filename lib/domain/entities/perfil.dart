class Perfil {
  final String id;
  final String nombre;
  final String apellidos;
  final String telefono;
  final String genero;
  final String? email;
  final DateTime? fechaNacimiento;
  final double? pesoInicial;
  final double? altura;
  final double? imc;
  final double? pesoObjetivo;

  const Perfil({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.telefono,
    required this.genero,
    this.email,
    this.fechaNacimiento,
    this.pesoInicial,
    this.altura,
    this.imc,
    this.pesoObjetivo,
  });
}
