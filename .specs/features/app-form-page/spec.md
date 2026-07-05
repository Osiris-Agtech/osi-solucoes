# AppFormPage — Layout Centralizado para Formulários de Cadastro

**Status:** Draft
**Autor:** Orchestrator
**Data:** 2026-07-05
**Versão:** 1.0
**Feature:** `app-form-page`

---

## 1. Overview

### 1.1 Contexto

Atualmente, as páginas de cadastro da aplicação não possuem um layout padronizado. Cada página implementa seu próprio scaffold manual, resultando em:

- **Formulários comprimidos no topo da tela** sem centralização vertical
- **Sem constraint de largura máxima** em desktop web, campos ocupam 100% da largura
- **Boilerplate repetido** em 7+ páginas: `AnnotatedRegion<SystemUiOverlayStyle>`, `SafeArea`, `Scaffold`, `GestureDetector(onTap: unfocus)`, `SingleChildScrollView`, `BouncingScrollPhysics`
- **Padding e layout inconsistentes** entre páginas (valores hardcoded: 10, 16, 20)

### 1.2 Escopo — Fase 1

**Dentro do escopo (Fase 1):**
- Criar componente `AppFormPage` em `lib/features/presenter/widgets/common/`
- O componente deve:
  - Envolver o conteúdo em um card branco centralizado horizontal e verticalmente
  - Aplicar largura máxima configurável (default: 640px)
  - Adaptar altura ao conteúdo (sem `Expanded` forçado), com altura mínima para steps com pouco conteúdo
  - Incluir `AppFormHeader` como AppBar
  - Gerenciar scroll, teclado (`resizeToAvoidBottomInset`), padding responsivo e `SystemUiOverlayStyle`
  - Gerenciar `GestureDetector(onTap: unfocus)` para fechar teclado
  - Centralização vertical: distribuir ~⅓ do espaço livre acima do card em desktop
- Refatorar `cadastrar_lote_page.dart` para usar `AppFormPage` como prova de conceito
- Manter total compatibilidade com os widgets existentes: `AppStepWizard`, `AppFormSection`, etc.

**Fora do escopo (Fase 1):**
- Refatoração das demais páginas de cadastro (Área, Setor, Reservatório, Usuário, Solução, Protocolo, Caderno de Campo) — postergado para Fase 2
- Modificação de `AppStepWizard`, `StepProgressBar`, `StepNavigationFooter` ou outros componentes compartilhados
- Modificação de stores, repositórios ou modelos de dados
- Criação de testes automatizados
- Internacionalização / i18n

---

## 2. Current State Analysis

### 2.1 Como o Cadastro de Lote Funciona Hoje

`cadastrar_lote_page.dart` (~98 linhas relevantes):

```dart
AnnotatedRegion<SystemUiOverlayStyle>(
  value: const SystemUiOverlayStyle(
    statusBarColor: Constants.kBackgroundColor,
    statusBarIconBrightness: Brightness.dark,
  ),
  child: Scaffold(
    resizeToAvoidBottomInset: true,
    appBar: AppFormHeader(
      onBack: () { Get.close(1); store.limparTudo(); },
      title: store.isEditing ? 'Alterando Lote' : 'Criando Novo Lote',
    ),
    backgroundColor: Constants.kBackgroundColor,
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Expanded(
          child: AppStepWizard(
            steps: [...],
            onSubmit: () { ... },
            stepLabels: const ['Setor', 'Reservatório', 'Lote', 'Cultura', 'Protocolo'],
          ),
        ),
        const SizedBox(height: 30),
      ],
    ),
  ),
);
```

**Problemas:**
1. `Expanded(child: AppStepWizard(...))` força o wizard a ocupar todo o espaço vertical disponível, deixando o formulário "grudado" no topo com vazio embaixo
2. Sem `Center()` ou `ConstrainedBox(maxWidth: ...)` — em desktop web o conteúdo ocupa 100% da largura
3. Repete `AnnotatedRegion`, `Scaffold`, `backgroundColor` que são boilerplate puro
4. Padding fixo `SizedBox(height: 12)` no topo — não escala para diferentes tamanhos de tela

### 2.2 Padrão em Outras Páginas de Cadastro

| Página | Arquivo | Abordagem |
|--------|---------|-----------|
| Lote | `N3/cadastrar_lote_page.dart` | Scaffold + Column + Expanded(AppStepWizard) |
| Área Cultivo | `N1/cadastrar_area_cultivo_page.dart` | Scaffold + SingleChildScrollView + Column (padding 10) |
| Setor | `N2/cadastrar_setor_page.dart` | Scaffold + SingleChildScrollView + Column (padding 10) |
| Reservatório | `reservatorio/.../cadastrar_resevatorio_page.dart` | Scaffold + Column + Expanded(Container()) |
| Usuário | `gerenciar_equipe/cadastrar_usuario_page.dart` | Scaffold + SingleChildScrollView + Column |
| Cadastro (user) | `cadastro/cadastro_page.dart` | AuthScaffold + AuthPanelCard (parcialmente centralizado) |

### 2.3 Componentes Existentes que o AppFormPage Vai Usar

| Componente | Arquivo | Uso |
|---|---|---|
| `AppFormHeader` | `widgets/common/app_form_header.dart` | AppBar com back + title |
| `AppPanelCard` | `widgets/common/app_panel_card.dart` | Base para o card centralizado |
| `AppStepWizard` | `widgets/common/app_step_wizard.dart` | Wizard multi-step (child do card) |
| `Constants` | `core/constants/constants.dart` | Cores e tokens de design |

---

## 3. Design Decisions

### 3.1 Decisão 1: Card Centralizado com Altura Adaptativa

O `AppFormPage` renderiza um **card branco** (`AppPanelCard` como referência visual) centralizado na página, cuja altura é determinada pelo conteúdo (sem `Expanded`).

**Justificativa:** O usuário confirmou que quer "o card muda o formato para comportar as informações da nova seção". Isso significa altura adaptativa, não preenchimento forçado.

### 3.2 Decisão 2: Centralização Vertical com LayoutBuilder

Usar `LayoutBuilder` + `ConstrainedBox(minHeight: viewportHeight - padding)` + `Center` para centralizar o card verticalmente, mesmo padrão do `AuthScaffold` existente.

**Cálculo de padding:**
- Desktop (>720px): horizontal 32px, top 32px, bottom 28px + viewInsets
- Mobile (<720px): horizontal 20px, top 24px, bottom 28px + viewInsets

**Justificativa:** O `AuthScaffold` já implementa este padrão com sucesso para a tela de login/cadastro de usuário. Reutilizamos a mesma abordagem.

### 3.3 Decisão 3: `SystemUiOverlayStyle` Padronizado

O componente definirá o `SystemUiOverlayStyle` padrão (status bar escura sobre fundo claro, `Brightness.dark`), com `statusBarColor: Constants.kBackgroundColor`.

**Justificativa:** Todas as páginas de cadastro atuais usam este mesmo padrão. Se uma página precisar de estilo diferente, pode sobrescrever via parâmetro.

### 3.4 Decisão 4: Compatibilidade Retroativa com `AppStepWizard`

O `AppFormPage` aceita qualquer `Widget child` — não modifica o funcionamento interno do `AppStepWizard`. Apenas ajusta o layout externo (remove o `Expanded` do scaffold e deixa o card adaptar altura).

**Nota:** Como o `AppStepWizard` internamente usa `Expanded` (dentro de sua `Column`), o card precisa ter altura mínima suficiente para que o `Expanded` funcione. A `ConstrainedBox(minHeight: 400)` no card garante isso.

---

## 4. Especificação das Mudanças

### 4.1 Novo Arquivo: `AppFormPage`

**Path:** `lib/features/presenter/widgets/common/app_form_page.dart`

**Assinatura:**
```dart
class AppFormPage extends StatelessWidget {
  final String title;                    // Título no AppFormHeader
  final String? subtitle;                // Subtítulo (não usado no header atualmente, reservado)
  final Widget child;                    // Conteúdo principal (AppStepWizard, form, etc.)
  final VoidCallback? onBack;            // Callback ao pressionar voltar
  final List<Widget>? actions;           // Ações no AppFormHeader
  final double maxWidth;                 // Largura máxima do card (default: 640)
  final Color backgroundColor;           // Fundo da página (default: kBackgroundColor)
  final EdgeInsetsGeometry? contentPadding; // Padding interno do card
  final double topPadding;               // Padding superior (default: 24)
  final double horizontalPadding;        // Padding lateral (calculado responsivamente)
  final double cardMinHeight;            // Altura mínima do card (default: 400)
}
```

**Comportamento esperado do build:**
1. `AnnotatedRegion<SystemUiOverlayStyle>` com estilo padrão
2. `GestureDetector(onTap: FocusScope.of(context).unfocus())`
3. `SafeArea` + `Scaffold` com:
   - `resizeToAvoidBottomInset: true`
   - `backgroundColor: backgroundColor`
   - `appBar: AppFormHeader(title: title, onBack: onBack, actions: actions)`
4. Body: `LayoutBuilder` → calcula paddings responsivos
5. `SingleChildScrollView` + `BouncingScrollPhysics`
6. `ConstrainedBox(minHeight: viewportHeight - verticalPadding)` para preencher viewport
7. `Center` → `ConstrainedBox(maxWidth: maxWidth)` → card branco com borderRadius + shadow

**Estrutura visual do card:**
```
┌────────────────────────────────────┐
│                                    │
│          CHILD (ex:                │
│         AppStepWizard)             │
│                                    │
└────────────────────────────────────┘
```

**Card styling:**
- `color: Colors.white` (`Constants.kBackgroundColor`)
- `borderRadius: BorderRadius.circular(20)` (mesmo do `AuthPanelCard`)
- `BoxShadow` com `blurRadius: 18, offset: (0, 8), color: Colors.black.withOpacity(0.07)`
- `padding: contentPadding ?? EdgeInsets.all(24)`

### 4.2 Modificação: `cadastrar_lote_page.dart`

**Antes (~98 linhas relevantes):**
```dart
return AnnotatedRegion<SystemUiOverlayStyle>(
  value: const SystemUiOverlayStyle(
    statusBarColor: Constants.kBackgroundColor,
    statusBarIconBrightness: Brightness.dark,
  ),
  child: Scaffold(
    resizeToAvoidBottomInset: true,
    appBar: AppFormHeader(
      onBack: () {
        Get.close(1);
        store.limparTudo();
      },
      title: store.isEditing ? 'Alterando Lote' : 'Criando Novo Lote',
    ),
    backgroundColor: Constants.kBackgroundColor,
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Expanded(
          child: AppStepWizard(
            steps: [...],
            onSubmit: () { ... },
            stepLabels: const ['Setor', 'Reservatório', 'Lote', 'Cultura', 'Protocolo'],
          ),
        ),
        const SizedBox(height: 30),
      ],
    ),
  ),
);
```

**Depois:**
```dart
return AppFormPage(
  title: store.isEditing ? 'Alterando Lote' : 'Criando Novo Lote',
  onBack: () {
    Get.close(1);
    store.limparTudo();
  },
  child: AppStepWizard(
    steps: [...],
    onSubmit: () { ... },
    stepLabels: const ['Setor', 'Reservatório', 'Lote', 'Cultura', 'Protocolo'],
  ),
);
```

**O que muda:**
- Remove `AnnotatedRegion<SystemUiOverlayStyle>`
- Remove `Scaffold` + `resizeToAvoidBottomInset` + `backgroundColor`
- Remove `AppFormHeader` (agora dentro de `AppFormPage`)
- Remove `Column` com `SizedBox(height: 12)`
- Remove `Expanded` (agora o card adapta altura)
- Remove `SizedBox(height: 30)`
- Adiciona import de `app_form_page.dart`
- Remove imports não mais usados: `package:flutter/services.dart`

---

## 5. Estados do AppFormPage

| Estado | Comportamento |
|---|---|
| **Default** | Card centralizado com ~⅓ do espaço livre no topo. Conteúdo do child renderizado dentro do card. |
| **Teclado aberto** | `resizeToAvoidBottomInset: true` + `MediaQuery.viewInsets.bottom` no padding → scroll automático para o campo ativo. |
| **Conteúdo pequeno** | Card com `minHeight: 400px` para não parecer flutuando, centralizado verticalmente. |
| **Conteúdo grande (>viewport)** | Card cresce naturalmente, `SingleChildScrollView` permite scroll da página. |
| **Mobile (<600px)** | Padding lateral 20px, top 24px. Card ocupa quase toda a largura. |
| **Tablet (600-900px)** | Padding lateral 32px, `maxWidth` limita a largura do card. |
| **Desktop (>900px)** | Card centralizado com maxWidth 640px, amplo espaço nas laterais. |

---

## 6. Acceptance Criteria — Fase 1

| ID | Critério | Como Verificar |
|----|----------|---------------|
| **F1.1** | `AppFormPage` existe em `widgets/common/app_form_page.dart` | Arquivo existe |
| **F1.2** | `AppFormPage` aceita `title`, `child`, `onBack`, `maxWidth`, `backgroundColor`, `actions`, `subtitle`, `contentPadding`, `cardMinHeight` | Assinatura do construtor |
| **F1.3** | `AppFormPage` renderiza `AppFormHeader` com o `title` e `onBack` passados | Inspeção visual |
| **F1.4** | O conteúdo (`child`) é renderizado dentro de um card branco com borderRadius 20 e shadow | Inspeção visual |
| **F1.5** | O card é centralizado verticalmente na página (quando conteúdo < viewport) | Printscreen |
| **F1.6** | O card tem `maxWidth` configurável (default 640px) | Inspeção visual em desktop |
| **F1.7** | Padding responsivo: mobile <720px usa 20px lateral, >=720px usa 32px | Inspeção visual |
| **F1.8** | `GestureDetector(onTap: unfocus)` fecha teclado ao tocar fora | Teste manual |
| **F1.9** | `cadastrar_lote_page.dart` usa `AppFormPage` e mantém o mesmo comportamento funcional | Wizard funciona, steps navegam, submit salva |
| **F1.10** | `cadastrar_lote_page.dart` reduziu de ~98 para ~25-35 linhas | `wc -l` |
| **F1.11** | `dart analyze` não aponta erros ou warnings nos arquivos modificados | Comando `dart analyze` |

---

## 7. Regressão

| ID | Critério |
|----|----------|
| **R1** | O `AppStepWizard` continua funcionando exatamente como antes (steps, progress bar, navegação, submit) |
| **R2** | O `onSubmit` do lote ainda chama `store.validarRegistro()` e `store.registrarLote()` / `store.alterarLote()` |
| **R3** | `store.limparTudo()` ainda é chamado ao sair (via `onBack` no `AppFormPage`) |
| **R4** | Navegação (avançar/voltar) entre steps continua funcional |
| **R5** | Nenhum widget step (`setor_step.dart`, `lote_step.dart`, etc.) foi modificado |

---

## 8. File List — Fase 1

| Arquivo | Tipo | Responsabilidade |
|---------|------|------------------|
| `lib/features/presenter/widgets/common/app_form_page.dart` | **Criar** | Novo componente de layout centralizado para formulários |
| `lib/features/presenter/views/area_cultivo/N3/cadastrar_lote_page.dart` | **Modificar** | Substituir scaffold manual por `AppFormPage` |
| `lib/core/constants/constants.dart` | **Nenhuma** | Já contém as cores necessárias; sem alterações |

---

## 9. Glossary

| Termo | Definição |
|-------|-----------|
| **AppFormPage** | Novo componente que encapsula scaffold + card centralizado + scroll + padding responsivo para formulários |
| **Card centralizado** | Container branco com bordas arredondadas e sombra, posicionado no centro da tela |
| **Fase 1** | Criação do componente + refatoração da página de cadastro de lote (prova de conceito) |
| **Fase 2** | Refatoração das demais páginas de cadastro (escopo futuro) |

---

## 10. References

- Spec de refatoração anterior: `.specs/features/cadastrar-lote-refactor/spec.md`
- Página atual do lote: `lib/features/presenter/views/area_cultivo/N3/cadastrar_lote_page.dart`
- Componente AppStepWizard: `lib/features/presenter/widgets/common/app_step_wizard.dart`
- Componente AppFormHeader: `lib/features/presenter/widgets/common/app_form_header.dart`
- Componente AppPanelCard: `lib/features/presenter/widgets/common/app_panel_card.dart`
- Componente AuthScaffold (inspiração): `lib/features/presenter/views/login/components/auth/auth_scaffold.dart`
- Cores e tokens: `lib/core/constants/constants.dart`
- Análise visual do sistema: `.specs/decisions/visual-design-system-analysis.md`
