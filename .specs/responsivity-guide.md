# 📖 Guia de Uso - Componentes de Responsividade

## 🚀 O que foi implementado

### Fase 1 Completa ✅
Infraestrutura base para tornar o app responsivo para **mobile**, **tablet** e **web/desktop**.

---

## 📦 Componentes Criados

### 1. **ResponsiveBreakpoints** (`lib/core/utils/responsive_breakpoints.dart`)

Utilitário para detectar tipo de dispositivo e breakpoints.

#### Métodos Principais:

```dart
// Detecção de dispositivo
ResponsiveBreakpoints.isMobile(context)    // true se < 600px
ResponsiveBreakpoints.isTablet(context)    // true se 600-1024px
ResponsiveBreakpoints.isDesktop(context)   // true se >= 1024px
ResponsiveBreakpoints.isWeb              // true se estiver no navegador

// Tamanhos responsivos
ResponsiveBreakpoints.responsiveWidth(
  context,
  mobile: 200,
  tablet: 300,
  desktop: 400,
)

// Padding responsivo
ResponsiveBreakpoints.responsivePadding(context)
// Retorna: 16px (mobile), 24px (tablet), 32px (desktop)

// Outras funções úteis
ResponsiveBreakpoints.gridColumns(context)        // 1, 2 ou 3 colunas
ResponsiveBreakpoints.modalMaxWidth(context)     // Largura máxima para modais
ResponsiveBreakpoints.shouldShowSidebar(context) // true se >= 600px
ResponsiveBreakpoints.canShowSideBySide(context) // true se >= 900px
```

#### Exemplo de Uso:

```dart
Widget build(BuildContext context) {
  if (ResponsiveBreakpoints.isDesktop(context)) {
    return DesktopWidget();
  } else if (ResponsiveBreakpoints.isTablet(context)) {
    return TabletWidget();
  } else {
    return MobileWidget();
  }
}
```

---

### 2. **ResponsiveLayout** (`lib/core/widgets/responsive_layout.dart`)

Widget que renderiza layouts diferentes baseado no breakpoint.

#### Uso Básico:

```dart
ResponsiveLayout(
  mobile: MobileWidget(),
  tablet: TabletWidget(),      // opcional
  desktop: DesktopWidget(),    // opcional
)
```

#### Versão Simplificada:

```dart
ResponsiveLayoutSimple(
  mobile: MobileWidget(),
  desktop: DesktopWidget(),
)
```

#### Versão Customizada:

```dart
ResponsiveLayoutCustom(
  small: SmallWidget(),
  medium: MediumWidget(),     // opcional
  large: LargeWidget(),       // opcional
  breakpointSmall: 500,       // customizado
  breakpointLarge: 900,       // customizado
)
```

---

### 3. **Spacing** (`lib/core/utils/spacing.dart`)

Sistema de espaçamento responsivo. Substitui valores hardcoded.

#### Constantes:

```dart
Spacing.xs   // 4px
Spacing.sm   // 8px
Spacing.md   // 16px
Spacing.lg   // 24px
Spacing.xl   // 32px
Spacing.xxl  // 48px
Spacing.xxxl // 64px
```

#### Métodos de EdgeInsets:

```dart
// Padding horizontal responsivo
Spacing.horizontal(context)

// Padding completo responsivo
Spacing.all(context)

// EdgeInsets específicos
Spacing.top(size: Spacing.lg)
Spacing.bottom(size: Spacing.md)
Spacing.symmetricH(size: Spacing.xl)
Spacing.symmetricV(size: Spacing.lg)
Spacing.symmetric(horizontal: 16, vertical: 24)
```

#### SizedBox Helpers:

```dart
// Espaçador vertical
Spacing.v(16)           // SizedBox(height: 16)
Spacing.vResponsive(context)  // Altura responsiva

// Espaçador horizontal
Spacing.h(16)           // SizedBox(width: 16)
Spacing.hResponsive(context)  // Largura responsiva
```

#### Exemplo de Uso:

```dart
// ❌ ANTES (não responsivo)
Padding(
  padding: EdgeInsets.only(left: size.width * 0.06, right: size.width * 0.06),
  child: MyWidget(),
)

// ✅ DEPOIS (responsivo)
Padding(
  padding: Spacing.horizontal(context),
  child: MyWidget(),
)
```

```dart
// Espaçamento entre widgets
Column(
  children: [
    Widget1(),
    Spacing.v(Spacing.lg),  // 24px de espaço
    Widget2(),
    Spacing.vResponsive(context),  // Espaço responsivo
    Widget3(),
  ],
)
```

---

### 4. **ResponsiveModal** (`lib/core/widgets/responsive_modal.dart`)

Modais que adaptam tamanho baseado no dispositivo.

#### Uso Básico:

```dart
ResponsiveModal.show(
  context: context,
  child: MeuConteudo(),
  title: 'Título do Modal',
);
```

#### Modal de Confirmação:

```dart
ResponsiveModal.showConfirm(
  context: context,
  title: 'Confirmar Ação',
  message: 'Tem certeza que deseja excluir?',
  onConfirm: () {
    // Ação de confirmação
  },
  confirmText: 'Excluir',
  cancelText: 'Cancelar',
);
```

#### Exemplo dentro de bottom sheet customizado:

```dart
// ❌ ANTES (tamanho fixo)
Get.bottomSheet(
  Container(
    height: MediaQuery.of(context).size.height * 0.9,
    child: MeuConteudo(),
  ),
)

// ✅ DEPOIS (responsivo)
ResponsiveModal.show(
  context: context,
  child: MeuConteudo(),
  title: 'Título',
)
```

---

## 🎯 Exemplos Práticos de Migração

### Exemplo 1: Tela de Login

```dart
// ❌ ANTES
var size = MediaQuery.of(context).size;
return Padding(
  padding: EdgeInsets.only(left: size.width * 0.06, right: size.width * 0.06),
  child: Column(
    children: [
      SizedBox(height: size.height * 0.1),
      Image.asset("logo.png", width: size.width * 0.42),
    ],
  ),
);

// ✅ DEPOIS
return LayoutBuilder(
  builder: (context, constraints) {
    final isDesktop = ResponsiveBreakpoints.isDesktop(context);
    final maxWidth = isDesktop ? 450.0 : double.infinity;
    
    return Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: Spacing.horizontal(context),
            child: Column(
              children: [
                Spacing.v(constraints.maxHeight * 0.08),
                Image.asset(
                  "logo.png",
                  width: ResponsiveBreakpoints.responsiveWidth(
                    context,
                    mobile: MediaQuery.of(context).size.width * 0.42,
                    tablet: 200,
                    desktop: 220,
                  ),
                ),
                Spacing.vResponsive(context),
                // ... mais campos
              ],
            ),
          ),
        ),
      ),
    );
  },
);
```

### Exemplo 2: Navegação Principal

```dart
// ❌ ANTES (apenas bottom navigation)
Scaffold(
  body: Conteudo(),
  bottomNavigationBar: BottomNavigationBar(...),
)

// ✅ DEPOIS (adaptativo)
Scaffold(
  body: ResponsiveBreakpoints.isDesktop(context) || ResponsiveBreakpoints.isTablet(context)
      ? Row(
          children: [
            NavigationRail(...),  // Menu lateral
            Expanded(child: Conteudo()),
          ],
        )
      : Conteudo(),
  bottomNavigationBar: ResponsiveBreakpoints.isMobile(context)
      ? BottomNavigationBar(...)  // Apenas em mobile
      : null,
)
```

### Exemplo 3: Grid Responsivo

```dart
// ❌ ANTES (coluna fixa)
ListView.builder(
  itemBuilder: (context, index) => CardItem(),
)

// ✅ DEPOIS (grid adaptativo)
LayoutBuilder(
  builder: (context, constraints) {
    final columns = ResponsiveBreakpoints.gridColumns(context);
    
    return GridView.count(
      crossAxisCount: columns,  // 1 (mobile), 2 (tablet), 3 (desktop)
      crossAxisSpacing: Spacing.md,
      mainAxisSpacing: Spacing.md,
      children: items.map((item) => CardItem(item: item)).toList(),
    );
  },
)
```

---

## 📝 Checklist de Migração de Tela

Quando for refatorar uma tela, siga este checklist:

- [ ] Substituir `MediaQuery.of(context).size.width * X` por `ResponsiveBreakpoints.responsiveWidth()`
- [ ] Substituir `MediaQuery.of(context).size.height * X` por cálculos com `LayoutBuilder`
- [ ] Substituir paddings hardcoded por `Spacing.horizontal(context)` ou `Spacing.all(context)`
- [ ] Adicionar `LayoutBuilder` se precisar adaptar layout baseado em constraints
- [ ] Usar `ResponsiveLayout` se precisar de widgets completamente diferentes por breakpoint
- [ ] Usar `ResponsiveModal.show()` em vez de `Get.bottomSheet()` com altura fixa
- [ ] Testar em pelo menos 3 tamanhos: 360px, 768px, 1280px
- [ ] Verificar se não há overflow em nenhum tamanho

---

## 🎨 Breakpoints Utilizados

| Nome | Range | Dispositivo |
|------|-------|-------------|
| **MOBILE** | 0 - 599px | Smartphones |
| **TABLET** | 600 - 1023px | Tablets, celulares grandes |
| **DESKTOP** | 1024 - 1439px | Laptops, monitores |
| **4K** | 1440px+ | Monitores grandes, TVs |

---

## 🧪 Testando Responsividade

### Opção 1: Device Preview (Recomendado)

```dart
// main.dart - Apenas em debug
void main() {
  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => AppWidget(),
    ),
  );
}
```

### Opção 2: Redimensionar janela do navegador

Abra o app web e redimensione a janela para ver adaptação em tempo real.

### Opção 3: Flutter DevTools

Use Flutter DevTools > Layout Explorer para visualizar em diferentes tamanhos.

---

## ⚠️ Erros Comuns a Evitar

### ❌ NÃO FAÇA:

```dart
// Multiplicadores mágicos
width: MediaQuery.of(context).size.width * 0.069

// Tamanho fixo ignorando tela
Container(width: 800)

// Usar valores hardcoded
padding: EdgeInsets.only(left: 24.53)

// Assumir tamanho da tela
if (MediaQuery.of(context).size.width > 1200) // Use breakpoints!
```

### ✅ FAÇA:

```dart
// Use utilitários responsivos
width: ResponsiveBreakpoints.responsiveWidth(context, mobile: 200, tablet: 300, desktop: 400)

// Use constraints do LayoutBuilder
LayoutBuilder(
  builder: (context, constraints) {
    return Container(maxWidth: constraints.maxWidth * 0.8);
  },
)

// Use Spacing
padding: Spacing.horizontal(context)

// Use breakpoints nomeados
if (ResponsiveBreakpoints.isDesktop(context))
```

---

## 📚 Telas já Refatoradas (Piloto)

✅ **ModulosPage** - NavigationRail para desktop/tablet, BottomNav para mobile  
✅ **SplashPage** - Imagem responsiva com padding adaptativo  
✅ **LoginPage** - Layout centrado com max-width para desktop  

---

## 🚀 Próximos Passos

Para continuar a migração:

1. **Priorize telas mais acessadas** (Home, Agenda, Caderno de Campo)
2. **Refatore formulários** (cadastrar, editar)
3. **Adapte modais e bottom sheets**
4. **Otimize gráficos e tabelas**
5. **Teste em dispositivos reais**

Veja o plano completo em: `.specs/responsivity-plan.md`

---

## 💡 Dicas Finais

1. **Mobile-first**: Sempre comece pelo layout mobile e depois adapte para telas maiores
2. **Teste constantemente**: Use DevicePreview durante desenvolvimento
3. **Não refatore tudo de uma vez**: Faça gradualmente, tela por tela
4. **Documente padrões**: Quando encontrar um bom padrão, reuse em outras telas
5. **Performance**: `LayoutBuilder` causa rebuild quando constraints mudam, use com cuidado

---

**Dúvidas?** Consulte o planejamento completo em `.specs/responsivity-plan.md`
