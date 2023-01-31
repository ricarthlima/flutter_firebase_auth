import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  criarUsuario({
    required String email,
    required String senha,
    required String nome,
  }) async {
    UserCredential credencial = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );

    await credencial.user?.updateDisplayName(nome);

    print("Chegamos aqui!");
  }

  entrarUsuario() {}
}
