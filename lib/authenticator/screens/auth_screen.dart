import 'package:flutter/material.dart';
import 'package:flutter_firebase_firestore_second/_core/my_colors.dart';
import 'package:flutter_firebase_firestore_second/authenticator/services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();

  bool isEntrando = true;

  final _formKey = GlobalKey<FormState>();

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 64,
          horizontal: 32,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.network(
                      "https://github.com/ricarthlima/listin_assetws/raw/main/logo-icon.png",
                      height: 64,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        (isEntrando)
                            ? "Bem vindo ao Listin!"
                            : "Vamos começar?",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      (isEntrando)
                          ? "Faça login para criar sua lista de compras."
                          : "Faça seu cadastro para começar a criar sua lista de compras com Listin.",
                      textAlign: TextAlign.center,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(label: Text("E-mail")),
                      validator: (value) {
                        if (value == null || value == "") {
                          return "O valor de e-mail deve ser preenchido";
                        }
                        if (!value.contains("@") ||
                            !value.contains(".") ||
                            value.length < 4) {
                          return "O valor do e-mail deve ser válido";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _senhaController,
                      obscureText: true,
                      decoration: const InputDecoration(label: Text("Senha")),
                      validator: (value) {
                        if (value == null || value.length < 4) {
                          return "Insira uma senha válida.";
                        }
                        return null;
                      },
                    ),
                    Visibility(
                      visible: isEntrando,
                      child: GestureDetector(
                        onTap: () {
                          _esqueceuSenhaClicado();
                        },
                        child: const Text(
                          "Esqueceu a senha?",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Visibility(
                        visible: !isEntrando,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _confirmaController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                label: Text("Confirme a senha"),
                              ),
                              validator: (value) {
                                if (value == null || value.length < 4) {
                                  return "Insira uma confirmação de senha válida.";
                                }
                                if (value != _senhaController.text) {
                                  return "As senhas devem ser iguais.";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _nomeController,
                              decoration: const InputDecoration(
                                label: Text("Nome"),
                              ),
                              validator: (value) {
                                if (value == null || value.length < 3) {
                                  return "Insira um nome maior.";
                                }
                                return null;
                              },
                            ),
                          ],
                        )),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        botaoEnviarClicado();
                      },
                      child: Text(
                        (isEntrando) ? "Entrar" : "Cadastrar",
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isEntrando = !isEntrando;
                        });
                      },
                      child: Text(
                        (isEntrando)
                            ? "Ainda não tem conta?\nClique aqui para cadastrar."
                            : "Já tem uma conta?\nClique aqui para entrar",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: MyColors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  botaoEnviarClicado() {
    String email = _emailController.text;
    String senha = _senhaController.text;
    String nome = _nomeController.text;

    if (_formKey.currentState!.validate()) {
      if (isEntrando) {
        _entrarUsuario(email: email, senha: senha);
      } else {
        _criarUsuario(email: email, senha: senha, nome: nome);
      }
    }
  }

  _entrarUsuario({required String email, required String senha}) async {
    String? erro = await authService.entrarUsuario(email: email, senha: senha);

    if (erro != null) {
      _mostrarSnackBar(erro: erro);
    }
  }

  _criarUsuario({
    required String email,
    required String senha,
    required String nome,
  }) async {
    String? erro = await authService.criarUsuario(
      email: email,
      senha: senha,
      nome: nome,
    );

    if (erro != null) {
      _mostrarSnackBar(erro: erro);
    }
  }

  _mostrarSnackBar({required String erro, bool isErro = true}) {
    SnackBar snackBar = SnackBar(
      content: Text(erro),
      backgroundColor: (isErro) ? Colors.red : Colors.green,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _enviarEmailRedefinicao(String email) async {
    String? erro = await authService.enviarEmailRedefinicao(email: email);

    if (erro != null) {
      _mostrarSnackBar(erro: erro);
    } else {
      _mostrarSnackBar(erro: "Email de redefinição enviado!", isErro: false);
    }
  }

  _esqueceuSenhaClicado() {
    String email = _emailController.text;

    showDialog(
      context: context,
      builder: (context) {
        TextEditingController confirmarEmailController =
            TextEditingController(text: email);
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          title: const Text("Confirme o e-mail"),
          content: TextFormField(
            controller: confirmarEmailController,
            decoration: const InputDecoration(label: Text("E-mail")),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _enviarEmailRedefinicao(confirmarEmailController.text);
              },
              child: const Text("Enviar"),
            ),
          ],
        );
      },
    );
  }
}
