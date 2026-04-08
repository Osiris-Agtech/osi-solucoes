# Dashboard com Navegação por Cards - Resumo das Mudanças

## O que foi alterado

### 1. `lib/features/presenter/viewmodels/home_store.dart`

**Novos observables:**
- `currentCardIndex`: índice do card atualmente visível
- `cardOrder`: lista ordenada dos tipos de cards (ex: `['lotes', 'tarefas', 'producao', 'culturas', 'saude']`)

**Novos métodos:**
- `nextCard()`: avança para o próximo card
- `previousCard()`: volta para o card anterior
- `goToCard(int index)`: vai para um card específico
- `initializeCardOrder()`: ordena os cards com o **recomendado em primeiro**
- `_mapDashboardToCard(String dashboardName)`: mapeia o nome do dashboard adaptativo para o tipo de card

**Comportamento:**
- Quando o `loadAdaptiveInterface()` completa, chama `initializeCardOrder()` para definir a ordem dos cards
- O dashboard recomendado (baseado em `adaptiveDashboard` e `dashboardConfidence`) é colocado na posição 0 da lista
- Se não há recomendado ou confiança é baixa (< 50%), usa ordem padrão: lotes → tarefas → produção → culturas → saúde

---

### 2. `lib/features/presenter/views/home/home_page.dart`

**Novas variáveis:**
- `_pageController`: controller do PageView para navegação programática

**Mudanças na UI:**
- **Antes**: `Column` com todos os 5 cards exibidos simultaneamente
- **Agora**: `PageView` com navegação por swipe + botões de seta + indicadores (dots)

**Elementos da nova interface:**
1. **Nome do card atual** (ex: "Lotes em Produção")
2. **PageView** (altura fixa de 280px) para swipe entre cards
3. **Indicadores (dots)** mostrando qual card está visível
4. **Botões de navegação** (setas esquerda/direita)

**Novo método:**
- `_buildCardByType(String cardType, HomeDashboard dashboard, Size size)`: factory que mapeia o tipo de card para o widget correspondente
- `_buildPlaceholderCard(String message)`: card fallback para quando não há dados

**Lifecycle:**
- `_initializePageController()`: cria/recria o PageController quando a ordem dos cards muda
- `dispose()`: libera o PageController

---

### 3. `lib/features/presenter/views/home/components/segmented_progress_bar.dart`

**Correção de bug:**
- `Color.tryParse()` não existe, substituído por função helper `_parseColor()`

---

## Como funciona agora

1. Ao abrir a HomePage:
   - Carrega dados do dashboard via `store.carregarHome()`
   - Carrega interface adaptativa via `store.loadAdaptiveInterface()`
   - Inicializa a ordem dos cards com recomendado em primeiro

2. O usuário pode:
   - **Swipar** horizontalmente para navegar entre cards
   - **Clicar nas setas** para avançar/voltar
   - **Ver os dots** indicando qual card está visível

3. Ordem dos cards:
   - Se há dashboard recomendado com confiança > 50%: recomendado vem primeiro
   - Caso contrário: ordem padrão (lotes → tarefas → produção → culturas → saúde)

---

## Testes manuais recomendados

1. Abrir o app e verificar se o dashboard aparece com apenas 1 card visível
2. Swipar para esquerda/direita e verificar a navegação
3. Clicar nas setas e verificar se muda o card
4. Verificar se os dots mudam conforme o card visível
5. Verificar se o nome do card no topo muda conforme a navegação
6. Se há dashboard recomendado, verificar se ele aparece em primeiro
