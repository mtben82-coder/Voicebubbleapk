import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../services/subscription_service.dart';

class PaywallScreen extends StatefulWidget {
  final VoidCallback onSubscribe;
  final VoidCallback onRestore;
  final VoidCallback onClose;
  
  const PaywallScreen({
    super.key,
    required this.onSubscribe,
    required this.onRestore,
    required this.onClose,
  });

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> with SingleTickerProviderStateMixin {
  final SubscriptionService _subscriptionService = SubscriptionService();
  
  bool _isLoading = true;
  bool _isPurchasing = false;
  String _selectedPlan = 'yearly';
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _initIAP();
  }

  Future<void> _initIAP() async {
    try {
      await _subscriptionService.initialize();
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _attemptBuy() async {
    if (_isPurchasing) return;
    setState(() => _isPurchasing = true);

    final productId = _selectedPlan == 'yearly'
        ? SubscriptionService.yearlyProductId
        : SubscriptionService.monthlyProductId;

    final success = await _subscriptionService.purchaseSubscription(productId);

    if (!success) {
      setState(() {
        _isPurchasing = false;
        _errorMessage = 'Purchase failed or cancelled.';
      });
    } else {
      // Purchase will complete or fail in the subscription callback
      setState(() {});
    }
  }

  Future<void> _restore() async {
    if (_isPurchasing) return;
    setState(() {
      _isPurchasing = true;
      _errorMessage = null;
    });

    await _subscriptionService.restorePurchases();
    final active = await _subscriptionService.hasActiveSubscription();

    if (active && mounted) {
      widget.onRestore();
      widget.onClose();
    } else {
      setState(() {
        _errorMessage = 'No active purchases found.';
        _isPurchasing = false;
      });
    }
  }

  ProductDetails? get _monthly => _subscriptionService.monthlyProduct;
  ProductDetails? get _yearly => _subscriptionService.yearlyProduct;

  String getPricingText() {
    if (_isLoading) return 'Loading...';

    final product = _selectedPlan == 'yearly' ? _yearly : _monthly;
    if (product == null) return 'Free 1 day, then subscribe. Cancel anytime.';

    final sub = product.subscriptionPeriod ?? '';
    final per = sub.contains('Y') ? 'per year' : sub.contains('M') ? 'per month' : '';

    return 'Free for 1 day, then ${product.price} $per. Cancel anytime.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(.75),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, constraints) {
            return Stack(
              children: [
                Center(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF0D47A1),
                          Color(0xFF1565C0),
                          Color(0xFF1E88E5),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        // Title
                        const Text(
                          "Unlock Premium",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Get unlimited Voicebubble power",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withOpacity(.9),
                          ),
                        ),
                        const SizedBox(height: 26),

                        // PLAN SELECTOR AT THE TOP
                        _buildPlans(),
                        const SizedBox(height: 26),

                        // FEATURES (TIGHT)
                        _feature(Icons.timer_rounded, "90 Minutes Speech-to-Text"),
                        _feature(Icons.auto_awesome_rounded, "Premium AI Models (GPT-4)"),
                        _feature(Icons.palette_rounded, "Unlimited Custom Presets"),
                        _feature(Icons.cloud_sync_rounded, "Cloud Sync"),
                        _feature(Icons.workspace_premium_rounded, "Priority Support"),
                        const SizedBox(height: 22),

                        // PRICE DESCRIPTION
                        Text(
                          getPricingText(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(.75),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // PURCHASE BUTTON
                        _actionBtn(
                          label: _isPurchasing ? "Processing..." : "Subscribe",
                          onTap: _isPurchasing ? null : _attemptBuy,
                          filled: true,
                        ),
                        const SizedBox(height: 8),

                        // FREE TRIAL CLOSE
                        _actionBtn(
                          label: "Continue Free for 1 Day",
                          onTap: widget.onClose,
                        ),
                        const SizedBox(height: 8),

                        // RESTORE
                        TextButton(
                          onPressed: _isPurchasing ? null : _restore,
                          child: Text(
                            "Restore Purchase",
                            style: TextStyle(
                              color: Colors.white.withOpacity(.8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        if (_errorMessage != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // CLOSE BUTTON
                Positioned(
                  right: 14,
                  top: 12,
                  child: GestureDetector(
                    onTap: widget.onClose,
                    child: const Icon(Icons.close_rounded, color: Colors.white, size: 32),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _feature(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(6),
            child: Icon(icon, size: 20, color: const Color(0xFF0D47A1)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 22),
        ],
      ),
    );
  }

  Widget _buildPlans() {
    final m = _monthly?.price ?? "\$4.99";
    final y = _yearly?.price ?? "\$49.99";

    return Row(
      children: [
        Expanded(child: _plan("Monthly", m, "monthly")),
        const SizedBox(width: 10),
        Expanded(child: _plan("Yearly", y, "yearly", save: "Save 30%")),
      ],
    );
  }

  Widget _plan(String title, String price, String val, {String? save}) {
    final selected = _selectedPlan == val;

    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = val),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.white.withOpacity(.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? Colors.white : Colors.white.withOpacity(.3),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            if (save != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(save, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
              ),
            if (save != null) const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: selected ? const Color(0xFF0D47A1) : Colors.white,
              ),
            ),
            Text(
              price,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w900,
                color: selected ? const Color(0xFF0D47A1) : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn({required String label, required VoidCallback? onTap, bool filled = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: filled ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white, width: filled ? 0 : 2),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: filled ? const Color(0xFF0D47A1) : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
