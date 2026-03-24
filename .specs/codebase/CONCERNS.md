# Codebase Concerns

## [CRITICAL] Navegação de Atalhos para Lotes sem Contexto de Estado

**Severity:** Critical — bug funcional confirmado
**Location:** `lib/features/presenter/views/home/home_page.dart:_navigateWithResource()`

**Problem:**
`_navigateWithResource()` faz `Get.toNamed(shortcut.route)` sem preparar os stores.
`DetalhesLotePage.initState()` chama `loteStore.buscarDetalhesLote()` que usa `loteSelecionado.id!` — se `loteSelecionado` estiver vazio, lança `Null check operator used on a null value`.

O fluxo normal exige: `areaSelecionada` → `setorSelecionado` → `loteSelecionado` todos pré-definidos nas stores.

**Fix approach:** Ver spec em `.specs/features/smart-shortcut-navigation/spec.md`

---

## [HIGH] Ausência de Testes Automatizados

**Severity:** High — risco de regressão em features de ML e navegação
**Location:** Todo o projeto
**Evidence:** Sem arquivos de teste identificados nas features principais

**Fix approach:** Adicionar testes unitários para stores, especialmente `lote_store.dart` e `home_store.dart`.

---

## [HIGH] Código de Debug em Produção

**Severity:** High — performance e segurança
**Location:** Toda a codebase (home_store.dart, adaptive_interface_service.dart, home_page.dart, etc.)
**Evidence:** Centenas de `print()` statements com dados sensíveis (userId, rotas, estados)

**Fix approach:** Substituir por logging condicional (`kDebugMode`) ou biblioteca de logging estruturado.

---

## [MEDIUM] Lógica de Atalhos Padrão Duplicada

**Severity:** Medium — manutenção
**Location:**
- `lib/core/services/adaptive_interface_service.dart:_getDefaultShortcuts()`
- `lib/features/presenter/viewmodels/home_store.dart:_getDefaultShortcuts()`

**Evidence:** Mesma lista de atalhos padrão definida em dois lugares. Inconsistência futura garantida.

**Fix approach:** Extrair para uma constante centralizada ou deixar apenas no `AdaptiveInterfaceService`.

---

## [MEDIUM] `buscarDetalhesLote` depende de estado implícito do store

**Severity:** Medium — acoplamento frágil
**Location:** `lib/features/presenter/viewmodels/lote_store.dart:buscarDetalhesLote()`
**Evidence:** Usa `loteSelecionado.id!` sem validar se está definido — qualquer navegação direta sem preparar o store causará crash.

**Fix approach:** Adicionar `buscarDetalhesLotePorId(int id)` que não depende de estado implícito.

---

## [LOW] `exit(0)` direto no botão de fechar app

**Severity:** Low — UX e segurança
**Location:** `lib/features/presenter/views/home/home_page.dart:exitApp()`
**Evidence:** `exit(0)` mata o processo sem flush de dados ou notificação ao SO.

**Fix approach:** Usar `SystemNavigator.pop()` ou `SystemChannels.platform.invokeMethod('SystemNavigator.pop')`.
