# Instant Component Gallery

## Descrição

Tela que renderiza todos os componentes dinâmicos do sistema **instant** com dados mockados hardcoded, permitindo visualização de todos os componentes adaptativos sem depender de contexto real do backend.

## Requisitos

| ID | Descrição | Critério de aceite |
|---|---|---|
| R1 | Botão "📦 Componentes Instant" no AppBar da `AdaptiveAdminPage` | Aparece ao lado do botão "Métricas" |
| R2 | Ao clicar, navega para `InstantComponentGalleryPage` | Rota `/instantComponentGalleryPage` |
| R3 | A página exibe todos os componentes instant com dados hardcoded | Cada seção tem header descritivo + componente renderizado |
| R4 | Componentes exibidos: FocusBanner, ActivityFeed, RecommendedActionsPanel, ContextualOnboardingCard, OperationalOnboardingCard, todas as variações de InfoCard | Nenhum componente quebra na renderização |
| R5 | Cada seção tem um título e descrição do data model | Fácil entender o que cada componente representa |

## Arquivos envolvidos

| Arquivo | Ação | Responsabilidade |
|---|---|---|
| `lib/features/presenter/views/adaptive_admin/instant_component_gallery_page.dart` | Criar | Tela galeria com mocks hardcoded |
| `lib/features/presenter/routes/routes.dart` | Modificar | Adicionar `instantComponentGalleryPage` |
| `lib/features/presenter/routes/app_pages.dart` | Modificar | Registrar `GetPage` |
| `lib/features/presenter/views/adaptive_admin/adaptive_admin_page.dart` | Modificar | Adicionar `IconButton` no AppBar |

## Tasks

| # | O que | Arquivo(s) | Dependência |
|---|---|---|---|
| 1 | Criar `InstantComponentGalleryPage` | `instant_component_gallery_page.dart` | — |
| 2 | Adicionar rota em `routes.dart` | `routes.dart` | 1 |
| 3 | Registrar `GetPage` em `app_pages.dart` | `app_pages.dart` | 2 |
| 4 | Adicionar botão no AppBar | `adaptive_admin_page.dart` | 2 |
