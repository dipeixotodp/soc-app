enum Severidade { critico, alto, medio, baixo }

enum StatusIncidente { aberto, emAndamento, resolvido }

class Incidente {
  final String identificador;
  final String titulo;
  final String tipo;
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
