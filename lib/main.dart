// ignore_for_file: camel_case_types, use_build_context_synchronously, library_private_types_in_public_api

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(Projeto_Compras());
}

class Projeto_Compras extends StatelessWidget {
  const Projeto_Compras({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Compras',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => TelaLogin(),
        '/register': (context) => TelaCadastro(),
        '/forgot': (context) => TelaRecuperarSenha(),
        '/about': (context) => TelaSobre(),
        '/home': (context) => TelaHome(),
        '/list': (context) => TelaListaDeCompras(),
      },
    );
  }
}

class TelaLogin extends StatelessWidget {
  final controladorEmail = TextEditingController();
  final controladorSenha = TextEditingController();

  TelaLogin({super.key});

  Future<void> login(BuildContext context) async {
    final email = controladorEmail.text;
    final senha = controladorSenha.text;

    if (email.isEmpty || senha.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Informe email e senha válidos.')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);

    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FlutterLogo(size: 100),
            TextField(
              controller: controladorEmail,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: controladorSenha,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => login(context),
              child: Text('Entrar'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: Text('Cadastrar-se'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/forgot'),
              child: Text('Esqueceu a senha?'),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaCadastro extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final controladorEmail = TextEditingController();
  final controladorNome = TextEditingController();
  final controladorTelefone = TextEditingController();
  final controladorSenha = TextEditingController();
  final controladorConfirmarSenha = TextEditingController();

  TelaCadastro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Usuário'),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: controladorNome,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: controladorEmail,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.contains('@') ? null : 'Email inválido',
              ),
              TextFormField(
                controller: controladorTelefone,
                decoration: InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Informe o telefone' : null,
              ),
              TextFormField(
                controller: controladorSenha,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) =>
                    value!.length < 6 ? 'Senha muito curta' : null,
              ),
              TextFormField(
                controller: controladorConfirmarSenha,
                decoration: InputDecoration(labelText: 'Confirmar Senha'),
                obscureText: true,
                validator: (value) =>
                    value != controladorSenha.text ? 'Senhas não coincidem' : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('email', controladorEmail.text);
                    await prefs.setString('nome', controladorNome.text);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cadastro realizado com sucesso!')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Cadastrar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TelaRecuperarSenha extends StatelessWidget {
  final controladorEmail = TextEditingController();

  TelaRecuperarSenha({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Senha'),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controladorEmail,
              decoration: InputDecoration(labelText: 'Informe seu email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final email = controladorEmail.text.trim();
                if (email.isEmpty || !email.contains('@')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Informe um email válido')),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('Recuperação de senha'),
                      content: Text('Email enviado para $email'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Ok'),
                        )
                      ],
                    ),
                  );
                }
              },
              child: Text('Recuperar'),
            )
          ],
        ),
      ),
    );
  }
}

class TelaSobre extends StatelessWidget {
  const TelaSobre({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre o Projeto'),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lista de Compras',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Objetivo: Organizar compras de mercado de forma prática.'),
            SizedBox(height: 10),
            Text('Equipe: Lucas Capalbo, RA:2840482123033'),
          ],
        ),
      ),
    );
  }
}

class TelaHome extends StatelessWidget {
  const TelaHome({super.key});

  Future<String> obterNomeUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nome') ?? 'Usuário';
  }

  void _confirmarLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sair'),
        content: Text('Deseja realmente sair da aplicação?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: Text('Sair'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Início'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _confirmarLogout(context),
          )
        ],
      ),
      body: FutureBuilder<String>(
        future: obterNomeUsuario(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Bem-vindo, ${snapshot.data}!', style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/list'),
                  child: Text('Lista de Compras'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/about'),
                  child: Text('Sobre o Projeto'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TelaListaDeCompras extends StatefulWidget {
  const TelaListaDeCompras({super.key});

  @override
  _TelaListaDeComprasState createState() => _TelaListaDeComprasState();
}

class _TelaListaDeComprasState extends State<TelaListaDeCompras> {
  List<Map<String, dynamic>> itens = [
    {'nome': 'Leite', 'comprado': false},
    {'nome': 'Pão', 'comprado': false},
    {'nome': 'Queijo', 'comprado': false},
    {'nome': 'Café', 'comprado': false},
    {'nome': 'Arroz', 'comprado': false},
    {'nome': 'Feijão', 'comprado': false},
    {'nome': 'Macarrão', 'comprado': false},
    {'nome': 'Tomate', 'comprado': false},
    {'nome': 'Alface', 'comprado': false},
    {'nome': 'Frango', 'comprado': false},
  ];

  final TextEditingController _controladorNovoItem = TextEditingController();

  void _alternarCompra(int indice) {
    setState(() {
      itens[indice]['comprado'] = !itens[indice]['comprado'];
    });
  }

  void _adicionarItem() {
    if (_controladorNovoItem.text.isNotEmpty) {
      setState(() {
        itens.add({'nome': _controladorNovoItem.text, 'comprado': false});
        _controladorNovoItem.clear();
      });
    }
  }

  void _removerItem(int indice) {
    setState(() {
      itens.removeAt(indice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Compras'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Adicionar Item'),
                  content: TextField(
                    controller: _controladorNovoItem,
                    decoration: InputDecoration(hintText: 'Nome do item'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        _adicionarItem();
                        Navigator.pop(context);
                      },
                      child: Text('Adicionar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: itens.length,
        itemBuilder: (context, indice) {
          return Card(
            child: ListTile(
              leading: Icon(
                itens[indice]['comprado']
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
              ),
              title: Text(
                itens[indice]['nome'],
                style: TextStyle(
                  decoration: itens[indice]['comprado']
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _removerItem(indice),
              ),
              onTap: () => _alternarCompra(indice),
            ),
          );
        },
      ),
    );
  }
}
