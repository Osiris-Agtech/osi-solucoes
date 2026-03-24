# Project Structure

**Root:** `lib/`

## Directory Tree

```
lib/
├── core/
│   ├── constants/          # Constants.dart, i18n JSONs
│   ├── domain/             # Entidades base
│   ├── errors/             # Failure classes
│   ├── inject/             # GetIt DI setup
│   ├── middlewares/        # Route middlewares (ex: area_cultivo_middleware)
│   ├── services/           # Serviços transversais
│   │   ├── adaptive_interface_service.dart  ← ML + shortcuts
│   │   ├── navigation_analytics.dart        ← Firebase Analytics
│   │   └── local_storage.dart
│   ├── theme/
│   └── utils/              # Toast, helpers, enums
└── features/
    ├── data/
    │   ├── datasources/    # GraphQL datasources por domínio
    │   │   ├── area/, lote/, setor/, reservatorio/, ...
    │   └── repositories/   # Implementações por domínio
    │       ├── area/, lote/, setor/, reservatorio/, ...
    └── presenter/
        ├── models/         # DTOs + JSON serialization
        │   ├── area/, lote/, setor/, shortcut/, ...
        ├── routes/
        │   └── routes.dart             ← Todas as rotas nomeadas
        ├── viewmodels/     # MobX stores
        │   ├── home_store.dart         ← Estado da home + shortcuts
        │   ├── lote_store.dart         ← Estado + lógica de lotes
        │   ├── setor_store.dart        ← Estado + lógica de setores
        │   └── area_cultivo_store.dart ← Estado + lógica de áreas
        └── views/
            ├── home/
            │   └── home_page.dart      ← HomePage + _navigateWithResource
            └── area_cultivo/
                ├── N1/                 ← AreaCultivoPage
                ├── N2/                 ← SetorPage, CadastrarSetorPage
                └── N3/                 ← LotePage, DetalhesLotePage, CadastrarLotePage
```

## Module Organization

### Core
**Purpose:** Código transversal sem dependência de features
**Key files:** `adaptive_interface_service.dart`, `navigation_analytics.dart`, `constants.dart`

### Data Layer
**Purpose:** Acesso a dados via GraphQL e Firebase
**Location:** `features/data/datasources/` + `features/data/repositories/`
**Pattern:** Interface + Implementação + Datasource

### Presenter Layer
**Purpose:** UI, estado e navegação
**Location:** `features/presenter/`

## Where Things Live

**Shortcut/ML logic:**
- Service: `core/services/adaptive_interface_service.dart`
- Store integration: `features/presenter/viewmodels/home_store.dart`
- Navigation handler: `features/presenter/views/home/home_page.dart` (`_navigateWithResource`)
- Model: `features/presenter/models/shortcut/shortcut_model.dart`

**Lote:**
- UI: `features/presenter/views/area_cultivo/N3/`
- Business Logic: `features/presenter/viewmodels/lote_store.dart`
- Data: `features/data/repositories/lote/` + `features/data/datasources/lote/`
- Model: `features/presenter/models/lote/lote_model.dart`
