import 'dart:ui';
import 'package:flutter/material.dart';

import '../utils/app_snackbar.dart';

class SellerSalesReportScreen extends StatefulWidget {
  const SellerSalesReportScreen({super.key});

  @override
  State<SellerSalesReportScreen> createState() =>
      _SellerSalesReportScreenState();
}

class _SellerSalesReportScreenState extends State<SellerSalesReportScreen> {
  final List<Map<String, dynamic>> _transactionList = [
    {
      'date': 'Okt 24',
      'day': '24',
      'month': 'Okt',
      'title': 'Pembelian Nila Merah',
      'amount': '+ Rp 2.500.000',
      'isIncome': true,
      'detail': 'Nila Merah (50kg)',
      'paymentMethod': 'Lunas',
    },
    {
      'date': 'Okt 23',
      'day': '23',
      'month': 'Okt',
      'title': 'Panen Kolam A-12',
      'amount': '+ Rp 4.200.000',
      'isIncome': true,
      'detail': 'Lele Sangkuriang (75kg)',
      'paymentMethod': 'Lunas',
    },
    {
      'date': 'Okt 22',
      'day': '22',
      'month': 'Okt',
      'title': 'Setoran Sentra',
      'amount': '+ Rp 1.200.000',
      'isIncome': true,
      'detail': 'Paket Ikan Segar',
      'paymentMethod': 'Transfer',
    },
    {
      'date': 'Okt 18',
      'day': '18',
      'month': 'Okt',
      'title': 'Panen Kolam B-03',
      'amount': '+ Rp 300.000',
      'isIncome': true,
      'detail': 'Gurame (30kg)',
      'paymentMethod': 'Lunas',
    },
    {
      'date': 'Okt 15',
      'day': '15',
      'month': 'Okt',
      'title': 'Beli Pakan (Keluar)',
      'amount': '- Rp 150.000',
      'isIncome': false,
      'detail': 'Pelet 781-2',
      'paymentMethod': 'Tunai',
      'isExpense': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background gradient decorations
          Positioned(
            top: 120,
            right: 20,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFEFF6FF).withValues(alpha: 0.6),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),

          // Main content
          Column(
            children: [
              // Header
              _buildHeader(),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Net Income Card
                      _buildNetIncomeCard(),

                      const SizedBox(height: 24),

                      // Print Button
                      _buildPrintButton(),

                      const SizedBox(height: 24),

                      // Revenue Breakdown
                      _buildRevenueBreakdown(),

                      const SizedBox(height: 8),

                      // Divider
                      Container(height: 8, color: const Color(0xFFF8FAFC)),

                      const SizedBox(height: 24),

                      // Transaction History Header
                      _buildTransactionHeader(),

                      const SizedBox(height: 16),

                      // Transaction List
                      _buildTransactionList(),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(9999),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.arrow_back,
                size: 16,
                color: Color(0xFF0F172A),
              ),
            ),
          ),

          // Title
          const Text(
            'BUKU KAS KELOMPOK',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 18,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.45,
            ),
          ),

          const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _buildNetIncomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0077B6), Color(0xFF023E8A)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0077B6).withValues(alpha: 0.2),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PENDAPATAN BERSIH',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Rp 14.500.000',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.trending_up, size: 16, color: Color(0xFF16A34A)),
                SizedBox(width: 4),
                Text(
                  '+12% vs bulan lalu',
                  style: TextStyle(
                    color: Color(0xFF16A34A),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrintButton() {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0077B6), Color(0xFF023E8A)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Fitur unduh PDF segera hadir'),
                backgroundColor: Color(0xFF0077B6),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.print, size: 20, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Print Laporan Keuangan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRevenueBreakdown() {
    return Column(
      children: [
        // Pendapatan Kotor
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.trending_up,
                  size: 20,
                  color: Color(0xFF0284C7),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Pendapatan Kotor',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Rp 15.000.000',
                      style: TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Potongan Admin
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF7ED),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.remove_circle_outline,
                  size: 20,
                  color: Color(0xFFF97316),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Potongan Admin',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '- Rp 500.000',
                      style: TextStyle(
                        color: Color(0xFFEF4444),
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Riwayat Transaksi',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 16,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
          ),
        ),
        InkWell(
          onTap: () {
            AppSnackBar.showInfo(
              context,
              message: 'Fitur ini akan segera hadir pada update berikutnya.',
            );
          },
          child: const Text(
            'Filter',
            style: TextStyle(
              color: Color(0xFF0284C7),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionList() {
    return Stack(
      children: [
        // Timeline vertical line
        Positioned(
          left: 20,
          top: 0,
          bottom: 0,
          child: Container(
            width: 1,
            color: const Color(0xFFFEFEF2).withValues(alpha: 0.8),
          ),
        ),

        // Transaction items
        Column(
          children: _transactionList.asMap().entries.map((entry) {
            final index = entry.key;
            final transaction = entry.value;
            final isLast = index == _transactionList.length - 1;
            final isExpense = transaction['isExpense'] ?? false;

            return Opacity(
              opacity: isExpense ? 0.6 : 1.0,
              child: Container(
                padding: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  border: isLast
                      ? null
                      : const Border(
                          bottom: BorderSide(
                            color: Color(0xFFF1F5F9),
                            width: 1,
                          ),
                        ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date badge
                    SizedBox(
                      width: 40,
                      child: Column(
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            transaction['month'],
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            transaction['day'],
                            style: const TextStyle(
                              color: Color(0xFF0F172A),
                              fontSize: 20,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Transaction details
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    transaction['title'],
                                    style: const TextStyle(
                                      color: Color(0xFF0F172A),
                                      fontSize: 16,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  transaction['amount'],
                                  style: TextStyle(
                                    color: transaction['isIncome']
                                        ? const Color(0xFF16A34A)
                                        : const Color(0xFFEF4444),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3.5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 11,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      transaction['detail'],
                                      style: const TextStyle(
                                        color: Color(0xFF64748B),
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 1.43,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    transaction['paymentMethod'],
                                    style: const TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 1.33,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
