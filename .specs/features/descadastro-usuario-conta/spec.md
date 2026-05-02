# Spec — Descadastro de usuário por conta (Frontend `osi-solucoes`)

## Contexto

Na aplicação `osi-solucoes`, a gestão de equipe atualmente não expõe ação de **descadastro de usuário por conta** na tela de detalhes.  
Com a disponibilidade de mutation dedicada no backend, o frontend precisa incorporar essa ação de forma clara e segura, distinguindo:

- **Descadastrar da conta**: remove o usuário apenas da conta atual.
- **Inativar usuário global**: ação administrativa global (não faz parte desta feature).

A direção recomendada é adicionar botão/ação na aba de gestão de usuários para acionar a mutation específica.

---

## Goals / Non-Goals

### Goals
1. Permitir descadastro de usuário da conta atual via UI de gestão de usuários.
2. Exibir feedback claro de sucesso/erro conforme contrato do backend.
3. Atualizar lista de usuários após operação, refletindo estado real.
4. Tratar explicitamente casos de múltiplas contas, conta única, vínculo inexistente e último Dono (regra dependente).

### Non-Goals
1. Não implementar fluxo de inativação global de usuário.
2. Não alterar schema de banco (frontend não possui essa responsabilidade).
3. Não criar nova área de gestão fora da tela/aba já existente.
4. Não introduzir padrões novos de estado/arquitetura sem necessidade.

---

## Escopo funcional

1. Adicionar ação “Descadastrar da conta” na aba de gestão de usuários (tela de detalhes).
2. Exigir confirmação do usuário operador antes de efetivar remoção.
3. Chamar mutation dedicada do backend com `contaId` e `usuarioId`.
4. Exibir retorno:
   - sucesso de remoção;
   - vínculo inexistente (estado já atualizado);
   - bloqueio por regra de negócio (ex.: último Dono);
   - falhas de permissão/erro técnico.
5. Atualizar listagem de usuários da conta após operação concluída.

---

## Abordagem técnica

### Decisões de UI/fluxo
1. Inserir ação contextual por usuário na lista de gestão (botão/menu de ação).
2. Confirm dialog obrigatório com texto explícito: remoção da **conta atual**, não inativação global.
3. Após resposta da mutation, invalidar/recarregar fonte de dados da lista.

### Decisão de consistência
- A UI confiará no resultado da mutation e fará refresh para evitar divergência local.
- Sem suposições de transaction no backend; frontend deve lidar com respostas de corrida/concorrência de forma amigável (mensagem + refresh).

### Mensageria sugerida
- Sucesso: “Usuário descadastrado desta conta.”
- Vínculo inexistente: “Usuário já não está vinculado a esta conta.”
- Último Dono bloqueado: “Não é possível remover o último Dono da conta.”
- Permissão negada: “Você não tem permissão para esta ação.”

---

## Estruturas/interfaces

> Estruturas conceituais para alinhar integração; nomes finais seguem contratos reais.

### Ação de UI
- `onDescadastrarUsuario(contaId, usuarioId)`

### Integração GraphQL
- Mutation dedicada de descadastro por conta (definida no `isis`).
- Payload esperado com status semântico (`REMOVIDO`, `VINCULO_INEXISTENTE`, `BLOQUEADO_REGRA_NEGOCIO`, etc.).

### Estado de tela
- `isSubmitting` por item/ação para evitar clique duplo.
- `feedback` (toast/alerta contextual).
- `listaUsuarios` atualizada via refetch/invalidação.

---

## Critérios de aceite (WHEN / THEN)

1. **Usuário com múltiplas contas**
   - **WHEN** operador descadastra usuário da conta atual  
   - **THEN** a lista da conta atual remove o usuário e não comunica inativação global.

2. **Usuário com conta única**
   - **WHEN** operador descadastra usuário que só estava nesta conta  
   - **THEN** o usuário sai da lista da conta e a UI não indica exclusão global do usuário.

3. **Vínculo inexistente**
   - **WHEN** backend retorna vínculo inexistente  
   - **THEN** UI mostra mensagem informativa e mantém lista consistente após refresh.

4. **Tentativa de remover último Dono**
   - **WHEN** backend bloquear remoção por regra de último Dono  
   - **THEN** UI exibe erro de negócio claro e não remove usuário da lista.

5. **Atualização da lista no frontend**
   - **WHEN** mutation finaliza (sucesso ou estado idempotente)  
   - **THEN** a lista de usuários da conta é atualizada para refletir o estado mais recente do backend.

---

## Edge cases

1. Clique duplo na ação de descadastro (deve bloquear envio concorrente na UI).
2. Usuário removido por outro operador durante fluxo de confirmação.
3. Erro de rede após confirmação (exibir erro e permitir retry seguro).
4. Sessão expirada/permissão alterada entre carregamento da tela e ação.
5. Latência alta: manter indicador de carregamento e prevenir ações conflitantes.

---

## Open questions

1. A ação deve ficar visível para todos os perfis administrativos ou somente Dono?
2. O bloqueio de “último Dono” será regra definitiva no backend?
3. Em `VINCULO_INEXISTENTE`, UX prefere toast neutro, sucesso silencioso, ou aviso explícito?
4. É necessário capturar motivo de descadastro no frontend (campo opcional)? (fora do escopo atual)
5. Deve haver filtro/auditoria visual de “removidos recentemente” na tela? (provável fora de escopo)

---

## Rastreabilidade

- Problema identificado: ausência de ação de descadastro por conta na gestão de equipe.
- Dependência funcional: mutation dedicada no backend `isis`.
- Decisão de produto/técnica:
  - ação localizada na aba de gestão de usuários;
  - distinção explícita entre descadastro por conta e inativação global;
  - atualização de lista pós-operação para consistência.

---

## Dependências / impacto

### Dependências
1. Mutation de descadastro disponível e estável no `isis`.
2. Contrato de status/erros alinhado entre backend e frontend.
3. Permissões de gestão de usuários já existentes na aplicação.

### Impacto
1. Mudança de UX na tela de detalhes (gestão de usuários).
2. Ajustes de integração GraphQL e estado da lista.
3. Potencial necessidade de texto legal/operacional de confirmação validado por produto.

### Limites deste escopo
- Sem criação de fluxo de inativação global.
- Sem mudanças estruturais de backend/schema.
- Sem novos módulos de auditoria além do feedback operacional na UI.
