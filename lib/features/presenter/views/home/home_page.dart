// ignore_for_file: unused_element

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/features/presenter/models/homeDashboard/home_dashboard_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:localization/localization.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/core/utils/responsive_breakpoints.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/views/login/multi_account_page.dart';
import 'package:osi_solucoes/features/presenter/views/onboarding/splash_page.dart';

import '../../../../core/services/local_storage.dart';
import '../../../../core/services/navigation_analytics.dart';
import '../../../../core/services/navigation_resource_args.dart';
import '../../viewmodels/auth_controller.dart';
import '../../viewmodels/home_store.dart';
import '../../viewmodels/lote_store.dart';
import '../../viewmodels/modulos_store.dart';
import '../../models/shortcut/shortcut_model.dart';
import '../../models/setor/setor_model.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({super.key, this.title = "Home"});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final AuthController authController = GetIt.I<AuthController>();
  ModulosStore modulosStore = GetIt.I<ModulosStore>();
  HomeStore store = GetIt.I<HomeStore>();
  final Duration duration = const Duration(milliseconds: 300);

  // Variáveis para o dashboard (carousel removido em favor de cards expansivos)
  String? _adaptiveDashboardName; // Mantido para compatibilidade com sistema adaptativo
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    print('🏠 [HOME_PAGE] Inicializando HomePage...');

    // Carregar dados do dashboard quando a página é aberta
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🏠 [HOME_PAGE] Carregando dados...');
      store.carregarHome();
      store.loadAdaptiveInterface().then((_) {
        print(
            '🏠 [HOME_PAGE] Interface adaptativa carregada, aplicando dashboard...');
        // Ajustar dashboard quando a interface adaptativa for carregada
        _applyAdaptiveDashboard();
        // Inicializa o PageController após carregar a ordem dos cards
        _initializePageController();
      }).catchError((e) {
        print('❌ [HOME_PAGE] Erro ao carregar interface adaptativa: $e');
        // Mesmo com erro, inicializa o controller
        _initializePageController();
      });
    });
  }

  /// Inicializa o PageController para navegação dos cards
  void _initializePageController() {
    if (store.cardOrder.isEmpty) return;
    
    // Descarta o controller antigo se existir
    _pageController?.dispose();
    
    // Cria um novo controller com o índice correto
    _pageController = PageController(initialPage: store.currentCardIndex);
    
    print('📊 [HOME_PAGE] PageController inicializado na posição ${store.currentCardIndex}');
    
    if (mounted) {
      setState(() {});
    }
  }

  /// Armazena o nome do dashboard recomendado para uso futuro (sistema adaptativo).
  /// Os cards agora são expansivos e mostram todos os dados simultaneamente.
  void _applyAdaptiveDashboard() {
    print('📊 [HOME_PAGE] Verificando aplicação de dashboard adaptativo...');

    if (store.adaptiveDashboard == null) {
      print('   └─ ⚠️ Nenhum dashboard recomendado (null)');
      return;
    }

    if (store.dashboardConfidence <= 0.5) {
      print(
          '   └─ ⚠️ Confiança muito baixa (${(store.dashboardConfidence * 100).toStringAsFixed(1)}%), não aplicando');
      return;
    }

    final dashboardName = store.adaptiveDashboard!;
    print('   └─ Dashboard recomendado: "$dashboardName"');
    print(
        '   └─ Confiança: ${(store.dashboardConfidence * 100).toStringAsFixed(1)}%');
    print('   └─ ✅ Dashboard será usado para personalizar cards no futuro');

    setState(() {
      _adaptiveDashboardName = dashboardName;
    });
    
    // Reinicializa o PageController com a nova ordem dos cards
    _initializePageController();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  Future<bool> exitApp() async {
    showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        // title: const Text(
        //   'Warning',
        //   textAlign: TextAlign.center,
        // ),
        content: Text(
          'Tem certeza que deseja fechar o APP ?',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black.withValues(alpha: .75),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.grey),
            onPressed: () async {
              exit(0); // kill app
            },
            child: const Text(
              'Sim',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text(
              'Não',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Constants.kBackgroundColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: PopScope(
          onPopInvokedWithResult: (_, __) => exitApp(),
          child: Scaffold(
            backgroundColor: Constants.kSecondBackgroundColor,
            body: Stack(
              children: [
                menu(context, size),
                home(context, size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget menu(BuildContext context, Size size) {
    final isMobile = ResponsiveBreakpoints.isMobile(context);
    final isTablet = ResponsiveBreakpoints.isTablet(context);
    final useDrawerOverlay = isMobile || isTablet;

    // Em mobile/tablet, usamos o drawer overlay (renderizado no home())
    // Em desktop, renderizamos o menu lateral fixo
    if (useDrawerOverlay) {
      return const SizedBox.shrink();
    }

    final menuWidth = 320.0;

    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        height: size.height,
        width: size.width,
        color: Colors.black.withValues(alpha: 0.3),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: menuWidth,
            height: size.height,
            decoration: BoxDecoration(
              color: Constants.kBackgroundColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(4, 0),
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header com botão de fechar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        onPressed: () => store.setIsCollaped(),
                        icon: const Icon(Icons.close),
                        iconSize: 22,
                        color: Colors.black54,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Seção do usuário com ícone genérico
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Constants.kPrimaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Constants.kPrimaryColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Observer(
                              builder: (_) {
                                final nome = store
                                        .authController
                                        .usuario
                                        .selected_conta
                                        ?.conta
                                        ?.nome ??
                                    'Usuário';
                                return Text(
                                  'Olá, $nome',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                );
                              },
                            ),
                            const SizedBox(height: 2),
                            Observer(
                              builder: (_) {
                                final cargo = store
                                        .authController
                                        .usuario
                                        .selected_conta
                                        ?.cargo
                                        ?.cargo ??
                                    'Cargo';
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Constants.kPrimaryColor
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    cargo,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Constants.kPrimaryColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(height: 1, indent: 16, endIndent: 16),
                const SizedBox(height: 8),

                // Itens do menu
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      // Trocar Conta (apenas se multi-conta)
                      Observer(builder: (_) {
                        final contas = store.authController.usuario.contas;
                        if (contas == null || contas.length < 2) {
                          return const SizedBox.shrink();
                        }
                        return _buildModernMenuItem(
                          icon: Icons.swap_horiz,
                          title: 'Trocar Conta',
                          onTap: () async {
                            store.setIsCollaped();
                            Get.to(
                              () => MultiAccountsPage(
                                isLoggedIn: true,
                                user: store.authController.usuario,
                              ),
                            );
                          },
                          iconColor: const Color(0xFF6366F1),
                        );
                      }),

                      _buildModernMenuItem(
                        icon: Icons.info_outline,
                        title: 'Sobre o App',
                        onTap: () {
                          store.setIsCollaped();
                          // TODO: Implementar tela sobre
                        },
                        iconColor: const Color(0xFF06B6D4),
                      ),

                      const SizedBox(height: 8),
                      const Divider(height: 1),
                      const SizedBox(height: 8),

                      // Logout
                      _buildModernMenuItem(
                        icon: Icons.logout,
                        title: 'Sair',
                        onTap: () async {
                          store.setIsCollaped();
                          await LocalStorage().deleteUser();
                          Get.offAll(() => const SplashPage());
                        },
                        iconColor: const Color(0xFFDC2626),
                        showTrailing: true,
                      ),
                    ],
                  ),
                ),

                // Versão do app
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'versao'.i18n(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Item moderno do menu com ícone, título e opcional trailing
  Widget _buildModernMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = Colors.black54,
    bool showTrailing = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (showTrailing)
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black38,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Botão de navegação do dashboard com estilo minimalista e sutil
  Widget _buildDashboardNavButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: onPressed != null ? Colors.grey[300]! : Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: onPressed != null ? Colors.black87 : Colors.grey[400],
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget home(BuildContext context, Size size) {
    size = MediaQuery.of(context).size;
    final isMobile = ResponsiveBreakpoints.isMobile(context);
    final isTablet = ResponsiveBreakpoints.isTablet(context);
    final useDrawerOverlay = isMobile || isTablet;

    return Observer(builder: (_) {
      // Em mobile/tablet, o conteúdo ocupa 100% da tela (menu é overlay)
      // Em desktop, o conteúdo é comprimido pelo menu lateral
      final leftOffset = useDrawerOverlay ? 0.0 : (store.isCollapsed ? 0.0 : 320.0);
      final rightOffset = useDrawerOverlay ? 0.0 : (store.isCollapsed ? 0.0 : 0.0);
      final contentWidth = useDrawerOverlay ? size.width : (store.isCollapsed ? size.width : size.width - 320.0);

      return Stack(
        children: [
          // Conteúdo principal
          AnimatedPositioned(
            duration: useDrawerOverlay ? const Duration(milliseconds: 0) : duration,
            top: 0,
            bottom: 0,
            left: useDrawerOverlay ? 0 : leftOffset,
            right: rightOffset,
            child: Container(
              constraints: const BoxConstraints(
                minWidth: 256,
                minHeight: 600,
              ),
              height: size.height,
              width: useDrawerOverlay ? size.width : contentWidth,
              decoration: BoxDecoration(
                color: Constants.kSecondBackgroundColor,
              ),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
              // sliverAppBarWidget(size),
              const SliverPersistentHeader(
                pinned: true,
                delegate: MyHeaderDelegate(),
              ),
              // Seção de Ações Rápidas Inteligentes
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.05,
                    right: size.width * 0.05,
                    top: 20,
                    bottom: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Ações Rápidas',
                          style: TextStyle(
                            fontSize: ResponsiveBreakpoints.responsiveFontSize(
                              context,
                              mobile: 16,
                              tablet: 18,
                              desktop: 20,
                            ),
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Observer(builder: (_) {
                        if (store.recommendedShortcuts.isNotEmpty &&
                            store.recommendedShortcuts
                                .any((s) => s.confidence > 0.5)) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Constants.kPrimaryColor
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  size: 14,
                                  color: Constants.kPrimaryColor,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    'Inteligente',
                                    style: TextStyle(
                                      color: Constants.kPrimaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Observer(builder: (_) {
                  if (store.isLoadingShortcuts) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05, vertical: 20),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  // Se há atalhos recomendados, mostra eles
                  if (store.recommendedShortcuts.isNotEmpty) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.05),
                      child: SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: store.recommendedShortcuts.map((shortcut) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: _buildSmartShortcutCard(
                                context,
                                size,
                                shortcut,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  }

                  // Fallback: mostra atalhos padrão
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    child: SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          modernQuickActionCard(
                            context,
                            size,
                            "card1Home".i18n(),
                            "assets/icons/gerenciar_icon.svg",
                            const Color(0xFF6366F1),
                            onTap: () {
                              Get.toNamed(Routes.gerenciarEquipePage);
                            },
                          ),
                          const SizedBox(width: 12),
                          modernQuickActionCard(
                            context,
                            size,
                            "card1Home".i18n(),
                            "assets/icons/gerenciar_icon.svg",
                            const Color(0xFF6366F1),
                            onTap: () {
                              Get.toNamed(Routes.gerenciarEquipePage);
                            },
                          ),
                          const SizedBox(width: 12),
                          modernQuickActionCard(
                            context,
                            size,
                            "card2Home".i18n(),
                            "assets/icons/relatorio_icon.svg",
                            const Color(0xFF8B5CF6),
                            onTap: () {
                              Get.toNamed(Routes.historicoPage);
                            },
                          ),
                          const SizedBox(width: 12),
                          modernQuickActionCard(
                            context,
                            size,
                            "card3Home".i18n(),
                            "assets/icons/inventario_icon.svg",
                            const Color(0xFF06B6D4),
                            onTap: () {
                              Get.toNamed(Routes.agendaPage);
                            },
                          ),
                          const SizedBox(width: 12),
                          modernQuickActionCard(
                            context,
                            size,
                            "card4Home".i18n(),
                            "assets/icons/relatorio_icon.svg",
                            const Color(0xFF10B981),
                            onTap: () {
                              Get.toNamed(Routes.protocoloPage);
                            },
                          ),
                          const SizedBox(width: 12),
                          modernQuickActionCard(
                            context,
                            size,
                            'Relatórios',
                            "assets/icons/relatorio_icon.svg",
                            const Color(0xFFE11D48),
                            onTap: () {
                              Get.toNamed(Routes.relatoriosPage);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),

              // Seção do Dashboard
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.05,
                    right: size.width * 0.05,
                    top: 30,
                    bottom: 10,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 300;
                      return Flex(
                        direction: isNarrow ? Axis.vertical : Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Dashboard de Produção',
                                    style: TextStyle(
                                      fontSize: isNarrow ? 16 : 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Observer(builder: (_) {
                                  if (store.adaptiveDashboard != null &&
                                      store.dashboardConfidence > 0.5) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 6),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Constants.kPrimaryColor
                                              .withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.auto_awesome,
                                              size: 12,
                                              color: Constants.kPrimaryColor,
                                            ),
                                            const SizedBox(width: 3),
                                            Flexible(
                                              child: Text(
                                                'Adaptativo',
                                                style: TextStyle(
                                                  color: Constants.kPrimaryColor,
                                                  fontSize: isNarrow ? 9 : 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                }),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // Carousel de Cards de Métricas
              SliverToBoxAdapter(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Altura responsiva para o carousel
                    final carouselHeight = ResponsiveBreakpoints.responsiveHeight(
                      context,
                      mobile: size.height * 0.45,
                      tablet: size.height * 0.40,
                      desktop: size.height * 0.35,
                    );

                    return SizedBox(
                      height: carouselHeight,
                      child: Observer(builder: (_) {
                        if (store.isLoading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (store.hasError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Erro: ${store.errorMessage}',
                                    style: const TextStyle(color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () => store.carregarHome(),
                                    child: const Text('Tentar novamente'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        final dashboard = store.dashboard;
                        if (dashboard == null) {
                          return const SizedBox.shrink();
                        }

                        // Garante que a ordem dos cards está inicializada
                        if (store.cardOrder.isEmpty) {
                          store.initializeCardOrder();
                        }
                        
                        // Se ainda assim não há cards, mostra placeholder
                        if (store.cardOrder.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: Text(
                                'Carregando dashboard...',
                                style: TextStyle(fontSize: 14, color: Colors.black54),
                              ),
                            ),
                          );
                        }

                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Header com nome do dashboard e botões de navegação
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              child: Observer(
                                builder: (_) {
                                  final cardNames = {
                                    'lotes': 'Lotes em Produção',
                                    'tarefas': 'Tarefas Pendentes',
                                    'producao': 'Produção Total',
                                    'saude': 'Saúde da Produção',
                                  };
                                  final currentIndex = store.currentCardIndex;
                                  final total = store.cardOrder.length;
                                  final currentName = store.cardOrder.isNotEmpty && currentIndex < total
                                      ? cardNames[store.cardOrder[currentIndex]] ?? ''
                                      : '';

                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Nome do dashboard atual
                                      Text(
                                        currentName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(width: 12),
                                      // Botão anterior
                                      _buildDashboardNavButton(
                                        icon: Icons.chevron_left,
                                        onPressed: currentIndex > 0
                                            ? () {
                                                store.previousCard();
                                                _pageController?.previousPage(
                                                  duration: const Duration(milliseconds: 300),
                                                  curve: Curves.easeOut,
                                                );
                                              }
                                            : null,
                                      ),
                                      const SizedBox(width: 8),
                                      // Botão próximo
                                      _buildDashboardNavButton(
                                        icon: Icons.chevron_right,
                                        onPressed: currentIndex < total - 1
                                            ? () {
                                                store.nextCard();
                                                _pageController?.nextPage(
                                                  duration: const Duration(milliseconds: 300),
                                                  curve: Curves.easeOut,
                                                );
                                              }
                                            : null,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            // PageView ocupa todo espaço restante
                            Expanded(
                              child: Observer(
                                builder: (_) {
                                  if (_pageController == null) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  return PageView.builder(
                                    controller: _pageController,
                                    onPageChanged: (index) => store.goToCard(index),
                                    itemCount: store.cardOrder.length,
                                    itemBuilder: (context, index) {
                                      final cardType = store.cardOrder[index];
                                      return Padding(
                                        key: ValueKey('$cardType-$index'),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.05, vertical: 6),
                                        child: _buildCardByType(cardType, dashboard, size),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            // Indicadores (dots) clicáveis para navegação direta
                            Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 4),
                              child: Observer(
                                builder: (_) => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    store.cardOrder.length,
                                    (index) => GestureDetector(
                                      onTap: () {
                                        store.goToCard(index);
                                        _pageController?.animateToPage(
                                          index,
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.easeOut,
                                        );
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        margin: const EdgeInsets.symmetric(horizontal: 4),
                                        width: store.currentCardIndex == index ? 24 : 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: store.currentCardIndex == index
                                              ? Constants.kPrimaryColor
                                              : Colors.grey[300],
                                          borderRadius: BorderRadius.circular(4),
                                          border: store.currentCardIndex == index
                                              ? null
                                              : Border.all(color: Colors.grey[400]!, width: 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Contador de posição
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Observer(
                                builder: (_) {
                                  final currentIndex = store.currentCardIndex;
                                  final total = store.cardOrder.length;
                                  return Text(
                                    '${currentIndex + 1} de $total • Deslize para navegar',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[500],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }),
                    );
                  },
                ),
              ),

              // Espaçador entre dashboard e módulos
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Constants.kPrimaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Título da seção de módulos
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.05,
                    right: size.width * 0.05,
                    top: 10,
                    bottom: 8,
                  ),
                  child: const Text(
                    'Módulos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              // Grid de Módulos Responsivo com TODAS as funcionalidades
              // Organizado em 2 sub-seções lado a lado para reduzir scroll vertical
              SliverToBoxAdapter(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = ResponsiveBreakpoints.isMobile(context);
                    final isTablet = ResponsiveBreakpoints.isTablet(context);
                    
                    final horizontalPadding = ResponsiveBreakpoints.responsivePadding(
                      context,
                      mobile: size.width * 0.05,
                      tablet: size.width * 0.08,
                      desktop: size.width * 0.12,
                    );

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: isMobile
                          ? _buildMobileModulesLayout(context, size)
                          : isTablet
                              ? _buildTabletModulesLayout(context, size)
                              : _buildDesktopModulesLayout(context, size),
                    );
                  },
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 40),
              ),
            ],
          ),
        ),
      ),
          // Drawer Overlay para mobile/tablet
          if (useDrawerOverlay && !store.isCollapsed)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => store.setIsCollaped(),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                ),
              ),
            ),
          if (useDrawerOverlay && !store.isCollapsed)
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: AnimatedContainer(
                duration: duration,
                width: size.width * 0.85,
                child: _buildDrawerContent(context, size),
              ),
            ),
        ],
      );
    });
  }

  /// Constrói o conteúdo do drawer (usado em mobile/tablet)
  Widget _buildDrawerContent(BuildContext context, Size size) {
    final menuWidth = size.width * 0.85;

    return Container(
      width: menuWidth,
      height: size.height,
      decoration: BoxDecoration(
        color: Constants.kBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(4, 0),
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header com botão de fechar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () => store.setIsCollaped(),
                  icon: const Icon(Icons.close),
                  iconSize: 22,
                  color: Colors.black54,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Seção do usuário com ícone genérico
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Constants.kPrimaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Constants.kPrimaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Observer(
                        builder: (_) {
                          final nome = store
                                  .authController
                                  .usuario
                                  .selected_conta
                                  ?.conta
                                  ?.nome ??
                              'Usuário';
                          return Text(
                            'Olá, $nome',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                      const SizedBox(height: 2),
                      Observer(
                        builder: (_) {
                          final cargo = store
                                  .authController
                                  .usuario
                                  .selected_conta
                                  ?.cargo
                                  ?.cargo ??
                              'Cargo';
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Constants.kPrimaryColor
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              cargo,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Constants.kPrimaryColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Divider(height: 1, indent: 16, endIndent: 16),
          const SizedBox(height: 8),

          // Itens do menu
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                // Trocar Conta (apenas se multi-conta)
                Observer(builder: (_) {
                  final contas = store.authController.usuario.contas;
                  if (contas == null || contas.length < 2) {
                    return const SizedBox.shrink();
                  }
                  return _buildModernMenuItem(
                    icon: Icons.swap_horiz,
                    title: 'Trocar Conta',
                    onTap: () async {
                      store.setIsCollaped();
                      Get.to(
                        () => MultiAccountsPage(
                          isLoggedIn: true,
                          user: store.authController.usuario,
                        ),
                      );
                    },
                    iconColor: const Color(0xFF6366F1),
                  );
                }),

                _buildModernMenuItem(
                  icon: Icons.info_outline,
                  title: 'Sobre o App',
                  onTap: () {
                    store.setIsCollaped();
                    // TODO: Implementar tela sobre
                  },
                  iconColor: const Color(0xFF06B6D4),
                ),

                const SizedBox(height: 8),
                const Divider(height: 1),
                const SizedBox(height: 8),

                // Logout
                _buildModernMenuItem(
                  icon: Icons.logout,
                  title: 'Sair',
                  onTap: () async {
                    store.setIsCollaped();
                    await LocalStorage().deleteUser();
                    Get.offAll(() => const SplashPage());
                  },
                  iconColor: const Color(0xFFDC2626),
                  showTrailing: true,
                ),
              ],
            ),
          ),

          // Versão do app
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'versao'.i18n(),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  SliverAppBar sliverAppBarWidget(Size size) {
    return SliverAppBar(
      backgroundColor: Constants.kBackgroundColor,
      floating: true,
      pinned: false,
      elevation: 0,
      expandedHeight: 140,
      collapsedHeight: 60,
      toolbarHeight: 60,
      leading: IconButton(
        onPressed: () => store.setIsCollaped(),
        icon: const Icon(Icons.menu_rounded),
        iconSize: 24,
        color: Colors.black87,
      ),
      title: Observer(
        builder: (_) {
          final nome = store.authController.usuario.selected_conta?.conta?.nome ?? '';
          return Text(
            nome.isNotEmpty ? 'Olá, $nome' : 'Olá',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Constants.kPrimaryColor.withValues(alpha: 0.05),
              Constants.kBackgroundColor,
            ],
          ),
        ),
      ),
    );
  }

  Widget firstItems(BuildContext context, Size size, String title, String icon,
      {VoidCallback? onTap}) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                  colors: [Color(0xFF707070), Color(0xFF53916C)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  stops: [0.2, 1]),
            ),
            height: 50,
            width: 50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(icon),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.009),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget modernQuickActionCard(
    BuildContext context,
    Size size,
    String title,
    String icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 90,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 2),
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    color,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Layout MOBILE: 2 colunas, módulos empilhados verticalmente (mais compactos)
  Widget _buildMobileModulesLayout(BuildContext context, Size size) {
    final allModules = _buildAllModuleGridItems(context, size, compact: true);
    
    // Divide em 2 grupos: principais e secundários
    final mainModules = allModules.take(8).toList();

    // Grid principal (8 módulos em 2 colunas - 4 linhas)
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.25,
      children: mainModules,
    );
  }

  /// Layout TABLET: 3 colunas, melhor distribuição visual
  Widget _buildTabletModulesLayout(BuildContext context, Size size) {
    final allModules = _buildAllModuleGridItems(context, size, compact: false);
    
    // Divide em 2 grupos de 5
    final group1 = allModules.take(5).toList();
    final group2 = allModules.skip(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Primeira linha (5 módulos em grid 3+2)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.4, // Menos alto para evitar overflow
                children: group1.take(3).toList(),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 2,
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.4,
                children: group1.skip(3).toList(),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 14),
        
        // Segunda linha (5 módulos em grid 3+2)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.4,
                children: group2.take(3).toList(),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 2,
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.4,
                children: group2.skip(3).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Layout DESKTOP: 5 colunas em 2 linhas, todos visíveis sem scroll
  Widget _buildDesktopModulesLayout(BuildContext context, Size size) {
    final allModules = _buildAllModuleGridItems(context, size, compact: false);
    
    // Divide em 2 grupos de 5
    final row1 = allModules.take(5).toList();
    final row2 = allModules.skip(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Primeira linha (5 módulos)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: row1
              .map((m) => Expanded(child: m))
              .toList()
              .expand((e) => [e, const SizedBox(width: 16)])
              .toList()
              .sublist(0, 9),
        ),
        
        const SizedBox(height: 16),
        
        // Segunda linha (5 módulos)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: row2
              .map((m) => Expanded(child: m))
              .toList()
              .expand((e) => [e, const SizedBox(width: 16)])
              .toList()
              .sublist(0, 9),
        ),
      ],
    );
  }

  /// Constrói grid com TODOS os módulos do sistema (incluindo Agenda, Gestão de Equipe, Protocolos, Histórico)
  List<Widget> _buildAllModuleGridItems(BuildContext context, Size size, {bool compact = false}) {
    return [
      // === MÓDULOS PRINCIPAIS ===
      // 1. Área de Cultivo / Setores
      _buildModernModuleCard(
        context,
        size,
        "card5Home".i18n(),
        "Áreas de cultivo e setores",
        "assets/icons/cultivo_icon.svg",
        const Color(0xFF059669),
        moduleId: 0,
        compact: compact,
      ),
      
      // 2. Reservatórios
      _buildModernModuleCard(
        context,
        size,
        "card6Home".i18n(),
        "Solução nutritiva e tanques",
        "assets/icons/reservatorio_icon.svg",
        const Color(0xFF2563EB),
        moduleId: 1,
        compact: compact,
      ),
      
      // 3. Caderno de Campo
      _buildModernModuleCard(
        context,
        size,
        "card7Home".i18n(),
        "Registro de atividades",
        "assets/icons/caderno_campo_icon.svg",
        const Color(0xFFDC2626),
        moduleId: 2,
        compact: compact,
      ),
      
      // 4. Soluções Nutritivas
      _buildModernModuleCard(
        context,
        size,
        "card8Home".i18n(),
        "Formulação de nutrientes",
        "assets/icons/solucoes_nutritivas_icon.svg",
        const Color(0xFFEA580C),
        moduleId: 3,
        compact: compact,
      ),
      
      // 5. Protocolos
      _buildModernModuleCard(
        context,
        size,
        "Protocolos",
        "Templates de cultivo",
        "assets/icons/etapa.svg",
        const Color(0xFF10B981),
        onTap: () {
          Get.toNamed(Routes.protocoloPage);
        },
        compact: compact,
      ),
      
      // 6. Agenda
      _buildModernModuleCard(
        context,
        size,
        "Agenda",
        "Tarefas e atividades",
        "assets/icons/inventario_icon.svg",
        const Color(0xFF06B6D4),
        onTap: () {
          Get.toNamed(Routes.agendaPage);
        },
        compact: compact,
      ),
      
      // 7. Relatórios
      _buildModernModuleCard(
        context,
        size,
        "cardRelatoriosHome".i18n(),
        "Análises e métricas",
        "assets/icons/relatorio_icon.svg",
        const Color(0xFF0891B2),
        moduleId: 4,
        compact: compact,
      ),
      
      // 8. Ajustes
      _buildModernModuleCard(
        context,
        size,
        "card9Home".i18n(),
        "Parâmetros de cultivo",
        "assets/icons/ajustes_icon.svg",
        const Color(0xFF7C3AED),
        moduleId: 5,
        compact: compact,
      ),
      
      // === MÓDULOS SECUNDÁRIOS ===
      // 9. Gestão de Equipe
      _buildModernModuleCard(
        context,
        size,
        "Gestão de Equipe",
        "Usuários e permissões",
        "assets/icons/gerenciar_icon.svg",
        const Color(0xFF6366F1),
        onTap: () {
          Get.toNamed(Routes.gerenciarEquipePage);
        },
        compact: compact,
      ),
      
      // 10. Histórico
      _buildModernModuleCard(
        context,
        size,
        "Histórico",
        "Lotes finalizados",
        "assets/icons/relatorio_icon.svg",
        const Color(0xFF8B5CF6),
        onTap: () {
          Get.toNamed(Routes.historicoPage);
        },
        compact: compact,
      ),
    ];
  }

  /// Card moderno para módulo do sistema com título, subtítulo e ícone
  Widget _buildModernModuleCard(
    BuildContext context,
    Size size,
    String title,
    String subtitle,
    String icon,
    Color color, {
    int? moduleId,
    VoidCallback? onTap,
    bool compact = false,
  }) {
    final iconSize = compact ? 36.0 : 44.0;
    final iconImageSize = compact ? 20.0 : 24.0;
    final titleFontSize = compact ? 11.0 : 13.0;
    final subtitleFontSize = compact ? 9.0 : 10.0;
    final padding = compact ? 10.0 : 14.0;
    final spacing = compact ? 4.0 : 6.0;

    return InkWell(
      onTap: onTap ?? () {
        if (moduleId != null) {
          modulosStore.setPageViewController(moduleId);
          Get.toNamed(Routes.modulosPage);
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 2),
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ícone com fundo colorido
                Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      icon,
                      width: iconImageSize,
                      height: iconImageSize,
                      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    ),
                  ),
                ),
                
                SizedBox(height: spacing),
                
                // Título
                Text(
                  title,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    height: 1.1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                SizedBox(height: 2),
                
                // Subtítulo
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    height: 1.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget gridItems(
      BuildContext context, Size size, String title, String icon, bool isLeft,
      {String? path, required int id}) {
    return Padding(
      padding: isLeft
          ? EdgeInsets.only(left: size.width * 0.07)
          : EdgeInsets.only(right: size.width * 0.07),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              offset: Offset(1, 1),
              color: Color.fromARGB(15, 0, 0, 0),
              blurRadius: 15,
            ),
          ],
        ),
        child: InkWell(
          onTap: () async {
            modulosStore.setPageViewController(id);
            // modulosPage é apenas container de navegação, não deve ser rastreado
            Get.toNamed(
              Routes.modulosPage,
              // () => const ModulosPage(),
              // transition: Transition.rightToLeft,
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 2,
            child: SizedBox(
              height: 120, // Altura fixa para o Card
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, top: 10),
                      child: IconButton(
                        icon: SvgPicture.asset(
                          icon,
                          height: 25,
                          width: 25,
                        ),
                        onPressed: null,
                      ),
                    ),
                  ),
                  const Spacer(), // Agora pode ser usado porque o Column tem altura definida
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        bottom: 20,
                        right: 16,
                      ),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withValues(alpha: .7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget modernGridItems(
    BuildContext context,
    Size size,
    String title,
    String icon,
    Color color, {
    String? path,
    required int id,
  }) {
    return InkWell(
      onTap: () async {
        modulosStore.setPageViewController(id);
        // modulosPage é apenas container de navegação, não deve ser rastreado
        Get.toNamed(Routes.modulosPage);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    icon,
                    width: 28,
                    height: 28,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 30,
                      height: 3,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // NOVOS MÉTODOS DE BUILD DOS CARDS EXPANDIDOS
  // ============================================================

  /// Card 1: Lotes em Produção (expandido)
  Widget _buildLotesCard(BuildContext context, Size size, HomeDashboard dashboard) {
    final resumo = dashboard.resumo;
    final bool semDados = resumo == null;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  semDados ? Icons.warning_amber_rounded : Icons.agriculture,
                  color: semDados ? Colors.orange[600] : const Color(0xFF059669),
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Lotes em Produção', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    Text(
                      semDados ? 'Nenhum lote registrado' : '${resumo.lotesAtivos ?? 0} ativos',
                      style: TextStyle(
                        fontSize: 12,
                        color: semDados ? Colors.orange[700] : Colors.grey[600],
                        fontStyle: semDados ? FontStyle.italic : FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
              // Badge de colheita próxima
              if (!semDados && (resumo.lotesComColheitaProxima ?? 0) > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.schedule, size: 14, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 4),
                      Text('${resumo.lotesComColheitaProxima}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFF59E0B))),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          // Estado vazio quando sem dados
          if (semDados)
            Expanded(
              child: _buildEmptyState(
                icon: Icons.agriculture_outlined,
                iconColor: Colors.orange[600]!,
                title: 'Nenhum lote cadastrado',
                subtitle: 'Cadastre lotes para visualizar o acompanhamento da produção aqui',
                buttonColor: const Color(0xFF059669),
                buttonText: 'Cadastrar Lote',
                onButtonPressed: () {
                  // TODO: Navegar para tela de cadastro de lotes
                },
              ),
            )
          else ...[
            // Barra de progresso por status
            if (resumo.lotesPorStatus != null && resumo.lotesPorStatus!.isNotEmpty)
              _buildSegmentedProgress(resumo.lotesPorStatus!),
            if (resumo.taxaConclusao != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: (resumo.taxaConclusao ?? 0) / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation(Color(0xFF059669)),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${resumo.taxaConclusao?.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            // Espécies em andamento
            if (resumo.especiesEmAndamento != null && resumo.especiesEmAndamento!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: resumo.especiesEmAndamento!.take(4).map((esp) {
                  return Chip(
                    label: Text('${esp.nome} (${esp.percentual?.toStringAsFixed(0)}%)', style: const TextStyle(fontSize: 10)),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: const Color(0xFF059669).withValues(alpha: 0.1),
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],
          ],
        ],
      ),
    );
  }

  /// Card 2: Tarefas Pendentes (expandido)
  Widget _buildTarefasCard(BuildContext context, Size size, HomeDashboard dashboard) {
    final tarefas = dashboard.tarefas;
    final bool semDados = tarefas == null;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  semDados ? Icons.warning_amber_rounded : Icons.task_alt,
                  color: semDados ? Colors.orange[600] : const Color(0xFFDC2626),
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tarefas Pendentes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    Text(
                      semDados ? 'Nenhuma tarefa registrada' : '${tarefas.pendentesHoje ?? 0} hoje',
                      style: TextStyle(
                        fontSize: 12,
                        color: semDados ? Colors.orange[700] : Colors.grey[600],
                        fontStyle: semDados ? FontStyle.italic : FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
              // Badge de atrasadas
              if (!semDados && (tarefas.atrasadas ?? 0) > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text('${tarefas.atrasadas}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Estado vazio quando sem dados
          if (semDados)
            Expanded(
              child: _buildEmptyState(
                icon: Icons.task_alt_outlined,
                iconColor: Colors.orange[600]!,
                title: 'Nenhuma tarefa cadastrada',
                subtitle: 'Cadastre tarefas nos lotes para visualizar o acompanhamento aqui',
                buttonColor: const Color(0xFFDC2626),
                buttonText: 'Cadastrar Tarefa',
                onButtonPressed: () {
                  // TODO: Navegar para tela de cadastro de tarefas
                },
              ),
            )
          else ...[
            // Breakdown por vencimento
            if (tarefas.porVencimento != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTaskBreakdownItem('Hoje', tarefas.porVencimento!.hoje ?? 0, const Color(0xFFDC2626)),
                  _buildTaskBreakdownItem('Semana', tarefas.porVencimento!.estaSemana ?? 0, const Color(0xFFF59E0B)),
                  _buildTaskBreakdownItem('Próx.', tarefas.porVencimento!.proximaSemana ?? 0, const Color(0xFF059669)),
                ],
              ),
            // Preview de tarefas
            if (tarefas.ultimasTarefas != null && tarefas.ultimasTarefas!.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 6),
              ...tarefas.ultimasTarefas!.take(3).map((t) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(t.vencida == true ? Icons.warning : Icons.circle_outlined, size: 12, color: t.vencida == true ? const Color(0xFFDC2626) : Colors.grey[400]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(t.titulo ?? '', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                      if (t.loteNome != null)
                        Text(t.loteNome!, style: TextStyle(fontSize: 10, color: Colors.grey[500]), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                );
              }),
            ],
          ],
        ],
      ),
    );
  }

  /// Card 3: Produção Total (expandido)
  Widget _buildProducaoCard(BuildContext context, Size size, HomeDashboard dashboard) {
    final producao = dashboard.producao;
    final bool semDados = producao == null;

    // Verifica se está zerado (sem dados de produção)
    final bool estaZerado = !semDados &&
        (producao.totalPlantasColhidas ?? 0) == 0 &&
        (producao.totalEmbalagensProduzidas ?? 0) == 0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  semDados ? Icons.warning_amber_rounded : Icons.eco,
                  color: semDados ? Colors.orange[600] : const Color(0xFF2563EB),
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Produção Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    Text(
                      semDados
                          ? 'Nenhuma produção registrada'
                          : estaZerado
                              ? 'Nenhuma colheita registrada'
                              : '${producao.totalPlantasColhidas ?? 0} plantas',
                      style: TextStyle(
                        fontSize: 12,
                        color: (semDados || estaZerado) ? Colors.orange[700] : Colors.grey[600],
                        fontStyle: (semDados || estaZerado) ? FontStyle.italic : FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
              // Comparativo de variação
              if (!semDados && !estaZerado && producao.comparativoPeriodo != null && producao.comparativoPeriodo!.variacaoPercentual != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (producao.comparativoPeriodo!.variacaoPercentual ?? 0) >= 0
                        ? const Color(0xFF059669).withValues(alpha: 0.12)
                        : const Color(0xFFDC2626).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        (producao.comparativoPeriodo!.variacaoPercentual ?? 0) >= 0 ? Icons.trending_up : Icons.trending_down,
                        size: 14,
                        color: (producao.comparativoPeriodo!.variacaoPercentual ?? 0) >= 0 ? const Color(0xFF059669) : const Color(0xFFDC2626),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${(producao.comparativoPeriodo!.variacaoPercentual ?? 0) >= 0 ? '+' : ''}${producao.comparativoPeriodo!.variacaoPercentual?.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: (producao.comparativoPeriodo!.variacaoPercentual ?? 0) >= 0 ? const Color(0xFF059669) : const Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Estado vazio quando sem dados
          if (semDados)
            Expanded(
              child: _buildEmptyState(
                icon: Icons.eco_outlined,
                iconColor: Colors.orange[600]!,
                title: 'Nenhum dado de produção',
                subtitle: 'Registre colheitas e produções nos lotes para visualizar as métricas aqui',
                buttonColor: const Color(0xFF2563EB),
                buttonText: 'Registrar Produção',
                onButtonPressed: () {
                  // TODO: Navegar para tela de registro de produção
                },
              ),
            )
          else if (estaZerado)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 48,
                      color: Colors.orange[300],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Aguardando dados de produção',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Nenhuma colheita registrada no período',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            // Gráfico de barras verticais - Produção mensal
            if (producao.producaoMensal != null && producao.producaoMensal!.isNotEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: producao.producaoMensal!.map((producaoMes) {
                      final maxProducao = producao.producaoMensal!
                          .map((p) => p.quantidade ?? 0)
                          .reduce((a, b) => a > b ? a : b);
                      final percentual = maxProducao > 0
                          ? ((producaoMes.quantidade ?? 0) / maxProducao).toDouble()
                          : 0.0;
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              _formatNumber(producaoMes.quantidade ?? 0),
                              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                              maxLines: 1,
                            ),
                            const SizedBox(height: 2),
                            Container(
                              width: double.infinity,
                              height: (80.0 * percentual).clamp(6.0, 80.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2563EB),
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getMonthAbbreviation(producaoMes.mes ?? ''),
                              style: const TextStyle(fontSize: 9, color: Colors.grey),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            // Taxas de produtividade
            if (producao.taxasMedia != null && producao.taxasMedia!.taxaGlobal != null && producao.taxasMedia!.taxaGlobal! > 0)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildRateIndicator('Germinação', producao.taxasMedia!.taxaGerminacao ?? 0, const Color(0xFF10B981)),
                    _buildRateIndicator('Transplantio', producao.taxasMedia!.taxaTransplantio ?? 0, const Color(0xFF2563EB)),
                    _buildRateIndicator('Embalagem', producao.taxasMedia!.taxaEmbalagem ?? 0, const Color(0xFFF59E0B)),
                    _buildRateIndicator('Global', producao.taxasMedia!.taxaGlobal ?? 0, const Color(0xFF8B5CF6)),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  /// Card 5: Saúde da Produção (NOVO)
  Widget _buildSaudeCard(BuildContext context, Size size, HomeDashboard dashboard) {
    final taxas = dashboard.producao?.taxasMedia;
    final equipe = dashboard.equipe;
    final alertas = dashboard.alertasCritico;
    final bool semDados = taxas == null && equipe == null && (alertas == null || alertas.isEmpty);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF06B6D4).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  semDados ? Icons.warning_amber_rounded : Icons.monitor_heart,
                  color: semDados ? Colors.orange[600] : const Color(0xFF06B6D4),
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Saúde da Produção', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    Text(
                      semDados ? 'Dados insuficientes' : 'Eficiência e alertas',
                      style: TextStyle(
                        fontSize: 12,
                        color: semDados ? Colors.orange[700] : Colors.grey[600],
                        fontStyle: semDados ? FontStyle.italic : FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Estado vazio quando sem dados
          if (semDados)
            Expanded(
              child: _buildEmptyState(
                icon: Icons.monitor_heart_outlined,
                iconColor: Colors.orange[600]!,
                title: 'Dados insuficientes para análise',
                subtitle: 'Registre taxas de produção e atividades da equipe para visualizar a saúde da produção aqui',
                buttonColor: const Color(0xFF06B6D4),
                buttonText: 'Registrar Dados',
                onButtonPressed: () {
                  // TODO: Navegar para tela de registro de taxas/atividade
                },
              ),
            )
          else ...[
            // Gauges de taxas
            if (taxas != null && taxas.taxaGlobal != null && taxas.taxaGlobal! > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildRateGauge('Germinação', taxas.taxaGerminacao ?? 0, const Color(0xFF10B981)),
                  _buildRateGauge('Transplantio', taxas.taxaTransplantio ?? 0, const Color(0xFF2563EB)),
                  _buildRateGauge('Embalagem', taxas.taxaEmbalagem ?? 0, const Color(0xFFF59E0B)),
                  _buildRateGauge('Global', taxas.taxaGlobal ?? 0, const Color(0xFF8B5CF6)),
                ],
              ),
            // Resumo da equipe
            if (equipe != null && equipe.membrosAtivos != null && equipe.membrosAtivos! > 0) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTeamStat('Membros', '${equipe.membrosAtivos}', Icons.people, const Color(0xFF06B6D4)),
                  _buildTeamStat('Conclusão', '${equipe.taxaConclusaoMedia?.toStringAsFixed(0)}%', Icons.check_circle, const Color(0xFF10B981)),
                  _buildTeamStat('No prazo', '${equipe.atividadesNoPrazo ?? 0}', Icons.schedule, const Color(0xFF2563EB)),
                  if ((equipe.atividadesVencidas ?? 0) > 0)
                    _buildTeamStat('Vencidas', '${equipe.atividadesVencidas}', Icons.warning, const Color(0xFFDC2626)),
                ],
              ),
            ],
            // Alertas críticos
            if (alertas != null && alertas.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 6),
              const Text('Alertas', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54)),
              const SizedBox(height: 6),
              ...alertas.take(3).map((alerta) {
                final gravidadeColor = alerta.gravidade == 'alta' ? const Color(0xFFDC2626) : alerta.gravidade == 'media' ? const Color(0xFFF59E0B) : const Color(0xFF10B981);
                final gravidadeIcon = alerta.gravidade == 'alta' ? Icons.error : alerta.gravidade == 'media' ? Icons.warning_amber : Icons.info_outline;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(gravidadeIcon, size: 16, color: gravidadeColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(alerta.mensagem ?? '', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
                            if (alerta.loteNome != null)
                              Text(alerta.loteNome!, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ],
      ),
    );
  }

  // ============================================================
  // HELPERS PARA CARDS EXPANDIDOS
  // ============================================================

  /// Parse de cor hex string com fallback
  Color _parseColor(String hex, Color fallback) {
    try {
      if (hex.isEmpty) return fallback;
      String clean = hex.replaceAll('#', '');
      if (clean.length == 6) clean = 'FF$clean';
      return Color(int.parse(clean, radix: 16));
    } catch (e) {
      return fallback;
    }
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(offset: const Offset(0, 2), color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, spreadRadius: 0),
      ],
    );
  }

  /// Widget compacto para estado vazio com aviso (cabe em 280px)
  Widget _buildEmptyState({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Color buttonColor,
    String? buttonText,
    VoidCallback? onButtonPressed,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;
        final isCompact = availableHeight < 200;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(isCompact ? 10 : 14),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  size: isCompact ? 32 : 38,
                  color: iconColor,
                ),
              ),
              SizedBox(height: isCompact ? 6 : 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: isCompact ? 12 : 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isCompact ? 3 : 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isCompact ? 10 : 11,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              if (buttonText != null && onButtonPressed != null && !isCompact) ...[
                SizedBox(height: 8),
                SizedBox(
                  height: 28,
                  child: ElevatedButton.icon(
                    onPressed: onButtonPressed,
                    icon: const Icon(Icons.add, size: 14),
                    label: Text(
                      buttonText,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  /// Constrói o card adequado baseado no tipo informado
  Widget _buildCardByType(String cardType, HomeDashboard dashboard, Size size) {
    switch (cardType) {
      case 'lotes':
        return _buildLotesCard(context, size, dashboard);
      case 'tarefas':
        return _buildTarefasCard(context, size, dashboard);
      case 'producao':
        return _buildProducaoCard(context, size, dashboard);
      case 'saude':
        // Card de saúde só é exibido se houver dados de equipe ou taxas
        if (dashboard.equipe != null || dashboard.producao?.taxasMedia != null) {
          return _buildSaudeCard(context, size, dashboard);
        }
        // Fallback: exibe um card vazio ou outro card se não houver dados
        return _buildPlaceholderCard('Sem dados de saúde da produção');
      default:
        return _buildPlaceholderCard('Card desconhecido');
    }
  }

  /// Card placeholder para quando não há dados ou tipo inválido
  Widget _buildPlaceholderCard(String message) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: _cardDecoration(),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_outline, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedProgress(List<HomeLoteStatus> statuses) {
    final total = statuses.fold<int>(0, (sum, s) => sum + (s.quantidade ?? 0));
    if (total == 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 10,
            width: double.infinity,
            child: Row(
              children: statuses.map((status) {
                final flex = status.quantidade ?? 0;
                if (flex == 0) return const SizedBox.shrink();
                return Flexible(
                  flex: flex,
                  child: Container(color: _parseColor(status.cor ?? '', Colors.grey)),
                );
              }).where((w) => w != const SizedBox.shrink()).toList(),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 10,
          children: statuses.where((s) => (s.quantidade ?? 0) > 0).map((status) {
            return Text(
              '${status.status}: ${status.quantidade}',
              style: const TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.w500),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTaskBreakdownItem(String label, int value, Color color) {
    return Column(
      children: [
        Text('$value', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.black54)),
      ],
    );
  }

  Widget _buildRateIndicator(String label, double value, Color color) {
    return Column(
      children: [
        Text('${value.toStringAsFixed(0)}%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.black54)),
      ],
    );
  }

  Widget _buildRateGauge(String label, double value, Color color) {
    return SizedBox(
      width: 60,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: CustomPaint(
              painter: _GaugePainter(value: value, color: color, strokeWidth: 5),
            ),
          ),
          const SizedBox(height: 2),
          Text('${value.toStringAsFixed(0)}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(fontSize: 8, color: Colors.black54), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildTeamStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.black54)),
      ],
    );
  }

  /// Formata número para exibição compacta (1.2k, 1.5M)
  String _formatNumber(double value) {
    final intValue = value.toInt();
    if (intValue >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1).replaceAll('.0', '')}M';
    }
    if (intValue >= 1000) {
      return '${(value / 1000).toStringAsFixed(1).replaceAll('.0', '')}k';
    }
    return intValue.toString();
  }

  /// Obtém abreviação do mês para exibição compacta
  String _getMonthAbbreviation(String month) {
    if (month.isEmpty) return '';
    const months = {
      'jan': 'Jan', 'janeiro': 'Jan', 'january': 'Jan',
      'fev': 'Fev', 'fevereiro': 'Fev', 'february': 'Fev',
      'mar': 'Mar', 'março': 'Mar', 'march': 'Mar', 'marco': 'Mar',
      'abr': 'Abr', 'abril': 'Abr', 'april': 'Abr',
      'mai': 'Mai', 'maio': 'Mai', 'may': 'Mai',
      'jun': 'Jun', 'junho': 'Jun', 'june': 'Jun',
      'jul': 'Jul', 'julho': 'Jul', 'july': 'Jul',
      'ago': 'Ago', 'agosto': 'Ago', 'august': 'Ago',
      'set': 'Set', 'setembro': 'Set', 'september': 'Set',
      'out': 'Out', 'outubro': 'Out', 'october': 'Out',
      'nov': 'Nov', 'novembro': 'Nov', 'november': 'Nov',
      'dez': 'Dez', 'dezembro': 'Dez', 'december': 'Dez', 'dec': 'Dez',
    };
    final lower = month.toLowerCase().trim();
    return months[lower] ?? month.substring(0, month.length > 3 ? 3 : month.length);
  }

  Widget _buildMiniTrendChart(List<HomeProducaoMensal> data) {
    final values = data.map((d) => d.quantidade ?? 0).toList();
    final labels = data.map((d) => d.mes ?? '').toList();
    if (values.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 50,
      child: CustomPaint(
        painter: _SparklinePainter(values: values.map((v) => v.toDouble()).toList(), labels: labels, lineColor: const Color(0xFF2563EB), fillColor: const Color(0xFF2563EB).withValues(alpha: 0.13)),
        size: const Size(double.infinity, 50),
      ),
    );
  }

  String _formatCulturas(List<HomeCultura>? culturas) {
    if (culturas == null || culturas.isEmpty) return 'Nenhuma';
    if (culturas.length == 1) {
      return '${culturas.first.nome}\n${culturas.first.quantidade} lotes';
    }
    // Formato mais legível para múltiplas culturas
    final top3 = culturas.take(3).toList();
    if (top3.length == 2) {
      return '${top3[0].nome}: ${top3[0].quantidade}\n${top3[1].nome}: ${top3[1].quantidade}';
    }
    return top3.map((c) => '${c.nome}: ${c.quantidade}').join('\n');
  }

  String _formatPeriodoProducao(HomeProducao? producao) {
    if (producao == null ||
        producao.periodoInicio == null ||
        producao.periodoFim == null) {
      return 'plantas colhidas';
    }
    try {
      final inicio = DateTime.parse(producao.periodoInicio!);
      final fim = DateTime.parse(producao.periodoFim!);
      final inicioFormatado = '${inicio.day}/${inicio.month}/${inicio.year}';
      final fimFormatado = '${fim.day}/${fim.month}/${fim.year}';
      return 'de $inicioFormatado a $fimFormatado';
    } catch (e) {
      return 'plantas colhidas';
    }
  }

  // Métodos de navegação do carousel removidos - agora todos os cards são exibidos simultaneamente

  Widget _buildMetricCard(
    BuildContext context,
    Size size,
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    // Tamanhos responsivos
    final iconSize = ResponsiveBreakpoints.responsiveWidth(
      context,
      mobile: size.width * 0.10,
      tablet: 48,
      desktop: 56,
    );

    final valueFontSize = ResponsiveBreakpoints.responsiveFontSize(
      context,
      mobile: size.width * 0.10,
      tablet: 32,
      desktop: 38,
    );

    final titleFontSize = ResponsiveBreakpoints.responsiveFontSize(
      context,
      mobile: 13,
      tablet: 15,
      desktop: 17,
    );

    final subtitleFontSize = ResponsiveBreakpoints.responsiveFontSize(
      context,
      mobile: 11,
      tablet: 12,
      desktop: 13,
    );

    final padding = ResponsiveBreakpoints.responsivePadding(
      context,
      mobile: 16,
      tablet: 22,
      desktop: 28,
    );

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          // Ícone maior e mais destacado
          Container(
            padding: EdgeInsets.all(padding * 0.5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: color,
              size: iconSize,
            ),
          ),
          SizedBox(height: size.height * 0.015),
          // Valor principal - muito maior
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  height: 1.2,
                  letterSpacing: -1,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.008),
          // Título
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            SizedBox(height: size.height * 0.006),
            // Subtítulo
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSmartShortcutCard(
    BuildContext context,
    Size size,
    ShortcutModel shortcut,
  ) {
    return InkWell(
      onTap: () {
        // Bloquear cliques duplos enquanto um lote está sendo carregado
        if (GetIt.I<LoteStore>().isLoadingLotePorId) return;

        NavigationAnalytics.logShortcutClick(
            shortcut.route, shortcut.confidence);

        // Se tiver resourceId, navegar com recurso específico
        if (shortcut.resourceId != null && shortcut.resourceType != null) {
          _navigateWithResource(shortcut);
        } else {
          Get.toNamed(shortcut.route);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: shortcut.confidence > 0.7
              ? Border.all(
                  color: shortcut.color.withValues(alpha: 0.3),
                  width: 2,
                )
              : null,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 2),
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRect(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Observer(
                    builder: (_) {
                      final isLoading =
                          GetIt.I<LoteStore>().isLoadingLotePorId &&
                              shortcut.resourceType == 'lote';
                      return Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: shortcut.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: isLoading
                              ? SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: shortcut.color,
                                  ),
                                )
                              : SvgPicture.asset(
                                  shortcut.icon,
                                  width: 16,
                                  height: 16,
                                  colorFilter: ColorFilter.mode(
                                    shortcut.color,
                                    BlendMode.srcIn,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                  if (shortcut.confidence > 0.7)
                    Positioned(
                      top: -1,
                      right: -1,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: shortcut.color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            '⭐',
                            style: TextStyle(fontSize: 6),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  shortcut.displayTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Navega para uma rota com recurso específico.
  /// Para lotes, busca os detalhes via API e prepara o store antes de navegar.
  /// Para setores, seta o setor no store e navega para a lista de lotes.
  Future<void> _navigateWithResource(ShortcutModel shortcut) async {
    if (shortcut.resourceType == 'lote' && shortcut.resourceId != null) {
      final id = int.tryParse(shortcut.resourceId!);
      if (id == null) {
        Get.toNamed(shortcut.route);
        return;
      }

      final loteStore = GetIt.I<LoteStore>();
      final success = await loteStore.buscarLotePorId(id);
      if (success) {
        Get.toNamed(
          Routes.detalhesLotePage,
          arguments: NavigationResourceArgs(
            resourceId: shortcut.resourceId,
            resourceType: 'lote',
            resourceName: shortcut.resourceName,
          ),
        );
      }
      return;
    }

    if (shortcut.resourceType == 'setor' && shortcut.resourceId != null) {
      final id = int.tryParse(shortcut.resourceId!);
      if (id == null) {
        Get.toNamed(shortcut.route);
        return;
      }

      GetIt.I<LoteStore>()
          .setSetorSelecionado(Setor(id: id, nome: shortcut.resourceName));
      Get.toNamed(
        Routes.lotePage,
        arguments: NavigationResourceArgs(
          resourceId: shortcut.resourceId,
          resourceType: 'setor',
          resourceName: shortcut.resourceName,
        ),
      );
      return;
    }

    Get.toNamed(shortcut.route);
  }

  // Método removido: botões de carousel não são mais necessários
}

// ============================================================
// CUSTOM PAINTERS PARA GAUGES E SPARKLINES
// ============================================================

class _GaugePainter extends CustomPainter {
  final double value;
  final Color color;
  final double strokeWidth;

  _GaugePainter({
    required this.value,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Fundo
    final bgPaint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, bgPaint);

    // Progresso
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (value / 100) * 2 * 3.14159;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> values;
  final List<String>? labels;
  final Color lineColor;
  final Color fillColor;

  _SparklinePainter({
    required this.values,
    this.labels,
    required this.lineColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final maxVal = values.reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) return;

    final padding = 16.0;
    final chartWidth = size.width;
    final chartHeight = size.height - padding;

    // Criar pontos
    final points = <Offset>[];
    for (int i = 0; i < values.length; i++) {
      final x = values.length > 1 ? (i / (values.length - 1)) * chartWidth : chartWidth / 2;
      final y = chartHeight - (values[i] / maxVal) * chartHeight;
      points.add(Offset(x, y));
    }

    // Desenhar área preenchida
    final fillPath = Path()..moveTo(points[0].dx, chartHeight);
    for (final point in points) {
      fillPath.lineTo(point.dx, point.dy);
    }
    fillPath.lineTo(points.last.dx, chartHeight);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);

    // Desenhar linha
    final linePath = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(linePath, paint);

    // Desenhar labels
    if (labels != null && labels!.length == values.length) {
      for (int i = 0; i < labels!.length; i++) {
        final x = values.length > 1 ? (i / (labels!.length - 1)) * chartWidth : chartWidth / 2;
        textPainter.text = TextSpan(
          text: labels![i],
          style: const TextStyle(fontSize: 8, color: Colors.black54),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, chartHeight + 1),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.labels != labels;
  }
}

class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  const MyHeaderDelegate();

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    HomeStore store = GetIt.I<HomeStore>();
    final progress = shrinkOffset / maxExtent;
    final opacity = (1 - progress).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Constants.kPrimaryColor.withValues(alpha: 0.08),
            Constants.kBackgroundColor,
          ],
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Constants.kPrimaryColor.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Row(
            children: [
            // Botão menu
            GestureDetector(
              onTap: () => store.setIsCollaped(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Constants.kPrimaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.menu_rounded,
                  color: Constants.kPrimaryColor,
                  size: 22,
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Nome e cargo
            Expanded(
              child: Opacity(
                opacity: opacity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Observer(
                      builder: (_) {
                        final nome = store
                                .authController
                                .usuario
                                .selected_conta
                                ?.conta
                                ?.nome ??
                            '';
                        return Text(
                          nome.isNotEmpty ? 'Olá, $nome' : 'Olá',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                    const SizedBox(height: 2),
                    Observer(
                      builder: (_) {
                        final cargo = store
                                .authController
                                .usuario
                                .selected_conta
                                ?.cargo
                                ?.cargo ??
                            '';
                        if (cargo.isEmpty) return const SizedBox.shrink();
                        return Text(
                          cargo,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
          ],
        ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 72;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
