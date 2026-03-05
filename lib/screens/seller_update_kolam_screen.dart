import 'package:flutter/material.dart';

class SellerUpdateKolamScreen extends StatefulWidget {
  const SellerUpdateKolamScreen({super.key});

  @override
  State<SellerUpdateKolamScreen> createState() => _SellerUpdateKolamScreenState();
}

class _SellerUpdateKolamScreenState extends State<SellerUpdateKolamScreen> {
  final _kapasitasController = TextEditingController();
  final _beratTotalController = TextEditingController();
  final _beratPanenController = TextEditingController();
  
  String? _selectedKolam;
  String _selectedJenisIkan = 'Nila';
  DateTime? _tanggalTebar;
  DateTime? _estimasiPanen;
  
  // Berat per jenis ikan
  final Map<String, double> _beratPerJenis = {
    'Nila': 0,
    'Bawal': 0,
    'Lele': 0,
  };
  
  // Data dummy kolam
  final List<Map<String, dynamic>> _kolamList = [
    {
      'id': '1',
      'name': 'Kolam A1',
      'jenis': 'Nila',
      'kapasitas': 30000,
      'beratTotal': 1500,
      'beratPanen': 1200,
      'tanggalTebar': DateTime(2024, 1, 15),
      'estimasiPanen': DateTime(2024, 7, 15),
      'beratPerJenis': {'Nila': 1500, 'Bawal': 0, 'Lele': 0},
    },
    {
      'id': '2',
      'name': 'Kolam A2',
      'jenis': 'Bawal',
      'kapasitas': 25000,
      'beratTotal': 1200,
      'beratPanen': 800,
      'tanggalTebar': DateTime(2024, 2, 1),
      'estimasiPanen': DateTime(2024, 8, 1),
      'beratPerJenis': {'Nila': 0, 'Bawal': 1200, 'Lele': 0},
    },
    {
      'id': '3',
      'name': 'Kolam B1',
      'jenis': 'Lele',
      'kapasitas': 20000,
      'beratTotal': 950,
      'beratPanen': 700,
      'tanggalTebar': DateTime(2024, 1, 20),
      'estimasiPanen': DateTime(2024, 5, 20),
      'beratPerJenis': {'Nila': 0, 'Bawal': 0, 'Lele': 950},
    },
    {
      'id': '4',
      'name': 'Kolam B2',
      'jenis': 'Nila',
      'kapasitas': 35000,
      'beratTotal': 2100,
      'beratPanen': 1800,
      'tanggalTebar': DateTime(2023, 12, 10),
      'estimasiPanen': DateTime(2024, 6, 10),
      'beratPerJenis': {'Nila': 2100, 'Bawal': 0, 'Lele': 0},
    },
    {
      'id': '5',
      'name': 'Kolam C1',
      'jenis': 'Bawal',
      'kapasitas': 28000,
      'beratTotal': 1400,
      'beratPanen': 1100,
      'tanggalTebar': DateTime(2024, 1, 5),
      'estimasiPanen': DateTime(2024, 7, 5),
      'beratPerJenis': {'Nila': 0, 'Bawal': 1400, 'Lele': 0},
    },
    {
      'id': '6',
      'name': 'Kolam C2',
      'jenis': 'Nila',
      'kapasitas': 32000,
      'beratTotal': 1850,
      'beratPanen': 1500,
      'tanggalTebar': DateTime(2024, 2, 15),
      'estimasiPanen': DateTime(2024, 8, 15),
      'beratPerJenis': {'Nila': 1850, 'Bawal': 0, 'Lele': 0},
    },
  ];

  @override
  void dispose() {
    _kapasitasController.dispose();
    _beratTotalController.dispose();
    _beratPanenController.dispose();
    super.dispose();
  }
  
  void _loadSelectedKolam() {
    if (_selectedKolam != null) {
      final kolam = _kolamList.firstWhere((k) => k['name'] == _selectedKolam);
      setState(() {
        _selectedJenisIkan = kolam['jenis'];
        _kapasitasController.text = kolam['kapasitas'].toString();
        _beratTotalController.text = kolam['beratTotal'].toString();
        _beratPanenController.text = kolam['beratPanen'].toString();
        _tanggalTebar = kolam['tanggalTebar'];
        _estimasiPanen = kolam['estimasiPanen'];
        _beratPerJenis.addAll(Map<String, double>.from(kolam['beratPerJenis']));
      });
    }
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
                    'Update Kolam',
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
        boxShadow: const [
          BoxShadow(
            color: Color(0x80E2E8F0),
            blurRadius: 15,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildKolamDropdown(),
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
          _buildUpdateButton(),
        ],
      ),
    );
  }

  Widget _buildKolamDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Pilih Kolam',
            style: TextStyle(
              color: Color(0xFF334155),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 17),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedKolam,
              hint: const Text(
                'Pilih kolam tersedia...',
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF64748B),
              ),
              items: _kolamList.map((kolam) {
                return DropdownMenuItem<String>(
                  value: kolam['name'],
                  child: Text(
                    kolam['name'],
                    style: const TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedKolam = value;
                  _loadSelectedKolam();
                });
              },
            ),
          ),
        ),
      ],
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

  Widget _buildUpdateButton() {
    return GestureDetector(
      onTap: () {
        // TODO: Update kolam data
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
              'Update Kolam',
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
