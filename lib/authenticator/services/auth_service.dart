import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> criarUsuario({
    required String email,
    required String senha,
    required String nome,
  }) async {
    try {
      UserCredential credencial = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      await credencial.user?.updateDisplayName(nome);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          return "E-mail em uso, esqueceu sua senha?";
      }

      return e.code;
    }

    return null;
  }

  entrarUsuario() {}
}
