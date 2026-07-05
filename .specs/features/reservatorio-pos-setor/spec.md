# Reservatório Logo Após Setor no Cadastro de Lote

**Status:** Draft  
**Autor:** Orchestrator  
**Data:** 2026-07-05  
**Versão:** 1.0  
**Feature:** `reservatorio-pos-setor`

---

## 1. Overview

### 1.1 Contexto

No cadastro de lote (`cadastrar_lote_page.dart`), o fluxo atual é:

```
Setor → Lote → Cultura → Reservatório → Protocolo
```

O vínculo com reservatório (step 3) está no final, depois de Lote e Cultura. No entanto, cada `Setor` já possui um `reservatorio` vinculado (campo `Setor.reservatorio`). Isso significa que, na prática, o lote quase sempre usa o mesmo reservatório do setor, mas o usuário é forçado a:
1. Selecionar o setor (step 0)
2. Avançar por Lote e Cultura (steps 1-2)
3. Só então selecionar manualmente o reservatório (step 3)

### 1.2 Escopo

**Dentro do escopo:**
- Mover o step de Reservatório para imediatamente após Setor (step 1)
- Auto-presetar o `novoLoteReservatorio` com o `Setor.reservatorio` quando o setor for selecionado
- Manter a etapa como opcional (usuário pode trocar ou desvincular)
- Atualizar a validação por etapa (step de reservatório sempre `true`)
- Quando a área for trocada e o setor resetado, o reservatório também deve ser limpo

**Fora do escopo:**
- Alteração de modelos (`Lote`, `Setor`, `Area`, `Reservatorio`, `Cultura`, `Protocolo`)
- Alteração de APIs/repositories
- Alteração do fluxo de *edição* de lote (já funciona com `setLoteEditing()`)
- Alteração de `reservatorio_step.dart` visual (já lê `store.novoLoteReservatorio.id`)
- Criação de testes automatizados (fora do escopo do projeto)
- Internacionalização / i18n

---

## 2. Current State Analysis

### 2.1 Ordem Atual dos Steps

| Step | Label        | Componente             | Validação                          |
|------|-------------|------------------------|-------------------------------------|
| 0    | Setor       | `setor_step.dart`      | `novoLoteArea.id != null && novoLoteSetor.id != null` |
| 1    | Lote        | `lote_step.dart`       | `novoLoteName.text.trim().isNotEmpty` |
| 2    | Cultura     | `cultura_step.dart`    | `novoLoteCultura.id != null` |
| 3    | Reservatório | `reservatorio_step.dart` | `true` (opcional) |
| 4    | Protocolo   | `protocolo_step.dart`  | `true` (opcional) |

### 2.2 Fluxo de Dados Relevante

- `Setor.reservatorio` é populado pela API (ver `setor_model.dart` linha 28, `setor_model.g.dart` linha 19-21)
- `novoLoteReservatorio` é o observable que controla a seleção (ver `lote_store.dart` linha 389)
- `reservatorio_step.dart` usa `store.novoLoteReservatorio.id` para determinar qual item está selecionado (linha 38-39)
- `registrarLote()` usa `novoLoteReservatorio` para montar o payload (linha 740-741)

### 2.3 Problemas Identificados

| # | Problema | Localização | Impacto |
|---|----------|-------------|---------|
| 1 | Reservatório no final do stepper força re-trabalho | `cadastrar_lote_page.dart` step 3 | Usuário precisa lembrar de voltar para vincular após ver o setor |
| 2 | Setor já carrega o reservatório, mas ele não é aproveitado | `setor_step.dart` onChanged não propaga para `novoLoteReservatorio` | Oportunidade de UX perdida |
| 3 | Troca de área reseta setor mas não limpa reservatório | `setor_step.dart` linha 35-41 | Resquício de reservatório de setor anterior pode causar confusão |

---

## 3. Design Decisions

### 3.1 Decisão 1: Nova Ordem dos Steps

**Setor → Reservatório → Lote → Cultura → Protocolo**

**Justificativa:** O reservatório é uma propriedade que deriva naturalmente do setor. Colocá-lo imediatamente após a seleção do setor permite que o usuário:
1. Veja o preset automaticamente
2. Confirme ou ajuste antes de preencher os dados específicos do lote

### 3.2 Decisão 2: Auto-preset Sempre ao Selecionar Setor

Quando o setor muda, `novoLoteReservatorio` é sempre sobrescrito com `Setor.reservatorio` (ou limpo se o setor não tiver reservatório).

**Justificativa:** Simplicidade. O step de reservatório vem logo em seguida, então o usuário pode desfazer ou alterar imediatamente. Não compensa adicionar lógica de "só trocar se não foi alterado manualmente".

### 3.3 Decisão 3: Action Isolada no Store

Criar uma action `autoPreencherReservatorioDoSetor()` no `LoteStoreBase` para encapsular a lógica de preset, em vez de acessar `novoLoteReservatorio` diretamente do widget.

**Justificativa:** Mantém a responsabilidade no store, facilita testabilidade futura, e evita que o widget atribua diretamente a um observable MobX.

---

## 4. Especificação das Mudanças

### 4.1 `cadastrar_lote_page.dart`

**4.1.1 `stepLabels`** (linha 34-40)
```dart
// ANTES
static const List<String> stepLabels = [
  'Setor', 'Lote', 'Cultura', 'Reservatório', 'Protocolo',
];

// DEPOIS
static const List<String> stepLabels = [
  'Setor', 'Reservatório', 'Lote', 'Cultura', 'Protocolo',
];
```

**4.1.2 `_buildStepContent()`** — reordenar `switch` (linha 115-130)
```dart
case 0: SetorStep(...)
case 1: ReservatorioStep(...)
case 2: LoteStep(...)
case 3: CulturaStep(...)
case 4: ProtocoloStep(...)
```

**4.1.3 `_canGoForward()`** — reordenar validações (linha 133-147)
```dart
case 0: store.validarEtapaSetor()
case 1: true  // Reservatório - opcional
case 2: store.validarEtapaLote()
case 3: store.validarEtapaCultura()
case 4: true
```

### 4.2 `setor_step.dart`

**4.2.1 Área onChanged** — limpar reservatório ao resetar setor (linha 35-41)
```dart
onChanged: (value) {
  if (value != null) {
    formKey.currentState?.reset();
    store.selecionarNovoLoteSetor(Setor());
    store.novoLoteReservatorio = Reservatorio();  // NOVO
    store.selecionarNovoLoteArea(value);
  }
},
```

**4.2.2 Setor onChanged** — auto-preset reservatório (linha 56-59)
```dart
onChanged: (value) {
  if (value != null) {
    store.selecionarNovoLoteSetor(value);
    store.autoPreencherReservatorioDoSetor();  // NOVO
  }
},
```

### 4.3 `lote_store.dart`

**4.3.1 Nova action** — após linha ~448
```dart
@action
void autoPreencherReservatorioDoSetor() {
  if (novoLoteSetor.reservatorio != null) {
    novoLoteReservatorio = novoLoteSetor.reservatorio!;
  } else {
    novoLoteReservatorio = Reservatorio();
  }
}
```

---

## 5. Data Flow

### 5.1 Fluxo Novo

```
[Usuário abre CadastrarLotePage]
  │
  ├── initState() → buscarAreasList, buscarCulturas, buscarReservatorios, buscarProtocolos
  │
  ├── Step 0 (Setor) → usuário seleciona área → dropdown setor é populado
  │   └── usuário seleciona setor
  │       └── autoPreencherReservatorioDoSetor()
  │           ├── se setor.temReservatorio → novoLoteReservatorio = setor.reservatorio
  │           └── senão → novoLoteReservatorio = Reservatorio() (vazio)
  │   └── valida: area && setor selecionados
  │
  ├── Step 1 (Reservatório) → lista exibida com reservatório pré-selecionado
  │   ├── usuário pode: manter, trocar (via detalhes), ou desvincular
  │   └── valida: true (sempre pode avançar)
  │
  ├── Step 2 (Lote) → nome do lote
  │   └── valida: nome não vazio
  │
  ├── Step 3 (Cultura) → seleção de cultura
  │   └── valida: cultura selecionada
  │
  ├── Step 4 (Protocolo) → busca + seleção de protocolo
  │   └── valida: true
  │
  └── "Salvar" → store.registrarLote() (mesmo código)
```

### 5.2 Fluxo de Edição

`setLoteEditing()` (linha 562-576) restaura `novoLoteReservatorio` do lote existente, independente da ordem dos steps. A reordenação não afeta este fluxo.

---

## 6. Estados

### 6.1 Step de Reservatório com Auto-preset

- **Setor com reservatório:** `novoLoteReservatorio` populado → step 1 abre com o reservatório do setor já selecionado (check verde no tile correspondente)
- **Setor sem reservatório:** `novoLoteReservatorio` vazio → step 1 abre sem pré-seleção
- **Usuário troca:** ao abrir detalhes de outro reservatório e clicar "Vincular", `novoLoteReservatorio` é atualizado
- **Usuário desvincula:** `novoLoteReservatorio` volta a `Reservatorio()` vazio

### 6.2 Troca de Setor Após Alteração Manual

Se o usuário:
1. Seleciona setor A → reservatório A é presetedo
2. Vai ao step 1 e troca para reservatório B manualmente
3. Volta ao step 0 e troca para setor C → reservatório C é presetedo (sobrescreve B)

Este comportamento é intencional e esperado. O usuário pode trocar novamente no step 1.

---

## 7. Acceptance Criteria

| ID | Critério | Como Verificar |
|----|----------|---------------|
| F1 | O stepper exibe a ordem: Setor, Reservatório, Lote, Cultura, Protocolo | Abrir página; ver labels e sequência |
| F2 | Ao selecionar um setor, o reservatório do setor é automaticamente presetedo | Selecionar setor com reservatório, avançar → step 1 mostra o reservatório selecionado |
| F3 | Ao selecionar um setor *sem* reservatório, nenhum reservatório fica presetedo | Selecionar setor sem reservatório, avançar → step 1 sem pré-seleção |
| F4 | Ao trocar de área (resetando setor), o reservatório também é limpo | Trocar área → setor reseta → reservatório reseta |
| F5 | O usuário pode trocar o reservatório presetedo por outro | Step 1, selecionar outro reservatório → check muda |
| F6 | O usuário pode desvincular o reservatório | Step 1, desvincular → `novoLoteReservatorio` fica vazio |
| F7 | A validação por etapa permite avanço no step de reservatório mesmo sem seleção | Step 1 sem seleção → botão Avançar habilitado |
| F8 | `registrarLote()` envia o reservatório correto | Submit com reservatório trocado → payload com o reservatório selecionado |
| F9 | Edição de lote não é afetada | Abrir lote existente → steps mantêm valores originais |

---

## 8. Regressão

| ID | Critério |
|----|----------|
| R1 | `store.registrarLote()` é chamado com os mesmos campos de antes |
| R2 | `store.alterarLote()` é chamado com os mesmos campos de antes |
| R3 | `store.limparTudo()` é chamado ao sair da página |
| R4 | Toast de erro/sucesso continua funcionando |
| R5 | Lista de lotes é recarregada após sucesso |
| R6 | `setor_step.dart` continua funcionando sem depender do step de reservatório |
| R7 | Reservatório opcional pode ser pulado (avançar sem selecionar) |

---

## 9. File List

| Arquivo | Tipo de Mudança | Responsabilidade |
|---------|----------------|------------------|
| `cadastrar_lote_page.dart` | Alterar | Reordenar steps, labels, validação |
| `setor_step.dart` | Alterar | Auto-preset ao selecionar setor, limpar ao trocar área |
| `lote_store.dart` | Alterar | Nova action `autoPreencherReservatorioDoSetor()` |

---

## 10. Glossary

| Termo | Definição |
|-------|-----------|
| **Auto-preset** | Preenchimento automático de um campo com base no valor de outro campo relacionado |
| **Setor** | Subdivisão física de uma área de cultivo |
| **Reservatório** | Tanque de solução nutritiva vinculável a lotes e setores |

---

## 11. References

- Spec existente: `.specs/features/cadastrar-lote-refactor/spec.md`
- Store: `lib/features/presenter/viewmodels/lote_store.dart`
- Página: `lib/features/presenter/views/area_cultivo/N3/cadastrar_lote_page.dart`
- Setor step: `lib/features/presenter/views/area_cultivo/N3/components/cadastrar_page/setor_step.dart`
- Reservatório step: `lib/features/presenter/views/area_cultivo/N3/components/cadastrar_page/reservatorio_step.dart`
- Modelo Setor: `lib/features/presenter/models/setor/setor_model.dart`
