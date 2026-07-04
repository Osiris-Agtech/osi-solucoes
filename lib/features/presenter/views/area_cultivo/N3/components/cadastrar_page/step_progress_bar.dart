import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class StepProgressBar extends StatelessWidget {
  final int currentStep;
  final List<String> stepLabels;
  final Set<int> completedSteps;
  final int totalSteps;

  const StepProgressBar({
    super.key,
    required this.currentStep,
    required this.stepLabels,
    required this.completedSteps,
    required this.totalSteps,
  }) : assert(
          stepLabels.length == totalSteps,
          'stepLabels length ($totalSteps) must equal totalSteps',
        );

  @override
  Widget build(BuildContext context) {
    final stepCount = stepLabels.length;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(stepCount * 2 - 1, (index) {
        if (index.isOdd) {
          return _buildConnector(index ~/ 2);
        }
        return _buildStep(index ~/ 2);
      }),
    );
  }

  Widget _buildStep(int stepIndex) {
    final isCompleted = completedSteps.contains(stepIndex);
    final isCurrent = currentStep == stepIndex;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 24,
            child: Center(child: _buildIcon(isCompleted, isCurrent)),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              stepLabels[stepIndex],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                color: isCompleted || isCurrent
                    ? Constants.kPrimaryColor
                    : Constants.kGreyText2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(bool isCompleted, bool isCurrent) {
    if (isCompleted) {
      return const Icon(
        Icons.check_circle,
        color: Constants.kPrimaryColor,
        size: 24,
      );
    }
    if (isCurrent) {
      return Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: Constants.kPrimaryColor,
          shape: BoxShape.circle,
        ),
      );
    }
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Constants.kGreyText2, width: 2),
      ),
    );
  }

  Widget _buildConnector(int leftStep) {
    final rightStep = leftStep + 1;
    final isGreen =
        completedSteps.contains(leftStep) && completedSteps.contains(rightStep);
    return Expanded(
      child: SizedBox(
        height: 24,
        child: Center(
          child: Container(
            height: 2,
            color: isGreen ? Constants.kPrimaryColor : Constants.kGreyLight,
          ),
        ),
      ),
    );
  }
}
