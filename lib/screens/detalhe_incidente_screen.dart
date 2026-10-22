import 'package:flutter/material.dart';

import '../models/incidente.dart';
import '../widgets/incidente_card.dart';

class DetalheIncidenteScreen extends StatefulWidget {
  final Incidente incidente;

  const DetalheIncidenteScreen({super.key, required this.incidente});

  @override
  State<DetalheIncidenteScreen> createState() => _DetalheIncidenteScreenState();
}

class _DetalheIncidenteScreenState extends State<DetalheIncidenteScreen> {
  late StatusIncidente statusSelecionado;

  @override
  void initState() {
    super.initState();
    statusSelecionado = widget.incidente.status;
  }

  void salvarAtualizacao() {
    Navigator.of(context).pop(statusSelecionado);
  }

  @override
  Widget build(BuildContext context) {
    final incidente = widget.incidente;
    final corSeveridade = corDaSeveridade(incidente.severidade);

    return Scaffold(
      appBar: AppBar(title: Text('#${incidente.id}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(
              label: Text(
                textoDaSeveridade(incidente.severidade),
                style: TextStyle(
                  color: corSeveridade,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: corSeveridade.withValues(alpha: 0.14),
              side: BorderSide(color: corSeveridade),
            ),
            const SizedBox(height: 12),
            Text(
              incidente.titulo,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            _CampoDetalhe(rotulo: 'Tipo', valor: incidente.tipo),
            _CampoDetalhe(rotulo: 'Aberto', valor: incidente.abertoHa),
            _CampoDetalhe(
              rotulo: 'Responsável',
              valor: incidente.responsavel ?? 'Sem responsável',
            ),
            _CampoDetalhe(
              rotulo: 'IP relacionado',
              valor: incidente.ipRelacionado ?? '—',
            ),

            const SizedBox(height: 8),
            Text('Descrição', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(incidente.descricao),

            const SizedBox(height: 24),
            Text('Status', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: StatusIncidente.values.map((status) {
                final cor = corDoStatus(status);
                final selecionado = statusSelecionado == status;

                return ChoiceChip(
                  label: Text(status.texto),
                  selected: selecionado,
                  selectedColor: cor.withValues(alpha: 0.15),
                  labelStyle: TextStyle(
                    color: selecionado ? cor : null,
                    fontWeight: selecionado
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: selecionado ? cor : Colors.grey.shade400,
                  ),
                  onSelected: (selecionar) {
                    if (selecionar) {
                      setState(() {
                        statusSelecionado = status;
                      });
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: salvarAtualizacao,
                child: const Text('Salvar atualização'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CampoDetalhe extends StatelessWidget {
  final String rotulo;
  final String valor;

  const _CampoDetalhe({required this.rotulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rotulo,
            style: Theme.of(context).textTheme.labelLarge
                ?.copyWith(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 4),
          Text(valor, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
