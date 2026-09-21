import 'package:flutter/material.dart';

import '../models/incidente.dart';
import '../widgets/incidente_card.dart';

final List<Incidente> incidentes = [
  Incidente(
    identificador: 'INC-1042',
    titulo: 'E-mail de phishing detectado',
    tipo: 'Phishing',
    severidade: Severidade.alto,
    status: StatusIncidente.aberto,
    abertoEm: DateTime.now().subtract(const Duration(minutes: 15)),
  ),
  Incidente(
    identificador: 'INC-1043',
    titulo: 'Malware em estação financeira',
    tipo: 'Malware',
    severidade: Severidade.critico,
    status: StatusIncidente.emAndamento,
    abertoEm: DateTime.now().subtract(const Duration(hours: 3)),
    responsavel: 'Ana Souza',
  ),
  Incidente(
    identificador: 'INC-1044',
    titulo: 'Login suspeito em conta administrativa',
    tipo: 'Acesso não autorizado',
    severidade: Severidade.medio,
    status: StatusIncidente.emAndamento,
    abertoEm: DateTime.now().subtract(const Duration(hours: 7)),
    responsavel: 'Carlos Lima',
  ),
  Incidente(
    identificador: 'INC-1045',
    titulo: 'Tentativa de ataque DDoS',
    tipo: 'DDoS',
    severidade: Severidade.critico,
    status: StatusIncidente.resolvido,
    abertoEm: DateTime.now().subtract(const Duration(days: 1)),
    responsavel: 'Mariana Costa',
  ),
  Incidente(
    identificador: 'INC-1046',
    titulo: 'Varredura de portas no servidor web',
    tipo: 'Outro',
    severidade: Severidade.baixo,
    status: StatusIncidente.resolvido,
    abertoEm: DateTime.now().subtract(const Duration(days: 2)),
    responsavel: 'Lucas Martins',
  ),
  Incidente(
    identificador: 'INC-1047',
    titulo: 'Certificado digital expirado',
    tipo: 'Outro',
    severidade: Severidade.medio,
    status: StatusIncidente.aberto,
    abertoEm: DateTime.now().subtract(const Duration(hours: 5)),
  ),
];

class IncidentesScreen extends StatelessWidget {
  const IncidentesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Incidentes')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: incidentes
            .map((incidente) => IncidenteCard(incidente: incidente))
            .toList(),
      ),
    );
  }
}
