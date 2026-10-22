import 'package:flutter/material.dart';

import '../models/incidente.dart';

String textoDaSeveridade(Severidade severidade) {
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

Color corDaSeveridade(Severidade severidade) {
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

IconData iconeDaSeveridade(Severidade severidade) {
  switch (severidade) {
    case Severidade.critico:
      return Icons.report;
    case Severidade.alto:
      return Icons.warning;
    case Severidade.medio:
      return Icons.info;
    case Severidade.baixo:
      return Icons.low_priority;
  }
}

Color corDoStatus(StatusIncidente status) {
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
  final VoidCallback onTap;

  const IncidenteCard({
    super.key,
    required this.incidente,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final corSeveridade = corDaSeveridade(incidente.severidade);
    final corStatus = corDoStatus(incidente.status);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Text(
                    incidente.abertoHa,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    iconeDaSeveridade(incidente.severidade),
                    color: corSeveridade,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      incidente.titulo,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '#${incidente.id} · ${incidente.tipo}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Chip(
                    label: Text(
                      incidente.status.texto,
                      style: TextStyle(
                        color: corStatus,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.grey.shade200,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
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
      ),
    );
  }
}
