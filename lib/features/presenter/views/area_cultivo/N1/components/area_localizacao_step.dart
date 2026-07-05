import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/localizacao/localizacao_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/area_cultivo_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_dropdown.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_section.dart';

class AreaLocalizacaoStep extends StatefulWidget {
  final AreaCultivoStore store;

  const AreaLocalizacaoStep({super.key, required this.store});

  @override
  State<AreaLocalizacaoStep> createState() => _AreaLocalizacaoStepState();
}

class _AreaLocalizacaoStepState extends State<AreaLocalizacaoStep> {
  bool _showNewLocationForm = false;

  @override
  Widget build(BuildContext context) {
    final store = widget.store;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: _showNewLocationForm
          ? _buildNewLocationForm(store)
          : _buildSelectLocation(store),
    );
  }

  Widget _buildSelectLocation(AreaCultivoStore store) {
    return AppFormSection(
      title: 'Localização',
      description: 'Selecione a localização da área de cultivo.',
      isRequired: true,
      children: [
        Observer(builder: (_) {
          if (store.localizacaoList.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Nenhuma localização cadastrada.',
                style: TextStyle(color: Constants.kGreyText2),
              ),
            );
          }
          return AppDropdown<Localizacao>(
            value: store.localizacaoSelecionada.id != null
                ? store.localizacaoList.firstWhere(
                    (element) => element.id == store.localizacaoSelecionada.id,
                    orElse: () => store.localizacaoList.first,
                  )
                : null,
            hint: const Text('Selecionar localização'),
            items: store.localizacaoList.map((item) {
              return DropdownMenuItem<Localizacao>(
                value: item,
                child: Text(item.endereco ?? ''),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                final idx = store.localizacaoList.indexOf(value);
                if (idx >= 0) store.setLocalizacaoSelecionada(idx);
              }
            },
          );
        }),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => setState(() => _showNewLocationForm = true),
          child: const Text(
            '+ Nova localização',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Constants.kPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewLocationForm(AreaCultivoStore store) {
    return AppFormSection(
      title: 'Nova Localização',
      description: 'Preencha os dados da nova localização.',
      footer: TextButton(
        onPressed: () => setState(() => _showNewLocationForm = false),
        child: const Text(
          'Voltar para seleção',
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: Constants.kGreyText2,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Observer(builder: (_) {
            return TextFormField(
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CepInputFormatter(),
              ],
              onChanged: (value) async {
                if (value.length == 10) {
                  showDialog(
                    context: context,
                    builder: (_) => const Center(child: CircularProgressIndicator()),
                  );
                  await store.buscaCEP();
                  if (!mounted) return;
                  Navigator.pop(context);
                }
              },
              controller: store.cep,
              decoration: const InputDecoration(labelText: 'CEP'),
            );
          }),
          const SizedBox(height: 12),
          Observer(builder: (_) {
            return TextFormField(
              textInputAction: TextInputAction.next,
              controller: store.endereco,
              decoration: const InputDecoration(labelText: 'Endereço'),
            );
          }),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Observer(builder: (_) {
                  return TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: store.bairro,
                    decoration: const InputDecoration(labelText: 'Bairro'),
                  );
                }),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Observer(builder: (_) {
                  return TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: store.numero,
                    decoration: const InputDecoration(labelText: 'Número'),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Observer(builder: (_) {
            return TextFormField(
              textInputAction: TextInputAction.next,
              controller: store.cidade,
              decoration: const InputDecoration(labelText: 'Cidade'),
            );
          }),
          const SizedBox(height: 12),
          Observer(builder: (_) {
            return TextFormField(
              textInputAction: TextInputAction.next,
              controller: store.estado,
              decoration: const InputDecoration(labelText: 'Estado'),
            );
          }),
          const SizedBox(height: 12),
          Observer(builder: (_) {
            return TextFormField(
              textInputAction: TextInputAction.next,
              controller: store.pais,
              decoration: const InputDecoration(labelText: 'País'),
            );
          }),
          const SizedBox(height: 12),
          Observer(builder: (_) {
            return TextFormField(
              textInputAction: TextInputAction.done,
              controller: store.complemento,
              decoration: const InputDecoration(labelText: 'Complemento'),
            );
          }),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => store.cadastrarNovaLocalizacao(context),
              child: const Text(
                'Cadastrar localização',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
