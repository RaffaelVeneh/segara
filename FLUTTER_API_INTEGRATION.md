# 🎯 Segara Flutter → Laravel API Integration Guide

## ✅ Tahap Selesai (PHASE 1-5)

### 1. Dependencies & Project Structure

- ✅ Updated `pubspec.yaml` dengan semua dependencies
- ✅ Directory structure: `lib/api/`, `lib/models/`, `lib/providers/`, `lib/services/`, `lib/utils/`

### 2. Constants & Configuration

- ✅ `lib/utils/constants.dart` - API endpoints, storage keys, user roles
- **Base URL**: `http://10.0.2.2:8000/api` (untuk Android emulator)
  - Ubah ke `http://localhost:8000/api` untuk iOS atau `http://<IP>:8000/api` untuk device real

### 3. Data Models (dengan Freezed)

- ✅ `User` - AuthResponse, OtpRequest, OtpVerifyRequest
- ✅ `Pond` - PondResponse untuk list kolam
- ✅ `Product` - ProductResponse untuk katalog
- ✅ `Order` - OrderItem, OrderCreateRequest, OrderResponse

**⚠️ PENTING**: Jalankan code generation setelah menambah models:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. API Client & Interceptors

- ✅ `lib/api/dio_client.dart` - Singleton DioClient dengan interceptors:
  - **AuthInterceptor**: Otomatis tambah Bearer token dari secure_storage
  - **LoggingInterceptor**: Log semua HTTP requests/responses
  - **Error Handling**: Auto-logout on 401 Unauthorized

### 5. API Services Layer

- ✅ `lib/services/api_services.dart` dengan 4 main services:
  - `AuthService` - OTP logic
  - `PondService` - Fetch/create/update/delete ponds
  - `ProductService` - Fetch products
  - `OrderService` - Create orders

### 6. Riverpod Providers

- ✅ `lib/providers/app_providers.dart` - Centralized state management:
  - `authProvider` - StateNotifier untuk login/logout
  - `pondsProvider` - FutureProvider untuk fetching ponds
  - `productsProvider` - FutureProvider untuk fetching products
  - `ordersProvider` - FutureProvider untuk fetching orders
  - Persistent auth via `flutter_secure_storage` + `shared_preferences`

### 7. Utility Widgets

- ✅ `lib/utils/app_snackbar.dart` - Toast/SnackBar helper
- ✅ `lib/utils/loading_widgets.dart` - Shimmer + Error + Empty states

### 8. Auth Flow Integration

- ✅ `lib/screens/otp_verification_screen.dart` - OTP verification flow
- ✅ Updated `lib/main.dart` dengan ProviderScope wrapper
- Screen routing untuk SELLER_RT vs BUYER roles

### 9. Seller Screens Integration

- ✅ `lib/screens/seller_kolam_screen.dart` - Updated ke ConsumerStatefulWidget
  - Menggunakan `pondsProvider` untuk fetch data
  - Loading states dengan skeleton shimmer
  - Error handling dengan retry button
  - Empty state untuk kolam kosong

---

## 📋 Next Steps (Build Upon)

### A. HOME SCREEN - Products Integration (Home Buyer)

**File**: `lib/screens/home_screen.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedTab = 0;
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    final productsAsyncValue = ref.watch(
      productsProvider((_currentPage, null)), // null = semua kategori
    );

    return Scaffold(
      // ... existing UI
      body: productsAsyncValue.when(
        data: (productResponse) {
          return _buildProductGrid(productResponse.data);
        },
        loading: () => const ProductSkeletonLoader(itemCount: 4),
        error: (error, stack) => ErrorStateWidget(
          error: error.toString(),
          onRetry: () => ref.refresh(productsProvider((_currentPage, null))),
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    // Ganti hardcoded produk dengan dynamic products
    // Keep styling sama, hanya ganti Text/data
  }
}
```

**Key Changes**:

1. Change `StatefulWidget` → `ConsumerStatefulWidget`
2. Replace hardcoded `products` list dengan `productsProvider`
3. Handle loading/error/empty states dengan widgets
4. Replace `_addToCart` logic ke order flow later

---

### B. PRODUCT DETAIL SCREEN - Dynamic Data

**File**: `lib/screens/product_detail_screen.dart`

Accept product dari navigation parameters:

```dart
class ProductDetailScreen extends ConsumerWidget {
  final Product product;

  const ProductDetailScreen({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // Use product.name, product.price, product.imageUrl, etc
      // Replace hardcoded values
    );
  }
}
```

---

### C. CHECKOUT & ORDER CREATION

**File**: `lib/screens/checkout_screen.dart`

```dart
Future<void> _submitOrder() async {
  final orderRequest = OrderCreateRequest(
    sellerId: selectedSeller.id.toString(),
    items: cartItems.map((item) => OrderItem(
      productId: item.productId,
      productName: item.name,
      price: item.price,
      quantity: item.quantity,
    )).toList(),
    totalPrice: totalAmount,
    deliveryAddress: addressController.text,
  );

  final orderService = ref.read(orderServiceProvider);
  try {
    final order = await orderService.createOrder(orderRequest: orderRequest);
    // Navigate to order tracking
  } catch (e) {
    AppSnackBar.show(context, message: e.toString(), type: SnackBarType.error);
  }
}
```

---

### D. SELLER DASHBOARD Stats

**File**: `lib/screens/seller_dashboard_screen.dart`

Replace hardcoded stats dengan data dari ponds:

```dart
final pondsData = ref.watch(pondsProvider(1)).value;
final totalPonds = pondsData?.total ?? 0;
final readyToHarvestCount = pondsData?.data
    .where((pond) => pond.phLevel > 0.9)
    .length ?? 0;
```

---

## 🔧 Setup Instructions for Developers

### 1. Generate Code from Models

```bash
cd segara
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Adjust Base URL

Edit `lib/utils/constants.dart`:

- Android Emulator: `http://10.0.2.2:8000/api`
- iOS Simulator: `http://localhost:8000/api`
- Real Device: `http://<your-pc-ip>:8000/api` (e.g., `http://192.168.1.100:8000/api`)

### 3. Verify Dependencies Install

```bash
flutter pub get
flutter clean
flutter pub get
```

### 4. Run Flutter App

```bash
flutter run
```

---

## 📝 API Contract Expectations

Your Laravel backend should provide these endpoints:

### Authentication

```
POST /api/auth/send-otp
  Body: { phone, role }
  Response: { success: true, message: "OTP sent" }

POST /api/auth/verify-otp
  Body: { phone, otp, role }
  Response: {
    data: {
      token: "sanctum_token_here",
      user: { id, name, email, phone, role, ... }
    }
  }

POST /api/auth/logout (Protected)
```

### Ponds (Seller only)

```
GET /api/ponds?page=1&per_page=20 (Protected)
  Response: {
    data: [
      { id, name, location, area, phLevel, temperature, ... },
      ...
    ],
    total: 100,
    per_page: 20,
    current_page: 1
  }

GET /api/ponds/:id (Protected)
POST /api/ponds (Protected)
PUT /api/ponds/:id (Protected)
DELETE /api/ponds/:id (Protected)
```

### Products (Public or Protected)

```
GET /api/products?page=1&per_page=20&category=ikan
  Response: {
    data: [
      { id, name, price, category, imageUrl, stock, ... },
      ...
    ],
    total: 50,
    per_page: 20,
    current_page: 1
  }

GET /api/products/:id
```

### Orders (Protected)

```
POST /api/orders
  Body: OrderCreateRequest JSON
  Response: { data: { id, status, totalPrice, ... } }

GET /api/orders?page=1&per_page=20 (Protected)
GET /api/orders/:id (Protected)
POST /api/orders/:id/cancel (Protected)
```

---

## 🎨 Styling Preservation Rules

✅ **JANGAN UBAH**:

- Colors (hex codes)
- Border radius, shadows
- Font sizes, weights
- Layout (padding, spacing)
- Icons, images positions
- Widget tree structure

✅ **BOLEH UBAH**:

- Hardcoded text → variabel dari provider
- Hardcoded lists → dynamic lists dari API
- Static data → real-time data
- States (loading/error) → AsyncValue handling

---

## 🔐 Security Checklist

- ✅ Token disimpan di `flutter_secure_storage`
- ✅ No API key di code, gunakan constants
- ✅ Interceptor otomatis add Authorization header
- ✅ 401 error auto trigger logout
- ✅ OTP verification required sebelum akses app
- ✅ User role dari JWT atau response ditentukan routing (`SELLER_RT` vs `BUYER`)

---

## 🐛 Troubleshooting

### Compilation Error: "xxx.freezed.dart not found"

→ Jalankan `flutter pub run build_runner build`

### 401 Unauthorized pada setiap request

→ Check token disimpan di secure storage dengan key `auth_token`

### Connection refused (Android Emulator)

→ Emulator localhost = `10.0.2.2`, bukan `127.0.0.1`

### Riverpod provider not working

→ Wrap MyApp dengan `ProviderScope (sudah dilakukan di main.dart)

---

## 📱 Testing Flow

1. **Login Flow**:
   - Click "Masuk sebagai [Role]"
   - Enter phone → Hit "Kirim OTP"
   - Enter OTP → Hit "Verifikasi"
   - Auto-navigate ke home based on role

2. **Seller Dashboard**:
   - View ponds dari GET /api/ponds
   - See loading skeleton while fetching
   - See actual pond data when ready

3. **Buyer Home**:
   - View products dari GET /api/products
   - Click product → see detail
   - Add to cart → checkout
   - Create order POST /api/orders

---

**Last Updated**: March 18, 2026
**Integration Status**: Core API layer ready, screens pending individual integration
