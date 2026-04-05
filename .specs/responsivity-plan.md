# 📱 Planejamento de Responsividade - OSI Soluções

## 📊 Análise Atual do Projeto

### Contexto
- **Framework**: Flutter com GetX (roteamento) + MobX (estado)
- **Foco original**: Mobile Android (smartphones)
- **Objetivo atual**: Suporte responsivo para **Mobile Android** + **Web (Desktop e Mobile)**
- **Total de arquivos Dart**: ~379 arquivos
- **Telas principais**: ~48 páginas + ~95 componentes

---

## 🔍 Problemas Identificados

### 1. **Uso Excessivo de Proporções Fixas com MediaQuery** (CRÍTICO)
**Ocorrências**: 226 usos de `MediaQuery.of(context).size`

**Problema**: O app usa multiplicadores fracionários hardcoded que funcionam bem em smartphones, mas quebram em telas grandes:
```dart
// Exemplo atual (resultadoajuste_page.dart)
width: MediaQuery.of(context).size.width * .69,
padding: EdgeInsets.only(left: size.width * 0.05),
height: size.height * 0.9,
```

**Impacto**:
- ✅ Funciona em smartphones (360px - 420px width)
- ❌ Elementos ficam enormes em tablets (600px - 800px)
- ❌ Elementos minúsculos em desktop (1280px+)
- ❌ BottomNavigationBar com 6 itens fica apertado em telas pequenas
- ❌ Modais com `height * 0.9` desperdiçam espaço em telas grandes

---

### 2. **Ausência de Breakpoints e Detecção de Plataforma** (CRÍTICO)

**Problema**: Não há nenhuma lógica que diferencie:
- 📱 Smartphone (< 600px)
- 📱 Tablet (600px - 1024px)
- 💻 Desktop (> 1024px)
- 🌐 Web vs 📱 Mobile (para comportamentos específicos)

**Impacto**:
- Mesma UI para todos os dispositivos
- Não aproveita espaço extra em desktop/web
- Navegação mobile (bottom bar) não faz sentido em desktop

---

### 3. **BottomNavigationBar com 6 Itens** (ALTO)

**Problema**: `ModulosPage` usa `BottomNavigationBar` com 6 itens:
```dart
BottomNavigationBar(
  items: [
    Cultivos,
    Reservatórios,
    Cadernos de Campo,  // label com quebra de linha!
    Soluções,
    Relatórios,
    Ajustes,
  ],
)
```

**Impacto**:
- ✅ Aceitável em telas > 400px
- ❌ Labels truncados em telas pequenas (< 360px)
- ❌ Não escala para desktop (deveria ser NavigationRail ou menu lateral)
- ❌ Label "Cadernos de\n     Campo" com quebra manual é sintoma de problema de espaço

---

### 4. **Home Page com 2085 Linhas** (ALTO)

**Problema**: `home_page.dart` tem 2085 linhas de código com:
- Menu lateral animado com cálculos manuais (`width * 0.76`)
- Dashboard com carousel
- Múltiplos widgets de gráficos
- Lógica de interface adaptativa (ML)

**Impacto**:
- Difícil manutenção e testes
- Layout não adapta para desktop (poderia ter sidebar + conteúdo lado a lado)
- Gráficos podem ficar distorcidos em telas grandes

---

### 5. **Modais e BottomSheets com Tamanhos Fixos** (MÉDIO)

**Problema**: BottomSheets usam proporções que não consideram conteúdo:
```dart
// cadastrar_lote_page.dart
height: MediaQuery.of(context).size.height * 0.9,

// componentes caderno_campo
height: MediaQuery.of(context).size.height * 0.9 - 140,
```

**Impacto**:
- Desperdício de espaço em telas grandes
- Pode cortar conteúdo em telas com notch/status bar diferente
- Não considera conteúdo dinâmico (listas longas)

---

### 6. **Padding e Espaçamentos Inconsistente** (MÉDIO)

**Problema**: 
- Constante `kDefaultPadding = 20.0` existe, mas nem sempre é usado
- Muitos usos de `width * 0.04`, `width * 0.05`, `width * 0.069` (valores específicos demais)
- Sem sistema de espaçamento responsivo

**Exemplos encontrados**:
```dart
// diferentes arquivos, diferentes abordagens
padding: EdgeInsets.symmetric(horizontal: size.width * 0.04)
padding: EdgeInsets.only(left: size.width * 0.05)
padding: EdgeInsets.only(left: size.width * 0.06)
```

---

### 7. **Falta de LayoutBuilder e Widgets Responsivos** (MÉDIO)

**Problema**: 
- **ZERO** uso de `LayoutBuilder` no código de produção
- **ZERO** uso de `OrientationBuilder` (exceto date picker de terceiro)
- **ZERO** uso de pacotes de responsividade

**Impacto**:
- Impossível adaptar layout baseado no espaço disponível
- Widgets não sabem se estão em coluna, linha, tela cheia, etc.

---

### 8. **Formulários e Inputs Não Responsivos** (MÉDIO)

**Problema**: Campos de formulário com larguras fixas ou proporcionais:
- Não adaptam para layout multi-coluna em telas grandes
- Dropdowns e date pickers podem ficar enormes em desktop
- Validações visuais podem quebrar

---

### 9. **Gráficos e Charts** (BAIXO)

**Problema**: Uso de `fl_chart` sem considerar tamanho do container:
- Gráfico de pizza pode ficar gigante em desktop
- Gráficos de barra podem precisar de scroll em mobile
- Sem legendas adaptativas

---

### 10. **Navegação Web Não Otimizada** (BAIXO)

**Problema**: Navegação foi pensada para toque (mobile):
- Sem suporte a keyboard shortcuts (web)
- Sem hover effects (web)
- Sem deep linking otimizado para web
- Rotas podem não funcionar bem com URL no navegador

---

## 🎯 Objetivos de Responsividade

### Dispositivos Alvo

| Dispositivo | Largura | Altura | Prioridade |
|-------------|---------|--------|------------|
| Smartphone S | 360px | 640px | ⭐⭐⭐ |
| Smartphone M | 375px - 414px | 667px - 896px | ⭐⭐⭐ |
| Smartphone L | 414px+ | 896px+ | ⭐⭐⭐ |
| Tablet | 600px - 1024px | 800px - 1366px | ⭐⭐ |
| Desktop Web | 1024px - 1920px+ | 768px - 1080px+ | ⭐⭐⭐ |
| Mobile Web | 360px - 414px | 640px - 896px | ⭐⭐⭐ |

---

## 📋 Plano de Melhorias

### **FASE 1: Fundação Responsiva** (Prioridade: CRÍTICA)

#### 1.1 Instalar e Configurar Pacote de Responsividade
**Pacote recomendado**: `flutter_screenutil` ou `sizer`

**Por que `sizer`**:
- ✅ Mais simples de migrar
- ✅ Usa porcentagens e breakpoints nativamente
- ✅ Menos invasivo que `flutter_screenutil`
- ✅ Funciona bem para web e mobile

**Alternativa**: Criar utilitário próprio (mais trabalho, mais controle)

```yaml
# pubspec.yaml
dependencies:
  sizer: ^3.0.0
  responsive_framework: ^1.1.0  # Para breakpoints automáticos
```

#### 1.2 Criar Sistema de Breakpoints Global
```dart
// lib/core/utils/responsive_utils.dart

class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobile &&
      MediaQuery.of(context).size.width < tablet;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tablet;

  static bool isWeb(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobile;

  static double responsiveWidth(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktop ?? tablet ?? mobile) {
      return desktop ?? tablet ?? mobile;
    } else if (width >= tablet ?? mobile) {
      return tablet ?? mobile;
    }
    return mobile;
  }

  static EdgeInsets responsivePadding(
    BuildContext context, {
    double mobile = 16.0,
    double tablet = 32.0,
    double desktop = 48.0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: responsiveWidth(
        context,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      ),
    );
  }
}
```

#### 1.3 Criar Widget ResponsiveWrapper
```dart
// lib/core/widgets/responsive_layout.dart

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= ResponsiveBreakpoints.desktop) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= ResponsiveBreakpoints.tablet) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}
```

---

### **FASE 2: Refatorar Navegação Principal** (Prioridade: ALTA)

#### 2.1 Adaptar ModulosPage para Multi-Plataforma

**Mobile (< 600px)**: Manter `BottomNavigationBar`
**Tablet/Desktop (>= 600px)**: Usar `NavigationRail` ou menu lateral

```dart
// lib/features/presenter/views/modulos/modulos_page.dart

class ModulosPageState extends State<ModulosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // NavigationRail para tablet/desktop
          if (!ResponsiveBreakpoints.isMobile(context))
            NavigationRail(
              selectedIndex: store.pageviewController,
              onDestinationSelected: (index) => store.setPageViewController(index),
              labelType: NavigationRailLabelType.all,
              destinations: _buildRailDestinations(),
            ),
          
          // Conteúdo principal
          Expanded(
            child: _getBody(),
          ),
        ],
      ),
      // BottomNavigationBar apenas para mobile
      bottomNavigationBar: ResponsiveBreakpoints.isMobile(context)
          ? _buildBottomBar()
          : null,
    );
  }
}
```

#### 2.2 Otimizar Labels da BottomNavigationBar

**Problema atual**: "Cadernos de\n     Campo" com quebra manual

**Solução**:
```dart
BottomNavigationBarItem(
  icon: SvgPicture.asset("assets/icons/caderno_campo_icon.svg", height: 24, width: 24),
  label: 'Caderno Campo',  // Remover "de"
)
```

Ou usar `NavigationDestination` (Material 3) que gerencia melhor espaços.

---

### **FASE 3: Refatorar HomePage** (Prioridade: ALTA)

#### 3.1 Dividir HomePage em Widgets Menores

**Estrutura atual**: 2085 linhas em um único arquivo

**Estrutura proposta**:
```
home/
├── home_page.dart (150 linhas - scaffold principal)
├── home_layout_mobile.dart (400 linhas)
├── home_layout_desktop.dart (400 linhas)
├── widgets/
│   ├── home_header.dart
│   ├── dashboard_carousel.dart
│   ├── metrics_grid.dart
│   ├── charts_section.dart
│   └── quick_actions.dart
```

#### 3.2 Layout Adaptativo para HomePage

**Mobile**:
```
[Header com saudação]
[Carousel de métricas - vertical scroll]
[Gráfico 1]
[Gráfico 2]
[Quick Actions]
```

**Desktop**:
```
[Header] | [Quick Actions Sidebar]
----------------------------------
[Carousel] | [Gráfico 1] [Gráfico 2]
----------------------------------
[Métricas em Grid 3 colunas]
```

```dart
// Exemplo simplificado
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobile: HomeMobileLayout(),
        tablet: HomeTabletLayout(),
        desktop: HomeDesktopLayout(),
      ),
    );
  }
}
```

---

### **FASE 4: Refatorar Formulários e Modais** (Prioridade: ALTA)

#### 4.1 Sistema de Modais Responsivos

**Atual**:
```dart
height: MediaQuery.of(context).size.height * 0.9,
```

**Novo**:
```dart
// lib/core/widgets/responsive_modal.dart

class ResponsiveModal extends StatelessWidget {
  final Widget child;
  final double? mobileMaxWidth;
  final double? tabletMaxWidth;
  final double? desktopMaxWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: ResponsiveBreakpoints.responsiveWidth(
          context,
          mobile: mobileMaxWidth ?? double.infinity,
          tablet: tabletMaxWidth ?? 600,
          desktop: desktopMaxWidth ?? 800,
        ),
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: SingleChildScrollView(  // Sempre permitir scroll se necessário
        child: child,
      ),
    );
  }
}
```

#### 4.2 Formulários Multi-Coluna para Desktop

**Mobile**: Uma coluna
**Desktop**: Duas ou três colunas

```dart
class ResponsiveForm extends StatelessWidget {
  final List<Widget> fields;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        if (constraints.maxWidth >= 1024) crossAxisCount = 3;
        else if (constraints.maxWidth >= 600) crossAxisCount = 2;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: fields,
        );
      },
    );
  }
}
```

---

### **FASE 5: Otimizações Específicas por Plataforma** (Prioridade: MÉDIA)

#### 5.1 Detecção de Plataforma

```dart
// lib/core/utils/platform_detector.dart

class PlatformDetector {
  static bool get isWeb => kIsWeb;
  static bool get isMobile => !isWeb && (Platform.isAndroid || Platform.isIOS);
  static bool get isDesktop => !isWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
  static bool get isAndroid => Platform.isAndroid;
  static bool get isIOS => Platform.isIOS;
}
```

#### 5.2 Adaptações Específicas para Web

```dart
// Habilitar hover effects apenas em web/desktop
MouseRegion(
  cursor: PlatformDetector.isWeb ? SystemMouseCursors.click : MouseCursor.defer,
  child: GestureDetector(
    onTap: () => ...,
    child: Container(
      // Hover effect apenas web
      decoration: BoxDecoration(
        color: _isHovering && PlatformDetector.isWeb 
            ? Colors.grey.shade100 
            : Colors.white,
      ),
    ),
  ),
)
```

#### 5.3 Keyboard Shortcuts para Web

```dart
// Adicionar atalhos de teclado
Shortcuts(
  shortcuts: {
    LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS): 
        ActivateIntent(),
  },
  child: Actions(
    actions: {
      ActivateIntent: CallbackAction<ActivateIntent>(
        onInvoke: (_) => salvarFormulario(),
      ),
    },
    child: MyApp(),
  ),
)
```

---

### **FASE 6: Otimizações de UI/UX** (Prioridade: MÉDIA)

#### 6.1 Sistema de Espaçamento Consistente

Substituir todos os `width * 0.04`, `width * 0.05`, etc. por:

```dart
// lib/core/utils/spacing.dart

class Spacing {
  static double xs = 4.0;
  static double sm = 8.0;
  static double md = 16.0;
  static double lg = 24.0;
  static double xl = 32.0;
  static double xxl = 48.0;

  static EdgeInsets horizontal(BuildContext context, {double? custom}) {
    final isMobile = ResponsiveBreakpoints.isMobile(context);
    return EdgeInsets.symmetric(
      horizontal: custom ?? (isMobile ? md : lg),
    );
  }

  static EdgeInsets vertical({double size = md}) {
    return EdgeInsets.symmetric(vertical: size);
  }

  static EdgeInsets all({double size = md}) {
    return EdgeInsets.all(size);
  }
}
```

#### 6.2 Gráficos Responsivos

```dart
// Envolver gráficos com LayoutBuilder
LayoutBuilder(
  builder: (context, constraints) {
    final isSmall = constraints.maxWidth < 400;
    final isLarge = constraints.maxWidth > 800;

    return SizedBox(
      height: isSmall ? 200 : 300,
      child: LineChart(
        LineChartData(
          // Ajustar propriedades baseado no tamanho
          titlesData: FlTitlesData(
            show: !isSmall,  // Esconder títulos em telas muito pequenas
          ),
        ),
      ),
    );
  },
)
```

#### 6.3 Tabelas e Listas Responsivas

**Mobile**: Lista vertical com cards
**Desktop**: Tabela com colunas

```dart
ResponsiveDataTable(
  mobile: ListView.builder(...),
  desktop: DataTable(
    columns: [...],
    rows: [...],
  ),
)
```

---

### **FASE 7: Testes e Validação** (Prioridade: ALTA)

#### 7.1 Matriz de Testes

| Tela | Chrome | Firefox | Safari | Android | iOS |
|------|--------|---------|--------|---------|-----|
| 360x640 | ✅ | ✅ | ❌ | ✅ | ❌ |
| 375x667 | ✅ | ✅ | ❌ | ✅ | ❌ |
| 414x896 | ✅ | ✅ | ❌ | ✅ | ❌ |
| 768x1024 | ✅ | ✅ | ❌ | ❌ | ❌ |
| 1024x768 | ✅ | ✅ | ❌ | ❌ | ❌ |
| 1280x720 | ✅ | ✅ | ❌ | ❌ | ❌ |
| 1440x900 | ✅ | ✅ | ❌ | ❌ | ❌ |
| 1920x1080 | ✅ | ✅ | ❌ | ❌ | ❌ |

#### 7.2 Device Preview (Ferramenta de Teste)

```yaml
dev_dependencies:
  device_preview: ^1.1.0
```

```dart
// main.dart
void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(),
    ),
  );
}
```

---

## 📦 Dependências Recomendadas

```yaml
dependencies:
  # Responsividade
  sizer: ^3.0.0                           # Unidades responsivas (vw, vh, etc.)
  responsive_framework: ^1.1.0            # Breakpoints e auto-scaling
  
  # Web otimizações
  url_strategy: ^0.3.0                    # Remover # das URLs web
  flutter_web_plugins:                    # SDK (deep linking)
    sdk: flutter

dev_dependencies:
  device_preview: ^1.1.0                  # Testar múltiplos dispositivos
```

---

## 🗺️ Roadmap Sugerido

### **Sprint 1-2: Fundação**
- [ ] Instalar pacotes de responsividade
- [ ] Criar `ResponsiveBreakpoints` utilitário
- [ ] Criar `ResponsiveLayout` widget
- [ ] Configurar `DevicePreview` para testes
- [ ] Refatorar 2-3 telas simples como piloto

### **Sprint 3-4: Navegação**
- [ ] Refatorar `ModulosPage` para multi-plataforma
- [ ] Implementar `NavigationRail` para desktop
- [ ] Otimizar labels e ícones
- [ ] Testar em 3 resoluções diferentes

### **Sprint 5-6: HomePage**
- [ ] Dividir `home_page.dart` em widgets menores
- [ ] Criar layouts mobile/tablet/desktop
- [ ] Adaptar gráficos para responsivos
- [ ] Otimizar carousel de dashboard

### **Sprint 7-8: Formulários e Modais**
- [ ] Criar sistema de modal responsivo
- [ ] Refatorar formulários para multi-coluna (desktop)
- [ ] Padronizar espaçamentos
- [ ] Testar em mobile e web

### **Sprint 9-10: Refatoração em Massa**
- [ ] Aplicar padrão em todas as 48 telas
- [ ] Priorizar telas mais acessadas primeiro
- [ ] Criar documentação de padrões
- [ ] Code review de responsividade

### **Sprint 11-12: Polimento**
- [ ] Adicionar hover effects (web)
- [ ] Keyboard shortcuts
- [ ] Otimizar performance
- [ ] Testes em dispositivos reais
- [ ] Corrigir bugs de responsividade

---

## ⚠️ Riscos e Mitigações

| Risco | Impacto | Mitigação |
|-------|---------|-----------|
| Regressão em mobile existente | ALTO | Manter mobile como padrão, testar constantemente |
| Complexidade da migração | MÉDIO | Fazer gradual, tela por tela |
| Performance em web | BAIXO | Usar const, evitar rebuilds desnecessários |
| Tempo de implementação | ALTO | Priorizar telas críticas primeiro |
| Conflitos com MobX/GetX | BAIXO | Responsividade é apenas UI, não afeta estado |

---

## 📐 Padrões de Código a Seguir

### ✅ FAZER
```dart
// Usar LayoutBuilder
LayoutBuilder(
  builder: (context, constraints) {
    final isMobile = constraints.maxWidth < 600;
    return isMobile ? MobileWidget() : DesktopWidget();
  },
)

// Usar constantes responsivas
padding: ResponsiveBreakpoints.responsivePadding(context)

// Widgets responsivos por natureza
Expanded(
  child: MyWidget(),
  flex: isDesktop ? 2 : 1,
)
```

### ❌ NÃO FAZER
```dart
// Multiplicadores mágicos
width: MediaQuery.of(context).size.width * 0.069

// Hardcoded values
if (width > 1200) // Use breakpoints em vez de números soltos

// Ignorar constraints do parent
Container(
  width: 800, // Pode ser maior que tela!
)

// Assumir orientação
// Sempre verificar OrientationBuilder
```

---

## 🎓 Referências

- [Flutter Responsive Documentation](https://docs.flutter.dev/development/ui/layout/responsive)
- [Responsive Web App](https://docs.flutter.dev/ui/layout/responsive)
- [Material Design Responsive Layout](https://m3.material.io/foundations/layout/applying-layout)
- [Flutter Web Best Practices](https://docs.flutter.dev/platform-integration/web/best-practices)

---

## 📝 Notas Finais

1. **Migração gradual**: Não é necessário refatorar tudo de uma vez. Comece pelas telas mais críticas.
2. **Mobile-first**: Sempre mantenha a versão mobile funcionando perfeitamente.
3. **Teste constante**: Use `device_preview` durante desenvolvimento.
4. **Documentação**: Crie um guia de padrões de responsividade para a equipe.
5. **Performance**: Web e mobile têm características diferentes de performance.

---

**Criado em**: 5 de abril de 2026  
**Versão**: 1.0  
**Status**: Aguardando aprovação para implementação
