import 'package:osi_solucoes/features/data/datasources/protocolo/protocolo_datasource.dart';
import 'package:osi_solucoes/features/data/repositories/protocolo/protocolo_repository_interface.dart';

class ProtocoloRepository implements IProtocoloRepository {
  final IProtocoloDatasource datasource;
  ProtocoloRepository({
    required this.datasource,
  });
}
