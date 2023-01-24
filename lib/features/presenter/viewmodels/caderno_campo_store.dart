import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/data/repositories/cadernoCampo/cadeno_campo_repository.dart';
import 'package:osi_solucoes/features/presenter/models/area/area_model.dart';
import 'package:osi_solucoes/features/presenter/models/atividade/atividade_model.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';
import 'package:osi_solucoes/features/presenter/models/lotesAtividades/lotes_atividades_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';
import "package:collection/collection.dart";

part 'caderno_campo_store.g.dart';

class CadernoCampoStore = _CadernoCampoStoreBase with _$CadernoCampoStore;

abstract class _CadernoCampoStoreBase with Store {
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

  @observable
  List<bool> expandedCard = [];

  @observable
  TextEditingController searchAtividade = TextEditingController();

  @observable
  TextEditingController searchLote = TextEditingController();

  @action
  setSearchAtividade(String value) =>
      searchAtividade = TextEditingController(text: value);

  @action
  setSearchLote(String value) =>
      searchLote = TextEditingController(text: value);

  @action
  selecionarDropButtonArea(Area area) => dropButtonArea = area;

  @action
  selecionarDropButtonSetor(Setor setor) => dropButtonSetor = setor;

  @action
  setLoteSelecionado(Lote lote) => loteSelecionado = lote;

  @action
  setExpandedCard(int index) {
    expandedCard[index] = !expandedCard[index];
    expandedCard = List.from(expandedCard);
  }

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
    return;
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
  buscarAreasList() async {
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
  limparLotes() {
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
  selectDateRegistro(DateTime value) => dateRegistro = value;

  @action
  selectTimeRegistro(TimeOfDay value) => dateRegistro = DateTime(
      dateRegistro.year,
      dateRegistro.month,
      dateRegistro.day,
      value.hour,
      value.minute);

  @action
  setSeachLotePage(String value) {
    searchLotePage = TextEditingController(text: value);
  }

  @action
  selectUser(Usuario? usuario) {
    selectedUsuario = usuario;
    if (usuario != null) {
      novoAutorName = TextEditingController(
          text: '${usuario.nome} (${usuario.selected_conta?.cargo?.cargo})');
    } else {
      novoAutorName.clear();
    }
  }

  @action
  setDotIndicator(int value) {
    if (value >= 0 && value <= 2) {
      dotIndicator = value;
    }
  }

  @action
  setSelectedGroup(String name) {
    selectedGroup = name;
  }

  @action
  setShowTextFormField(bool value) {
    showTextFormField = value;
  }

  @action
  setIsCadastroLoteLoading(bool value) {
    isCadastroLoteLoading = value;
  }

  @action
  alterarAtividadeNome(String name) {
    novoAtividadeName = TextEditingController(text: name);
  }

  @action
  selectLotesGroup(int index, bool value) {
    getLotesGroup[index].selected = value;
    for (var i = 0; i < getLotesGroup[index].lotesSelection.length; i++) {
      getLotesGroup[index].lotesSelection[i].selected = value;
    }

    lotesGroup = List.from(lotesGroup);
  }

  @action
  selectLotesByLote(Lote lote, bool value) {
    for (var i = 0; i < lotesGroup.length; i++) {
      for (var item in lotesGroup[i].lotesSelection) {
        if (item.lote.id == lote.id) item.selected = value;
      }
    }

    lotesGroup = List.from(lotesGroup);
  }

  @action
  selectLotesSelection(int index1, int index2, bool value) {
    getLotesGroup[index1].lotesSelection[index2].selected = value;
    lotesGroup = List.from(lotesGroup);
  }

  @action
  buscarUsuariosConta() async {
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
  validarCadastro() {
    bool validate = novoAtividadeName.text.isNotEmpty &&
        novaDescricao.text.isNotEmpty &&
        selectedUsuario != null;

    mostrarErroFormulario = !validate;
    return validate;
  }

  @action
  cadastrarAtividade() async {
    isNovoRegistroLoading = true;

    AuthController authController = GetIt.I<AuthController>();
    CadernoCampoRepository cadernoCampoRepository =
        GetIt.I<CadernoCampoRepository>();

    Atividade novaAtividade = Atividade(
      nome: novoAtividadeName.text,
      descricao: utf8.encode(novaDescricao.text).toString(),
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
        await buscarLotesByConta();
        Get.close(2);
      },
    );
    isNovoRegistroLoading = false;
  }

  @action
  groupLotesBy() async {
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
              lotesSelection: value
                  .map((e) => LoteSelection(selected: false, lote: e))
                  .toList(),
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
              lotesSelection: value
                  .map((e) => LoteSelection(selected: false, lote: e))
                  .toList(),
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
  limparTudo() {
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
