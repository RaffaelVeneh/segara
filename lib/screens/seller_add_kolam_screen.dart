import 'package:flutter/material.dart';

class SellerAddKolamScreen extends StatefulWidget {
  const SellerAddKolamScreen({super.key});

  @override
  State<SellerAddKolamScreen> createState() => _SellerAddKolamScreenState();
}

class _SellerAddKolamScreenState extends State<SellerAddKolamScreen> {
  final _namaKolamController = TextEditingController();
  final _kapasitasController = TextEditingController();
  final _beratTotalController = TextEditingController();
  final _beratPanenController = TextEditingController();
  
  String _selectedJenisIkan = 'Nila';
  DateTime? _tanggalTebar;
  DateTime? _estimasiPanen;
  
  // Berat per jenis ikan
  final Map<String, double> _beratPerJenis = {
    'Nila': 0,
    'Bawal': 0,
    'Lele': 0,
  };

  @override
  void dispose() {
    _namaKolamController.dispose();
    _kapasitasController.dispose();
    _beratTotalController.dispose();
    _beratPanenController.dispose();
    super.dispose();
  }
  
  String _getBeratTotalText() {
    if (_beratPerJenis.values.every((value) => value == 0)) {
      return 'Berat total seluruh ikan:\nNila 0kg | Bawal 0kg | Lele 0kg';
    }
    return 'Berat total seluruh ikan:\nNila ${_beratPerJenis['Nila']!.toStringAsFixed(0)}kg | Bawal ${_beratPerJenis['Bawal']!.toStringAsFixed(0)}kg | Lele ${_beratPerJenis['Lele']!.toStringAsFixed(0)}kg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Transform.translate(
                    offset: const Offset(0, -47),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildForm(),
                    ),
                  ),
                  _buildFooterText(),
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background pattern overlay
          Positioned(
            top: 56,
            left: 0,
            right: 0,
            child: Container(
              height: 128,
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE).withOpacity(0.5),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 48, bottom: 24, left: 24, right: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0D000000),
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF475569),
                        size: 20,
                      ),
                    ),
                  ),
                  const Text(
                    'Tambah Kolam',
                    style: TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            label: 'Nama Kolam',
            controller: _namaKolamController,
            placeholder: 'Kolam Pak Sugeng',
          ),
          const SizedBox(height: 24),
          _buildAlamatKolam(),
          const SizedBox(height: 24),
          _buildJenisIkan(),
          const SizedBox(height: 24),
          _buildTextField(
            label: 'Kapasitas Maksimum Kolam',
            controller: _kapasitasController,
            placeholder: '0',
            suffix: 'Kilo',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          _buildTextField(
            label: 'Berat Total',
            controller: _beratTotalController,
            placeholder: '0',
            suffix: 'Kilo',
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _beratPerJenis[_selectedJenisIkan] = 
                    double.tryParse(value) ?? 0;
              });
            },
          ),
          const SizedBox(height: 24),
          _buildTextField(
            label: 'Berat Siap Panen Saat Ini',
            controller: _beratPanenController,
            placeholder: '0',
            suffix: 'Kilo',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  label: 'Tanggal Tebar',
                  date: _tanggalTebar,
                  onTap: () => _selectDate(context, true),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDateField(
                  label: 'Estimasi Panen',
                  date: _estimasiPanen,
                  onTap: () => _selectDate(context, false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              _getBeratTotalText(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xAA334155),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.43,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    String? suffix,
    TextInputType? keyboardType,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF334155),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Stack(
          children: [
            TextField(
              controller: controller,
              keyboardType: keyboardType,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF0077B6)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 19,
                ),
              ),
            ),
            if (suffix != null)
              Positioned(
                right: 17,
                top: 21,
                child: Text(
                  suffix,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildAlamatKolam() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A3D62).withOpacity(0.04),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.location_on,
                    color: Color(0xFF0A3D62),
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Alamat Kolam',
                    style: TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Edit address
                },
                child: const Text(
                  'Ubah',
                  style: TextStyle(
                    color: Color(0xFF3C6E91),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Rumah',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Budi Santoso (0812-3456-7890)',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.625,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Jl. Pantai Indah Kapuk No. 88, Cluster Ebony, Jakarta Utara, DKI Jakarta 14470',
            style: TextStyle(
              color: Color(0xFF475569),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.625,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 96,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A3D62).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.90),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Color(0xFF0A3D62),
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJenisIkan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Jenis Ikan',
            style: TextStyle(
              color: Color(0xFF334155),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildIkanChip('Nila', Icons.check),
              const SizedBox(width: 12),
              _buildIkanChip('Bawal', Icons.waves),
              const SizedBox(width: 12),
              _buildIkanChip('Lele', Icons.water_drop),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIkanChip(String label, IconData icon) {
    final isSelected = _selectedJenisIkan == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          // Save current input before switching
          if (_beratTotalController.text.isNotEmpty) {
            _beratPerJenis[_selectedJenisIkan] = 
                double.tryParse(_beratTotalController.text) ?? 0;
          }
          
          // Switch to new fish type
          _selectedJenisIkan = label;
          
          // Load the saved weight for this fish type
          _beratTotalController.text = 
              _beratPerJenis[label]! > 0 
                  ? _beratPerJenis[label]!.toStringAsFixed(0) 
                  : '';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0x1A0077B6)
              : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0077B6)
                : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF0077B6)
                  : const Color(0xFF0F172A),
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF0077B6)
                    : const Color(0xFF0F172A),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF334155),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date != null
                      ? '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}'
                      : 'mm/dd/yyyy',
                  style: TextStyle(
                    color: date != null 
                        ? const Color(0xFF1E293B) 
                        : const Color(0xFF94A3B8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF94A3B8),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: () {
        // TODO: Save kolam data
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF0077B6), Color(0xFF023E8A)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x4D0077B6),
              blurRadius: 15,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Simpan & Aktifkan Kolam',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterText() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        'Pastikan data yang dimasukkan sudah benar untuk\nakurasi prediksi panen.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF94A3B8),
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.33,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isTanggalTebar) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isTanggalTebar) {
          _tanggalTebar = picked;
        } else {
          _estimasiPanen = picked;
        }
      });
    }
  }
}
