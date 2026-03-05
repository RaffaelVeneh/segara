import 'package:flutter/material.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final String role; // 'buyer' or 'mitra'

  const LoginScreen({
    super.key,
    required this.role,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // Hardcoded credentials
  final Map<String, Map<String, String>> _credentials = {
    'buyer': {
      'email': 'buyer@email.com',
      'password': 'segara123',
    },
    'mitra': {
      'email': 'mitra@email.com',
      'password': 'segara123',
    },
  };

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final expectedEmail = _credentials[widget.role]!['email']!;
    final expectedPassword = _credentials[widget.role]!['password']!;

    if (_emailController.text.trim() == expectedEmail &&
        _passwordController.text == expectedPassword) {
      // Login success
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Login berhasil sebagai ${widget.role == 'buyer' ? 'Pembeli' : 'Mitra'}!',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // TODO: Navigate to main screen based on role
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(role: widget.role)));
      }
    } else {
      // Login failed
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email atau password salah!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterScreen(role: widget.role),
      ),
    );
  }

  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lupa Password?'),
        content: const Text(
          'Fitur reset password akan segera tersedia. Silakan hubungi admin untuk bantuan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roleLabel = widget.role == 'buyer' ? 'Pembeli' : 'Mitra';

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
                const SizedBox(height: 20),

                // Main card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFF1F5F9),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 25,
                        offset: const Offset(0, 20),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 10,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header section with logo
                      Container(
                        padding: const EdgeInsets.only(top: 48, bottom: 48),
                        child: Column(
                          children: [
                            // Logo
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  'assets/icons/logo-segara.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: const Color(0xFF0077B6),
                                      child: const Icon(
                                        Icons.waves,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Title
                            const Text(
                              'Selamat Datang',
                              style: TextStyle(
                                color: Color(0xFF334155),
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                height: 32 / 24,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Subtitle with role
                            Text(
                              'Masuk sebagai $roleLabel',
                              style: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                height: 20 / 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Form section
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Email field
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Email atau Nomor Ponsel',
                                    style: TextStyle(
                                      color: Color(0xFF334155),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      height: 16 / 12,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: 'Masukkan email atau nomor ponsel',
                                      hintStyle: const TextStyle(
                                        color: Color(0xFF94A3B8),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
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
                                          width: 1,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 44,
                                        vertical: 15,
                                      ),
                                      prefixIcon: const Padding(
                                        padding: EdgeInsets.only(left: 16, right: 12),
                                        child: Icon(
                                          Icons.email_outlined,
                                          color: Color(0xFF94A3B8),
                                          size: 18,
                                        ),
                                      ),
                                      prefixIconConstraints: const BoxConstraints(
                                        minWidth: 44,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Email tidak boleh kosong';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Password field
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Kata Sandi',
                                    style: TextStyle(
                                      color: Color(0xFF334155),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      height: 16 / 12,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: !_isPasswordVisible,
                                    decoration: InputDecoration(
                                      hintText: 'Masukkan kata sandi',
                                      hintStyle: const TextStyle(
                                        color: Color(0xFF94A3B8),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
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
                                          width: 1,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 44,
                                        vertical: 15,
                                      ),
                                      prefixIcon: const Padding(
                                        padding: EdgeInsets.only(left: 16, right: 12),
                                        child: Icon(
                                          Icons.lock_outline,
                                          color: Color(0xFF94A3B8),
                                          size: 18,
                                        ),
                                      ),
                                      prefixIconConstraints: const BoxConstraints(
                                        minWidth: 44,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isPasswordVisible
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: const Color(0xFF94A3B8),
                                          size: 18,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordVisible = !_isPasswordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Password tidak boleh kosong';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 12),

                                  // Forgot password
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: _forgotPassword,
                                      child: const Text(
                                        'Lupa Password?',
                                        style: TextStyle(
                                          color: Color(0xFF0077B6),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          height: 16 / 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Login button
                              GestureDetector(
                                onTap: _isLoading ? null : _login,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment(-0.98, 0.17),
                                      end: Alignment(0.98, -0.17),
                                      colors: [Color(0xFF0077B6), Color(0xFF0096C7)],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF3B82F6).withOpacity(0.20),
                                        blurRadius: 15,
                                        offset: const Offset(0, 10),
                                      ),
                                      BoxShadow(
                                        color: const Color(0xFF3B82F6).withOpacity(0.20),
                                        blurRadius: 6,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text(
                                            'Masuk',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              height: 20 / 14,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Register link
                              Center(
                                child: GestureDetector(
                                  onTap: _goToRegister,
                                  child: RichText(
                                    text: const TextSpan(
                                      style: TextStyle(
                                        fontSize: 12,
                                        height: 16 / 12,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'Belum punya akun? ',
                                          style: TextStyle(
                                            color: Color(0xFF94A3B8),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Daftar Sekarang',
                                          style: TextStyle(
                                            color: Color(0xFF0077B6),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
