// ignore_for_file: file_names

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:sigma_hort_gestao_producao/core/constants/constants.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/viewmodels/solucao_store.dart';

class CustomTextFormField extends StatefulWidget {
  final Function(String)? onChanged;
  final String? value;

  const CustomTextFormField({Key? key, this.onChanged, this.value})
      : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  SolucaoStore store = GetIt.I<SolucaoStore>();
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.value ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CentavosInputFormatter(),
      ],
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Constants.kText2,
      ),
      decoration: const InputDecoration(
        suffixText: 'mg/L',
        suffixStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
          color: Constants.kButtonGrey,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Constants.kGreyLight,
            width: 2,
          ),
        ),
      ),
      onChanged: (String value) {
        widget.onChanged?.call(value);
        controller.selection =
            TextSelection.collapsed(offset: controller.text.length);
      },
    );
  }
}
