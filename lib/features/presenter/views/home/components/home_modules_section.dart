import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

import '../models/home_panel_view_data.dart';
import 'home_panel_shared.dart';

class HomeModulesSection extends StatefulWidget {
  final List<HomeModuleShortcutViewData> modules;
  final ValueChanged<HomeModuleShortcutViewData> onModuleTap;

  const HomeModulesSection({
    super.key,
    required this.modules,
    required this.onModuleTap,
  });

  @override
  State<HomeModulesSection> createState() => _HomeModulesSectionState();
}

class _HomeModulesSectionState extends State<HomeModulesSection> {
  static const int _compactModuleCount = 6;
  static const int _expandedModuleCount = 10;

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final canExpand = widget.modules.length > _compactModuleCount;
    final visibleModules = (_isExpanded
            ? widget.modules.take(_expandedModuleCount)
            : widget.modules.take(_compactModuleCount))
        .toList();

    return HomePanelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: HomeSectionTitle(
                  icon: Icons.apps_rounded,
                  title: 'Módulos principais',
                ),
              ),
              if (canExpand)
                TextButton(
                  onPressed: _toggleExpanded,
                  child: Text(_isExpanded ? 'Ver menos' : 'Ver todos'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth < 360
                    ? 1
                    : constraints.maxWidth >= 720
                        ? 3
                        : 2;
                final width =
                    (constraints.maxWidth - ((columns - 1) * 10)) / columns;
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: visibleModules
                      .map(
                        (module) => _ModuleTile(
                          width: width,
                          module: module,
                          onTap: () => widget.onModuleTap(module),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}

class _ModuleTile extends StatelessWidget {
  final double width;
  final HomeModuleShortcutViewData module;
  final VoidCallback onTap;

  const _ModuleTile({
    required this.width,
    required this.module,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: module.color.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                HomeAssetIcon(iconAsset: module.iconAsset, color: module.color),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.label,
                        style: homeTitleStyle(13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        module.description,
                        style: homeBodyStyle(Colors.black54),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
