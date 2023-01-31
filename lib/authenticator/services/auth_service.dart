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

  Future<String?> entrarUsuario(
      {required String email, required String senha}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          return "Usuário não encontrado.";

        case "wrong-password":
          return "Senha incorreta.";
      }

      return e.code;
    }

    return null;
  }

  Future<String?> enviarEmailRedefinicao({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on Exception {
      return "Não foi possível enviar o e-mail de redefinição.";
    }

    return null;
  }

  Future<String?> deslogar() async {
    try {
      await _auth.signOut();
    } on Exception {
      return "Não foi possível deslogar.";
    }

    return null;
  }

  Future<String?> removerUsuario({required String senha}) async {
    try {
      print("Autenticando");
      await _auth.signInWithEmailAndPassword(
        email: _auth.currentUser!.email!,
        password: senha,
      );

      print("Removendo");
      await _auth.currentUser?.delete();
    } on Exception catch (e) {
      print(e);
      return "Não foi possível excluir o usuário";
    }

    return null;
  }
}
