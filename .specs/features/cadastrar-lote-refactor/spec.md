# Refatoração da Página "Cadastrar Lote"

**Status:** Draft  
**Autor:** Leaf Spec Agent  
**Data:** 2026-07-03  
**Versão:** 1.0  

---

## 1. Overview

### 1.1 Contexto

A página de cadastro de lote (`cadastrar_lote_page.dart`) é o ponto de entrada para registrar um novo lote de cultivo no sistema de gestão agrícola. O fluxo atual possui dois layers sobrepostos — uma visualização resumo com 5 ListTiles + botão "Salvar" na página principal, e um wizard em bottom sheet com 5 steps usando CarouselSlider — que geram confusão de navegação, código duplicado e inconsistência visual.

O redesign unifica o fluxo em uma única experiência progressiva (stepper inline na própria página), eliminando a dualidade página/bottom-sheet e aplicando o design system existente.

### 1.2 Escopo

**Dentro do escopo:**
- Unificar os dois layers (summary view + bottom sheet wizard) em um único fluxo inline
- Substituir `CarouselSlider` + `DotsIndicator` por um stepper com labels textuais por etapa
- Aplicar `AppPanelCard`, `AppFormSection`, `AppFormSelectionTile`, `AppEntityCard`, `AppStatePanel`, `AppSectionHeader`, `AppPrimaryButton`, `AppDropdown`, `AppModalSheet` do design system existente
- Substituir cores inline (ex: `Color(0xFFC4C4C4)`, `Color(0xffF5F5F5)`, `Color(0xff6F6464)`) por tokens de `Constants.*`
- Adicionar validação por etapa antes de permitir avanço
- Atualizar cópia dos headings (eliminar padrão "Qual X deseja...?")
- Substituir `"Preencher"` / `"Selecionar"` por indicadores visuais de completude (badge/check)
- Manter as funcionalidades de drill-down (detalhes de reservatório, detalhes de protocolo, atividades) como bottom sheets modais usando `AppModalSheet`
- Manter o estado MobX (`lote_store.dart`) como fonte da verdade, reorganizando apenas se necessário

**Fora do escopo:**
- Migração para outro state manager
- Alteração do modelo de dados (`Lote`, `Reservatorio`, `Protocolo`, `Cultura`, `Setor`, `Area`)
- Alteração da API/GraphQL (repositories)
- Criação de testes automatizados
- Internacionalização / i18n
- Dark mode
- Adição de novos campos ao formulário

---

## 2. Current State Analysis

### 2.1 Arquitetura Atual

```
cadastrar_lote_page.dart (596 linhas)
├── Summary view (Scaffold → Column)
│   ├── titulo() / subtitulo()
│   ├── setor() → InkWell + ListTile
│   ├── Divider (hardcoded Color(0xFFC4C4C4))
│   ├── lote() → InkWell + ListTile
│   ├── Divider
│   ├── cultura() → InkWell + ListTile
│   ├── Divider
│   ├── reservatorio() → InkWell + ListTile
│   ├── Divider
│   ├── protocolo() → InkWell + ListTile
│   └── saveButton() → AppPrimaryButton
│
└── bottomSheetN3() → showModalBottomSheet (90% altura)
    ├── DotsIndicator (5 dots, sem label)
    ├── CarouselSlider (5 páginas)
    │   ├── setorPage()    → step 0
    │   ├── lotePage()     → step 1
    │   ├── culturaPage()  → step 2
    │   ├── reservatorioPage() / reservatorioDetalhesPage()  → step 3
    │   └── protocoloPage() / protocoloDetalhes() / protocoloAtividadeDetalhes()  → step 4
    └── BackStepButton / NextStepButton
```

### 2.2 Problemas Identificados

| # | Problema | Localização | Impacto |
|---|----------|-------------|---------|
| 1 | Dois layers (summary + wizard) redundantes | `cadastrar_lote_page.dart` linhas 70-183 vs 266-411 | Usuário preenche no sheet, fecha, e salva na página. Fluxo confuso. |
| 2 | Bottom sheet a 90% é essencialmente full page | linha 289: `size.height * 0.9` | Perde benefícios de bottom sheet (contexto, drag). |
| 3 | DotsIndicator sem label textual | linha 331-342 | Usuário não sabe qual etapa está vindo ou indo. |
| 4 | Repetição "Qual X deseja...?" em todos os steps | `setor_item.dart:117-128`, `lote_item.dart:107-118`, `cultura_item.dart:106-117`, `reservatorio_item.dart:106-117`, `protocolo_page.dart:106-119` | Cansativo, não escalável. |
| 5 | Sem validação por step antes de avançar | `NextStepButton` não valida campo atual | Usuário avança sem preencher, erro só aparece no save final. |
| 6 | Indicador de completude fraco ("Preencher" / "Selecionar") | `setor_item.dart:68`, `lote_item.dart:62`, `cultura_item.dart:63`, `reservatorio_item.dart:63`, `protocolo_page.dart:63` | Não comunica status claramente. |
| 7 | Cores inline não usam tokens | `Color(0xFFC4C4C4)`, `Color(0xffF5F5F5)`, `Color(0xff6F6464)` | Inconsistência, difícil manutenção. |
| 8 | Card com `elevation: 5` em vez de `AppPanelCard` | `reservatorio_item.dart:177-181`, `protocoloItemLote.dart:29-33` | Fere padronização. |
| 9 | Hardcoded dividers e spacing inconsistente | `Divider(thickness:0.5, color:Color(0xFFC4C4C4))` repetido | Semântica zero, difícil de alterar globalmente. |
| 10 | Store muito grande (1193 linhas) mescla observables do cadastro com outras funcionalidades | `lote_store.dart` | Baixa coesão, difícil manutenção. |

### 2.3 Design System Disponível (não utilizado)

| Componente | Arquivo | Status atual |
|------------|---------|-------------|
| `AppPanelCard` | `app_panel_card.dart` | Não usado na página (cards usam `Card(elevation:5)` diretamente) |
| `AppFormSection` | `app_form_section.dart` | Não usado (substituível por seções com título + validação) |
| `AppFormSelectionTile` | `app_form_selection_tile.dart` | Não usado (substituiria ListTiles no stepper) |
| `AppEntityCard` | `app_entity_card.dart` | Não usado (substituiria cards de protocolo/reservatório) |
| `AppModalSheet` | `app_modal_sheet.dart` | Não usado (substituiria `showModalBottomSheet` manual com header e padding) |
| `AppStatePanel` | `app_state_panel.dart` | Não usado (loading/empty/error atuais são widgets avulsos) |
| `AppSectionHeader` | `app_section_header.dart` | Não usado (títulos são `Padding` + `Text` manual) |
| `AppIconTile` | `app_icon_tile.dart` | Não usado (leading icons são `Icon` solto) |
| `AppPrimaryButton` | `app_primary_button.dart` | **Usado** no botão Salvar |

---

## 3. Design Decisions

### 3.1 Decisão 1: Stepper Inline em vez de Bottom Sheet + Summary

**Opções consideradas:**
1. **Manter dual-layer** (status quo) — rejeitado: maior fonte de confusão.
2. **Wizard-only** (apenas bottom sheet como fluxo principal) — rejeitado: 90% de altura não traz benefício real de bottom sheet, e perderia o contexto da página.
3. **Stepper inline na própria página** com progresso textual — **escolhido**.

**Decisão:** Substituir o bottom sheet + CarouselSlider por um stepper vertical ou horizontal na própria `CadastrarLotePage`. Cada etapa é uma `AppFormSection` com transição animada. Não há mais bottom sheet para o wizard — apenas para drill-down details (reservatório detalhes, protocolo detalhes, atividades).

**Justificativa:** Elimina a dualidade, reduz complexidade, permite validação por etapa naturalmente, e o progresso fica visível sem ocupar espaço extra de sheet.

### 3.2 Decisão 2: Stepper com Labels Textuais

Substituir `DotsIndicator` (5 bolinhas sem label) por um componente de progresso que mostra:
- Nome da etapa atual
- Número da etapa (ex: "Etapa 2 de 5")
- Etapas concluídas com check
- Etapa atual destacada
- Etapas futuras atenuadas

Pode ser implementado como `StepProgressBar` (widget próprio) que recebe `currentStep`, `totalSteps`, `stepLabels`, `completedSteps`.

### 33 Decisão 3: Validação por Etapa

Cada etapa válida seus campos antes de permitir `next`. O botão "Avançar" fica desabilitado se a etapa não for válida. A validação usa os métodos já existentes no store (`validarRegistro()` pode ser desmembrado em validadores específicos).

### 34 Decisão 4: Indicadores de Status nos Steps

Cada etapa concluída mostra:
- Ícone de check verde (`Icons.check_circle`, `Constants.kPrimaryColor`)
- Resumo do que foi selecionado/preenchido (ex: "Setor: A1 - Norte")
- Etapa atual mostra um indicador de "em andamento" (cor primária, borda destacada)
- Etapa não iniciada mostra tom cinza

### 3.5 Decisão 5: Drill-down como Bottom Sheets Modais

Os detalhes (reservatório detalhes, protocolo detalhes, atividades) continuam como bottom sheets, mas agora usando `AppModalSheet.show()` com header padronizado, ao invés de `showModalBottomSheet` manual.

### 3.6 Decisão 6: Store Permanece, mas com Refatoração Mínima

O `lote_store.dart` (1193 linhas) não será refatorado estruturalmente neste escopo. Apenas removeremos os observables de controle de UI que se tornarem obsoletos:
- `dotIndicator` → substituído por `currentStep` no novo stepper
- `showReservatorioDetalhes`, `showProtocoloDetalhes` → movidos para controle local do stepper ou mantidos
- `mostrarErroFormulario` → substituído por validação por etapa

---

## 4. Component Tree / Estrutura

### 4.1 Nova Árvore de Componentes

```
CadastrarLotePage (StatefulWidget)
├── AppFormHeader (appBar)
├── SingleChildScrollView
│   ├── PageHeader (título + subtítulo existentes)
│   ├── StepProgressBar (NOVO)
│   │   ├── StepIndicator × 5 (cada um com label, status, número)
│   │   └── ConnectorLine × 4
│   ├── AnimatedSwitcher
│   │   ├── StepContent[0]: SetorStep
│   │   │   └── AppFormSection("Área e Setor")
│   │   │       ├── AppDropdown<Area>
│   │   │       └── AppDropdown<Setor>
│   │   ├── StepContent[1]: LoteStep
│   │   │   └── AppFormSection("Identificação do Lote")
│   │   │       └── TextFormField (nome)
│   │   ├── StepContent[2]: CulturaStep
│   │   │   └── AppFormSection("Cultura")
│   │   │       ├── AppFormSelectionTile × N (radio)
│   │   │       └── "Adicionar nova cultura" (inline form)
│   │   ├── StepContent[3]: ReservatorioStep
│   │   │   └── AppFormSection("Reservatório")
│   │   │       ├── AppEntityCard × N (lista de reservatórios)
│   │   │       └── "Vincular" → AppModalSheet (detalhes)
│   │   └── StepContent[4]: ProtocoloStep
│   │       └── AppFormSection("Protocolo")
│   │           ├── AppSearchBar
│   │           ├── AppEntityCard × N (lista de protocolos)
│   │           └── "Vincular" → AppModalSheet (detalhes + atividades)
│   └── NavigationFooter
│       ├── TextButton("Voltar")
│       ├── StepCounter ("Etapa X de 5")
│       └── AppPrimaryButton("Avançar" / "Concluir")
```

### 4.2 Estrutura de Arquivos Proposta

```
lib/features/presenter/views/area_cultivo/N3/
├── cadastrar_lote_page.dart          (REFATORADO ~250 linhas)
├── components/
│   ├── cadastrar_page/               (PASTA MANTIDA, conteúdo refatorado)
│   │   ├── setor_step.dart           → Step de área/setor
│   │   ├── lote_step.dart            → Step de nome do lote
│   │   ├── cultura_step.dart         → Step de cultura + add cultura
│   │   ├── reservatorio_step.dart    → Step de seleção de reservatório
│   │   ├── reservatorio_detalhes_page.dart  (MANTIDO, mas usando AppModalSheet)
│   │   ├── protocolo_step.dart       → Step de seleção de protocolo
│   │   ├── protocolo_detalhes_page.dart     (MANTIDO, mas usando AppModalSheet)
│   │   ├── protocolo_detalhes_atv.dart      (MANTIDO)
│   │   ├── protocolo_atividadeItemDetalhes.dart (MANTIDO)
│   │   ├── protocolo_item_card.dart → Renomeado de protocoloItemLote.dart
│   │   ├── step_progress_bar.dart    → NOVO: indicador de progresso textual
│   │   ├── step_navigation_footer.dart → NOVO: botões voltar/avançar + contador
│   │   └── data_item.dart           → (MANTIDO ou removido se não usado no fluxo)
```

### 4.3 Descrição dos Novos Componentes

#### `StepProgressBar`

```
Props:
  - currentStep: int (0-4)
  - stepLabels: List<String> (["Setor", "Lote", "Cultura", "Reservatório", "Protocolo"])
  - completedSteps: Set<int>
  - totalSteps: int (5)

Comportamento:
  - Exibe horizontalmente os 5 steps com label textual
  - Step concluído: check verde + label completa
  - Step atual: label em negrito, cor primária, indicador "●"
  - Step futuro: label atenuada (Constants.kGreyText2)
  - Conectores entre steps (linha verde se concluída, cinza se não)
```

#### `StepNavigationFooter`

```
Props:
  - currentStep: int
  - totalSteps: int
  - canGoBack: bool
  - canGoForward: bool
  - isLastStep: bool
  - isLoading: bool
  - onBack: VoidCallback
  - onNext: VoidCallback
  - onSubmit: VoidCallback

Comportamento:
  - Botão "Voltar" sempre visível (desabilitado no step 0)
  - Contador "Etapa 2 de 5"
  - Botão "Avançar" / "Salvar" (último step)
  - Botão desabilitado se validação da etapa falhar
```

### 4.4 Layout por Step

#### Step 0 — Setor (Área + Setor)

```
[AppFormSection title="Área de Cultivo e Setor" isRequired=true description="Selecione a área onde o lote será alocado"]
  └── [AppDropdown<String> label="Área"]  (itens: store.areaList)
  └── [AppDropdown<String> label="Setor"]  (itens: store.novoLoteArea.setores, dependente da área)
```

Validação: ambos preenchidos.

#### Step 1 — Lote (Nome)

```
[AppFormSection title="Identificação do Lote" description="Dê um nome para identificar o lote"]
  └── [TextFormField hint="Ex: L01S01-250721" ...]
```

Validação: texto não vazio.

#### Step 2 — Cultura

```
[AppFormSection title="Cultura" description="Selecione a cultura que será cultivada neste lote"]
  └── [AppFormSelectionTile × N]  (radio, isSelected se igual à selecionada)
  └── [TextButton "Adicionar nova cultura +"] → inline form
```

Validação: uma cultura selecionada.

#### Step 3 — Reservatório

```
[AppFormSection title="Reservatório" description="Vincule um reservatório ao lote (opcional na edição)"]
  └── [AppStatePanel loading/empty] ou [AppEntityCard × N]
```

Validação: opcional (pode pular).

Drill-down: `AppModalSheet.show(title: "Detalhes do Reservatório", body: reservatorioDetalhesPage(store))`

#### Step 4 — Protocolo

```
[AppFormSection title="Protocolo" description="Vincule um protocolo de cultivo ao lote"]
  └── [AppSearchBar onChanged: store.setSearchProtocoloText]
  └── [AppStatePanel loading/empty] ou [AppEntityCard × N]
```

Validação: opcional (pode pular).

Drill-down: `AppModalSheet.show(title: "Detalhes do Protocolo", body: ...)` com sub-navegação para atividades.

---

## 5. Data Flow

### 5.1 Fluxo de Navegação

```
[Usuário abre CadastrarLotePage]
    │
    ├── initState() → buscarAreasList, buscarCulturas, buscarReservatorios, buscarProtocolos
    │
    ├── Step 0 (Setor) → usuário seleciona área → dropdown setor é populado
    │   └── valida: area && setor selecionados
    │
    ├── Step 1 (Lote) → usuário digita nome
    │   └── valida: nome não vazio
    │
    ├── Step 2 (Cultura) → usuário seleciona cultura OU cria nova
    │   └── valida: cultura selecionada
    │
    ├── Step 3 (Reservatório) → usuário pode:
    │   ├── Selecionar reservatório da lista → ver detalhes → "Vincular"
    │   └── Pular (opcional)
    │
    ├── Step 4 (Protocolo) → usuário pode:
    │   ├── Buscar protocolo → selecionar → ver detalhes → "Vincular"
    │   └── Pular (opcional)
    │
    └── "Salvar" → store.registrarLote() / store.alterarLote()
        └── onSuccess → toast + Get.close() + refresh lista
        └── onError → toast de erro
```

### 5.2 Estados do Store

Os observables existentes são mantidos, com ajustes mínimos:

| Observable Atual | Uso no Novo Design |
|------------------|-------------------|
| `dotIndicator` | Substituído por variável local `currentStep` no State ou novo observable `currentStep` |
| `showReservatorioDetalhes` | Mantido (controla drill-down) |
| `showProtocoloDetalhes` | Mantido (controla drill-down) |
| `abrirProtocoloDetalhesAtv` | Mantido |
| `novoLoteSetor` | Mantido |
| `novoLoteArea` | Mantido |
| `novoLoteName` | Mantido |
| `novoLoteCultura` | Mantido |
| `novoLoteReservatorio` | Mantido |
| `protocoloVinculado` | Mantido |
| `mostrarErroFormulario` | **Removido** (validação por etapa substitui) |
| `isNovaCultura` | Mantido |
| `novaCulturaController` | Mantido |
| `isNovoLoteLoading` | Mantido |
| `reservatorioDetalhes`, `protocoloDetalhes` | Mantidos |

### 5.3 Métodos de Validação por Etapa

Novos métodos no store (ou local no State):

```dart
bool validarEtapaSetor() => novoLoteArea.id != null && novoLoteSetor.id != null;
bool validarEtapaLote() => novoLoteName.text.trim().isNotEmpty;
bool validarEtapaCultura() => novoLoteCultura.id != null;
bool validarEtapaReservatorio() => true; // opcional
bool validarEtapaProtocolo() => true;    // opcional
```

---

## 6. States

### 6.1 Loading State

**Onde ocorre:** Ao buscar listas iniciais (áreas, culturas, reservatórios, protocolos).

**Comportamento esperado:**
- Enquanto `isAreaLoading`, `isNovaAreaLoading`, ou carregamentos similares estiverem true
- O step correspondente exibe `AppStatePanel(stateKind: AppStateKind.loading, title: "Carregando...")`
- Botão "Avançar" fica desabilitado até o carregamento completo

**Visual:**
```
┌────────────────────────┐
│      ⟳ (spinner)       │
│   Carregando áreas...  │
└────────────────────────┘
```

### 6.2 Empty State

**Onde ocorre:**
- Step 2 (Cultura): `culturaList.isEmpty`
- Step 3 (Reservatório): `reservatorioList.isEmpty` — mostra `AppStatePanel(stateKind: AppStateKind.empty, title: "Nenhum reservatório encontrado")`
- Step 4 (Protocolo): `protocoloStore.protocoloList.isEmpty`

**Comportamento esperado:**
- Exibe `AppStatePanel` com ícone, título e mensagem
- Botão "Avançar" permanece habilitado (campos opcionais)

### 6.3 Error State

**Onde ocorre:** Falha ao carregar listas (erro de rede, servidor).

**Comportamento esperado:**
- Exibe `AppStatePanel(stateKind: AppStateKind.error, title: "Erro ao carregar", message: err.message)` com botão "Tentar novamente" se aplicável
- Mensagem de erro via toast para erros não-recuperáveis

### 6.4 Success State

**Onde ocorre:** Após `store.registrarLote()` ou `store.alterarLote()` bem-sucedido.

**Comportamento esperado:**
- `isNovoLoteLoading = false`
- Toast de sucesso ("Lote cadastrado com sucesso")
- `Get.close()` e refresh da lista
- Store é limpo (`store.limparTudo()`)

### 6.5 Validation State

**Por step:**
- Step sem preenchimento: indicador "●" neutro/cinza no progresso
- Step preenchido: indicador "✓" verde, label do step em verde
- Step atual: indicador "●" verde pulsante (ou destacado), label em negrito
- Tentativa de avanço com erro: shake no step ou mensagem de erro inline via `AppFormSection` (`AppFormSelectionTile.errorText`)

---

## 7. Considerações de Acessibilidade

### 7.1 Contraste de Cor

| Elemento | Cor Atual (problemática) | Cor Proposta |
|----------|-------------------------|--------------|
| Texto de validação | `Color(0xff6F6464)` sobre background branco | `Constants.kGreyText` (#4A4A4A) |
| Hint "Preencher" | `Constants.kPrimaryColor` (#26C164) — parece link clicável | `Constants.kGreyText2` (#9F9F9F) para não-preenchido |
| Texto de "Vinculado" | `Constants.kBackgroundColor` (#FFFFFF) sobre `Constants.kPrimaryColor` | OK (contrato > 4.5:1) |
| Texto informativo | `Constants.kButtonGrey` (#767676) | `Constants.kGreyText` (#4A4A4A) |

### 7.2 Semântica e Navegação

- Todos os botões e tappable areas devem ter `semanticLabel` quando o ícone ou label visual não for auto-explicativo
- `StepProgressBar` deve ser navegável por TalkBack como uma barra de progresso com `Semantics(label: "Etapa 2 de 5: Lote")`
- Pulos de etapa (Reservatório/Protocolo opcionais) devem ser anunciados como "opcional"
- Erros de validação devem ser anunciados via `Semantics` ou `liveRegion`
- Botão "Avançar" desabilitado deve ter `Semantics(button: true, enabled: false)` com explicação do porquê

### 7.3 Alvos de Toque

- Mínimo 44×44 dp para todos os botões e tappable items
- `AppFormSelectionTile`, `AppEntityCard` já atendem esse requisito
- `AppDropdown` também atende

### 7.4 Focus Management

- Ao avançar step, o foco deve mover para o primeiro campo do próximo step
- Ao voltar step, o foco deve retornar ao botão "Avançar" do step anterior
- Usar `FocusScope.of(context).requestFocus()` adequadamente

### 7.5 Font Scaling

- Usar `Text` sem tamanho fixo quando possível (respeitar `textScaleFactor`)
- Tamanhos fixos usados: 28 (título), 24 (nome), 18 (subtítulo), 14-16 (corpo) — devem ser revisados para `MediaQuery.textScaleFactor` ou usar `TextStyle` sem `fontSize` para melhor acessibilidade

---

## 8. Acceptance Criteria

### 8.1 Funcionais

| ID | Critério | Como Verificar |
|----|----------|---------------|
| F1 | A página exibe um stepper com 5 etapas com labels textuais, não dots | Navegar pelas 5 etapas; ver labels "Setor", "Lote", "Cultura", "Reservatório", "Protocolo" |
| F2 | Não há mais bottom sheet wizard (apenas para drill-down de detalhes) | Abrir página; verificar que não há CarouselSlider ou DotsIndicator |
| F3 | Validação por etapa impede avanço se campo obrigatório não preenchido | Step 0: tentar avançar sem selecionar área/setor → botão desabilitado |
| F4 | Steps concluídos mostram ícone de check verde | Preencher step 0, avançar → step 0 mostra check verde no progresso |
| F5 | Cópia do heading não usa "Qual X deseja...?" | Verificar textos: "Selecione a área e o setor", "Dê um nome ao lote", etc. |
| F6 | Indicador de "Preencher"/"Selecionar" é substituído por indicador visual de status | Step não preenchido: label cinza; preenchido: label verde com resumo |
| F7 | Todos os cards usam `AppPanelCard` (não `Card(elevation:5)`) | Inspecionar árvore de widgets |
| F8 | Todas as cores usam tokens `Constants.*` | Buscar por `Color(` na página refatorada — deve retornar 0 exceto no Constants |
| F9 | Reservatório e Protocolo opcionais podem ser pulados | Step 3 e 4: avançar sem selecionar → OK |
| F10 | Drill-down de detalhes abre `AppModalSheet` com header padronizado | Clicar em reservatório → bottom sheet com título "Detalhes do Reservatório" e ícone de fechar |
| F11 | Fluxo de edição (isEditing=true) mantém valores previamente selecionados | Abrir lote existente → ver steps preenchidos |
| F12 | Botão "Salvar" no último step executa submit e fecha página | Preencher tudo → "Salvar" → loading → sucesso → fecha |

### 8.2 Não Funcionais

| ID | Critério | Como Verificar |
|----|----------|---------------|
| NF1 | Nenhum `import` quebrado | `flutter analyze` sem erros |
| NF2 | Nenhum `any`, `@ts-ignore`, `as unknown` (ou equivalentes Dart: `dynamic`, `as`) | Code review |
| NF3 | Tamanho da `cadastrar_lote_page.dart` não ultrapassa 300 linhas | `wc -l cadastrar_lote_page.dart` |
| NF4 | Store não tem observables de UI de navegação (dotIndicator removido) | Verificar `lote_store.dart` — dotIndicator removido |
| NF5 | `AppModalSheet` é usado em vez de `showModalBottomSheet` direto | Verificar imports |

### 83 Regressão

| ID | Critério |
|----|----------|
| R1 | `store.registrarLote()` é chamado com os mesmos campos de antes |
| R2 | `store.alterarLote()` é chamado com os mesmos campos de antes |
| R3 | `store.limparTudo()` é chamado ao sair da página |
| R4 | Toast de erro é exibido em caso de falha de registro |
| R5 | Toast de sucesso é exibido em caso de sucesso |
| R6 | Lista de lotes é recarregada após sucesso |

---

## 9. File List

### 9.1 Arquivos a Criar

| Arquivo | Descrição |
|---------|-----------|
| `components/cadastrar_page/step_progress_bar.dart` | Widget de progresso textual com 5 steps, labels, checks |
| `components/cadastrar_page/step_navigation_footer.dart` | Botões Voltar/Avançar + contador "Etapa X de 5" |

### 9.2 Arquivos a Refatorar

| Arquivo | Mudança |
|---------|---------|
| `cadastrar_lote_page.dart` | Reescrever: remover referências a bottom sheet, CarouselSlider, DotsIndicator; implementar stepper inline com `AnimatedSwitcher` entre steps; remover summary view ListTiles; manter `AppFormHeader`, `PageHeader`, loading inicial, botão submit |
| `setor_item.dart` | Renomear função `setor()`→`setorStep()`; remover `InkWell` + `ListTile` (summary); manter `setorPage()` adaptada como step content; substituir `Color(0xffF5F5F5)` por `Constants.kCardColor`; usar `AppPanelCard` |
| `lote_item.dart` | Renomear `lote()`→`loteStep()`; similar ao setor |
| `cultura_item.dart` | Renomear `cultura()`→`culturaStep()`; usar `AppFormSelectionTile` para itens de rádio |
| `reservatorio_item.dart` | Renomear `reservatorio()`→`reservatorioStep()`; usar `AppEntityCard` para lista; `AppStatePanel` para loading/empty |
| `protocolo_page.dart` | Renomear `protocolo()`→`protocoloStep()`; usar `AppSearchBar`, `AppEntityCard`, `AppStatePanel` |
| `protocoloItemLote.dart` | Renomear para `protocolo_item_card.dart`; refatorar para usar `AppEntityCard` |
| `reservatorio_detalhes_page.dart` | Envolver em `AppModalSheet.show()` para header padronizado |
| `protocolo_detalhes_page.dart` | Envolver em `AppModalSheet.show()` para header padronizado |

### 9.3 Arquivos a Manter (sem alteração)

| Arquivo | Motivo |
|---------|--------|
| `protocolo_detalhes_atv.dart` | Funcionalidade de terceiro nível está ok como está |
| `protocolo_atividadeItemDetalhes.dart` | Funcionalidade de terceiro nível está ok como está |
| `data_item.dart` | Mantido (não usado no fluxo atual, mas pode ser útil futuramente; sem mudança) |

### 9.4 Arquivos a Remover

| Arquivo | Motivo |
|---------|--------|
| Nenhum | Nenhum arquivo precisa ser deletado; funções e referências serão reorganizadas |

### 9.5 Mudanças no Store

| Mudança | Tipo |
|---------|------|
| `dotIndicator` → remover (substituído por `currentStep` local no State) | Remoção |
| `mostrarErroFormulario` → remover (validação por etapa substitui) | Remoção |
| `validarRegistro()` → manter (usado no submit final) | Manter |
| Métodos auxiliares `validarEtapa*()` → adicionar | Adição |
| `isNovaCultura` → manter | Manter |
| `novaCulturaController` → manter | Manter |

---

## 10. Open Questions

1. **Ordem do stepper:** A ordem atual é Setor → Lote → Cultura → Reservatório → Protocolo. Esta ordem faz sentido ou deveria ser revisada? (ex: Cultura antes de Lote? Setor + Lote agrupados?)

2. **Mecanismo de transição:** Usar `AnimatedSwitcher` com fade, ou `PageView` com swipe? A preferência é `AnimatedSwitcher` para simplicidade e controle, mas swipe horizontal pode ser esperado pelos usuários.

3. **Step de Datas:** O arquivo `data_item.dart` existe mas não está no fluxo atual. Devemos integrar as 4 datas (Registro, Semeadura, Transplantio, Colheita) como um step extra ou como campos opcionais dentro do step de Lote?

4. **Responsividade em tablets:** O stepper horizontal com labels funciona bem em telas largas. Em telas estreitas (< 360dp), talvez seja necessário colapsar as labels para apenas ícones. Devemos suportar isso?

5. **Comportamento de "Pular":** Reservatório e Protocolo são opcionais. Devemos ocultar esses steps se não houver dados disponíveis (empty state), ou mantê-los visíveis com indicação clara de "opcional"?

6. **Edição vs Criação:** Na edição, o fluxo deve permitir avanço sem alterar campos já preenchidos, ou deve forçar o usuário a revisar cada etapa? Sugestão: comportamento atual de permitir avanço mantendo valores pré-preenchidos.

---

## 11. Glossário

| Termo | Definição |
|-------|-----------|
| **Lote** | Unidade de cultivo identificável (ex: L01S01-250721) |
| **Setor** | Subdivisão física de uma área de cultivo |
| **Área** | Zona de cultivo (ex: Estufa 1, Campo Norte) |
| **Cultura** | Espécie vegetal cultivada (alface, tomate, etc.) |
| **Reservatório** | Tanque de solução nutritiva vinculável a lotes |
| **Protocolo** | Conjunto de fases e atividades de cultivo |
| **Stepper** | Interface de formulário multi-etapas com progresso visível |
| **Drill-down** | Navegação para detalhes de um item selecionado |

---

## 12. Referências

- Design system components: `lib/features/presenter/widgets/common/`
- Constants: `lib/core/constants/constants.dart`
- Store atual: `lib/features/presenter/viewmodels/lote_store.dart`
- Página atual: `lib/features/presenter/views/area_cultivo/N3/cadastrar_lote_page.dart`
- Componentes atuais: `lib/features/presenter/views/area_cultivo/N3/components/cadastrar_page/`
