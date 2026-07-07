# Restore legacy encoding for `Atividade.descricao`

## Context

The Flutter app previously wrote `Atividade.descricao` using a legacy UTF-8 byte-array string format: `utf8.encode(text).toString()`. A prior change started writing plain text and adjusted GraphQL mutations, after which Caderno de Campo stopped working. The backend/API path is expected to remain unchanged and accepts/expects the legacy string format for writes.

Home also shows `Resumo do caderno` / `HomeInfoCard.field_notes_summary`, which must present readable descriptions even when stored descriptions are legacy encoded, plain text, null, or malformed.

## Problem

`Atividade.descricao` handling is inconsistent:

- Caderno de Campo writes plain `novaDescricao.text` instead of the legacy encoded array string.
- Detail and summary UI can display raw encoded strings instead of readable text.
- `ajustes_store.montandoDescricao` currently returns `String`, but the display path still needs frontend normalization.

This breaks compatibility with the existing API behavior and degrades user-facing readability.

## Goals

- Restore legacy write behavior for activity descriptions in frontend stores.
- Normalize/decode activity descriptions for user-facing display, including Home field notes summary.
- Centralize encoding/decoding behavior in a shared frontend utility.
- Keep the change limited to frontend application behavior; no backend/API contract changes.

## Non-goals

- No backend/API contract changes.
- No schema changes.
- No broad refactor of Caderno de Campo, Home, or data layers.
- No change to unrelated activity fields or backend mutation contracts.

## Scope and non-goals

### In scope

- Add a shared codec utility for `Atividade.descricao`.
- Use the codec to write descriptions in the legacy encoded format from stores that create/update Caderno de Campo descriptions.
- Restore Flutter frontend GraphQL datasource mutations for Caderno Campo and Ajuste to the prior interpolation/request shape if needed to restore the previous working behavior.
- Use the codec to normalize descriptions before rendering in details and Home summary paths.
- Preserve support for already plain-text descriptions created during the regression window.

### Out of scope

- Changing backend parsing, API routes, or database schema.
- Changing backend/API GraphQL schema, operation semantics, or server-side mutation contracts.
- Migrating existing persisted records.
- Introducing new tests infrastructure if the repo does not already have it.

## Desired behavior and acceptance criteria

### Desired behavior

- When the user saves an activity description, the frontend sends the legacy string form produced by `utf8.encode(text).toString()`.
- When the app displays an activity description, the frontend shows readable text.
- Home `Resumo do caderno` / `HomeInfoCard.field_notes_summary` displays normalized readable descriptions.
- Plain strings remain readable and are not corrupted.
- Null, empty, malformed, or partially invalid encoded values are handled safely without UI crashes.

### Acceptance criteria

- Given description text `Observação de campo`, when saved from Caderno de Campo, the store passes `[79, 98, 115, ...]`-style legacy string output equivalent to `utf8.encode(text).toString()` to the existing datasource/mutation path.
- Given persisted description `[79, 98, 115, 101, 114, 118, 97, 195, 167, 195, 163, 111]`, UI displays `Observação`.
- Given persisted description `Observação`, UI displays `Observação` unchanged.
- Given persisted description `null`, UI displays an empty or existing fallback value without throwing.
- Given malformed description strings such as `[79, abc]`, `[999]`, or an unclosed `[79, 98`, normalization returns a safe readable fallback and does not throw.
- Home field notes summary uses normalized descriptions rather than raw encoded array strings.
- Backend/API contract, GraphQL schema, and server-side mutation semantics remain unchanged.
- If the prior assistant implementation changed the Flutter datasource mutation request shape, `caderno_campo_datasource.dart` and `ajuste_datasource.dart` are restored to the previous working client mutation behavior needed by Caderno de Campo and Ajuste.

## Technical approach and design decisions

- Implement a single shared frontend codec utility instead of duplicating parsing logic in stores, pages, or mappers.
- Restore legacy write compatibility at the frontend boundary before mutation execution.
- If current Flutter datasource mutations differ from the previous working path, restore their request shape/client mutation behavior while keeping the backend/API contract unchanged.
- Normalize display data close to mapping/rendering boundaries so UI components receive readable text.
- Treat external/persisted description values as untrusted and parse defensively.
- Prefer backward compatibility over changing API contracts because the user explicitly does not want API/backend changes.

## Data structures or interfaces involved

Shared utility functions:

```dart
String encodeAtividadeDescricao(String text)
```

- Input: user-entered plain text.
- Output: legacy encoded string using `utf8.encode(text).toString()`.
- Responsibility: preserve API-compatible write format.

```dart
String normalizeAtividadeDescricao(String? value)
```

- Input: nullable persisted/frontend description value.
- Output: safe readable text for UI.
- Must support:
  - legacy encoded array strings, e.g. `[79, 98, 115]`;
  - plain strings;
  - `null` values;
  - malformed strings without throwing.

## Target files and responsibilities

- `lib/.../caderno_campo_store.dart`
  - Encode user-entered descriptions with `encodeAtividadeDescricao` before write/update calls.

- `lib/.../ajustes_store.dart`
  - Preserve existing description assembly behavior, but ensure final activity description writes use the shared legacy encoder where applicable.

- `lib/.../caderno_campo_datasource.dart`
  - Restore the frontend GraphQL mutation request shape/client mutation behavior to the previous working path for Caderno de Campo when required to recover behavior.
  - Do not introduce backend/API/schema contract changes.

- `lib/.../ajuste_datasource.dart`
  - Restore the frontend GraphQL mutation request shape/client mutation behavior to the previous working path for Ajuste when required to recover behavior.
  - Do not introduce backend/API/schema contract changes.

- `lib/.../detalhes...dart` or relevant activity details presentation file
  - Normalize `Atividade.descricao` before display using `normalizeAtividadeDescricao`.

- `lib/.../home...` mapper/store/component path for `HomeInfoCard.field_notes_summary`
  - Normalize descriptions before building the Home field notes summary.

- New shared utility file under the existing app utility/core structure
  - Own `encodeAtividadeDescricao` and `normalizeAtividadeDescricao`.
  - No backend/API/datasource responsibility.

Exact paths should be confirmed by reading the existing project structure before implementation.

## Implementation notes

- `encodeAtividadeDescricao(String)` should be a thin wrapper around `utf8.encode(text).toString()`.
- `normalizeAtividadeDescricao(String?)` should:
  - return a safe empty string or existing UI fallback for `null`;
  - detect array-like strings only when they match a defensively parseable byte-list format;
  - parse integer bytes safely;
  - decode bytes with UTF-8 when valid;
  - return the original plain string when the value is not a valid encoded array string;
  - never throw for malformed inputs.
- Datasource updates are allowed only to restore the Flutter client request shape/mutation execution behavior that existed before the regression.
- Avoid changing backend/API contracts, GraphQL schema, or server-side mutation semantics.
- Add focused tests only if an existing compatible test pattern is already present; otherwise validate manually and with existing static checks.

## Validation commands

Run the existing validation commands available in the repo after implementation, likely:

```bash
flutter analyze
flutter test
```

If tests are unavailable or not configured, record that limitation and at minimum run `flutter analyze`.

## Open questions that need clarification

- Should `normalizeAtividadeDescricao(null)` return an empty string globally, or should each UI keep its current fallback label?
- Is there an existing utility/core folder convention that should host the codec, or should a new small domain utility file be introduced near the activity/Caderno module?
