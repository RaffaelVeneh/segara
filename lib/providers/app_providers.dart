import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/index.dart';
import '../services/api_services.dart' as legacy_api;
import '../services/order_service.dart';
import '../services/seller_pond_service.dart';
import '../utils/constants.dart';

// ============= Service Providers =============
final authServiceProvider = Provider((ref) => legacy_api.AuthService());
final pondServiceProvider = Provider((ref) => legacy_api.PondService());
final productServiceProvider = Provider((ref) => legacy_api.ProductService());
final orderServiceProvider = Provider((ref) => legacy_api.OrderService());
final buyerOrderServiceProvider = Provider((ref) => OrderService());
final sellerPondServiceProvider = Provider((ref) => SellerPondService());

final secureStorageProvider = Provider((_) => const FlutterSecureStorage());
final sharedPreferencesProvider = FutureProvider(
  (ref) async => await SharedPreferences.getInstance(),
);

// ============= Auth State =============
class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final User? user;
  final String? error;
  final String? token;

  AuthState({
    this.isLoading = false,
    this.isLoggedIn = false,
    this.user,
    this.error,
    this.token,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    User? user,
    String? error,
    String? token,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      error: error ?? this.error,
      token: token ?? this.token,
    );
  }
}

// ============= Auth Notifier =============
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState();
  }

  /// Send OTP to WhatsApp number (from database)
  Future<bool> sendOtp({required String whatsapp}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authService = ref.read(authServiceProvider);
      await authService.sendOtp(whatsapp: whatsapp);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Verify OTP and get auth token
  Future<bool> verifyOtp({
    required String whatsapp,
    required String otp,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authService = ref.read(authServiceProvider);
      final authResponse = await authService.verifyOtp(
        whatsapp: whatsapp,
        otp: otp,
      );

      final secureStorage = ref.read(secureStorageProvider);
      final prefsAsync = ref.read(sharedPreferencesProvider);

      // Save token to secure storage
      await secureStorage.write(
        key: AppConstants.tokenKey,
        value: authResponse.token,
      );

      // Save user data to shared preferences
      final prefs = prefsAsync.whenData((p) => p).value;
      await prefs?.setString(AppConstants.userRoleKey, authResponse.user.role);
      await prefs?.setString(AppConstants.userNameKey, authResponse.user.name);
      await prefs?.setString(AppConstants.userPhoneKey, whatsapp);

      state = state.copyWith(
        isLoading: false,
        isLoggedIn: true,
        user: authResponse.user,
        token: authResponse.token,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      final authService = ref.read(authServiceProvider);
      await authService.logout();
    } catch (e) {
      // Continue logout anyway
    } finally {
      final secureStorage = ref.read(secureStorageProvider);
      final prefsAsync = ref.read(sharedPreferencesProvider);

      await secureStorage.delete(key: AppConstants.tokenKey);
      final prefs = prefsAsync.whenData((p) => p).value;
      await prefs?.remove(AppConstants.userRoleKey);
      await prefs?.remove(AppConstants.userNameKey);
      await prefs?.remove(AppConstants.userPhoneKey);

      state = AuthState();
    }
  }

  /// Check if already logged in
  Future<void> checkLoginStatus() async {
    try {
      final secureStorage = ref.read(secureStorageProvider);
      final token = await secureStorage.read(key: AppConstants.tokenKey);
      if (token != null) {
        final prefsAsync = ref.read(sharedPreferencesProvider);
        final prefs = prefsAsync.whenData((p) => p).value;
        final userName = prefs?.getString(AppConstants.userNameKey) ?? '';
        final role = prefs?.getString(AppConstants.userRoleKey) ?? '';
        final whatsapp = prefs?.getString(AppConstants.userPhoneKey) ?? '';
        state = state.copyWith(
          isLoggedIn: true,
          user: User(
            id: '',
            name: userName,
            email: '',
            whatsapp: whatsapp,
            role: role,
          ),
          token: token,
        );
      }
    } catch (e) {
      // Stay logged out
    }
  }
}

// ============= Auth Provider =============
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

// ============= Data Providers =============

final pondsProvider = FutureProvider.family<PondResponse, int>((
  ref,
  page,
) async {
  final pondService = ref.watch(pondServiceProvider);
  return pondService.getPonds(page: page);
});

final pondDetailProvider = FutureProvider.family<Pond, int>((
  ref,
  pondId,
) async {
  final pondService = ref.watch(pondServiceProvider);
  return pondService.getPondDetail(pondId);
});

final productsProvider = FutureProvider.family<ProductResponse, int>((
  ref,
  page,
) async {
  final productService = ref.watch(productServiceProvider);
  return productService.getProducts(page: page);
});

final productDetailProvider = FutureProvider.family<Product, int>((
  ref,
  productId,
) async {
  final productService = ref.watch(productServiceProvider);
  return productService.getProductDetail(productId);
});

final ordersProvider = FutureProvider.family<OrderResponse, int>((
  ref,
  page,
) async {
  final orderService = ref.watch(orderServiceProvider);
  return orderService.getOrders(page: page);
});

final orderDetailProvider = FutureProvider.family<Order, int>((
  ref,
  orderId,
) async {
  final orderService = ref.watch(orderServiceProvider);
  return orderService.getOrderDetail(orderId);
});

final orderTrackingProvider = FutureProvider.family<OrderTrackingData, String>((
  ref,
  orderId,
) async {
  final orderService = ref.watch(buyerOrderServiceProvider);
  return orderService.getOrderTracking(orderId);
});

final sellerPondsProvider = FutureProvider<List<SellerPond>>((ref) async {
  final pondService = ref.watch(sellerPondServiceProvider);
  return pondService.getPonds();
});

class OrderFlowState {
  final bool isSubmittingOrder;
  final bool isUploadingProof;
  final String? errorMessage;
  final CreateOrderResult? latestOrder;
  final UploadPaymentResult? latestUpload;

  const OrderFlowState({
    this.isSubmittingOrder = false,
    this.isUploadingProof = false,
    this.errorMessage,
    this.latestOrder,
    this.latestUpload,
  });

  OrderFlowState copyWith({
    bool? isSubmittingOrder,
    bool? isUploadingProof,
    String? errorMessage,
    bool clearError = false,
    CreateOrderResult? latestOrder,
    UploadPaymentResult? latestUpload,
  }) {
    return OrderFlowState(
      isSubmittingOrder: isSubmittingOrder ?? this.isSubmittingOrder,
      isUploadingProof: isUploadingProof ?? this.isUploadingProof,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      latestOrder: latestOrder ?? this.latestOrder,
      latestUpload: latestUpload ?? this.latestUpload,
    );
  }
}

class OrderFlowNotifier extends Notifier<OrderFlowState> {
  @override
  OrderFlowState build() {
    return const OrderFlowState();
  }

  Future<CreateOrderResult?> submitOrder({
    required List<Map<String, dynamic>> cartItems,
    required String shippingAddress,
    String? notes,
  }) async {
    state = state.copyWith(isSubmittingOrder: true, clearError: true);
    try {
      final result = await ref
          .read(buyerOrderServiceProvider)
          .createOrder(
            cartItems: cartItems,
            shippingAddress: shippingAddress,
            notes: notes,
          );
      state = state.copyWith(
        isSubmittingOrder: false,
        latestOrder: result,
        clearError: true,
      );
      return result;
    } catch (e) {
      state = state.copyWith(
        isSubmittingOrder: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  Future<UploadPaymentResult?> uploadProof({
    required String orderId,
    required File imageFile,
  }) async {
    state = state.copyWith(isUploadingProof: true, clearError: true);
    try {
      final result = await ref
          .read(buyerOrderServiceProvider)
          .uploadPaymentProof(orderId: orderId, imageFile: imageFile);
      state = state.copyWith(
        isUploadingProof: false,
        latestUpload: result,
        clearError: true,
      );
      return result;
    } catch (e) {
      state = state.copyWith(
        isUploadingProof: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }
}

final orderFlowProvider = NotifierProvider<OrderFlowNotifier, OrderFlowState>(
  OrderFlowNotifier.new,
);
