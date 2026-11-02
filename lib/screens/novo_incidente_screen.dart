import 'package:flutter/material.dart';

import '../models/incidente.dart';

class NovoIncidenteScreen extends StatefulWidget {
  final String proximoId;

  const NovoIncidenteScreen({super.key, required this.proximoId});

  @override
  State<NovoIncidenteScreen> createState() => _NovoIncidenteScreenState();
}

class _NovoIncidenteScreenState extends State<NovoIncidenteScreen> {
  final _formKey = GlobalKey<FormState>();

  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _ipController = TextEditingController();

  String _tipoSelecionado = 'Outro';
  Severidade _severidadeSelecionada = Severidade.medio;

  static const List<String> _tipos = [
    'Phishing',
    'Malware',
    'DDoS',
    'Acesso não autorizado',
    'Outro',
  ];

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _ipController.dispose();
    super.dispose();
  }

  String? _validarTitulo(String? valor) {
    final texto = valor?.trim() ?? '';

    if (texto.isEmpty) {
      return 'Este campo é obrigatório.';
    }

    if (texto.length < 5) {
      return 'O título deve ter pelo menos 5 caracteres.';
    }

    return null;
  }

  String? _validarDescricao(String? valor) {
    final texto = valor?.trim() ?? '';

    if (texto.isEmpty) {
      return 'Este campo é obrigatório.';
    }

    if (texto.length < 20) {
      return 'A descrição deve ter pelo menos 20 caracteres.';
    }

    return null;
  }

  String? _validarIp(String? valor) {
    final ip = valor?.trim() ?? '';

    if (ip.isEmpty) {
      return null;
    }

    final partes = ip.split('.');

    if (partes.length != 4) {
      return 'Informe um IPv4 válido.';
    }

    for (final parte in partes) {
      if (!RegExp(r'^\d+$').hasMatch(parte)) {
        return 'Informe um IPv4 válido.';
      }

      final numero = int.tryParse(parte);

      if (numero == null || numero > 255) {
        return 'Informe um IPv4 válido.';
      }
    }

    return null;
  }

  String _textoSeveridade(Severidade severidade) {
    switch (severidade) {
      case Severidade.critico:
        return 'Crítico';
      case Severidade.alto:
        return 'Alto';
      case Severidade.medio:
        return 'Médio';
      case Severidade.baixo:
        return 'Baixo';
    }
  }

  void _criarIncidente() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final ip = _ipController.text.trim();

    final novoIncidente = Incidente(
      id: widget.proximoId,
      titulo: _tituloController.text.trim(),
      tipo: _tipoSelecionado,
      severidade: _severidadeSelecionada,
      status: StatusIncidente.aberto,
      abertoEm: DateTime.now(),
      descricao: _descricaoController.text.trim(),
      ipRelacionado: ip.isEmpty ? null : ip,
    );

    Navigator.of(context).pop(novoIncidente);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo incidente')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validarTitulo,
                ),

                const SizedBox(height: 20),

                Text('Tipo', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _tipos.map((tipo) {
                    return ChoiceChip(
                      label: Text(tipo),
                      selected: _tipoSelecionado == tipo,
                      onSelected: (selecionado) {
                        if (!selecionado) return;

                        setState(() {
                          _tipoSelecionado = tipo;
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                Text(
                  'Severidade',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  children: Severidade.values.map((severidade) {
                    return ChoiceChip(
                      label: Text(_textoSeveridade(severidade)),
                      selected: _severidadeSelecionada == severidade,
                      onSelected: (selecionado) {
                        if (!selecionado) return;

                        setState(() {
                          _severidadeSelecionada = severidade;
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _descricaoController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: _validarDescricao,
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _ipController,
                  decoration: const InputDecoration(
                    labelText: 'IP relacionado (opcional)',
                    hintText: 'Ex.: 187.44.12.90',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validarIp,
                ),

                const SizedBox(height: 28),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _criarIncidente,
                        child: const Text('Criar incidente'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
