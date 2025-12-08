import 'package:flutter/material.dart';
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

class _PaywallScreenState extends State<PaywallScreen> {
  final SubscriptionService _subscriptionService = SubscriptionService();

  bool _isLoading = true;
  bool _isPurchasing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeIAP();
  }

  Future<void> _initializeIAP() async {
    try {
      await _subscriptionService.initialize();
    } catch (_) {}
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  Future<void> _handlePurchase() async {
    if (_isPurchasing) return;

    setState(() {
      _isPurchasing = true;
      _errorMessage = null;
    });

    const productId = SubscriptionService.monthlyProductId;

    try {
      final success = await _subscriptionService.purchaseSubscription(productId);

      // If user cancelled purchase popup
      if (!success) {
        if (!mounted) return;
        setState(() {
          _isPurchasing = false;
          _errorMessage = null;   // no error message
        });
        return;
      }

      await _waitForSubscriptionConfirmation();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isPurchasing = false;
        _errorMessage = 'An error occurred. Please try again.';
      });
    }
  }

  Future<void> _waitForSubscriptionConfirmation() async {
    for (int i = 0; i < 10; i++) {
      final hasSubscription = await _subscriptionService.hasActiveSubscription();
      if (hasSubscription) {
        if (!mounted) return;
        widget.onSubscribe();
        widget.onClose();
        return;
      }
      await Future.delayed(const Duration(seconds: 1));
    }

    if (!mounted) return;
    setState(() {
      _isPurchasing = false;
      _errorMessage =
          'Taking longer than expected. If charged, tap "Restore Purchase".';
    });
  }

  Future<void> _handleRestore() async {
    if (_isPurchasing) return;

    setState(() {
      _isPurchasing = true;
      _errorMessage = null;
    });

    try {
      await _subscriptionService.restorePurchases();
      final hasSubscription = await _subscriptionService.hasActiveSubscription();

      if (hasSubscription) {
        if (!mounted) return;
        widget.onRestore();
        widget.onClose();
      } else {
        if (!mounted) return;
        setState(() {
          _isPurchasing = false;
          _errorMessage = 'No purchases found to restore.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isPurchasing = false;
        _errorMessage = 'Failed to restore. Please try again.';
      });
    }
  }

  void _cancelProcessingAndClose() {
    setState(() {
      _isPurchasing = false;
      _errorMessage = null;
    });
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.75),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 24,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Unlock Premium',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Unlimited access with no restrictions.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 22),

                      _buildMonthlyPlan(),

                      const SizedBox(height: 16),
                      Text(
                        _pricingLine(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 14),

                      if (_errorMessage != null)
                        _buildError(),

                      _buildPrimaryButton(
                        label: _isPurchasing ? 'Processing...' : 'Subscribe',
                        onTap: _isLoading || _isPurchasing ? null : _handlePurchase,
                        filled: true,
                      ),
                      const SizedBox(height: 8),

                      _buildPrimaryButton(
                        label: 'Continue Free for 1 Day',
                        onTap: _isPurchasing ? null : widget.onClose,
                        filled: false,
                      ),
                      const SizedBox(height: 8),

                      TextButton(
                        onPressed: _isLoading || _isPurchasing ? null : _handleRestore,
                        child: Text(
                          'Restore Purchase',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                onPressed: _cancelProcessingAndClose,
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyPlan() {
    final monthly = _subscriptionService.monthlyProduct;
    final monthlyPrice = monthly?.price ?? '\$4.99';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            'Monthly',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            monthlyPrice,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0D47A1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.red.withOpacity(0.6),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _pricingLine() {
    if (_isLoading) return 'Loading pricing...';
    final monthly = _subscriptionService.monthlyProduct;
    if (monthly == null) return 'Free for 1 day, then subscribe. Cancel anytime.';
    return 'Free for 1 day, then ${monthly.price} per month. Cancel anytime.';
  }

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback? onTap,
    required bool filled,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: filled ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white,
            width: filled ? 0 : 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: filled ? const Color(0xFF0D47A1) : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
