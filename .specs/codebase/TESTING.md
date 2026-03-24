# Testing Infrastructure

## Test Frameworks

**Unit/Integration:** flutter_test (SDK built-in)
**Mocking:** mockito ^5.5.1
**Modular:** modular_test ^2.0.0

## Test Organization

**Location:** `test/` (diretório padrão Flutter)
**Naming:** `*_test.dart`
**Structure:** Não identificada estrutura elaborada de testes — projeto em fase de desenvolvimento

## Testing Patterns

### Unit Tests

**Approach:** Padrão Flutter/Dart com `flutter_test`
**Mocking:** `mockito` para datasources/repositories
**Coverage:** Sem configuração de cobertura identificada

### Integration / E2E

Não identificado uso de integration_test ou ferramentas de E2E no projeto.

## Test Execution

```bash
flutter test
```

## Coverage Targets

**Current:** Não mensurado
**Goals:** Não documentado
**Enforcement:** Não automatizado

> **Nota:** O projeto está em desenvolvimento ativo — a cobertura de testes é baixa. Prioridade identificada como dívida técnica (ver CONCERNS.md).
