import 'package:flutter/material.dart';

void main() {
  runApp(const CentralIncidentesApp());
}

enum TipoIncidente { phishing, malware, acessoNaoAutorizado, ddos, outro }

enum Severidade { critico, alto, medio, baixo }

enum StatusIncidente { aberto, emAndamento, resolvido }

class Incidente {
  final String identificador;
  final String titulo;
  final TipoIncidente tipo;
  final Severidade severidade;
  final StatusIncidente status;
  final DateTime abertoEm;
  final String? responsavel;

  Incidente({
    required this.identificador,
    required this.titulo,
    required this.tipo,
    required this.severidade,
    required this.status,
    required this.abertoEm,
    this.responsavel,
  });

  String get tempoDecorrido {
    final diferenca = DateTime.now().difference(abertoEm);

    if (diferenca.inMinutes < 60) {
      return 'há ${diferenca.inMinutes}min';
    }

    if (diferenca.inHours < 24) {
      return 'há ${diferenca.inHours}h';
    }

    if (diferenca.inDays == 1) {
      return 'há 1 dia';
    }

    return 'há ${diferenca.inDays} dias';
  }
}

final List<Incidente> incidentes = [
  Incidente(
    identificador: 'INC-1042',
    titulo: 'E-mail de phishing detectado',
    tipo: TipoIncidente.phishing,
    severidade: Severidade.alto,
    status: StatusIncidente.aberto,
    abertoEm: DateTime.now().subtract(const Duration(minutes: 15)),
  ),
  Incidente(
    identificador: 'INC-1043',
    titulo: 'Malware em estação financeira',
    tipo: TipoIncidente.malware,
    severidade: Severidade.critico,
    status: StatusIncidente.emAndamento,
    abertoEm: DateTime.now().subtract(const Duration(hours: 3)),
    responsavel: 'Ana Souza',
  ),
  Incidente(
    identificador: 'INC-1044',
    titulo: 'Login suspeito em conta administrativa',
    tipo: TipoIncidente.acessoNaoAutorizado,
    severidade: Severidade.medio,
    status: StatusIncidente.emAndamento,
    abertoEm: DateTime.now().subtract(const Duration(hours: 7)),
    responsavel: 'Carlos Lima',
  ),
  Incidente(
    identificador: 'INC-1045',
    titulo: 'Tentativa de ataque DDoS',
    tipo: TipoIncidente.ddos,
    severidade: Severidade.critico,
    status: StatusIncidente.resolvido,
    abertoEm: DateTime.now().subtract(const Duration(days: 1)),
    responsavel: 'Mariana Costa',
  ),
  Incidente(
    identificador: 'INC-1046',
    titulo: 'Varredura de portas no servidor web',
    tipo: TipoIncidente.outro,
    severidade: Severidade.baixo,
    status: StatusIncidente.resolvido,
    abertoEm: DateTime.now().subtract(const Duration(days: 2)),
    responsavel: 'Lucas Martins',
  ),
  Incidente(
    identificador: 'INC-1047',
    titulo: 'Certificado digital expirado',
    tipo: TipoIncidente.outro,
    severidade: Severidade.medio,
    status: StatusIncidente.aberto,
    abertoEm: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  Incidente(
    identificador: 'INC-1048',
    titulo: 'Arquivo malicioso bloqueado pelo antivírus',
    tipo: TipoIncidente.malware,
    severidade: Severidade.baixo,
    status: StatusIncidente.resolvido,
    abertoEm: DateTime.now().subtract(const Duration(days: 4)),
    responsavel: 'Pedro Alves',
  ),
];

String textoTipo(TipoIncidente tipo) {
  switch (tipo) {
    case TipoIncidente.phishing:
      return 'Phishing';
    case TipoIncidente.malware:
      return 'Malware';
    case TipoIncidente.acessoNaoAutorizado:
      return 'Acesso não autorizado';
    case TipoIncidente.ddos:
      return 'DDoS';
    case TipoIncidente.outro:
      return 'Outro';
  }
}

String textoSeveridade(Severidade severidade) {
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

String textoStatus(StatusIncidente status) {
  switch (status) {
    case StatusIncidente.aberto:
      return 'Aberto';
    case StatusIncidente.emAndamento:
      return 'Em andamento';
    case StatusIncidente.resolvido:
      return 'Resolvido';
  }
}

IconData iconeSeveridade(Severidade severidade) {
  switch (severidade) {
    case Severidade.critico:
      return Icons.dangerous;
    case Severidade.alto:
      return Icons.warning;
    case Severidade.medio:
      return Icons.info;
    case Severidade.baixo:
      return Icons.check_circle;
  }
}

class IncidenteCard extends StatelessWidget {
  final Incidente incidente;

  const IncidenteCard({super.key, required this.incidente});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(iconeSeveridade(incidente.severidade), size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    incidente.titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('#${incidente.identificador} · ${textoTipo(incidente.tipo)}'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 20,
              runSpacing: 5,
              children: [
                Text(
                  'Severidade: ${textoSeveridade(incidente.severidade)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Status: ${textoStatus(incidente.status)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(incidente.responsavel ?? 'Sem responsável'),
                ),
                Text(incidente.tempoDecorrido),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CentralIncidentesApp extends StatelessWidget {
  const CentralIncidentesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Central de Incidentes',
      home: Scaffold(
        appBar: AppBar(title: const Text('Central de Incidentes')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: incidentes
              .map((incidente) => IncidenteCard(incidente: incidente))
              .toList(),
        ),
      ),
    );
  }
}
