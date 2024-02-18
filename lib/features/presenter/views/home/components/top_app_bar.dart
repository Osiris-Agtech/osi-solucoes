import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sigma_hort_gestao_producao/core/constants/constants.dart';
import 'package:sigma_hort_gestao_producao/core/services/local_storage.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/views/onboarding/splash_page.dart';

class TopAppBar extends StatelessWidget {
  const TopAppBar({
    Key? key,
    this.path,
    this.navigate,
    required this.namePage,
    this.subtitle,
    this.onPressed,
    this.showBackButton = false,
  }) : super(key: key);
  final bool? navigate;
  final String? path;
  final String namePage;
  final String? subtitle;
  final Function? onPressed;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        // top: MediaQuery.of(context).size.width * 0.02
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Visibility(
            visible: !showBackButton,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  onPressed: () async {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return const Center(child: CircularProgressIndicator());
                      },
                    );
                    await LocalStorage().deleteUser();
                    await Future.delayed(const Duration(seconds: 2));
                    Get.offAll(() => const SplashPage());
                  },
                  icon: SvgPicture.asset(
                    "assets/icons/external_link_icon.svg",
                    color: Constants.kPrimaryColor,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: showBackButton,
            child: IconButton(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              onPressed: () {
                if (onPressed != null) {
                  onPressed!.call();
                } else {
                  Get.close(1);
                }
              },
              icon: const Icon(Icons.arrow_back),
              color: Constants.kPrimaryColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.013,
              // top: showBackButton ? 0 : 32,
              // top: MediaQuery.of(context).size.height * 0.002
            ),
            child: Text(
              namePage,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (subtitle != null)
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.003,
                  left: MediaQuery.of(context).size.width * 0.013),
              child: Text(
                subtitle!,
                style: const TextStyle(
                  color: Color(0xff707070),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
        ],
      ),
    );
  }
}
