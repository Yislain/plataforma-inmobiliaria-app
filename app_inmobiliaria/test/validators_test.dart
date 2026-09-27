import 'package:flutter_test/flutter_test.dart';
import 'package:app_inmobiliaria/utils/validators.dart'; // Ajusta la ruta si es necesario

void main() {
  test('Debe retornar true para correos válidos', () {
    expect(Validators.isValidEmail('usuario@inmobiliaria.com'), isTrue);
    expect(Validators.isValidEmail('test@dominio.co'), isTrue);
  });

  test('Debe retornar false para correos inválidos', () {
    expect(Validators.isValidEmail('usuariocom'), isFalse);
    expect(Validators.isValidEmail(''), isFalse);
  });
}