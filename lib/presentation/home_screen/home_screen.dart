import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../models/expense_model.dart';
import '../../routes/app_routes.dart';
import 'controller/home_controller.dart';



// ───────────────────────── Colors (from tailwind config) ─────────────────────────
class AppColors {
  static const teal = Color(0xFF2F7E79);
  static const teal600 = Color(0xFF2A716C);
  static const teal700 = Color(0xFF205753);
  static const teal50 = Color(0xFFF0F7F7);
  static const teal100 = Color(0xFFDDEEED);
  static const appDark = Color(0xFF222222);
  static const appGray = Color(0xFF666666);
  static const appMuted = Color(0xFFAAAAAA);
  static const incomeGreen = Color(0xFF25A969);
  static const expenseRed = Color(0xFFF95B51);
  static const background = Color(0xFFFAFAFA);
  static const rose50 = Color(0xFFFFF1F2);
}

// Shadows (from tailwind config)
const subtleShadow = [
  BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2)),
];
const cardShadow = [
  BoxShadow(
    color: Color(0x402F7E79),
    blurRadius: 24,
    spreadRadius: -4,
    offset: Offset(0, 8),
  ),
];
const fabShadow = [
  BoxShadow(color: Color(0x662F7E79), blurRadius: 16, offset: Offset(0, 6)),
];



// ───────────────────────── Home Page ─────────────────────────
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: _HomeBody(),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderGreeting(),
          SizedBox(height: 20),
          BalanceCard(),
          SizedBox(height: 20),
          SummaryWidgets(),
          SizedBox(height: 24),
          TransactionsHistory(),
        ],
      ),
    );
  }
}

// ───────────────────────── Header Greeting ─────────────────────────
class HeaderGreeting extends StatelessWidget {
  const HeaderGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good afternoon,',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.appMuted,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
            Text(
              'Sahal Muhammed',
              style: TextStyle(
                fontSize: 20,
                color: AppColors.appDark,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {},
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: subtleShadow,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 20,
                color: Color(0xFF525252),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ───────────────────────── Balance Card ─────────────────────────
class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ExpenseController>();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.teal, AppColors.teal700],
        ),
        boxShadow: cardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TOTAL BALANCE',
                  style: TextStyle(
                    color: AppColors.teal100,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.6,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: const Icon(
                    Icons.more_horiz_rounded,
                    size: 20,
                    color: Color(0xB3FFFFFF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Obx(() => Text(
              '\$ ${c.balance.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.6,
              ),
            )),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: Obx(() => _StatPill(
                    label: 'INCOME',
                    amount: '\$ ${c.totalIncome.toStringAsFixed(2)}',
                    icon: Icons.arrow_downward_rounded,
                    iconColor: const Color(0xFF6EE7B7),
                  )),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() => _StatPill(
                    label: 'EXPENSES',
                    amount: '\$ ${c.totalExpense.toStringAsFixed(2)}',
                    icon: Icons.arrow_upward_rounded,
                    iconColor: const Color(0xFFFDA4AF),
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String amount;
  final IconData icon;
  final Color iconColor;

  const _StatPill({
    required this.label,
    required this.amount,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x33FFFFFF),
            ),
            child: Icon(icon, size: 14, color: iconColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.teal100,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  amount,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Summary Widgets ─────────────────────────
class SummaryWidgets extends StatelessWidget {
  const SummaryWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ExpenseController>();

    return Obx(() => Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'DAILY AVERAGE',
            value: '\$ ${c.dailyAverage.toStringAsFixed(2)}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'WEEKLY',
            value: '\$ ${c.weeklyExpense.toStringAsFixed(2)}',
          ),
        ),
      ],
    ));
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: subtleShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.appMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.appDark,
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Transactions History ─────────────────────────
class TransactionsHistory extends StatelessWidget {
  const TransactionsHistory({super.key});

  IconData _iconFor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant_rounded;
      case 'transport':
        return Icons.directions_car_outlined;
      case 'shopping':
        return Icons.shopping_bag_outlined;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  String _prettyDate(String iso) {
    final d = DateTime.tryParse(iso);
    if (d == null) return iso;

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final now = DateTime.now();
    final diff = DateTime(now.year, now.month, now.day)
        .difference(DateTime(d.year, d.month, d.day))
        .inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ExpenseController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Transactions History',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.appDark,
              ),
            ),
            InkWell(
              onTap: () {},
              child: const Text(
                'See all',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.appGray,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          if (c.isLoading.value) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (c.expenses.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  'No transactions yet. Tap + to add one.',
                  style: TextStyle(color: AppColors.appMuted),
                ),
              ),
            );
          }
          return Column(
            children: c.expenses
                .map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TransactionItem(
                title: e.title,
                date: _prettyDate(e.date),
                amount:
                '${e.isIncome ? '+' : '-'} \$ ${e.amount.toStringAsFixed(2)}',
                isIncome: e.isIncome,
                icon: e.isIncome
                    ? Icons.account_balance_wallet_outlined
                    : _iconFor(e.category),
              ),
            ))
                .toList(),
          );
        }),
      ],
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final bool isIncome;
  final IconData icon;

  const TransactionItem({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.isIncome,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = isIncome ? AppColors.teal : AppColors.expenseRed;
    final Color iconBg = isIncome ? AppColors.teal50 : AppColors.rose50;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF9FAFB)),
        boxShadow: subtleShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 20, color: iconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.appDark,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.appMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isIncome ? AppColors.incomeGreen : AppColors.expenseRed,
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Bottom Navigation Bar ─────────────────────────
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return SizedBox(
      height: 100 + bottomInset,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // White bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 80 + bottomInset,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
              ),
            ),
          ),
          // Icons row
          Positioned(
            left: 8,
            right: 8,
            bottom: bottomInset,
            height: 80,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavIcon(icon: Icons.home_outlined, active: true),
                _NavIcon(icon: Icons.access_time_rounded),
                SizedBox(width: 56), // space for FAB
                _NavIcon(icon: Icons.credit_card_rounded),
                _NavIcon(icon: Icons.person_outline_rounded),
              ],
            ),
          ),
          // Raised FAB -> opens the Transaction screen
          Positioned(
            bottom: 32 + bottomInset,
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: fabShadow,
              ),
              child: Material(
                color: AppColors.teal,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  splashColor: AppColors.teal600,
                  onTap: () => Get.toNamed(AppRoutes.transaction),
                  child: const Icon(Icons.add_rounded,
                      size: 28, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool active;

  const _NavIcon({required this.icon, this.active = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {},
      child: SizedBox(
        width: 48,
        height: 48,
        child: Icon(
          icon,
          size: 24,
          color: active ? AppColors.teal : const Color(0xFF9CA3AF),
        ),
      ),
    );
  }
}