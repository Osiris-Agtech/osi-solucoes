# Implementation Plan — AppFormPage (Fase 2)

## Objetivo

Refatorar as 8 páginas de cadastro restantes para usar `AppFormPage`, eliminando boilerplate repetido e padronizando o layout centralizado.

## Estrutura Comum de Todas as Refatorações

### Remover de cada página:
- `AnnotatedRegion<SystemUiOverlayStyle>` wrapper
- `GestureDetector(onTap: FocusScope.of(context).unfocus())` (ou similar)
- `SafeArea` wrapper
- `Scaffold` com `appBar`, `backgroundColor`, `resizeToAvoidBottomInset`
- Método `appBar()` que retorna `AppFormHeader` (se existir)
- `AppFormHeader` se passado inline no Scaffold
- Padding externo manual e `SingleChildScrollView` (AppFormPage gerencia)
- `import 'package:flutter/services.dart'` (se só usado para SystemUiOverlayStyle)
- `import 'package:osi_solucoes/core/constants/constants.dart'` (se só usado para backgroundColor)
- `import 'package:osi_solucoes/features/presenter/widgets/common/app_form_header.dart'`

### Adicionar:
- Import: `import 'package:osi_solucoes/features/presenter/widgets/common/app_form_page.dart';`
- Wrapper: `return AppFormPage(title: ..., onBack: ..., child: ...);`

### Manter:
- Toda lógica de initState/dispose/stores
- Widget methods (titulo, subtitulo, _nome, _campos, etc.)
- Imports restantes (componentes, stores, etc.)
- Lógica de submit, validação, navegação

## Workstreams (8 páginas independentes)

### WS-1: cadastrar_area_cultivo_page.dart
**Arquivo:** `lib/features/presenter/views/area_cultivo/N1/cadastrar_area_cultivo_page.dart`

**Mudanças:**
- Remover: AnnotatedRegion, GestureDetector(onTap), SafeArea, Scaffold(appBar: AppFormHeader, backgroundColor, body: Padding/SingleChildScrollView/Column)
- Manter: Row `subtitulo()`, `nome()`, `_descricaoTextFormField()` (renomeado localmente), `saveButton()`, store, initState, dispose
- Substituir build por:
```dart
return AppFormPage(
  title: store.isEditing ? 'Alterar Área de Cultivo' : 'Nova Área de Cultivo',
  onBack: () => Get.back(),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      subtitulo(),
      const SizedBox(height: 20),
      nome(context),
      AppValidationMessage(...),
      const Divider(),
      localizacao(context),
      const Divider(),
      descricao(context),
      // ... existing content
      saveButton(size),
    ],
  ),
);
```
- Remover imports não usados: `flutter/services.dart`, `constants.dart` (se não usado mais)
- Adicionar import: `app_form_page.dart`

### WS-2: cadastrar_setor_page.dart
**Arquivo:** `lib/features/presenter/views/area_cultivo/N2/cadastrar_setor_page.dart`

**Mudanças:**
- Remover: AnnotatedRegion, GestureDetector(onTap), SafeArea, Scaffold, Padding/SingleChildScrollView/Column wrapper
- Substituir por AppFormPage com title 'Novo Setor', onBack
- Manter: subtitulo, local(), nome, warning, reservatorio, descricao, saveButton
- Remover imports: `flutter/services.dart`
- Adicionar import: `app_form_page.dart`

### WS-3: cadastrar_reservatorio_page.dart
**Arquivo:** `lib/features/presenter/views/reservatorio/cadastrar_reservatorio/cadastrar_resevatorio_page.dart`

**Mudanças:**
- Remover: AnnotatedRegion, SafeArea, Scaffold, Padding/SingleChildScrollView/Column wrapper
- Substituir por AppFormPage com title 'Novo Reservatório', onBack
- Manter: subtitulo, nome, volume, solucaoNutritiva, AppValidationMessage, saveButton
- Remover imports: `flutter/services.dart`
- Adicionar import: `app_form_page.dart`

**Nota:** este arquivo tem um typo no nome (`resevatorio`), não corrigir — manter consistência.

### WS-4: cadastrar_usuario_page.dart
**Arquivo:** `lib/features/presenter/views/gerenciar_equipe/cadastrar_usuario_page.dart`

**Mudanças:**
- Remover: AnnotatedRegion, GestureDetector(onTap), SafeArea, Scaffold, Padding/SingleChildScrollView/ScrollConfiguration wrapper
- Substituir por AppFormPage com title 'Cadastrar Colaborador', onBack
- Manter: titulo, subtitulo, image, email, nome, sobrenome, cargo, info, saveButton
- O método `appBar()` deve ser removido, o título vai para AppFormPage
- Remover imports: `flutter/services.dart`
- Adicionar import: `app_form_page.dart`

**Nota:** este arquivo chama `store.clearCadastro()` no dispose.

### WS-5: cadastro_page.dart (user registration)
**Arquivo:** `lib/features/presenter/views/cadastro/cadastro_page.dart`

**Mudanças:**
- Remover: `AnnotatedRegion`, `AuthScaffold`, `AuthPanelCard` (AppFormPage substitui ambos)
- O `leading` (back button) do AuthScaffold vira `onBack` no AppFormPage
- O `maxWidth: 680` vira `maxWidth: 680` (mantido)
- `child: Form(...)` vira `child: child` do AppFormPage
- O `AuthPanelCard(child: Form(...))` vira `Form(...)` direto no child — AppFormPage já renderiza o card
- Remover imports: `flutter/services.dart`, `auth/auth_widgets.dart` (se não usado)
- Adicionar import: `app_form_page.dart`

**Nota:** manter `AuthHeader`, `AuthPrimaryButton`, `AuthTextField` e `AuthFeedbackMessage` — são componentes de formulário, não de layout. O layout (AuthScaffold, AuthPanelCard) é substituído.

### WS-6: cadastrar_solucao_page.dart
**Arquivo:** `lib/features/presenter/views/solucao/cadastrar_solucao_page.dart`

**Mudanças:**
- Remover: AnnotatedRegion, GestureDetector, SafeArea, DefaultTabController, Scaffold, Padding/SingleChildScrollView/Column wrapper
- O `bottomNavigationBar` com o botão "Avançar" deve ser movido para o final do body Column
- Substituir por AppFormPage com title 'Nova Solução Nutritiva', onBack
- Manter: subtitulo, _nome, _fertilizantes, TabBar e TabBarView, _cardListWithData, _nextButton
- O `resizeToAvoidBottomInset: false` vira `true` (padrão do AppFormPage)
- Remover imports: `flutter/services.dart`
- Adicionar import: `app_form_page.dart`

**Nota sobre bottomNavigationBar:**
```dart
// ANTES: bottomNavigationBar: isKeyboardOpen ? null : _nextButton(size)
// DEPOIS: adicionar no final do Column children:
if (!isKeyboardOpen) _nextButton(size),
```

### WS-7: cadastrar_caderno_campo_page.dart
**Arquivo:** `lib/features/presenter/views/caderno_campo/cadastrar_caderno_campo_page.dart`

**Mudanças:**
- Remover: AnnotatedRegion, GestureDetector(onTap), SafeArea, Scaffold, método `appBar()`, Padding/SingleChildScrollView/Column wrapper
- Substituir por AppFormPage, sem title no AppFormHeader (usar `title: 'Novo Registro'` para consistência)
- O título inline `titulo()` (linha 222) pode virar o title do AppFormPage — REMOVER o widget titulo()
- Manter: subtitulo, atividade, autor, data, hora, lote, descricao, _descricaoTextFormField, saveButton
- Remover imports: `flutter/services.dart`
- Adicionar import: `app_form_page.dart`

### WS-8: cadastrar_protocolo_page.dart
**Arquivo:** `lib/features/presenter/views/protocolo/cadastrar_protocolo_page.dart`

**Mudanças:**
- Remover: AnnotatedRegion, GestureDetector(onTap), SafeArea, Scaffold, método `appBar()`, Padding/SingleChildScrollView/Column wrapper
- O título inline `titulo()` vira o title do AppFormPage — REMOVER o widget titulo()
- O `subtitulo()` permanece no body
- Substituir por AppFormPage com title 'Criando novo Protocolo', onBack
- Manter: subtitulo, nome, cultura, sistema, forma, atividades, AppValidationMessage, saveButton
- Remover imports: `flutter/services.dart`
- Adicionar import: `app_form_page.dart`

## Validação

Para cada workstream, verificar:
1. `dart analyze <arquivo_modificado>` — zero erros
2. `dart analyze lib/features/presenter/` — sem novos erros
