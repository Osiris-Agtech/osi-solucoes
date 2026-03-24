# External Integrations

## Firebase

### Firebase Core
**Purpose:** Inicialização e base para todos os serviços Firebase
**Implementation:** `lib/core/services/` (inicialização via `Firebase.app()`)
**Configuration:** `google-services.json` (Android) / `GoogleService-Info.plist` (iOS)

### Firebase Analytics
**Purpose:** Rastreamento de navegação e comportamento do usuário para alimentar o ML
**Implementation:** `lib/core/services/navigation_analytics.dart`
**Key events:**
- `navigation_click` — cada navegação registra rota, hora, dia da semana, user_id
- `smart_shortcut_click` — clique em atalho inteligente com confidence
**Auth:** Via Firebase SDK autenticado implicitamente

### Firebase Cloud Functions
**Purpose:** Fornecer recomendações de interface adaptativa (ML) — dashboard e atalhos inteligentes
**Implementation:** `lib/core/services/adaptive_interface_service.dart`
**Function:** `getAdaptiveInterface`
**Input:** `{ hour: int, userId: String }`
**Output:** `{ dashboard: String?, confidence: double, shortcuts: List<{route, prob, resourceId?, resourceType?, resourceName?}> }`
**Fallback:** Atalhos padrão quando Firebase não disponível

## API Backend (GraphQL)

**Purpose:** CRUD principal da aplicação (lotes, setores, áreas, reservatórios, protocolos, etc.)
**Style:** GraphQL
**Implementation:** `lib/features/data/datasources/[domínio]/`
**Authentication:** Token de autenticação via `AuthController` / `LocalStorage`
**Key domains:**
- `lote/` — buscar, registrar, alterar, finalizar lotes
- `setor/` — buscar, registrar, alterar setores
- `area/` — buscar áreas de cultivo
- `reservatorio/` — reservatórios nutricionais
- `protocolo/` — protocolos de produção
- `homeDashboard/` — métricas do dashboard

## Local Storage

**Purpose:** Persistência local de dados de sessão (usuário autenticado, token)
**Implementation:** `lib/core/services/local_storage.dart`
**Library:** shared_preferences ^2.5.3
