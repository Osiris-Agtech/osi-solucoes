# Análise do Sistema Visual — OSI Soluções

## 1. Identidade Visual

### Paleta de Cores
| Token | Valor | Uso |
|-------|-------|-----|
| `kPrimaryColor` | `#26C164` (verde) | Ação primária, links, ícones selecionados, indicadores |
| `kSecondaryColor` | `#82A1B1` (azul acinzentado) | Secundário (subutilizado) |
| `kErrorColor` | `#F03738` (vermelho) | Erro, deleção, alerta crítico |
| `kWarninngColor` | `#F3BB1C` (amarelo) | Atenção |
| `kBackgroundColor` | `#FFFFFF` | Fundo de cards e telas de formulário |
| `kSecondBackgroundColor` | `#F5F5F5` | Fundo de listas e scaffold |
| `kText2` | `#333333` | Texto principal (títulos e body) |
| `kGreyText` | `#4A4A4A` | Texto secundário |
| `kGreyText2` | `#9F9F9F` | Texto terciário/descrição |
| `kGreyMedium` | `#707070` | Labels e subtítulos |
| `kButtonGrey` | `#767676` | Botões neutros |
| `kGreyLight` | `#D9D9D9` | Bordas, dividers, elementos desabilitados |
| `kCardColor` | `#F5F5F5` | Fundo de cards (mesmo que secondBackground) |

### Tipografia
- **Família declarada**: Montserrat (`bodyLarge` no ThemeData)
- **Uso real**: Montserrat definido apenas no `bodyLarge`; fallback para padrão do Flutter nos demais estilos
- `Roboto` usado inline em alguns lugares (ex: `_N3FilterArea` em `lote_page.dart`)
- Tamanhos comuns: 22px/600 (títulos de página), 16px/700 (botões), 14px/500-700 (corpo), 13px/500 (subtítulos), 12px (descrições)

### Formas
- **Border radius**: 12px (botões, cards), 14px (auth button), 20px (auth panel card), 24px (bottom sheets)
- **Sombras**: `BoxShadow` com `blurRadius: 18, offset: (0, 8), alpha: 0.07` (auth card); `blurRadius: 20, offset: (0, -4), alpha: 0.12` (modal sheet)
- **Elevação**: `SliverAppBar.elevation: 1`, botões `elevation: 0`

---

## 2. Shared Components (Já Padronizados)

Os seguintes componentes compartilhados em `lib/features/presenter/widgets/common/` estão bem definidos e devem ser referência:

| Componente | Arquivo | Status |
|-----------|---------|--------|
| `AppPageHeaderSliver` | `app_page_header_sliver.dart` | ✅ Maduro |
| `AppFormHeader` | `app_form_header.dart` | ✅ Maduro |
| `AppEntityCard` | `app_entity_card.dart` | ✅ Maduro |
| `AppPanelCard` | `app_panel_card.dart` | ✅ Maduro |
| `AppPrimaryButton` | `app_primary_button.dart` | ✅ Maduro (supports primary/neutral/danger) |
| `AppFormSection` | `app_form_section.dart` | ✅ Maduro |
| `AppFormSelectionTile` | `app_form_selection_tile.dart` | ✅ Maduro |
| `AppModalSheet` | `app_modal_sheet.dart` | ✅ Maduro |
| `AppSearchBar` | `app_search_bar.dart` | ✅ Maduro |
| `AppSectionHeader` | `app_section_header.dart` | ✅ Maduro |
| `AppStatePanel` | `app_state_panel.dart` | ✅ Maduro |
| `AppBadge` | `app_badge.dart` | ✅ Maduro |
| `AppIconTile` | `app_icon_tile.dart` | ✅ Maduro |
| `AppFloatingActionButton` | `app_floating_action_button.dart` | ✅ Maduro |
| `AppDropdown` | `app_dropdown.dart` | ✅ Maduro |

### Componentes de Autenticação (login/register)

| Componente | Arquivo | Status |
|-----------|---------|--------|
| `AuthScaffold` | `auth_scaffold.dart` | ✅ Maduro |
| `AuthPanelCard` | `auth_panel_card.dart` | ✅ Maduro |
| `AuthHeader` | `auth_header.dart` | ✅ Maduro |
| `AuthTextField` | `auth_text_field.dart` | ✅ Maduro |
| `AuthPrimaryButton` | `auth_primary_button.dart` | ✅ Maduro |
| `AuthSecondaryAction` | `auth_secondary_action.dart` | ✅ Maduro |
| `AuthFeedbackMessage` | `auth_feedback_message.dart` | ✅ Maduro |
| `AuthBadge` | `auth_badge.dart` | ✅ Maduro |
| `AccountSelectionCard` | `account_selection_card.dart` | ✅ Maduro |

---

## 3. Telas Mapeadas por Padrão Visual

### ✅ EM PADRÃO (usam shared components corretamente)

| Tela | Arquivo | Header | Lista | Botões |
|------|---------|--------|-------|--------|
| Home | `home_page.dart` | Custom (dashboard) | Custom panels | N/A |
| Login | `login_page.dart` | AuthHeader | N/A | AuthPrimaryButton |
| MultiAccounts | `multi_account_page.dart` | AuthScaffold | AccountSelectionCard | N/A |
| Áreas (N1) | `area_cultivo/N1/area_cultivo_page.dart` | AppPageHeaderSliver | AppEntityCard | AppFloatingActionButton |
| Setores (N2) | `area_cultivo/N2/setor_page.dart` | AppPageHeaderSliver | AppEntityCard | AppFloatingActionButton |
| Lotes (N3) | `area_cultivo/N3/lote_page.dart` | AppPageHeaderSliver | AppEntityCard | AppFloatingActionButton |
| Detalhes Lote | `area_cultivo/N3/detalhes_lote_page.dart` | AppPageHeaderSliver | AppPanelCard | PopupMenuButton |
| Soluções | `solucao/solucao_page.dart` | AppPageHeaderSliver | AppPanelCard (grid) | AppFloatingActionButton |
| Reservatórios | `reservatorio/reservatorios_page.dart` | AppPageHeaderSliver | AppEntityCard | AppFloatingActionButton |
| Agenda | `agenda/agenda_page.dart` | AppPageHeaderSliver | Custom items | AppFloatingActionButton |

### ⚠️ PARCIALMENTE PADRONIZADOS (usam shared components mas com inconsistências)

| Tela | Problemas |
|------|-----------|
| `cadastrar_setor_page.dart` | Usa `appBar()` custom em vez de `AppFormHeader`; `titulo()` inline em vez de `AppFormHeader.title`; paddings manuais (10, 16, 20) |
| `cadastrar_area_cultivo_page.dart` | Mesmo padrão do cadastrar setor; `appBar()` custom |
| `cadastrar_lote_page.dart` | `appBar()` custom; carousel slider para step wizard |
| `cadastrar_reservatorio_page.dart` | `appBar()` custom; carousel slider |
| `cadastrar_solucao_page.dart` | `appBar()` custom; TabController; carousel slider |
| `cadastrar_solucao_concentrada_page.dart` | `appBar()` custom; carousel slider |
| `detalhes_reservatorio_page.dart` | Usa `AppPageHeaderSliver` mas com Theme wrapper aninhado para PopupMenuButton |

### ❌ FORA DO PADRÃO (não usam shared components)

| Tela | Arquivo | Problema |
|------|---------|----------|
| **Bottom sheets de cadastro** (N1, N2, N3, solução, reservatório, agenda, caderno) | `*/bottomSheet.dart` | Cada um tem sua própria implementação de `showModalBottomSheet` com `CarouselSlider`; não usam `AppModalSheet` |
| **Páginas de step/carousel** (cadastro wizard) | `pagesNovoSetor`, `pagesNovaSolucao`, `pagesNovoLote` etc. | Cada wizard tem seu próprio layout inline; não reutilizam `AppFormSection` consistentemente |
| **Detalhes Solução** | `detalhes_solucao.dart` | Bottom sheet manual com `getBottomSheet()`; não usa `AppModalSheet`; padding e layout inline |
| **Finalizar Lote** | `finalizar_page/bottomSheet.dart` | Bottom sheet manual com carousel slider |

---

## 4. Inconsistências Detalhadas

### 4.1 Headers de Formulário
Todas as páginas de cadastro usam um método `appBar()` local em vez de `AppFormHeader`:

```dart
// Padrão atual (repetido em cada página):
PreferredSizeWidget appBar() { ... }

// Padrão desejado:
AppFormHeader(title: '...', onBack: () => Get.back())
```

**Arquivos afetados:**
- `lib/features/presenter/views/area_cultivo/N2/cadastrar_setor_page.dart`
- `lib/features/presenter/views/area_cultivo/N1/cadastrar_area_cultivo_page.dart`
- `lib/features/presenter/views/area_cultivo/N3/cadastrar_lote_page.dart`
- `lib/features/presenter/views/reservatorio/cadastrar_reservatorio_page.dart`
- `lib/features/presenter/views/solucao/cadastrar_solucao_page.dart`

### 4.2 Bottom Sheets Fragmentadas
Existem **7+ bottom sheets** com implementações quase idênticas mas copiadas:

| Bottom Sheet | Arquivo | Diferença |
|-------------|---------|-----------|
| N1 (Área) | `area_cultivo/N1/components/bottomSheet.dart` | showModalBottomSheet + CarouselSlider |
| N2 (Setor) | `area_cultivo/N2/components/bottomSheet.dart` | showModalBottomSheet + CarouselSlider |
| N3 (Lote) | `area_cultivo/N3/components/finalizar_page/bottomSheet.dart` | showModalBottomSheet + CarouselSlider |
| Solução | `solucao/components/bottomSheet.dart` | showModalBottomSheet + CarouselSlider |
| Reservatório | `reservatorio/cadastrar_reservatorio/components/bottomSheet.dart` | showModalBottomSheet + CarouselSlider |
| Agenda | `agenda/components/bottomSheet.dart` | showModalBottomSheet |
| Caderno | `caderno_campo/components/bottomSheet.dart` | showModalBottomSheet |
| Detalhes Solução | `solucao/detalhes_solucao.dart` | Get.bottomSheet direto |

### 4.3 Padding e Espaçamento Inline
- `cadastrar_setor_page.dart`: usa `left: 10, right: 10` em vez de `AppFormHeader`/`AppFormSection`
- `lote_page.dart` `_N3FilterArea`: usa `Color(0xFFF8F8F6)` inline em vez de `kSecondBackgroundColor`
- `detalhes_lote_page.dart`: `padding: EdgeInsets.fromLTRB(16, 16, 16, 0)` — valor hardcoded

### 4.4 Validação de Formulário
- Algumas páginas usam `AuthFeedbackMessage` (login)
- Outras usam toasts (`toastError`)
- Outras usam `Text` inline vermelho para erros
- Cadastro de setor usa `mostrarErroFormulario` com `Text` inline condicional

### 4.5 Carousel Slider para Steps
O padrão de wizard multi-step com `CarouselSlider` é usado em:
- Cadastro de setor
- Cadastro de área
- Cadastro de lote
- Cadastro de solução
- Cadastro de reservatório
- Finalizar lote

Cada um tem sua própria implementação com dot indicator e navegação. Extrair para um `AppStepWizard` compartilhado reduziria duplicação.

---

## 5. Recomendações de Padronização

### Prioridade Alta (impacto visual imediato)

| # | Tarefa | Esforço | Impacto |
|---|--------|---------|---------|
| 1 | Substituir `appBar()` custom por `AppFormHeader` em todas as páginas de cadastro | 2h | Alto |
| 2 | Unificar bottom sheets de cadastro para usar `AppModalSheet` | 4h | Alto |
| 3 | Extrair `AppStepWizard` para wizard multi-step com carousel | 4h | Alto |
| 4 | Padronizar validação de formulário: criar `AppFormValidationMessage` | 2h | Médio |

### Prioridade Média

| # | Tarefa | Esforço | Impacto |
|---|--------|---------|---------|
| 5 | Substituir cores inline por constantes (ex: `#F8F8F6` → `kSecondBackgroundColor`) | 1h | Médio |
| 6 | Padronizar padding system: criar `Spacing` constants e usar em vez de valores inline | 2h | Médio |
| 7 | Revisar font family: definir Montserrat globalmente via ThemeData em vez de inline | 1h | Médio |
| 8 | Unificar `DetalhesSolucao` para usar `AppModalSheet` | 1h | Médio |

### Prioridade Baixa

| # | Tarefa | Esforço | Impacto |
|---|--------|---------|---------|
| 9 | Extrair `_confirmarDelecao` dialogs para componente compartilhado `AppDeleteDialog` | 2h | Baixo |
| 10 | Padronizar `SystemUiOverlayStyle` via tema em vez de repetir em cada página | 1h | Baixo |
| 11 | Revisar uso de `BouncingScrollPhysics` vs `ClampingScrollPhysics` | 0.5h | Baixo |

---

## 6. Próximos Passos Recomendados

1. **Criar `AppFormHeader`** — já existe! Apenas substituir os `appBar()` customs
2. **Criar `AppStepWizard`** — extrair o padrão carousel+dots+navegação para componente único
3. **Criar `AppDeleteDialog`** — extrair o padrão de AlertDialog de confirmação com warning
4. **Refatorar bottom sheets** — unificar em `AppModalSheet.show()`
5. **Review de padding** — aplicar `Spacing` constants em vez de números mágicos

---

## 7. Legado vs. Novo Padrão

### Padrão Antigo (evitar)
```dart
// Header custom
PreferredSizeWidget appBar() {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: IconButton(...),
    title: Text(...),
  );
}

// Bottom sheet custom
showModalBottomSheet(
  shape: RoundedRectangleBorder(borderRadius: ...),
  builder: (_) => CarouselSlider(...),
);
```

### Padrão Novo (usar)
```dart
// Header
AppFormHeader(title: 'Cadastrar...', onBack: () => Get.back())

// Modal sheet
AppModalSheet.show(title: '...', body: ...)

// Step wizard
AppStepWizard(steps: [...], store: ...)
```
