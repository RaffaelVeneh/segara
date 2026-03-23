## Plan: Segara Checkout-Payment Tracking Refactor

Refactor end-to-end flow buyer dari checkout sampai tracking agar seluruh angka transaksi, deadline pembayaran, dan status order bersumber dari backend Laravel (escrow-safe), dengan prioritas stabilitas jaringan Android lokal dan perbaikan overflow UI tanpa mengubah estetika desain.

**Steps**

1. Phase 1 — API contract alignment & network baseline (blocking)
   - Tambah atribut `android:usesCleartextTraffic="true"` pada `segara/android/app/src/main/AndroidManifest.xml` (wajib untuk HTTP local testing).
   - Buat `segara/lib/core/api_config.dart` untuk base URL API environment dev (emulator `http://10.0.2.2:8000/api`, device fisik pakai IP WiFi lokal), termasuk catatan penggantian URL.
   - Refactor konfigurasi `DioClient` agar membaca base URL dari `ApiConfig` (tetap mempertahankan interceptor token dan timeout existing).
   - _depends on 1_: Validasi app tetap bisa login dan call endpoint dasar setelah perubahan base URL source.

2. Phase 2 — Backend order/payment capability (blocking for mobile flow)
   - Tambah endpoint buyer `POST /api/orders` pada Laravel (`backend/routes/api.php`) untuk create order dari cart + shipping address, dan pastikan backend menghitung `total_amount` + kode unik + `expired_at` (frontend tidak menghitung).
   - Gunakan perhitungan ongkos kirim **flat rate MVP** di Controller (contoh: Rp 10.000) agar implementasi cepat dan konsisten.
   - Tambah endpoint buyer `POST /api/orders/{id}/upload-payment` (multipart/form-data) untuk upload foto bukti transfer; endpoint admin `PATCH /api/payments/{id}/approve` tetap tidak dipakai buyer mobile.
   - Perluas status workflow backend agar mendukung urutan: `PENDING -> WAITING_PAYMENT -> ALLOCATING -> HARVESTING -> SHIPPING -> COMPLETED` (termasuk validasi transisi status).
   - Sesuaikan model/resource/response JSON agar `GET /api/orders/{id}` mengembalikan minimal: `order_id`, `total_amount`, `expired_at`, `status`, dan metadata tracking yang dibutuhkan UI.
   - _depends on 2_: Uji endpoint baru via request manual (payload JSON + multipart) dan verifikasi response contract konsisten.

3. Phase 3 — Flutter UI & Logic Integration (WAJIB, depends on Phase 2)
   - **Image Picker:** pastikan package `image_picker` tersedia di `pubspec.yaml` untuk fitur ambil gambar bukti transfer pada `PaymentConfirmationScreen`.
   - **OrderService terpisah:** buat `segara/lib/services/order_service.dart` berisi fungsi `createOrder`, `uploadPaymentProof`, dan `getOrderTracking`; dilarang menulis fungsi Dio langsung di file UI.
   - **Riverpod State:** gunakan `StateNotifier` atau `FutureProvider` untuk loading state saat submit order dan upload gambar (tombol berputar / disabled state).
   - **Cart Clearance (CRITICAL):** di `PaymentConfirmationScreen`, jalankan `CartStorage.clear()` jika upload API sukses (HTTP 200) sebelum navigasi ke tracking.
   - **UI Refactor eksplisit:** bungkus `Column`/`Stack` kaku dengan `SingleChildScrollView` / `SafeArea` bila perlu untuk cegah overflow, serta hapus `Random()` dan timer hardcode.
   - Tambah/rapikan model request-response order/payment jika field backend bertambah (`expired_at`, tracking status stage).
   - Update Riverpod provider di `segara/lib/providers/app_providers.dart` untuk expose service baru dan provider status order by `orderId`.
   - Migrasi pemanggilan screen agar tidak ada HTTP call langsung di UI; UI hanya panggil provider/service.

4. Phase 4 — Checkout screen refactor + overflow safety (depends on Phase 3)
   - Refactor `segara/lib/screens/checkout_screen.dart`: hapus `_shippingFee`, `_serviceFee`, `_discount`, dan seluruh kalkulasi total lokal; gunakan request payload cart + address ke backend.
   - Implement flow tombol “Bayar Sekarang”: set loading state, panggil `OrderService.createOrder()`, handle error snackbar, lalu navigasi ke Payment Confirmation dengan data API (`orderId`, `totalAmount`, `expiredAt`).
   - Tambahkan pembungkus responsif (`SafeArea` pada header jika perlu) untuk mencegah RenderFlex overflow tanpa mengubah warna, radius, typography, dan spacing inti desain.

5. Phase 5 — Payment confirmation refactor + countdown from API (depends on Phase 4)
   - Refactor `segara/lib/screens/payment_confirmation_screen.dart`: hapus `Random().nextInt(...)`, hapus timer statis 7170, hapus generate order id random.
   - Gunakan data yang diterima dari checkout/API (`orderId`, `totalAmount`, `expiredAt`) untuk tampilan nominal dan countdown `Timer.periodic` berbasis selisih `DateTime.now()` vs `expiredAt`.
   - Implement tombol “Konfirmasi” untuk upload bukti transfer ke `POST /api/orders/{id}/upload-payment` (multipart), tampilkan loading + success/failure feedback, lalu navigasi ke tracking jika sukses.
   - Perbaiki potensi overflow pada card akun bank/teks panjang dengan `Expanded/Flexible` atau pembungkus scroll yang sudah ada, tanpa mengubah style token.

6. Phase 6 — Dynamic order tracking with Riverpod (depends on Phase 5)
   - Refactor `segara/lib/screens/order_tracking_screen.dart` dari timeline statis menjadi data-driven memakai `FutureProvider.family` (atau FutureBuilder fallback) yang memanggil `getOrderStatus(orderId)`.
   - Render vertical progress tracker berdasarkan urutan status target bisnis; node status yang sudah tercapai berwarna forest green `#2D6A4F`.
   - Hapus hardcoded milestone/time text yang tidak berasal dari backend, dan gunakan data real order untuk estimasi/status subtitle jika tersedia.
   - Rapikan layout header/top spacing (hindari hardcoded `SizedBox(height: 80)`) agar aman di berbagai device dengan `SafeArea`.

7. Phase 7 — Regression checks & documentation (depends on all)
   - Verifikasi alur end-to-end: checkout -> payment instruction -> upload proof -> tracking status update.
   - Update dokumen integrasi mobile-backend (mis. `segara/FLUTTER_API_INTEGRATION.md`) untuk endpoint baru, format payload, dan mapping status.
   - Catat batasan scope: tidak mengubah tema visual utama, tidak menambah fitur UX di luar requirement.

**Relevant files**

- `segara/android/app/src/main/AndroidManifest.xml` — cleartext HTTP support for local network testing.
- `segara/lib/core/api_config.dart` — source of base URL and API env notes.
- `segara/lib/api/dio_client.dart` — consume `ApiConfig` while keeping auth interceptor behavior.
- `segara/lib/services/order_service.dart` — buyer order flow API methods (`createOrder`, `getOrderStatus`, `uploadPaymentProof`).
- `segara/lib/providers/app_providers.dart` — Riverpod providers for order detail/tracking refresh.
- `segara/lib/models/order_model.dart` (dan model terkait request/response) — map `expired_at`, status stages, payment upload response.
- `segara/lib/screens/checkout_screen.dart` — remove hardcoded fees, add create-order loading flow, overflow-safe wrapper.
- `segara/lib/screens/payment_confirmation_screen.dart` — remove random/static payment generation, API-driven countdown + upload proof.
- `segara/lib/screens/order_tracking_screen.dart` — dynamic progress tracker from backend status.
- `backend/routes/api.php` — add buyer endpoints for create order + upload payment proof.
- `backend/app/Http/Controllers/Api/OrderController.php` — implement create order and payment proof upload handlers (or split to dedicated controller if existing pattern requires).
- `backend/app/Models/Order.php` + migrations/resources — extend state machine fields/enum/serialization for `expired_at` and expanded statuses.

**Verification**

1. Backend contract test (manual/API client):
   - `POST /api/orders` returns `order_id`, `total_amount`, `expired_at`, `status=WAITING_PAYMENT` (or agreed initial state), and no frontend-derived unique code.
   - `POST /api/orders/{id}/upload-payment` accepts `multipart/form-data` image and transitions status as defined.
2. Flutter static checks:
   - Run `flutter analyze` in `segara` to ensure refactor compiles cleanly.
3. Laravel checks:
   - Run targeted tests (`php artisan test --filter=Order` and payment upload tests) atau minimal request validation tests untuk endpoint baru.
4. Manual device checks (emulator + physical device):
   - Emulator pakai `10.0.2.2`; device fisik pakai IP WiFi lokal sesuai `ApiConfig`.
   - Pastikan tidak ada RenderFlex overflow pada checkout/payment/tracking di layar kecil.
5. E2E functional validation:
   - Simulasikan checkout dengan cart nyata, lanjut upload bukti transfer, lalu cek tracking menampilkan node hijau sesuai status yang tercapai.

**Decisions**

- Scope mencakup perubahan Flutter + Laravel, bukan Flutter-only.
- Endpoint buyer baru yang disepakati: `POST /api/orders` dan `POST /api/orders/{id}/upload-payment`.
- Endpoint `PATCH /api/payments/{id}/approve` tetap domain admin web dan tidak dipanggil dari buyer mobile.
- Prioritas implementasi: jaringan/API baseline dulu, lalu overflow safety, baru business flow screens.
- Out-of-scope: redesign visual, penambahan fitur UX baru di luar alur checkout-payment-tracking.

**Further Considerations**

1. Penentuan transisi setelah upload bukti: rekomendasi `WAITING_PAYMENT` tetap sampai admin validasi, agar sesuai pemisahan peran buyer/admin.
2. Definisi `ALLOCATING` vs `HARVESTING` pada backend saat ini perlu dipastikan trigger bisnisnya agar tracker tidak ambigu.
3. Jika migrasi status/field menyentuh data existing, siapkan migration + fallback mapping status lama untuk kompatibilitas data lama.
