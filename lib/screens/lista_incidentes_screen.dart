import 'package:flutter/material.dart';

import '../models/incidente.dart';
import '../widgets/incidente_card.dart';
import 'detalhe_incidente_screen.dart';

enum FiltroIncidentes { todos, emAndamento, resolvidos }

class ListaIncidentesScreen extends StatefulWidget {
  const ListaIncidentesScreen({super.key});

  @override
  State<ListaIncidentesScreen> createState() => _ListaIncidentesScreenState();
}

class _ListaIncidentesScreenState extends State<ListaIncidentesScreen> {
  FiltroIncidentes filtroSelecionado = FiltroIncidentes.todos;

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
        descricao:
            'Foram identificadas várias tentativas de login '
            'malsucedidas na conta administrativa.',
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
        descricao:
            'A conta de um colaborador acessou a VPN fora do '
            'horário habitual. O acesso está sendo investigado.',
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
        descricao:
            'Uma mensagem suspeita direcionava os funcionários '
            'para uma página falsa de autenticação do portal de RH.',
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
        descricao:
            'O antivírus identificou um arquivo suspeito na '
            'estação FIN-07. A máquina está sendo analisada.',
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
        descricao:
            'Foi identificado um aumento anormal de requisições '
            'à API. As medidas de mitigação foram aplicadas.',
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
        descricao:
            'O certificado TLS da intranet expirou e foi renovado. '
            'O serviço voltou a operar normalmente.',
      ),
    ];
  }

  List<Incidente> get incidentesVisiveis {
    switch (filtroSelecionado) {
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

  Future<void> abrirDetalhe(Incidente incidente) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Incidentes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Todos'),
                  selected: filtroSelecionado == FiltroIncidentes.todos,
                  onSelected: (selecionar) {
                    if (selecionar) {
                      setState(() {
                        filtroSelecionado = FiltroIncidentes.todos;
                      });
                    }
                  },
                ),
                ChoiceChip(
                  label: const Text('Em andamento'),
                  selected: filtroSelecionado == FiltroIncidentes.emAndamento,
                  onSelected: (selecionar) {
                    if (selecionar) {
                      setState(() {
                        filtroSelecionado = FiltroIncidentes.emAndamento;
                      });
                    }
                  },
                ),
                ChoiceChip(
                  label: const Text('Resolvidos'),
                  selected: filtroSelecionado == FiltroIncidentes.resolvidos,
                  onSelected: (selecionar) {
                    if (selecionar) {
                      setState(() {
                        filtroSelecionado = FiltroIncidentes.resolvidos;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: incidentesVisiveis.isEmpty
                ? const Center(child: Text('Nenhum incidente neste filtro.'))
                : ListView(
                    padding: const EdgeInsets.all(12),
                    children: incidentesVisiveis.map((incidente) {
                      return IncidenteCard(
                        incidente: incidente,
                        onTap: () {
                          abrirDetalhe(incidente);
                        },
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
