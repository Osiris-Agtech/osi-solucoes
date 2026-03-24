# Smart Shortcut Navigation — Especificação

## Problem Statement

Os atalhos inteligentes da home (gerados por ML) podem recomendar um lote específico que o usuário acessa frequentemente. Ao clicar nesse atalho, `_navigateWithResource()` navega diretamente para `detalhesLotePage`, mas essa tela exige que `loteStore.loteSelecionado` esteja preenchido. Como o fluxo normal passa por Área → Setor → Lote (cada etapa populando o store), a navegação direta resulta em crash por `Null check operator used on a null value` ao chamar `buscarDetalhesLote()`.

## Goals

- [ ] Atalho de lote específico na home navega corretamente para os detalhes do lote sem crash
- [ ] O estado dos stores (`loteStore`, `setorStore`) é preparado corretamente antes da navegação
- [ ] Comportamento de fallback gracioso quando o lote não é encontrado (ex: lote finalizado/deletado)
- [ ] Nenhuma regressão no fluxo normal de navegação Área → Setor → Lote

## Out of Scope

| Feature | Reason |
|---------|--------|
| Refatorar toda a hierarquia de navegação | Fora do escopo — só fix no atalho |
| Navegação direta para SetorPage via atalho | Não reportado como problema |
| Cache local de lotes para navegação offline | Complexidade desnecessária agora |
| Modificar o Cloud Function ou o modelo ML | Backend fora do escopo |

---

## User Stories

### P1: Navegação Direta para Detalhes do Lote ⭐ MVP

**User Story:** Como usuário que acessa frequentemente um lote específico, quero clicar no atalho inteligente na home e ir direto para os detalhes desse lote, sem precisar navegar por Área → Setor → Lote.

**Why P1:** É o bug principal relatado — atalho quebra ao acessar lote diretamente.

**Acceptance Criteria:**

1. WHEN o usuário clica em um atalho com `resourceType == 'lote'` e `resourceId != null` THEN o sistema SHALL buscar os detalhes do lote via `loteRepository.buscarDetalhesLote(int.parse(resourceId))` antes de navegar
2. WHEN a busca do lote for bem-sucedida THEN o sistema SHALL chamar `loteStore.selecionarLote(lote)` para popular o store e navegar para `Routes.detalhesLotePage`
3. WHEN a busca do lote falhar (lote deletado, erro de rede) THEN o sistema SHALL exibir um toast de erro e NÃO navegar
4. WHEN o atalho estiver sendo processado (loading) THEN o sistema SHALL impedir cliques duplos
5. WHEN o lote retornado contiver referência ao `setor` THEN o sistema SHALL também chamar `loteStore.setSetorSelecionado(lote.setor!)` para habilitar operações que dependem do setor

**Independent Test:** Clicar no atalho de um lote específico na home → tela de detalhes do lote abre corretamente exibindo nome e dados do lote.

---

### P2: Indicador Visual de Loading no Atalho

**User Story:** Como usuário, quero ver um feedback visual ao clicar em um atalho que requer carregamento, para saber que a ação está em progresso.

**Why P2:** UX — sem feedback, o usuário pode clicar múltiplas vezes ou achar que o app travou.

**Acceptance Criteria:**

1. WHEN o sistema estiver buscando dados para navegar via atalho THEN o sistema SHALL exibir um `CircularProgressIndicator` ou desabilitar o atalho
2. WHEN a navegação for concluída (sucesso ou erro) THEN o sistema SHALL restaurar o estado normal do atalho

**Independent Test:** Clicar no atalho de lote → atalho mostra loading → tela abre (ou toast de erro aparece).

---

### P3: Navegação para Lista de Lotes do Setor via Atalho

**User Story:** Como usuário, se o atalho for para a rota `lotePage` com um `resourceId` de setor, quero ir direto para a lista de lotes daquele setor.

**Why P3:** Nice-to-have — caso o ML recomende o setor como atalho, a experiência deve ser fluida.

**Acceptance Criteria:**

1. WHEN o atalho tiver `resourceType == 'setor'` e `resourceId != null` THEN o sistema SHALL setar `loteStore.setorSelecionado` com os dados do setor e navegar para `Routes.lotePage`
2. WHEN os dados do setor não estiverem disponíveis localmente THEN o sistema SHALL navegar para `Routes.setorPage` como fallback

---

## Edge Cases

- WHEN `resourceId` não for um número válido THEN o sistema SHALL logar o erro e fazer fallback para `Get.toNamed(shortcut.route)` sem crash
- WHEN o usuário clicar no atalho mas o lote já tiver sido finalizado/deletado THEN o sistema SHALL exibir mensagem "Lote não encontrado" e remover o atalho da lista (ou ignorar)
- WHEN o Firebase não estiver disponível e os atalhos forem os padrão (sem resourceId) THEN o comportamento atual (Get.toNamed direto) SHALL ser mantido — sem regressão
- WHEN a navegação falhar por timeout de rede THEN o sistema SHALL exibir toast de erro sem crash

---

## Requirement Traceability

| Requirement ID | Story | Phase | Status |
|----------------|-------|-------|--------|
| SNAV-01 | P1: Buscar lote antes de navegar | Done | Verified |
| SNAV-02 | P1: Setar store antes de navegar | Done | Verified |
| SNAV-03 | P1: Fallback em caso de erro | Done | Verified |
| SNAV-04 | P1: Prevenir cliques duplos | Done | Verified |
| SNAV-05 | P1: Setar setorSelecionado quando disponível | Done | Verified |
| SNAV-06 | P2: Loading visual no atalho | Done | Verified |
| SNAV-07 | P3: Navegação para lotePage via setor | Done | Verified |

---

## Technical Design

### Arquivos a modificar

| Arquivo | Mudança |
|---------|---------|
| `lib/features/presenter/viewmodels/lote_store.dart` | Adicionar `buscarLotePorId(int id)` — action que busca lote por ID e seta `loteSelecionado` sem depender de estado anterior |
| `lib/features/presenter/views/home/home_page.dart` | Refatorar `_navigateWithResource()` para chamar `loteStore.buscarLotePorId()` antes de navegar |
| `lib/features/data/repositories/lote/lote_repository_interface.dart` | (Opcional) Já existe `buscarDetalhesLote(int loteId)` — pode ser reutilizado diretamente |

### Implementação detalhada

#### 1. `LoteStore` — novo método `buscarLotePorId`

```dart
@observable
bool isLoadingLotePorId = false;

@action
Future<bool> buscarLotePorId(int id) async {
  isLoadingLotePorId = true;
  try {
    final result = await loteRepository.buscarDetalhesLote(id);
    return result.fold(
      (err) {
        toastError(message: 'Lote não encontrado');
        return false;
      },
      (lote) {
        selecionarLote(lote);
        if (lote.setor?.id != null) {
          setSetorSelecionado(lote.setor!);
        }
        return true;
      },
    );
  } finally {
    isLoadingLotePorId = false;
  }
}
```

#### 2. `HomePage._navigateWithResource` — refatoração

```dart
Future<void> _navigateWithResource(ShortcutModel shortcut) async {
  final loteStore = GetIt.I<LoteStore>();

  if (shortcut.resourceType == 'lote' && shortcut.resourceId != null) {
    final id = int.tryParse(shortcut.resourceId!);
    if (id == null) {
      Get.toNamed(shortcut.route);
      return;
    }

    // Registra analytics
    NavigationAnalytics.logNavigation(
      Routes.detalhesLotePage,
      resourceId: shortcut.resourceId,
      resourceType: 'lote',
      resourceName: shortcut.resourceName,
    );

    // Busca lote e prepara store antes de navegar
    final success = await loteStore.buscarLotePorId(id);
    if (success) {
      Get.toNamed(Routes.detalhesLotePage);
    }
    return;
  }

  // Fallback: navegação normal para rotas sem recurso específico
  NavigationAnalytics.logNavigation(shortcut.route);
  Get.toNamed(shortcut.route);
}
```

### Fluxo após o fix

```
HomePage — clique em atalho de lote
  └─ _navigateWithResource(shortcut)
       └─ resourceType == 'lote' && resourceId != null
            └─ loteStore.buscarLotePorId(id)
                 └─ loteRepository.buscarDetalhesLote(id)  [API call]
                 └─ loteStore.selecionarLote(lote)         [prepara store]
                 └─ loteStore.setSetorSelecionado(setor)   [prepara store]
                 └─ return true
            └─ Get.toNamed(Routes.detalhesLotePage)
                 └─ DetalhesLotePage.initState()
                      └─ loteStore.buscarDetalhesLote()    [usa loteSelecionado.id — OK]
```

---

## Success Criteria

- [x] Clicar em atalho de lote na home abre DetalhesLotePage sem crash em 100% dos casos com lote válido
- [x] Lote inexistente/deletado exibe toast de erro sem crash
- [x] Fluxo normal Área → Setor → Lote → Detalhes não sofre regressão
- [x] `isLoadingLotePorId` previne cliques duplos durante o carregamento
- [x] Atalho de setor navega diretamente para lista de lotes do setor
- [x] Analytics logado uma única vez por clique (sem duplicatas)
