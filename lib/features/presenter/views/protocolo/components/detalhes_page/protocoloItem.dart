// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_entity_card.dart';

Padding protocoloItem({
  required int index,
  VoidCallback? onTap,
}) {
  ProtocoloStore store = GetIt.I<ProtocoloStore>();
  return Padding(
    padding: EdgeInsets.only(
      top: index == 0 ? 10 : 5,
      left: 10,
      right: 10,
    ),
    child: AppEntityCard(
      title: store.getProtocoloGroup[index].nome ?? '---',
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Constants.kPrimaryColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(
          Icons.assignment_outlined,
          color: Constants.kPrimaryColor,
          size: 24,
        ),
      ),
      metadata: [
        _ProtocolMetadata(
          label: 'Cultivos Alvo:',
          value: store.getProtocoloGroup[index].cultura?.nome ?? '---',
        ),
        _ProtocolMetadata(
          label: 'Lotes Vinculados:',
          value: '${store.getProtocoloGroup[index].lotes.where((l) => l.deleted_at == null).length} Lotes',
        ),
      ],
      onTap: () {
        store.alterarProtocoloSelecionado(store.getProtocoloGroup[index]);
        Get.toNamed(Routes.detalhesProtocoloPage);
      },
    ),
  );
}

class _ProtocolMetadata extends StatelessWidget {
  final String label;
  final String value;

  const _ProtocolMetadata({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(
              color: Constants.kText2,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Constants.kPrimaryColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
