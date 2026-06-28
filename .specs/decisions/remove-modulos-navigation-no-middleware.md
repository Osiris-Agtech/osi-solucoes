# Decisão: remover `ModulosPage` sem middleware de compatibilidade

## Decisão

Remover a navegação por `ModulosPage` diretamente, substituindo chamadas por rotas finais explícitas e removendo `Routes.modulosPage`, `ModulosPage` e `ModulosStore` quando não houver referências. Não criar middleware, guard ou redirecionador para manter `/modulosPage` funcionando.

## Motivo

A Home adaptativa já é o hub canônico. Manter um redirecionamento para o container antigo preservaria acoplamento, esconderia chamadas legadas e continuaria competindo com recomendações/dashboard. Rotas finais explícitas tornam a navegação auditável e removem a dependência de índices do `IndexedStack`.

## Descartados

- **Manter `ModulosPage` como fallback**: descartado porque perpetua a segunda camada de hub.
- **Criar middleware de redirect para `/modulosPage`**: descartado porque a feature exige não adicionar middlewares novos e porque esconderia usos legados.
- **Migrar navegação por índice para outro container**: descartado porque o objetivo é remover o container, não recriá-lo com outra forma.
