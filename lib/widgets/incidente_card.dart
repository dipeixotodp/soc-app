import 'package:flutter/material.dart';

import '../models/incidente.dart';

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

Color corSeveridade(Severidade severidade) {
  switch (severidade) {
    case Severidade.critico:
      return Colors.red;
    case Severidade.alto:
      return Colors.orange;
    case Severidade.medio:
      return Colors.amber;
    case Severidade.baixo:
      return Colors.blue;
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

Color corStatus(StatusIncidente status) {
  switch (status) {
    case StatusIncidente.aberto:
      return Colors.red;
    case StatusIncidente.emAndamento:
      return Colors.amber;
    case StatusIncidente.resolvido:
      return Colors.green;
  }
}

class IncidenteCard extends StatelessWidget {
  final Incidente incidente;

  const IncidenteCard({super.key, required this.incidente});

  @override
  Widget build(BuildContext context) {
    final severidadeCor = corSeveridade(incidente.severidade);
    final statusCor = corStatus(incidente.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    textoSeveridade(incidente.severidade),
                    style: TextStyle(
                      color: severidadeCor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: severidadeCor.withValues(alpha: 0.15),
                  side: BorderSide(color: severidadeCor),
                ),
                Text(incidente.tempoDecorrido),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  iconeSeveridade(incidente.severidade),
                  color: severidadeCor,
                  size: 28,
                ),
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
            Text(
              '#${incidente.identificador} · ${incidente.tipo}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(
                  label: Text(
                    textoStatus(incidente.status),
                    style: TextStyle(
                      color: statusCor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.grey.shade200,
                  side: BorderSide.none,
                ),
                const Spacer(),
                Flexible(
                  child: Text(
                    incidente.responsavel ?? 'Sem responsável',
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
