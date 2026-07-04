import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_primary_button.dart';

class StepNavigationFooter extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final bool canGoBack;
  final bool canGoForward;
  final bool isLastStep;
  final bool isLoading;
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final VoidCallback? onSubmit;

  const StepNavigationFooter({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.canGoBack,
    required this.canGoForward,
    required this.isLastStep,
    required this.isLoading,
    this.onBack,
    this.onNext,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          TextButton.icon(
            icon: const Icon(Icons.chevron_left, size: 18),
            onPressed: canGoBack ? onBack : null,
            label: const Text('Voltar'),
            style: TextButton.styleFrom(
              foregroundColor:
                  canGoBack ? Constants.kPrimaryColor : Constants.kGreyMedium,
            ),
          ),
          const Spacer(),
          Text(
            'Etapa ${currentStep + 1} de $totalSteps',
            style: const TextStyle(
              color: Constants.kGreyText2,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 130,
            child: AppPrimaryButton(
              label: isLastStep ? 'Salvar' : 'Avançar',
              icon: isLastStep ? null : Icons.chevron_right,
              onPressed: isLastStep ? onSubmit : onNext,
              isEnabled: canGoForward,
              isLoading: isLastStep ? isLoading : false,
              isFullWidth: false,
              size: AppButtonSize.compact,
            ),
          ),
        ],
      ),
    );
  }
}
