# Implementation Plan — AppFormPage (Fase 1)

## Resumo

Criar componente `AppFormPage` e refatorar `cadastrar_lote_page.dart` para usá-lo.

## Workstreams

### WS-A: Criar AppFormPage

**Arquivo:** `lib/features/presenter/widgets/common/app_form_page.dart` (NOVO)

**Responsabilidade:** Layout centralizado com card, scroll, padding responsivo, AppFormHeader.

**Parâmetros:**
- `title` (String) — Título no AppFormHeader
- `child` (Widget) — Conteúdo principal
- `onBack` (VoidCallback?) — Callback de voltar
- `actions` (List\<Widget\>?) — Ações no AppBar
- `maxWidth` (double, default 640) — Largura máxima do card
- `backgroundColor` (Color, default kBackgroundColor) — Fundo da página
- `contentPadding` (EdgeInsetsGeometry?, default EdgeInsets.all(24)) — Padding interno do card
- `cardMinHeight` (double, default 400) — Altura mínima do card

**Estrutura do build:**
```
AnnotatedRegion<SystemUiOverlayStyle>
  GestureDetector(onTap: unfocus)
    SafeArea
      Scaffold(resizeToAvoidBottomInset, appBar: AppFormHeader)
        LayoutBuilder → calcula paddings responsivos
          SingleChildScrollView(BouncingScrollPhysics)
            ConstrainedBox(minHeight: viewportHeight - padding)
              Center
                ConstrainedBox(maxWidth: maxWidth)
                  DecoratedBox(card styling)
                    Padding(child: child)
```

**Card styling:**
- `color: Constants.kBackgroundColor` (branco)
- `borderRadius: BorderRadius.circular(20)`
- `boxShadow: [BoxShadow(blurRadius: 18, offset: (0, 8), alpha: 0.07)]`

**Dependências:** Nenhuma (arquivo novo)

### WS-B: Refatorar cadastrar_lote_page.dart

**Arquivo:** `lib/features/presenter/views/area_cultivo/N3/cadastrar_lote_page.dart` (MODIFICAR)

**Responsabilidade:** Substituir scaffold manual por `AppFormPage`.

**Mudanças:**
- Remover: `AnnotatedRegion<SystemUiOverlayStyle>` wrapper
- Remover: `Scaffold`, `resizeToAvoidBottomInset`, `backgroundColor`
- Remover: `AppFormHeader` (agora dentro de AppFormPage)
- Remover: `Column` com `SizedBox(height: 12)`
- Remover: `Expanded(child: AppStepWizard(...))`
- Remover: `SizedBox(height: 30)`
- Remover: `import 'package:flutter/services.dart'` (não usado)
- Remover: `import 'package:flutter/material.dart'` (não usado diretamente — verificar)
- Adicionar: `import 'package:osi_solucoes/features/presenter/widgets/common/app_form_page.dart'`
- Substituir build por: `return AppFormPage(title: ..., onBack: ..., child: AppStepWizard(...))`

**Manter inalterado:**
- Toda a lógica de init/dispose (store.buscar*, store.limparTudo)
- O AppStepWizard com seus steps, onSubmit, stepLabels
- O callback onBack com `Get.close(1)` + `store.limparTudo()`
- Import do LoteStore, ProtocoloStore
- Import dos step widgets

### Dependências

WS-B depende de WS-A (usa AppFormPage). Executar sequencialmente.

## Validação

1. `dart analyze lib/features/presenter/widgets/common/app_form_page.dart` — zero erros
2. `dart analyze lib/features/presenter/views/area_cultivo/N3/cadastrar_lote_page.dart` — zero erros
3. `dart analyze lib/features/presenter/` — zero erros no módulo todo
