import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/data/repositories/cadernoCampo/cadeno_campo_repository.dart';
import 'package:osi_solucoes/features/presenter/models/area/area_model.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';

part 'caderno_campo_store.g.dart';

class CadernoCampoStore = _CadernoCampoStoreBase with _$CadernoCampoStore;

abstract class _CadernoCampoStoreBase with Store {
  @observable
  int value = 0;

  @observable
  List<Lote> loteList = [];

  @observable
  List<Area> areaList = [];

  @observable
  bool isLoteListLoading = false;

  @observable
  bool isAreaLoading = false;

  @observable
  Setor setorSelecionado = Setor();

  @observable
  Setor dropButtonSetor = Setor();

  @observable
  Area dropButtonArea = Area();

  @observable
  Lote loteSelecionado = Lote();

  @action
  selecionarDropButtonArea(Area area) => dropButtonArea = area;

  @action
  selecionarDropButtonSetor(Setor setor) => dropButtonSetor = setor;

  @action
  setLoteSelecionado(Lote lote) => loteSelecionado = lote;

  @action
  buscarLotesByConta() async {
    isLoteListLoading = true;

    CadernoCampoRepository cadernoCampoRepository =
        GetIt.I<CadernoCampoRepository>();
    AuthController authController = GetIt.I<AuthController>();

    var lotes = await cadernoCampoRepository
        .buscarLotesByConta(authController.usuario.selected_conta!.conta!.id!);

    lotes.fold(
      (err) {
        //toastError(message: err.message);
        loteList = [];
      },
      (data) async {
        loteList = List.from(data);
      },
    );

    isLoteListLoading = false;
  }

  @action
  buscarAtividades() async {
    isLoteListLoading = true;

    CadernoCampoRepository cadernoCampoRepository =
        GetIt.I<CadernoCampoRepository>();
    AuthController authController = GetIt.I<AuthController>();

    var lote =
        await cadernoCampoRepository.buscarAtividades(loteSelecionado.id!);

    lote.fold(
      (err) {
        //toastError(message: err.message);
      },
      (data) async {
        loteSelecionado = data;
        loteSelecionado.lotes_atividades?.map((e) => e.usuario?.selected_conta =
            e.usuario?.contas?.firstWhere((element) =>
                element.conta?.id ==
                authController.usuario.selected_conta!.id!));
      },
    );

    isLoteListLoading = false;
  }

  @action
  buscarLotesBySetor() async {
    isLoteListLoading = true;

    CadernoCampoRepository cadernoCampoRepository =
        GetIt.I<CadernoCampoRepository>();

    var lotes =
        await cadernoCampoRepository.buscarLotesBySetor(dropButtonSetor.id!);

    lotes.fold(
      (err) {
        //toastError(message: err.message);
        loteList = [];
      },
      (data) async {
        loteList = List.from(data);
      },
    );

    isLoteListLoading = false;
  }

  @action
  buscarLotesByArea() async {
    isLoteListLoading = true;

    CadernoCampoRepository cadernoCampoRepository =
        GetIt.I<CadernoCampoRepository>();

    var lotes =
        await cadernoCampoRepository.buscarLotesByArea(dropButtonArea.id!);

    lotes.fold(
      (err) {
        //toastError(message: err.message);
        loteList = [];
      },
      (data) async {
        loteList = List.from(data);
      },
    );

    isLoteListLoading = false;
  }

  @action
  void increment() {
    value++;
  }

  @action
  buscarAreasList() async {
    isAreaLoading = true;

    AuthController authController = GetIt.I<AuthController>();
    CadernoCampoRepository cadernoCampoRepository =
        GetIt.I<CadernoCampoRepository>();

    var areaListResult = await cadernoCampoRepository
        .buscarAreasList(authController.usuario.selected_conta!.conta!.id!);

    areaListResult.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        areaList = List.from(data);
      },
    );
    isAreaLoading = false;
  }
}
