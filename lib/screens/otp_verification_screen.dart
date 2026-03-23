import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../utils/app_snackbar.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String whatsapp;

  const OtpVerificationScreen({super.key, required this.whatsapp});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  late FocusNode _firstFocusNode;
  int _resendCountdown = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _firstFocusNode = FocusNode();
    _startResendCountdown();
    // Auto-focus first OTP field
    Future.delayed(const Duration(milliseconds: 100), () {
      _firstFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    _firstFocusNode.dispose();
    super.dispose();
  }

  void _startResendCountdown() {
    _canResend = false;
    _resendCountdown = 60;

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendCountdown--;
          if (_resendCountdown == 0) {
            _canResend = true;
          }
        });
      }
      return _resendCountdown > 0;
    });
  }

  String _getOtpCode() {
    return _otpControllers.map((c) => c.text).join();
  }

  void _handleOtpInput(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      FocusScope.of(context).nextFocus();
    }
  }

  void _handleOtpBackspace(int index, String value) {
    if (value.isEmpty && index > 0) {
      FocusScope.of(context).previousFocus();
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _getOtpCode();

    if (otp.length != 6) {
      AppSnackBar.show(
        context,
        message: 'Mohon isi semua digit OTP',
        type: SnackBarType.warning,
      );
      return;
    }

    final authNotifier = ref.read(authProvider.notifier);
    final success = await authNotifier.verifyOtp(
      whatsapp: widget.whatsapp,
      otp: otp,
    );

    if (success && mounted) {
      AppSnackBar.show(
        context,
        message: 'Login berhasil!',
        type: SnackBarType.success,
      );

      // Get user role dari auth state
      final authState = ref.read(authProvider);
      final userRole = authState.user?.role;

      // Navigate based on role
      if (userRole == 'SELLER_RT') {
        Navigator.pushReplacementNamed(context, '/seller-main');
      } else {
        Navigator.pushReplacementNamed(context, '/main');
      }
    } else if (mounted) {
      final authState = ref.read(authProvider);
      AppSnackBar.show(
        context,
        message: authState.error ?? 'OTP verifikasi gagal',
        type: SnackBarType.error,
      );
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend) return;

    final authNotifier = ref.read(authProvider.notifier);
    final success = await authNotifier.sendOtp(whatsapp: widget.whatsapp);

    if (success && mounted) {
      AppSnackBar.show(
        context,
        message: 'OTP telah dikirim ulang',
        type: SnackBarType.success,
      );
      _startResendCountdown();
    } else if (mounted) {
      AppSnackBar.show(
        context,
        message: 'Gagal mengirim ulang OTP',
        type: SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF334155)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Title
                const Text(
                  'Verifikasi OTP',
                  style: TextStyle(
                    color: Color(0xFF334155),
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),

                // Subtitle
                Text(
                  'Kami telah mengirim kode verifikasi ke ${widget.whatsapp}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 40),

                // OTP Input Fields
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 50,
                        child: TextFormField(
                          controller: _otpControllers[index],
                          focusNode: index == 0 ? _firstFocusNode : null,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          inputFormatters: [],
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: const Color(0xFFF1F5F9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF0077B6),
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _handleOtpInput(index, value);
                            } else {
                              _handleOtpBackspace(index, value);
                            }
                          },
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 40),

                // Verify Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _verifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0077B6),
                      disabledBackgroundColor: const Color(0xFFCBD5E1),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Verifikasi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Resend Code
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Tidak menerima kode? ',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: _canResend ? _resendOtp : null,
                      child: Text(
                        _canResend
                            ? 'Kirim Ulang'
                            : 'Kirim Ulang (${_resendCountdown}s)',
                        style: TextStyle(
                          color: _canResend
                              ? const Color(0xFF0077B6)
                              : const Color(0xFFCBD5E1),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
