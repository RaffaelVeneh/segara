import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  final String role; // 'buyer' or 'mitra'

  const RegisterScreen({
    super.key,
    required this.role,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Common fields
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  
  // Buyer specific
  bool _useTelephone = true; // true = phone, false = email
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _agreeTerms = false;
  
  // Mitra specific
  final _businessNameController = TextEditingController();
  final _nibController = TextEditingController();
  String? _selectedCategory;
  final _estimatedNeedController = TextEditingController();
  
  final List<String> _businessCategories = [
    'Rumah Makan',
    'Restoran',
    'Hotel',
    'Catering',
    'Pedagang Ikan',
    'Lainnya',
  ];

  // Photo verification
  final List<XFile?> _photos = List.filled(5, null);
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _businessNameController.dispose();
    _nibController.dispose();
    _estimatedNeedController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.role == 'buyer' && !_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus menyetujui syarat & ketentuan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pendaftaran berhasil! Silakan login dengan akun Anda.',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(role: widget.role),
        ),
      );
    }
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(role: widget.role),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBuyer = widget.role == 'buyer';
    final roleLabel = isBuyer ? 'Pembeli' : 'Mitra';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(roleLabel, isBuyer),

            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    
                    // Hero banner
                    if (isBuyer) _buildBuyerBanner(),
                    if (isBuyer) const SizedBox(height: 20),

                    // Form content
                    Form(
                      key: _formKey,
                      child: isBuyer ? _buildBuyerForm() : _buildMitraForm(),
                    ),
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // Bottom action
            _buildBottomAction(roleLabel),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String roleLabel, bool isBuyer) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(isBuyer ? 0 : 32),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF475569)),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  isBuyer
                      ? 'DAFTAR AKUN BARU & MITRA'
                      : '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.40,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          
          if (!isBuyer) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pendaftaran Mitra\nIKANURA',
                    style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 6.88),
                  const Text(
                    'Lengkapi data usaha Anda untuk mendapatkan\nakses harga kontrak',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.625,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildBuyerBanner() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: const Color(0xFF0077B6).withOpacity(0.20),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background image
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/register-hero.png',
              width: double.infinity,
              height: 160,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF0077B6).withOpacity(0.20),
                  child: const Center(
                    child: Icon(
                      Icons.group_add,
                      size: 60,
                      color: Colors.white54,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Color overlay (multiply blend)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0077B6).withOpacity(0.10),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          
          // Gradient overlay
          Positioned.fill(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0077B6).withOpacity(0),
                    const Color(0xFF0077B6).withOpacity(0.70),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Bergabung Bersama\nKami',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Jadilah bagian dari ekosistem perikanan\nmodern.',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      height: 1.43,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyerForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Color(0xFF0077B6),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Informasi Pribadi',
                    style: TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 20 / 14,
                    ),
                  ),
                  Text(
                    'DATA UTAMA',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.50,
                      height: 15 / 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Toggle Email/Phone
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _useTelephone = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _useTelephone ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: _useTelephone
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone,
                            size: 16,
                            color: _useTelephone
                                ? const Color(0xFF0077B6)
                                : const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'No. Telp',
                            style: TextStyle(
                              color: _useTelephone
                                  ? const Color(0xFF0077B6)
                                  : const Color(0xFF64748B),
                              fontSize: 14,
                              fontWeight: _useTelephone
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              height: 20 / 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _useTelephone = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_useTelephone ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: !_useTelephone
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.email,
                            size: 14,
                            color: !_useTelephone
                                ? const Color(0xFF0077B6)
                                : const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Email',
                            style: TextStyle(
                              color: !_useTelephone
                                  ? const Color(0xFF0077B6)
                                  : const Color(0xFF64748B),
                              fontSize: 14,
                              fontWeight: !_useTelephone
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              height: 20 / 14,
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
          const SizedBox(height: 16),

          // Fields based on toggle
          if (_useTelephone) ...[
            _buildTextField(
              label: 'NOMOR WHATSAPP',
              controller: _phoneController,
              hint: '812-3456-7890',
              prefix: '+62',
            ),
          ] else ...[
            _buildTextField(
              label: 'EMAIL',
              controller: _emailController,
              hint: 'Contoh: santoso@budi.com',
            ),
          ],
          const SizedBox(height: 16),

          _buildTextField(
            label: 'NAMA LENGKAP',
            controller: _nameController,
            hint: 'Contoh: Budi Santoso',
          ),
          const SizedBox(height: 16),

          _buildPasswordField(
            label: 'KATA SANDI',
            controller: _passwordController,
            hint: 'Minimal 8 karakter',
          ),
          const SizedBox(height: 16),

          _buildTextArea(
            label: 'ALAMAT LENGKAP',
            controller: _addressController,
            hint: 'Jalan, RT/RW, Kelurahan, Kecamatan',
          ),
          const SizedBox(height: 20),

          // Terms checkbox
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _agreeTerms,
                onChanged: (value) => setState(() => _agreeTerms = value!),
                activeColor: const Color(0xFF0077B6),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.25,
                      ),
                      children: [
                        TextSpan(
                          text: 'Saya setuju dengan ',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: 'Syarat & Ketentuan\n',
                          style: TextStyle(
                            color: Color(0xFF0077B6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Paguyuban IKANURA dan kebijakan privasi yang\nberlaku.',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMitraForm() {
    return Column(
      children: [
        // Section 1: Data Usaha
        _buildSection(
          icon: Icons.business,
          title: 'Data Usaha',
          children: [
            _buildTextField(
              label: 'NAMA PEMILIK',
              controller: _nameController,
              hint: 'Nama lengkap sesuai KTP',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'NAMA USAHA',
              controller: _businessNameController,
              hint: 'Contoh: Warung Sejahtera',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'NOMOR WHATSAPP',
              controller: _phoneController,
              hint: '812-3456-7890',
              prefix: '+62',
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'KATEGORI USAHA',
              value: _selectedCategory,
              items: _businessCategories,
              hint: 'Pilih Kategori',
              onChanged: (value) => setState(() => _selectedCategory = value),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Section 2: Lokasi & Logistik
        _buildSection(
          icon: Icons.location_on,
          title: 'Lokasi & Logistik',
          children: [
            _buildTextArea(
              label: 'ALAMAT LENGKAP',
              controller: _addressController,
              hint: 'Jalan, RT/RW, Kelurahan, Kecamatan',
            ),
            const SizedBox(height: 16),
            _buildMapPlaceholder(),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'ESTIMASI KEBUTUHAN IKAN',
              controller: _estimatedNeedController,
              hint: '0',
              suffix: 'kg/minggu',
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Section 3: Verifikasi Fleksibel
        _buildSection(
          icon: Icons.verified_user,
          title: 'Verifikasi Fleksibel',
          children: [
            _buildTextField(
              label: 'NOMOR INDUK BERUSAHA (NIB)',
              controller: _nibController,
              hint: 'Opsional jika belum ada',
            ),
            const SizedBox(height: 16),
            _buildPhotoGallery(),
          ],
        ),
      ],
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFE0F2FE),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF0077B6),
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 24 / 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    String? prefix,
    String? suffix,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.30,
            height: 16 / 12,
          ),
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(prefix != null ? 16 : 12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(prefix != null ? 16 : 12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(prefix != null ? 16 : 12),
                  borderSide: const BorderSide(
                    color: Color(0xFF0077B6),
                    width: 1,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: prefix != null ? 48 : (suffix != null ? 16 : 16),
                  vertical: 13,
                ).copyWith(
                  right: suffix != null ? 90 : (prefix != null ? 16 : 16),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '$label tidak boleh kosong';
                }
                return null;
              },
            ),
            if (prefix != null)
              Positioned(
                left: 16,
                top: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Color(0xFFCBD5E1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      prefix,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 20 / 14,
                      ),
                    ),
                  ),
                ),
              ),
            if (suffix != null)
              Positioned(
                right: 12,
                top: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      suffix,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 16 / 12,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.30,
            height: 16 / 12,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFF0077B6),
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 13,
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
            if (value.length < 8) {
              return 'Password minimal 8 karakter';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextArea({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.30,
            height: 16 / 12,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 20 / 14,
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFF0077B6),
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label tidak boleh kosong';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required String hint,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.30,
            height: 16 / 12,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF0077B6),
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 13,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label harus dipilih';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 128,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9999),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.location_on,
                color: Color(0xFF0077B6),
                size: 10.5,
              ),
              SizedBox(width: 8),
              Text(
                'Pinpoint Lokasi',
                style: TextStyle(
                  color: Color(0xFF0077B6),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 16 / 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(int index) async {
    try {
      // Show dialog to choose between camera or gallery
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pilih Sumber Foto'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Color(0xFF0077B6)),
                  title: const Text('Kamera'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: Color(0xFF0077B6)),
                  title: const Text('Galeri'),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
              ],
            ),
          );
        },
      );

      if (source != null) {
        final XFile? image = await _picker.pickImage(
          source: source,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 85,
        );

        if (image != null) {
          setState(() {
            _photos[index] = image;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengambil foto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildPhotoGallery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'FOTO VERIFIKASI TEMPAT USAHA',
          style: TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.30,
            height: 16 / 12,
          ),
        ),
        const SizedBox(height: 7.10),
        const Text(
          'Minimal upload 5 foto tampak depan, area produksi, dan\nproduk.',
          style: TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 11,
            fontWeight: FontWeight.w400,
            height: 1.38,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(5, (index) {
            final hasPhoto = _photos[index] != null;
            
            return GestureDetector(
              onTap: () => _pickImage(index),
              child: Container(
                width: 95.33,
                height: 93.25,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: hasPhoto ? const Color(0xFF0077B6) : const Color(0xFFCBD5E1),
                    width: hasPhoto ? 2 : 1,
                  ),
                ),
                child: hasPhoto
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Image.file(
                              File(_photos[index]!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _photos[index] = null;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            color: const Color(0xFFCBD5E1),
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Foto ${index + 1}',
                            style: const TextStyle(
                              color: Color(0xFFCBD5E1),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              height: 15 / 10,
                            ),
                          ),
                        ],
                      ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBottomAction(String roleLabel) {
    final isBuyer = widget.role == 'buyer';
    
    return Container(
      padding: const EdgeInsets. fromLTRB(24, 24, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isBuyer ? 0.90 : 0.95),
        border: const Border(
          top: BorderSide(
            color: Color(0xFFF1F5F9),
            width: 1,
          ),
        ),
        boxShadow: isBuyer
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
      ),
      child: Column(
        children: [
          // Register button
          GestureDetector(
            onTap: _isLoading ? null : _register,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: isBuyer
                    ? const LinearGradient(
                        colors: [Color(0xFF0077B6), Color(0xFF0077B6)],
                      )
                    : const LinearGradient(
                        colors: [Color(0xFF0077B6), Color(0xFF023E8A)],
                      ),
                borderRadius: BorderRadius.circular(isBuyer ? 20 : 12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0077B6).withOpacity(0.30),
                    blurRadius: 15,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: const Color(0xFF0077B6).withOpacity(0.30),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  else ...[
                    Text(
                      isBuyer ? 'Daftar Sekarang' : 'Daftar Sebagai Mitra',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.40,
                        height: 24 / 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 12,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Login link
          GestureDetector(
            onTap: _goToLogin,
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 12,
                  height: 16 / 12,
                ),
                children: [
                  TextSpan(
                    text: 'Sudah punya akun? ',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: 'Masuk',
                    style: TextStyle(
                      color: Color(0xFF0077B6),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
