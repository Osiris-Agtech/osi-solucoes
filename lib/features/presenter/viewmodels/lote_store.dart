import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/data/repositories/lote/lote_repository.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';

part 'lote_store.g.dart';

class LoteStore = _LoteStoreBase with _$LoteStore;

abstract class _LoteStoreBase with Store {
  @observable
  bool isLoteListLoading = false;

  @observable
  Setor setorSelecionado = Setor();

  @observable
  List<Lote> loteList = [];

  @action
  setSetorSelecionado(Setor setor) => setorSelecionado = setor;

  @action
  buscarLotes() async {
    isLoteListLoading = true;

    LoteRepository loteRepository = GetIt.I<LoteRepository>();

    var lotes = await loteRepository.buscarLotes(setorSelecionado.id!);

    lotes.fold(
      (err) {
        toastError(message: err.message);
        loteList = [];
      },
      (data) async {
        loteList = List.from(data);
      },
    );

    isLoteListLoading = false;
  }

  // #################### START DETALHES LOTE #######################
  @observable
  bool isDetalhesLoteLoading = false;

  @observable
  Lote loteSelecionado = Lote();

  @action
  selecionarLote(Lote lote) => loteSelecionado = lote;

  @action
  buscarDetalhesLote() async {
    isDetalhesLoteLoading = true;

    LoteRepository loteRepository = GetIt.I<LoteRepository>();

    var lote = await loteRepository.buscarDetalhesLote(loteSelecionado.id!);

    lote.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        loteSelecionado = data;
      },
    );

    isDetalhesLoteLoading = false;
  }

  // ##################### END DETALHES LOTE ########################
}
