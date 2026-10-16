import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  void getStarted() {
    Get.offAllNamed(AppRoutes.home);
  }
}