import 'package:flutter/material.dart';

// Página principal de cadastro
class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

// Estado da página de cadastro
class _CadastroPageState extends State<CadastroPage> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();

  String? _generoSelecionado;
  final ValueNotifier<List<Map<String, String?>>> _cadastrosNotifier =
      ValueNotifier([]);

  @override
  void dispose() {
    _cadastrosNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(
                  labelText: 'Telefone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: TextFormField(
                controller: _senhaController, // Campo de senha
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                obscureText: true, // Oculta o texto
              ),
            ),
            const SizedBox(height: 10),
            const Text('Gênero:'),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Masculino'),
                    value: 'masculino',
                    groupValue: _generoSelecionado,
                    onChanged: (value) {
                      setState(() {
                        _generoSelecionado = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Feminino'),
                    value: 'feminino',
                    groupValue: _generoSelecionado,
                    onChanged: (value) {
                      setState(() {
                        _generoSelecionado = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_nomeController.text.isNotEmpty &&
                        _emailController.text.isNotEmpty &&
                        _telefoneController.text.isNotEmpty &&
                        _senhaController.text.isNotEmpty && // Valida a senha
                        _generoSelecionado != null) {
                      setState(() {
                        _cadastrosNotifier.value.add({
                          'nome': _nomeController.text,
                          'email': _emailController.text,
                          'telefone': _telefoneController.text,
                          'senha': _senhaController.text, // Armazena a senha
                          'genero': _generoSelecionado,
                        });
                        _nomeController.clear();
                        _emailController.clear();
                        _telefoneController.clear();
                        _senhaController.clear(); // Limpa o campo senha
                        _generoSelecionado = null;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, preencha todos os campos.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Salvar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CadastrosPage(
                          cadastrosNotifier: _cadastrosNotifier,
                        ),
                      ),
                    );
                  },
                  child: const Text('Ver Cadastros'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Página para exibir a lista de cadastros
class CadastrosPage extends StatelessWidget {
  final ValueNotifier<List<Map<String, String?>>> cadastrosNotifier;

  const CadastrosPage({super.key, required this.cadastrosNotifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Cadastros'),
      ),
      body: ValueListenableBuilder<List<Map<String, String?>>>(
        valueListenable: cadastrosNotifier,
        builder: (context, cadastros, child) {
          return ListView.builder(
            itemCount: cadastros.length,
            itemBuilder: (context, index) {
              final cadastro = cadastros[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                      cadastro['genero'] == 'masculino'
                          ? 'assets/images/masculino.png'
                          : 'assets/images/feminino.png',
                    ),
                  ),
                  title: Text(cadastro['nome'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${cadastro['email'] ?? ''}'),
                      Text('Telefone: ${cadastro['telefone'] ?? ''}'),
                      Text('Senha: ${cadastro['senha'] ?? ''}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.blueGrey),
                    onPressed: () {
                      // Confirma a exclusão
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Excluir Cadastro'),
                          content: const Text(
                              'Tem certeza de que deseja excluir este cadastro?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Fecha o diálogo
                                cadastrosNotifier.value.removeAt(index);
                                cadastrosNotifier
                                    .notifyListeners(); // Notifica a mudança
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Cadastro excluído com sucesso.'),
                                  ),
                                );
                              },
                              child: const Text('Excluir'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
