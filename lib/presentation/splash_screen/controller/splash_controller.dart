import 'dart:async';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _timer = Timer(const Duration(seconds: 3), () {
      Get.offAllNamed(AppRoutes.onboarding);
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}