import 'package:flutter/material.dart';

import '../models/incidente.dart';
import '../widgets/incidente_card.dart';
import 'detalhe_incidente_screen.dart';
import 'novo_incidente_screen.dart';

enum FiltroIncidentes { todos, emAndamento, resolvidos }

class ListaIncidentesScreen extends StatefulWidget {
  const ListaIncidentesScreen({super.key});

  @override
  State<ListaIncidentesScreen> createState() => _ListaIncidentesScreenState();
}

class _ListaIncidentesScreenState extends State<ListaIncidentesScreen> {
  FiltroIncidentes _filtroSelecionado = FiltroIncidentes.todos;

  late final List<Incidente> incidentes = _criarIncidentes();

  List<Incidente> _criarIncidentes() {
    final agora = DateTime.now();

    return [
      Incidente(
        id: 'INC-1045',
        titulo: 'Login falho repetido — conta admin',
        tipo: 'Acesso não autorizado',
        severidade: Severidade.critico,
        status: StatusIncidente.aberto,
        abertoEm: agora.subtract(const Duration(minutes: 15)),
        descricao: 'Foram identificadas diversas tentativas de login malsucedidas na conta administrativa do sistema.',
        ipRelacionado: '203.0.113.14',
      ),
      Incidente(
        id: 'INC-1044',
        titulo: 'Acesso fora do horário — VPN corporativa',
        tipo: 'Acesso não autorizado',
        severidade: Severidade.critico,
        status: StatusIncidente.aberto,
        abertoEm: agora.subtract(const Duration(minutes: 40)),
        responsavel: 'Ana Souza',
        descricao: 'Foi identificado um acesso à VPN corporativa em horário incomum. A atividade está sendo investigada.',
        ipRelacionado: '198.51.100.22',
      ),
      Incidente(
        id: 'INC-1042',
        titulo: 'Tentativa de phishing — portal de RH',
        tipo: 'Phishing',
        severidade: Severidade.alto,
        status: StatusIncidente.emAndamento,
        abertoEm: agora.subtract(const Duration(hours: 3)),
        responsavel: 'Ana Souza',
        descricao: 'Um e-mail suspeito foi enviado aos funcionários com um link que imita o portal interno de RH.',
        ipRelacionado: '203.0.113.45',
      ),
      Incidente(
        id: 'INC-1039',
        titulo: 'Malware detectado — estação FIN-07',
        tipo: 'Malware',
        severidade: Severidade.alto,
        status: StatusIncidente.emAndamento,
        abertoEm: agora.subtract(const Duration(days: 1, hours: 2)),
        responsavel: 'Carlos Lima',
        descricao: 'O antivírus detectou um arquivo malicioso na estação FIN-07. A equipe está analisando o equipamento.',
        ipRelacionado: '192.0.2.77',
      ),
      Incidente(
        id: 'INC-1031',
        titulo: 'Picos de tráfego — API pública',
        tipo: 'DDoS',
        severidade: Severidade.medio,
        status: StatusIncidente.resolvido,
        abertoEm: agora.subtract(const Duration(days: 2, hours: 5)),
        responsavel: 'Ana Souza',
        descricao: 'A API pública apresentou um volume anormal de requisições. As medidas de mitigação foram aplicadas.',
        ipRelacionado: '198.51.100.80',
      ),
      Incidente(
        id: 'INC-1027',
        titulo: 'Certificado TLS expirado — intranet',
        tipo: 'Outro',
        severidade: Severidade.baixo,
        status: StatusIncidente.resolvido,
        abertoEm: agora.subtract(const Duration(days: 4)),
        responsavel: 'Carlos Lima',
        descricao: 'O certificado TLS da intranet expirou e foi substituído por um certificado válido.',
      ),
    ];
  }

  List<Incidente> get incidentesVisiveis {
    switch (_filtroSelecionado) {
      case FiltroIncidentes.todos:
        return incidentes;

      case FiltroIncidentes.emAndamento:
        return incidentes
            .where(
              (incidente) => incidente.status == StatusIncidente.emAndamento,
            )
            .toList();

      case FiltroIncidentes.resolvidos:
        return incidentes
            .where((incidente) => incidente.status == StatusIncidente.resolvido)
            .toList();
    }
  }

  Future<void> _abrirDetalhe(Incidente incidente) async {
    final statusRetornado = await Navigator.of(context).push<StatusIncidente>(
      MaterialPageRoute<StatusIncidente>(
        builder: (_) => DetalheIncidenteScreen(incidente: incidente),
      ),
    );

    if (!mounted || statusRetornado == null) {
      return;
    }

    setState(() {
      incidente.status = statusRetornado;
    });
  }

  String _gerarProximoId() {
    int maiorNumero = 1045;

    for (final incidente in incidentes) {
      final numero = int.tryParse(incidente.id.replaceFirst('INC-', ''));

      if (numero != null && numero > maiorNumero) {
        maiorNumero = numero;
      }
    }

    return 'INC-${(maiorNumero + 1).toString().padLeft(4, '0')}';
  }

  Future<void> _abrirNovoIncidente() async {
    final novoIncidente = await Navigator.of(context).push<Incidente>(
      MaterialPageRoute<Incidente>(
        builder: (_) => NovoIncidenteScreen(proximoId: _gerarProximoId()),
      ),
    );

    if (!mounted || novoIncidente == null) {
      return;
    }

    setState(() {
      incidentes.insert(0, novoIncidente);
      _filtroSelecionado = FiltroIncidentes.todos;
    });
  }

  Widget _construirFiltros() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ChoiceChip(
            label: const Text('Todos'),
            selected: _filtroSelecionado == FiltroIncidentes.todos,
            onSelected: (_) {
              setState(() {
                _filtroSelecionado = FiltroIncidentes.todos;
              });
            },
          ),
          ChoiceChip(
            label: const Text('Em andamento'),
            selected: _filtroSelecionado == FiltroIncidentes.emAndamento,
            onSelected: (_) {
              setState(() {
                _filtroSelecionado = FiltroIncidentes.emAndamento;
              });
            },
          ),
          ChoiceChip(
            label: const Text('Resolvidos'),
            selected: _filtroSelecionado == FiltroIncidentes.resolvidos,
            onSelected: (_) {
              setState(() {
                _filtroSelecionado = FiltroIncidentes.resolvidos;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _construirLista() {
    final lista = incidentesVisiveis;

    if (lista.isEmpty) {
      return const Center(child: Text('Nenhum incidente encontrado.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
      itemCount: lista.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final incidente = lista[index];

        return GestureDetector(
          onTap: () {
            _abrirDetalhe(incidente);
          },
          child: IncidenteCard(incidente: incidente),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incidentes'),
        actions: [
          TextButton.icon(
            onPressed: _abrirNovoIncidente,
            icon: const Icon(Icons.add),
            label: const Text('Novo incidente'),
          ),
        ],
      ),
      body: Column(
        children: [
          _construirFiltros(),
          Expanded(child: _construirLista()),
        ],
      ),
    );
  }
}
