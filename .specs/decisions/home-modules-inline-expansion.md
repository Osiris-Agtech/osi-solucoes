# Decisão: expansão inline do card “Módulos principais”

## Decisão

O botão “Ver todos” do card “Módulos principais” deve expandir inline o próprio card na Home, sem navegar para `Routes.modulosPage` e sem chamar `Get.toNamed` nesse clique. No estado expandido, o botão deve mudar para “Ver menos” e recolher o card para o estado compacto.

A seção deve exibir 6 módulos no estado compacto e 10 módulos no estado expandido. A lista final permitida é: Cultivos/Áreas, Reservatórios, Caderno de Campo, Soluções Nutritivas, Relatórios, Ajustes, Gestão de equipe, Agenda, Protocolos e Histórico.

Setores e Lotes devem ser excluídos somente da seção “Módulos principais”, porque exigem contexto/id de área. Essa exclusão não altera ações recomendadas adaptativas nem outros atalhos fora do card de módulos.

## Motivo

A Home deve manter a navegação por módulos como acesso secundário e rápido, sem deslocar o usuário para uma tela geral apenas para descobrir mais opções. A expansão inline reduz troca de contexto, preserva a hierarquia da Home diária e evita expor Setores/Lotes sem o contexto de área necessário.

Separar a regra da seção “Módulos principais” das ações recomendadas adaptativas evita regressão no sistema adaptativo existente, que deve continuar preservado conforme a decisão arquitetural da Home diária.

## Descartados

- **Navegar para `Routes.modulosPage` ao clicar em “Ver todos”**: descartado porque o comportamento desejado é expansão inline do próprio card.
- **Manter Setores e Lotes na lista de módulos da Home**: descartado porque esses destinos dependem de contexto/id de área e podem gerar navegação incompleta ou ambígua.
- **Aplicar o filtro de Setores/Lotes às ações recomendadas adaptativas**: descartado porque a decisão vale apenas para a seção “Módulos principais” e não deve alterar o sistema adaptativo.
