# Code Conventions

## Naming Conventions

**Files:**
- snake_case para todos os arquivos
- Sufixos semânticos: `_page.dart`, `_store.dart`, `_model.dart`, `_repository.dart`, `_datasource.dart`
- Arquivos gerados: `_model.g.dart`, `_store.g.dart`
- Examples: `lote_store.dart`, `lote_page.dart`, `lote_model.dart`, `lote_repository.dart`

**Classes:**
- PascalCase
- Stores: `LoteStore = LoteStoreBase with _$LoteStore` (pública) + `abstract class LoteStoreBase with Store`
- Pages: `LotePage`, `DetalhesLotePage`
- Repositories: `LoteRepository implements ILoteRepository`

**Variables/observables:**
- camelCase
- Booleanos: prefixo `is` ou `has` (ex: `isLoading`, `hasError`, `isEditing`)
- Listas: sufixo `List` (ex: `loteList`, `setorList`)

**Constants:**
- PascalCase com prefixo `k` em `Constants` (ex: `Constants.kPrimaryColor`)

## Code Organization

**Import ordering:**
1. Flutter/Dart packages
2. Third-party packages
3. Internal `package:osi_solucoes/`
4. Relative imports

**Store structure (MobX):**
1. Dependências (repositories, controllers)
2. `@observable` fields
3. `@action` methods
4. `@computed` getters

## Type Safety / Error Handling

- Dart null safety com `?` e `required`
- `Either<Failure, T>` via dartz
- `result.fold((err) { toastError(...); }, (data) { ... })`
- Toast utilities: `core/utils/toast.dart`

## Comments

- Comentários em português
- `print()` extensivo com prefixos emoji: `🏠`, `📊`, `✅`, `❌`, `⚠️`
- Seções demarcadas: `// ############# START ... #############`

## Localization

- Strings via `.i18n()` da lib `localization`
- JSONs em `lib/core/constants/i18n/`
