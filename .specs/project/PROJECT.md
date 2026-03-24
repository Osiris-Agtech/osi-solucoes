# OSI Soluções — Plataforma de Gestão de Produção Hidropônica

**Vision:** Aplicativo mobile Flutter para gestão completa de produções hidropônicas, com interface inteligente adaptativa baseada em ML que aprende o comportamento do usuário.
**For:** Produtores e equipes de gestão de fazendas hidropônicas
**Solves:** Complexidade operacional de rastreamento de lotes, setores, culturas, reservatórios e tarefas em produção hidropônica

## Goals

- Gestão completa do ciclo de vida de lotes de produção (criação → monitoramento → finalização)
- Interface adaptativa que recomenda atalhos e dashboards baseados no padrão de uso (ML via Firebase)
- Rastreamento de navegação para alimentar modelo de recomendação
- Suporte multi-conta (usuário pode operar diferentes fazendas)

## Tech Stack

**Core:**
- Framework: Flutter 3.35.0
- Language: Dart (null-safe)
- State: MobX
- Navigation: GetX named routes
- DI: GetIt

**Key dependencies:**
- Firebase (Analytics + Cloud Functions) — ML adaptativo
- GraphQL — API backend
- MobX — reatividade
- GetX — navegação + DI bootstrap

## Scope

**Funcionalidades implementadas:**
- Autenticação e multi-conta
- Módulos: Setores, Reservatórios, Caderno de Campo, Soluções Nutritivas, Ajustes
- Lotes: CRUD, migração entre setores, finalização
- Dashboard home com métricas (lotes ativos, tarefas, produção, culturas)
- Atalhos inteligentes na home (ML-driven)
- Agenda e Protocolos
- Gerenciar Equipe e Histórico

**Em desenvolvimento:**
- Correção da navegação direta via atalhos para lotes específicos

## Constraints

- Technical: Hierarquia de navegação (área → setor → lote) exige estado sequencial nos stores
- Technical: Firebase Cloud Functions necessário para ML — app funciona em modo degradado sem ele
- Platform: Android + iOS
