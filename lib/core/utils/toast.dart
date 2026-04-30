import 'package:flutter/material.dart';

import '../constants/constants.dart';

/// Tipo de notificação
enum ToastType { error, success, warning, info }

/// Estado global de notificações para evitar dependência de Overlay
final _toastNotifier = ValueNotifier<ToastMessage?>(null);

/// Modelo de mensagem de toast
class ToastMessage {
  final String message;
  final ToastType type;
  final Duration duration;

  const ToastMessage({
    required this.message,
    required this.type,
    this.duration = const Duration(seconds: 3),
  });
}

/// Mostra um toast usando ScaffoldMessenger (não depende de Overlay)
/// Deve ser chamado com um BuildContext válido
void showToast({
  required BuildContext context,
  required String message,
  ToastType type = ToastType.error,
  Duration duration = const Duration(seconds: 3),
}) {
  if (!context.mounted) return;

  Color backgroundColor;
  switch (type) {
    case ToastType.error:
      backgroundColor = Colors.red;
      break;
    case ToastType.success:
      backgroundColor = Constants.kPrimaryColor;
      break;
    case ToastType.warning:
      backgroundColor = Colors.orange;
      break;
    case ToastType.info:
      backgroundColor = Colors.blue;
      break;
  }

  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

/// Notifica o estado de um toast (para uso em stores/MobX sem contexto)
void notifyToast(ToastMessage message) {
  _toastNotifier.value = message;
}

/// Observer para ouvir notificações de toast
ValueNotifier<ToastMessage?> get toastNotifier => _toastNotifier;

/// Limpa a notificação atual
void clearToast() {
  _toastNotifier.value = null;
}

class ToastListener extends StatelessWidget {
  final Widget child;

  const ToastListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ToastMessage?>(
      valueListenable: toastNotifier,
      builder: (context, toast, _) {
        if (toast != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            showToast(
              context: context,
              message: toast.message,
              type: toast.type,
              duration: toast.duration,
            );
            clearToast();
          });
        }

        return child;
      },
    );
  }
}

/// Funções auxiliares para uso em stores sem BuildContext
@Deprecated('Use notifyToast com ToastMessage ou showToast com BuildContext')
void toastError({required String? message}) {
  notifyToast(
    ToastMessage(
      message: message ?? 'Não foi possível realizar essa requisição',
      type: ToastType.error,
    ),
  );
}

@Deprecated('Use notifyToast com ToastMessage ou showToast com BuildContext')
void toastSuccess({required String message}) {
  notifyToast(
    ToastMessage(
      message: message,
      type: ToastType.success,
    ),
  );
}
