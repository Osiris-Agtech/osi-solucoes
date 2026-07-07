# Histórico de Produção via Caderno de Campo

**Status:** Draft
**Data:** 2026-07-06
**Versão:** 1.0

---

## 1. Overview

### 1.1 Contexto

A seção de Produção na página de detalhes do lote (`detalhes_lote_page.dart`) agora permite edição inline via `ProducaoSection`, mas cada salvamento sobrescreve os valores anteriores (`UPDATE lote SET ...`). Não há rastreabilidade de *quando*, *quem* e *o que* mudou.

Paralelamente, o módulo Caderno de Campo já possui uma timeline de atividades (`DetalhesCadernoCampoPage`) que exibe `LotesAtividades` com data, usuário e cargo — exatamente a estrutura visual necessária para um histórico.

Esta feature aproveita o schema existente de `Atividade` para registrar automaticamente cada alteração de produção como uma entrada na timeline do Caderno de Campo, sem criar tabelas ou queries novas.

### 1.2 Escopo

**Dentro do escopo:**
- Criar método `registrarAtividadeProducao()` no `LoteStore` que cria uma `Atividade` com `privado: true` documentando as alterações
- Integrar a chamada no `_saveEdit()` do `ProducaoSection` após o salvamento bem-sucedido
- Adicionar filtro visual `mostrarRegistrosSistema` no `CadernoCampoStore` para ocultar/exibir registros automáticos
- Adicionar badge `[Sistema]` no card de atividade quando `atividade.privado == true` na timeline
- Adicionar toggle no header da timeline para filtrar registros do sistema

**Fora do escopo:**
- Criação de tabelas ou schemas novos no backend
- Alteração da mutation `updateLote` ou `createOneAtividade`
- Alteração do modelo de dados (`Atividade`, `LotesAtividades`, `Lote`)
- Criação de testes automatizados
- Internacionalização / i18n

### 1.3 Critérios de Aceitação

1. **CA-01:** Ao salvar produção com valores alterados, uma atividade `privado: true` é criada no Caderno de Campo vinculada ao lote
2. **CA-02:** A atividade criada contém nome descritivo (ex: "Bandejas semeadas: 42 → 55") e descrição JSON com todas as alterações
3. **CA-03:** Se nenhum valor foi alterado, nenhuma atividade é criada
4. **CA-04:** A timeline do Caderno de Campo exibe badges `[Sistema]` nas atividades com `privado: true`
5. **CA-05:** Um toggle no header permite ocultar/exibir registros do sistema na timeline
6. **CA-06:** Nenhuma regressão em funcionalidades existentes (listagem, criação manual de atividades)

---

## 2. Arquitetura da Solução

### 2.1 Fluxo de Dados

```
ProducaoSection._saveEdit()
  │
  ├─ 1. Snapshot oldValues do loteSelecionado (antes de mutar)
  │
  ├─ 2. Sync controllers locais → store controllers
  │
  ├─ 3. store.alterarProducaoLote()  →  UPDATE lote (já existe)
  │
  ├─ 4. store.registrarAtividadeProducao(oldValues, newValues)
  │      ├─ Compara old vs new
  │      ├─ Se sem alterações → return sem criar
  │      ├─ Monta Atividade(
  │      │     nome: string descritivo,
  │      │     descricao: JSON.encode({tipo, alteracoes}),
  │      │     privado: true,
  │      │     conta: usuario.selected_conta.conta,
  │      │     created_at: now
  │      │   )
  │      └─ repo.cadastrarAtividade()  →  INSERT atividade + lotes_atividades
  │
  └─ setState(_isEditing = false)
```

### 2.2 Arquivos Tocados

| Arquivo | O que muda | Responsabilidade |
|---|---|---|
| `lote_store.dart` | + método `registrarAtividadeProducao()` | Criar Atividade no repositório |
| `caderno_campo_store.dart` | + observable `mostrarRegistrosSistema`, action toggle, computed filter | Controlar exibição de registros automáticos |
| `producao_section.dart` | + snapshot + chamada a `registrarAtividadeProducao()` | Gatilho da gravação do histórico |
| `detalhes_caderno_campo_page.dart` | + badge visual + toggle no header | Exibir com distinção visual |

### 2.3 Novos Componentes

Nenhum. Apenas modificações em arquivos existentes.

### 2.4 Acoplamento e Riscos

- `LoteStore` passa a depender de `CadernoCampoRepository` via `GetIt.I<>` — acoplamento fraco por DI, sem instância direta
- `ProducaoSection` chama método novo no `LoteStore` — acoplamento contratual, já existe padrão similar com `alterarProducaoLote()`
- A criação da atividade é **não-blqueante para o usuário**: se falhar, mostra toast de erro mas não impede o salvamento da produção (o dado de produção já foi persistido no passo 3)

---

## 3. Especificação Detalhada

### 3.1 LoteStore.registrarAtividadeProducao()

**Localização:** `lote_store.dart` (após método `alterarProducaoLote()`)

```dart
@action
Future<void> registrarAtividadeProducao({
    required Map<String, int> oldValues,
    required Map<String, int> newValues,
}) async
```

**Comportamento:**
1. Compara `oldValues` com `newValues` campo a campo
2. Se nenhuma diferença → retorna sem criar
3. Se há diferenças → monta `Atividade` com:
   - `nome`: string curta descritiva
     - 1 alteração: `"Bandejas semeadas: 42 → 55"`
     - 2+ alterações: `"Produção: 3 campos atualizados"`
   - `descricao`: `jsonEncode({'tipo': 'atualizacao_producao', 'versao': 1, 'alteracoes': [...]})`
   - `privado`: `true`
   - `created_at`: `DateTime.now()`
   - `conta`: `authController.usuario.selected_conta!.conta`
4. Chama `CadernoCampoRepository.cadastrarAtividade()` com `usuarioId: authController.usuario.id!` e `listLoteId: [loteSelecionado.id!]`
5. Em caso de erro → `toastError()` não-bloqueante

**Imports novos necessários:**
- `dart:convert` (para `jsonEncode`)
- `package:osi_solucoes/features/data/repositories/cadernoCampo/cadeno_campo_repository.dart`
- `package:osi_solucoes/features/presenter/models/atividade/atividade_model.dart`

### 3.2 CadernoCampoStore — filtro

**Novo observable:**
```dart
@observable
bool mostrarRegistrosSistema = true;
```

**Nova action:**
```dart
@action
void toggleMostrarRegistrosSistema() =>
    mostrarRegistrosSistema = !mostrarRegistrosSistema;
```

**Computed modificado** (`getLotesAtividadesFilter`):
- Adicionar condição: se `mostrarRegistrosSistema == false`, filtrar `element.atividade?.privado != true`

### 3.3 ProducaoSection._saveEdit()

**Modificação no método existente:**
1. Antes de sincronizar controllers, capturar `oldValues` do `_store.loteSelecionado`
2. Após `alterarProducaoLote()` bem-sucedido, chamar `_store.registrarAtividadeProducao(oldValues, newValues)`

**Estrutura de valores:**
```dart
final old = {
  'bandejas_semeadas': _store.loteSelecionado.bandeijas_semeadas ?? 0,
  'mudas_transplantadas': _store.loteSelecionado.mudas_transplantadas ?? 0,
  'plantas_colhidas': _store.loteSelecionado.plantas_colhidas ?? 0,
  'embalagens_produzidas': _store.loteSelecionado.embalagens_produzidas ?? 0,
};

final novo = {
  'bandejas_semeadas': int.tryParse(_bandeijasCtrl.text) ?? 0,
  'mudas_transplantadas': int.tryParse(_mudasCtrl.text) ?? 0,
  'plantas_colhidas': int.tryParse(_plantasCtrl.text) ?? 0,
  'embalagens_produzidas': int.tryParse(_embalagensCtrl.text) ?? 0,
};
```

### 3.4 DetalhesCadernoCampoPage — badge visual

**_ActivityCard:**
- Se `item.atividade?.privado == true`:
  - Exibir chip/badge `[Sistema]` ao lado do nome ou junto ao usuário
  - Usar cor neutra (`Constants.kGreyMedium`) e ícone `Icons.auto_awesome` (ou `Icons.analytics`)
  - Texto do badge: "Sistema"

**_DetalhesCadernoHeader ou body:**
- Adicionar toggle `Switch` ou `FilterChip` no header para `mostrarRegistrosSistema`
- Rótulo: "Registros do sistema"
- Estado vinculado a `store.mostrarRegistrosSistema`

---

## 4. Estratégia de Implementação

### 4.1 Dependências entre Workstreams

```
Workstream A (lote_store.dart) ──────┐
                                     ├── Workstream B (producao_section.dart)
Workstream C (caderno_campo_store) ──┼── Workstream D (detalhes_caderno_campo_page)
                                     │   (arquivos diferentes, podem rodar paralelo)
                                     └── A depende de imports, B depende de A existir
```

### 4.2 Ordem de Implementação

1. **Workstream A** — `lote_store.dart`: método `registrarAtividadeProducao()`
2. **Workstream C** — `caderno_campo_store.dart`: filtro `mostrarRegistrosSistema`
3. **Workstream B** — `producao_section.dart`: snapshot + chamada
4. **Workstream D** — `detalhes_caderno_campo_page.dart`: badge + toggle

Workstreams A e C são independentes (arquivos diferentes). Workstream B depende de A. Workstream D depende de C. B e D podem rodar após A e C respectivamente.
