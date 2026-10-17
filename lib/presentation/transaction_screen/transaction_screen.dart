import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/transaction_controller.dart';

// ───────────────────────── Colors ─────────────────────────
class TxColors {
  static const teal = Color(0xFF368983);
  static const darkTeal = Color(0xFF2F7E79);
  static const inputBorder = Color(0xFFE0E5EC);
  static const labelGray = Color(0xFF7E8A97);
  static const background = Color(0xFFF7F9FA);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate400 = Color(0xFF94A3B8);
  static const slate500 = Color(0xFF64748B);
  static const slate800 = Color(0xFF1E293B);
}

const txCardShadow = [
  BoxShadow(
    color: Color(0x142F7E79),
    blurRadius: 30,
    spreadRadius: -4,
    offset: Offset(0, 10),
  ),
  BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 16,
    spreadRadius: -2,
    offset: Offset(0, 4),
  ),
];
const txFloatBtnShadow = [
  BoxShadow(color: Color(0x592F7E79), blurRadius: 20, offset: Offset(0, 8)),
];

// ───────────────────────── Transaction Screen ─────────────────────────
class TransactionScreen extends GetView<TransactionController> {
  const TransactionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final headerHeight = topInset + 12 + 40 + 96;

    return Scaffold(
      backgroundColor: TxColors.background,
      body: Stack(
        children: [
          // Teal header
          Container(
            height: headerHeight,
            width: double.infinity,
            color: TxColors.darkTeal,
            padding: EdgeInsets.only(top: topInset + 12, left: 20, right: 20),
            alignment: Alignment.topCenter,
            child: const TopNavigation(),
          ),
          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(20, headerHeight - 64, 20, 24),
            child: Column(
              children: [
                TransactionFormCard(controller: controller),
                const SizedBox(height: 24),
                SaveButton(controller: controller),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavDock(),
    );
  }
}

// ───────────────────────── Top Navigation ─────────────────────────
class TopNavigation extends StatelessWidget {
  const TopNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            tooltip: 'Go Back',
            onPressed: () => Get.back(),
            icon: const Icon(Icons.chevron_left_rounded,
                size: 30, color: Colors.white),
          ),
          const Text(
            'Transaction',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

// ───────────────────────── Form Card ─────────────────────────
class TransactionFormCard extends StatelessWidget {
  final TransactionController controller;
  const TransactionFormCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final c = controller;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: TxColors.slate100),
        boxShadow: txCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Transaction Type
          LabeledField(
            label: 'Transaction Type',
            child: Obx(() => SizedBox(
              height: 48,
              child: InputDecorator(
                decoration: fieldDecoration().copyWith(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: c.type.value,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(12),
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                        size: 18, color: TxColors.slate400),
                    style: fieldTextStyle,
                    items: const [
                      DropdownMenuItem(
                          value: 'expense', child: Text('Expense')),
                      DropdownMenuItem(
                          value: 'income', child: Text('Income')),
                    ],
                    onChanged: (v) {
                      if (v != null) c.type.value = v;
                    },
                  ),
                ),
              ),
            )),
          ),
          const SizedBox(height: 20),

          // Name
          LabeledField(
            label: 'Name',
            child: TextField(
              controller: c.name,
              style: fieldTextStyle,
              cursorColor: TxColors.teal,
              textCapitalization: TextCapitalization.sentences,
              decoration:
              fieldDecoration().copyWith(hintText: 'e.g. Netflix, Spotify'),
            ),
          ),
          const SizedBox(height: 20),

          // Amount
          LabeledField(
            label: 'Amount',
            child: TextField(
              controller: c.amount,
              focusNode: c.amountFocus,
              style: fieldTextStyle,
              cursorColor: TxColors.teal,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              decoration: fieldDecoration().copyWith(
                hintText: '0.00',
                suffixIconConstraints: const BoxConstraints(minWidth: 0),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: c.clearAmount,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      child: Text(
                        'Clear',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: TxColors.labelGray,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Date
          LabeledField(
            label: 'Date',
            child: TextField(
              controller: c.date,
              readOnly: true,
              showCursor: false,
              style: fieldTextStyle,
              decoration: fieldDecoration().copyWith(
                suffixIconConstraints: const BoxConstraints(minWidth: 0),
                suffixIcon: const Padding(
                  padding: EdgeInsets.only(right: 14),
                  child: Icon(Icons.calendar_today_outlined,
                      size: 20, color: TxColors.slate500),
                ),
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: c.selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) c.setDate(picked);
              },
            ),
          ),
        ],
      ),
    );
  }
}

const fieldTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: TxColors.slate800,
);

InputDecoration fieldDecoration() {
  OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: c, width: w),
  );
  return InputDecoration(
    isDense: true,
    filled: true,
    fillColor: Colors.white,
    hintStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: TxColors.slate400,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15.5),
    enabledBorder: border(TxColors.inputBorder),
    border: border(TxColors.inputBorder),
    focusedBorder: border(TxColors.teal, 1.5),
  );
}

class LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const LabeledField({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: TxColors.labelGray,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

// ───────────────────────── Save Button ─────────────────────────
class SaveButton extends StatelessWidget {
  final TransactionController controller;
  const SaveButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x1A000000), blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Material(
        color: TxColors.darkTeal,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: TxColors.teal,
          onTap: () {
            FocusScope.of(context).unfocus();
            if (!controller.isSaving.value) controller.save();
          },
          child: Center(
            child: Obx(() => controller.isSaving.value
                ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                  strokeWidth: 2.5, color: Colors.white),
            )
                : const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.4,
              ),
            )),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Bottom Navigation Dock ─────────────────────────
class BottomNavDock extends StatelessWidget {
  const BottomNavDock({super.key});

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.of(context).padding.bottom;
    final bottomPad = inset > 24 ? inset : 24.0;
    final barHeight = 12 + 40 + bottomPad;

    return SizedBox(
      height: barHeight + 16,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: barHeight,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: TxColors.slate100)),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: bottomPad,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _DockIcon(
                    icon: Icons.home_outlined, label: 'Home', onTap: Get.back),
                const _DockIcon(
                    icon: Icons.access_time_rounded,
                    label: 'Transaction History'),
                const SizedBox(width: 56),
                const _DockIcon(
                    icon: Icons.credit_card_rounded, label: 'Wallet'),
                const _DockIcon(
                    icon: Icons.person_outline_rounded, label: 'Profile'),
              ],
            ),
          ),
          Positioned(
            bottom: bottomPad + 40 - 20 - 28,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: TxColors.darkTeal,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: txFloatBtnShadow,
              ),
              child: const Icon(Icons.add_rounded, size: 28, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _DockIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _DockIcon({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: label,
      onPressed: onTap ?? () {},
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints.tightFor(width: 40, height: 40),
      icon: Icon(icon, size: 24, color: TxColors.slate400),
    );
  }
}