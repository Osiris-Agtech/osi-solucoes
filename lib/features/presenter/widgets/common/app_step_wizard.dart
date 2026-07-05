import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/components/cadastrar_page/step_progress_bar.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/components/cadastrar_page/step_navigation_footer.dart';

/// Reusable multi-step wizard component.
///
/// Encapsulates the common wizard pattern used across cadastro flows:
///   1. A [StepProgressBar] with labels and completed/dot indicators
///   2. A [CarouselSlider] body area with non-scrollable pages
///   3. A [StepNavigationFooter] with back/step-counter/next-or-submit controls
class AppStepWizard extends StatefulWidget {
  /// The list of step page widgets to display in order.
  final List<Widget> steps;

  /// Called when the user presses the submit button on the final step.
  final VoidCallback onSubmit;

  /// Labels for the progress bar, one per step.
  final List<String> stepLabels;

  /// Text for the final action button (defaults to 'Salvar').
  ///
  /// Note: [StepNavigationFooter] currently hardcodes the submit label;
  /// this parameter is reserved for future customization.
  final String submitLabel;

  const AppStepWizard({
    super.key,
    required this.steps,
    required this.onSubmit,
    required this.stepLabels,
    this.submitLabel = 'Salvar',
  });

  @override
  State<AppStepWizard> createState() => _AppStepWizardState();
}

class _AppStepWizardState extends State<AppStepWizard> {
  int _currentStep = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  int get _totalSteps => widget.steps.length;

  bool get _isFirstStep => _currentStep == 0;

  bool get _isLastStep => _currentStep == _totalSteps - 1;

  /// Steps before the current one are considered completed.
  Set<int> get _completedSteps =>
      {for (int i = 0; i < _currentStep; i++) i};

  void _onNext() {
    if (_isLastStep) {
      widget.onSubmit();
      return;
    }
    setState(() => _currentStep++);
    _carouselController.nextPage();
  }

  void _onBack() {
    if (_isFirstStep) return;
    setState(() => _currentStep--);
    _carouselController.previousPage();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StepProgressBar(
          currentStep: _currentStep,
          stepLabels: widget.stepLabels,
          completedSteps: _completedSteps,
          totalSteps: _totalSteps,
        ),
        Expanded(
          child: CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              enableInfiniteScroll: false,
              height: double.infinity,
              viewportFraction: 1.0,
              scrollPhysics: const NeverScrollableScrollPhysics(),
            ),
            items: widget.steps,
          ),
        ),
        StepNavigationFooter(
          currentStep: _currentStep,
          totalSteps: _totalSteps,
          canGoBack: !_isFirstStep,
          canGoForward: true,
          isLastStep: _isLastStep,
          isLoading: false,
          onBack: _onBack,
          onNext: _onNext,
          onSubmit: widget.onSubmit,
        ),
      ],
    );
  }
}
