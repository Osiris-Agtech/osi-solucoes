import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/core/utils/atividade_descricao_codec.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/data/repositories/cadernoCampo/cadeno_campo_repository.dart';
import 'package:osi_solucoes/features/presenter/models/area/area_model.dart';
import 'package:osi_solucoes/features/presenter/models/atividade/atividade_model.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';
import 'package:osi_solucoes/features/presenter/models/lotesAtividades/lotes_atividades_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_sequence_interaction_reporter.dart';
import "package:collection/collection.dart";

part 'caderno_campo_store.g.dart';

class CadernoCampoStore = CadernoCampoStoreBase with _$CadernoCampoStore;

abstract class CadernoCampoStoreBase with Store {
  @observable
  List<Lote> loteList = [];

  @observable
  List<Area> areaList = [];

  @observable
  bool isLoteListLoading = false;

  @observable
  bool isAreaLoading = false;

  @observable
  bool mostrarRegistrosSistema = true;

  @observable
  Setor setorSelecionado = Setor();

  @observable
  Setor dropButtonSetor = Setor();

  @observable
  Area dropButtonArea = Area();

  @observable
  Lote loteSelecionado = Lote();

  @observable
  List<bool> expandedCard = [];

  @observable
  TextEditingController searchAtividade = TextEditingController();

  @observable
  TextEditingController searchLote = TextEditingController();

  @action
  TextEditingController setSearchAtividade(String value) =>
      searchAtividade = TextEditingController(text: value);

  @action
  TextEditingController setSearchLote(String value) =>
      searchLote = TextEditingController(text: value);

  @action
  Area selecionarDropButtonArea(Area area) => dropButtonArea = area;

  @action
  Setor selecionarDropButtonSetor(Setor setor) => dropButtonSetor = setor;

  @action
  Lote setLoteSelecionado(Lote lote) => loteSelecionado = lote;

  @action
  void setExpandedCard(int index) {
    expandedCard[index] = !expandedCard[index];
    expandedCard = List.from(expandedCard);
  }

  @action
  void toggleMostrarRegistrosSistema() =>
      mostrarRegistrosSistema = !mostrarRegistrosSistema;

  @action
  Future<void> buscarLotesByConta() async {
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
    return;
  }

  @action
  Future<void> buscarAtividades() async {
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
        for (var i = 0; i < loteSelecionado.lotes_atividades!.length; i++) {
          loteSelecionado.lotes_atividades![i].usuario?.selected_conta =
              loteSelecionado.lotes_atividades![i].usuario?.contas?.firstWhere(
            (element) {
              return element.conta?.id ==
                  authController.usuario.selected_conta!.conta!.id!;
            },
          );
        }

        expandedCard = [];

        for (var i = 0;
            i < (loteSelecionado.lotes_atividades?.length ?? 0.0);
            i++) {
          expandedCard.add(false);
        }

        loteSelecionado.lotes_atividades =
            List.from(loteSelecionado.lotes_atividades!.reversed);
        expandedCard = List.from(expandedCard.reversed);
        if (GetIt.I.isRegistered<InstantSequenceInteractionReporter>()) {
          GetIt.I<InstantSequenceInteractionReporter>()
              .reportAdjustmentRecorded();
        }
      },
    );

    isLoteListLoading = false;
  }

  @action
  Future<void> buscarLotesBySetor() async {
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
  Future<void> buscarLotesByArea() async {
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
  Future<void> buscarAreasList() async {
    isAreaLoading = true;

    AuthController authController = GetIt.I<AuthController>();
    CadernoCampoRepository cadernoCampoRepository =
        GetIt.I<CadernoCampoRepository>();

    var areaListResult = await cadernoCampoRepository
        .buscarAreasList(authController.usuario.selected_conta!.conta!.id!);

    areaListResult.fold(
      (err) {
        // toastError(message: err.message);
      },
      (data) async {
        areaList = List.from(data);
      },
    );
    isAreaLoading = false;
  }

  @action
  Lote limparLoteSelecionado() => loteSelecionado = Lote();

  @action
  void limparLotes() {
    loteList.clear();
    areaList.clear();
    isLoteListLoading = false;
    isAreaLoading = false;
    setorSelecionado = Setor();
    dropButtonSetor = Setor();
    dropButtonArea = Area();
    loteSelecionado = Lote();
    expandedCard.clear();
    searchAtividade.clear();
    searchLote.clear();
  }

  @computed
  List<LotesAtividades> get getLotesAtividadesFilter {
    List<LotesAtividades> list =
        (loteSelecionado.lotes_atividades ?? []).where((element) {
      if (!mostrarRegistrosSistema && (element.atividade?.privado == true)) {
        return false;
      }
      if (searchAtividade.text.isEmpty) return true;
      return (element.atividade?.nome ?? '')
          .toLowerCase()
          .contains(searchAtividade.text.toLowerCase());
    }).toList();
    return list;
  }

  @computed
  List<Lote> get getLotesFilter => loteList.where((element) {
        if (searchLote.text.isEmpty) return true;
        return (element.nome ?? '')
            .toLowerCase()
            .contains(searchLote.text.toLowerCase());
      }).toList();

  // #################### START CADASTRO CADERNO DE CAMPO #######################

  @observable
  int dotIndicator = 0;

  @observable
  bool mostrarErroFormulario = false;

  @observable
  bool isCadastroLoteLoading = false;

  @observable
  bool showTextFormField = false;

  @observable
  bool isNovoRegistroLoading = false;

  @observable
  bool isEditing = false;

  @observable
  String selectedGroup = 'Cultura';

  @observable
  List<LoteByFilter> lotesGroup = [];

  @observable
  List<Usuario> usuariosConta = [];

  @observable
  Usuario? selectedUsuario;

  @observable
  TextEditingController novoAtividadeName = TextEditingController(text: '');

  @observable
  TextEditingController novoAutorName = TextEditingController();

  @observable
  TextEditingController novaDescricao = TextEditingController(text: '');

  @observable
  TextEditingController searchLotePage = TextEditingController(text: '');

  @observable
  DateTime dateRegistro = DateTime.now();

  // @observable
  // TimeOfDay timeRegistro = TimeOfDay.now();

  @observable
  Lote loteCadastro = Lote();

  @action
  DateTime selectDateRegistro(DateTime value) => dateRegistro = value;

  @action
  DateTime selectTimeRegistro(TimeOfDay value) => dateRegistro = DateTime(
      dateRegistro.year,
      dateRegistro.month,
      dateRegistro.day,
      value.hour,
      value.minute);

  @action
  void setSeachLotePage(String value) {
    searchLotePage = TextEditingController(text: value);
  }

  @action
  void selectUser(Usuario? usuario) {
    selectedUsuario = usuario;
    if (usuario != null) {
      novoAutorName = TextEditingController(
          text: '${usuario.nome} (${usuario.selected_conta?.cargo?.cargo})');
    } else {
      novoAutorName.clear();
    }
  }

  @action
  void setDotIndicator(int value) {
    if (value >= 0 && value <= 2) {
      dotIndicator = value;
    }
  }

  @action
  void setSelectedGroup(String name) {
    selectedGroup = name;
  }

  @action
  void setShowTextFormField(bool value) {
    showTextFormField = value;
  }

  @action
  void setIsCadastroLoteLoading(bool value) {
    isCadastroLoteLoading = value;
  }

  @action
  void alterarAtividadeNome(String name) {
    novoAtividadeName = TextEditingController(text: name);
  }

  @action
  void selectLotesGroup(int index, bool value) {
    getLotesGroup[index].selected = value;
    for (var i = 0; i < getLotesGroup[index].lotesSelection.length; i++) {
      getLotesGroup[index].lotesSelection[i].selected = value;
    }

    lotesGroup = List.from(lotesGroup);
  }

  @action
  void selectLotesByLote(Lote lote, bool value) {
    for (var i = 0; i < lotesGroup.length; i++) {
      for (var item in lotesGroup[i].lotesSelection) {
        if (item.lote.id == lote.id) item.selected = value;
      }
    }

    lotesGroup = List.from(lotesGroup);
  }

  @action
  void selectLotesSelection(int index1, int index2, bool value) {
    getLotesGroup[index1].lotesSelection[index2].selected = value;
    lotesGroup = List.from(lotesGroup);
  }

  @action
  Future<void> buscarUsuariosConta() async {
    isAreaLoading = true;

    AuthController authController = GetIt.I<AuthController>();
    CadernoCampoRepository cadernoCampoRepository =
        GetIt.I<CadernoCampoRepository>();

    var usuariosContaResult = await cadernoCampoRepository
        .buscarUsuariosConta(authController.usuario.selected_conta!.conta!.id!);

    usuariosContaResult.fold(
      (err) {
        usuariosConta = List.from([]);
      },
      (data) async {
        usuariosConta = data;
        for (var user in usuariosConta) {
          int index = user.contas!.indexWhere((element) =>
              element.conta!.id ==
              authController.usuario.selected_conta!.conta!.id);
          if (index != -1) {
            user.selected_conta = user.contas?[index];
          }
        }
        usuariosConta = List.from(usuariosConta);
      },
    );
    isAreaLoading = false;
  }

  @action
  bool validarCadastro() {
    bool validate = novoAtividadeName.text.isNotEmpty &&
        novaDescricao.text.isNotEmpty &&
        selectedUsuario != null;

    mostrarErroFormulario = !validate;
    return validate;
  }

  @action
  Future<void> cadastrarAtividade() async {
    isNovoRegistroLoading = true;

    AuthController authController = GetIt.I<AuthController>();
    CadernoCampoRepository cadernoCampoRepository =
        GetIt.I<CadernoCampoRepository>();

    Atividade novaAtividade = Atividade(
      nome: novoAtividadeName.text,
      descricao: encodeAtividadeDescricao(novaDescricao.text),
      privado: true,
      conta: authController.usuario.selected_conta!.conta,
      created_at: dateRegistro,
    );

    List<int> listLoteId = [];

    for (var groups in lotesGroup) {
      for (var lote in groups.lotesSelection) {
        if (lote.selected) {
          listLoteId.add(lote.lote.id!);
        }
      }
    }

    var atividadeResult = await cadernoCampoRepository.cadastrarAtividade(
      atividade: novaAtividade,
      usuarioId: selectedUsuario!.id!,
      listLoteId: listLoteId,
    );

    atividadeResult.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        Get.close(2);
        await buscarLotesByConta();
        if (loteSelecionado.id != null) buscarAtividades();
      },
    );
    isNovoRegistroLoading = false;
  }

  @action
  Future<void> groupLotesBy() async {
    isCadastroLoteLoading = true;

    await buscarLotesByConta();

    switch (selectedGroup) {
      case 'Cultura':
        final groupResult = groupBy(loteList, (Lote loteGroup) {
          return loteGroup.cultura?.nome ?? 'Não informado';
        });
        lotesGroup = [];
        groupResult.forEach((key, value) {
          lotesGroup.add(
            LoteByFilter(
              key: key,
              selected: false,
              lotesSelection: value.map((e) {
                if (loteSelecionado.id != null && loteSelecionado.id == e.id) {
                  return LoteSelection(selected: true, lote: e);
                }

                return LoteSelection(selected: false, lote: e);
              }).toList(),
            ),
          );
        });
        break;
      case 'Setor':
        var groupResult = groupBy(loteList, (Lote loteGroup) {
          return '${loteGroup.setor?.area?.nome ?? 'Não informado'} - ${loteGroup.setor?.nome ?? 'Não informado'}';
        });

        var sortedKeys = Map.fromEntries(groupResult.entries.toList()
          ..sort((e1, e2) => e1.key.compareTo(e2.key)));
        groupResult = sortedKeys;

        lotesGroup = [];
        groupResult.forEach((key, value) {
          lotesGroup.add(
            LoteByFilter(
              key: key,
              selected: false,
              lotesSelection: value.map((e) {
                if (loteSelecionado.id != null && loteSelecionado.id == e.id) {
                  return LoteSelection(selected: true, lote: e);
                }

                return LoteSelection(selected: false, lote: e);
              }).toList(),
            ),
          );
        });
        break;
      default:
        lotesGroup = [];
        break;
    }

    lotesGroup = List.from(lotesGroup);
    isCadastroLoteLoading = false;
  }

  @action
  void limparTudo() {
    dotIndicator = 0;
    isCadastroLoteLoading = false;
    showTextFormField = false;
    isNovoRegistroLoading = false;
    isEditing = false;
    selectedGroup = 'Cultura';
    lotesGroup = [];
    usuariosConta = [];
    selectedUsuario = null;
    novoAtividadeName.clear();
    novoAutorName.clear();
    novaDescricao.clear();
    searchLotePage.clear();
    dateRegistro = DateTime.now();
    loteCadastro = Lote();
  }

  @computed
  List<LoteByFilter> get getLotesGroup => lotesGroup.where((element) {
        if (searchLotePage.text.isEmpty) return true;
        return element.key
            .toLowerCase()
            .contains(searchLotePage.text.toLowerCase());
      }).toList();

  @computed
  List<Lote> get selectedLotes {
    List<Lote> list = [];
    for (var i = 0; i < lotesGroup.length; i++) {
      for (var item in lotesGroup[i].lotesSelection) {
        if (item.selected) list.add(item.lote);
      }
    }
    return list;
  }
}
