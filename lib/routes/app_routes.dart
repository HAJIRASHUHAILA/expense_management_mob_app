import 'package:get/get.dart';

import '../presentation/home_screen/controller/home_controller.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/onboarding_screen/controller/onboarding_controller.dart';
import '../presentation/onboarding_screen/onboarding_screen.dart';
import '../presentation/splash_screen/controller/splash_controller.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/transaction_screen/controller/transaction_controller.dart';
import '../presentation/transaction_screen/transaction_screen.dart';

class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const transaction = '/transaction';


  static final pages = <GetPage>[
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      binding: BindingsBuilder(() => Get.put(SplashController())),
    ),
    GetPage(
      name: onboarding,
      page: () => const OnboardingScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => OnboardingController())),

    ),
    GetPage(
      name: home,
      page: () => const HomePage(),
      binding: BindingsBuilder(() => Get.lazyPut(() => ExpenseController())),

    ),

    GetPage(
      name: transaction,
      page: () => const TransactionScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => TransactionController())),
      transition: Transition.downToUp,
    ),
  ];
}