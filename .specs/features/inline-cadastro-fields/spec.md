# Inline Fields — Eliminar Camada Summary + Modal em N1 e N2

**Status:** Draft
**Autor:** Orchestrator
**Data:** 2026-07-05
**Versão:** 1.0
**Feature:** `inline-cadastro-fields`

---

## 1. Overview

### 1.1 Contexto

As páginas de cadastro de **Área (N1)** e **Setor (N2)** usam um padrão de duas camadas:

1. **Página principal** com `AppFormSelectionTile` mostrando um resumo ("Preencher" / valor)
2. **Bottom sheet modal** com `AppStepWizard` para preencher os campos

Esse padrão força o usuário a: abrir modal → preencher → fechar → ver resumo → salvar. O ideal é que os campos estejam **diretamente visíveis na página**, como já acontece no cadastro de Lote (N3).

### 1.2 Escopo

**Dentro do escopo:**
- Substituir `AppFormSelectionTile` por campos de formulário inline em `cadastrar_area_cultivo_page.dart` (N1)
- Substituir `AppFormSelectionTile` por campos de formulário inline em `cadastrar_setor_page.dart` (N2)
- Extrair formulário de endereço (`FormularioNovaLocalizacao`) para uso inline em N1
- Remover bottom sheets e step widgets não utilizados (N1 e N2)
- Manter os mesmos stores, controllers e lógica de validação

**Fora do escopo:**
- Alteração de stores ou modelos de dados
- Alteração de lógica de validação ou submit
- Refatoração de outras páginas de cadastro além de N1 e N2
- Criação de testes automatizados

---

## 2. Current State Analysis

### 2.1 N1 — Área de Cultivo

**Antes:**
```
cadastrar_area_cultivo_page.dart
├── AppFormSelectionTile("Nome") → onTap → bottomSheet
│   └── bottomSheet
│       └── AppModalSheet + AppStepWizard
│           ├── nomePage (TextFormField)
│           └── localizacaoPage (lista selecionável) → novaLocalizacaoPage (formulário endereço)
├── AppFormSelectionTile("Localização") → onTap → bottomSheet (step 2)
├── Descrição (toggle inline)
└── Salvar
```

**Arquivos envolvidos:**
- `cadastrar_area_cultivo_page.dart` (243 linhas)
- `components/bottomSheet.dart` (32 linhas)
- `components/pagesNovaAreaCultivo.dart` (22 linhas)
- `components/nomePage.dart` (37 linhas)
- `components/localizacaoPage.dart` (98 linhas)
- `components/novaLocalizacaoPage.dart` (318 linhas — contém `FormularioNovaLocalizacao`)

### 2.2 N2 — Setor

**Antes:**
```
cadastrar_setor_page.dart
├── Row("Área: ...")  ← info readonly
├── AppFormSelectionTile("Nome") → onTap → bottomSheet
│   └── bottomSheet
│       └── AppModalSheet + AppStepWizard
│           ├── nomePage (TextFormField)
│           └── reservatorioPage (AppDropdown + link criar)
├── AppFormSelectionTile("Reservatório") → onTap → bottomSheet (step 2)
├── Descrição (toggle inline)
└── Salvar
```

**Arquivos envolvidos:**
- `cadastrar_setor_page.dart` (300 linhas)
- `components/bottomSheet.dart` (15 linhas)
- `components/pagesNovoSetor.dart` (20 linhas)
- `components/nomePage.dart` (71 linhas)
- `components/reservatorioPage.dart` (175 linhas)

---

## 3. Design Decisions

### 3.1 Nomes Inline em Ambos

Substituir o `AppFormSelectionTile` de nome por um `TextFormField` direto, usando o mesmo controller do store. O texto do hint permanece o mesmo ("EX. Estufa UFMT", "EX. Setor de Crescimento").

### 3.2 Localização Inline (N1)

Dois modos controlados pelo store:
- **Modo seleção**: `AppDropdown` com lista de localizações existentes + botão "+ Nova localização"
- **Modo criação**: Formulário de endereço (CEP, endereço, bairro, número, cidade, estado, país, complemento) usando o mesmo `FormularioNovaLocalizacao` mas sem Scaffold/AppBar

### 3.3 Reservatório Inline (N2)

`AppDropdown` com lista de reservatórios + link "Criar novo reservatório" que navega para `CadastrarReservatorioPage`

### 3.4 Descrição (mantida)

O toggle de descrição já é inline. Manter o comportamento atual.

---

## 4. Especificação das Mudanças

### 4.1 N2 — cadastrar_setor_page.dart

**Antes:**
```dart
nome(context) → AppFormSelectionTile → onTap → bottomSheet(store)
reservatorio(context) → AppFormSelectionTile → onTap → bottomSheet(store)
```

**Depois — campos inline direto no Column:**
```dart
// Nome
const Padding(
  padding: EdgeInsets.only(top: 10, left: 20),
  child: Text('Nome', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
),
Observer(builder: (_) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    child: TextFormField(
      controller: store.novoSetorName,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(hintText: 'EX. Setor de Crescimento'),
    ),
  );
}),
AppValidationMessage(...),

// Reservatório
const Padding(
  padding: EdgeInsets.only(top: 10, left: 20),
  child: Text('Reservatório', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
),
Observer(builder: (_) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    child: AppDropdown<Reservatorio>(
      value: store.novoSetorReservatorio.id != null ? ... : null,
      hint: const Text('Selecionar reservatório'),
      items: store.reservatorioList.map(...),
      onChanged: (value) { if (value != null) store.setReservatorioSelecionada(value); },
    ),
  );
}),
Padding(
  padding: const EdgeInsets.only(left: 20),
  child: TextButton(
    child: const Text("Criar novo reservatório"),
    onPressed: () => Get.to(() => const CadastrarReservatorioPage(isShortcut: true)),
  ),
),
```

**Remover:**
- Import `bottomSheet.dart`
- Métodos `nome()`, `reservatorio()`, `warning()`
- `CarouselSliderController` (se existir — não existe em setor)
- Arquivos: `bottomSheet.dart`, `pagesNovoSetor.dart`, `nomePage.dart`, `reservatorioPage.dart`

**Adicionar:**
- Import `AppDropdown` (se já não importado)
- Import `Reservatorio` model

### 4.2 N1 — cadastrar_area_cultivo_page.dart

**Antes:**
```dart
nome(context) → AppFormSelectionTile → onTap → bottomSheet(controlerPages, store)
localizacao(context) → AppFormSelectionTile → onTap → bottomSheet(controlerPages, store)
```

**Depois — campos inline:**
```dart
// Nome
Text('Nome', style: ...),
TextFormField(controller: store.novaAreaName, hintText: 'EX. Estufa UFMT'),
AppValidationMessage(...),

// Localização — selector + formulário
Text('Localização', style: ...),
// Dropdown de localizações existentes (se houver)
Observer(builder: (_) {
  if (store.localizacaoList.isEmpty && !store.showNewLocationForm) {
    // sem localizações, mostra formulário direto
    return _buildLocationForm();
  }
  if (store.showNewLocationForm) {
    return _buildLocationForm();
  }
  return Column(
    children: [
      AppDropdown<Localizacao>(
        value: store.localizacaoSelecionada,
        items: store.localizacaoList.map(...),
        onChanged: store.setLocalizacaoSelecionada,
      ),
      TextButton("+ Nova localização", onPressed: store.toggleNewLocationForm ?? () {}),
    ],
  );
}),

// Descrição
Text('Descrição', style: ...),
TextFormField(controller: store.novaAreaDescricao, maxLines: 4),
```

**O formulário de endereço** (`_buildLocationForm`) será extraído do `FormularioNovaLocalizacao` existente em `novaLocalizacaoPage.dart`, convertido de StatefulWidget para função/StatelessWidget (não precisa de estado próprio, usa store).

**Remover:**
- Import `bottomSheet.dart`
- `CarouselSliderController controlerPages`
- Métodos `nome()`, `localizacao()`, `descricao()`, `botaoDescricao()`
- Arquivos: `bottomSheet.dart`, `pagesNovaAreaCultivo.dart`, `nomePage.dart`, `localizacaoPage.dart`, `novaLocalizacaoPage.dart`

---

## 5. File List

| Arquivo | Ação |
|---|---|
| `N2/cadastrar_setor_page.dart` | **Modificar** — inline fields |
| `N2/components/bottomSheet.dart` | **Remover** |
| `N2/components/pagesNovoSetor.dart` | **Remover** |
| `N2/components/nomePage.dart` | **Remover** |
| `N2/components/reservatorioPage.dart` | **Remover** |
| `N1/cadastrar_area_cultivo_page.dart` | **Modificar** — inline fields + address form inline |
| `N1/components/bottomSheet.dart` | **Remover** |
| `N1/components/pagesNovaAreaCultivo.dart` | **Remover** |
| `N1/components/nomePage.dart` | **Remover** |
| `N1/components/localizacaoPage.dart` | **Remover** |
| `N1/components/novaLocalizacaoPage.dart` | **Remover** |

---

## 6. Acceptance Criteria

| ID | Critério |
|---|---|
| **F1** | N2: campo "Nome" é um TextFormField direto na página (não via tile + modal) |
| **F2** | N2: campo "Reservatório" é um AppDropdown direto na página |
| **F3** | N2: link "Criar novo reservatório" navega para CadastrarReservatorioPage |
| **F4** | N1: campo "Nome" é um TextFormField direto na página |
| **F5** | N1: campo "Localização" mostra lista/seletor inline (não via modal) |
| **F6** | N1: formulário de endereço (CEP, endereço, etc.) aparece inline quando necessário |
| **F7** | Nenhum arquivo de bottom sheet ou step widget permanece sem referência |
| **F8** | `dart analyze` em todos os arquivos modificados → zero erros |

---

## 7. References

- Página N1: `lib/features/presenter/views/area_cultivo/N1/cadastrar_area_cultivo_page.dart`
- Componentes N1: `lib/features/presenter/views/area_cultivo/N1/components/`
- Página N2: `lib/features/presenter/views/area_cultivo/N2/cadastrar_setor_page.dart`
- Componentes N2: `lib/features/presenter/views/area_cultivo/N2/components/`
- `AppDropdown`: `lib/features/presenter/widgets/common/app_dropdown.dart`
- Store N2: `lib/features/presenter/viewmodels/setor_store.dart`
