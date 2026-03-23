#!/bin/bash
# 🚀 QUICK START SCRIPT untuk Segara Flutter Development

echo "================================================"
echo "Segara Flutter - API Integration Setup"
echo "================================================"

# Step 1: Get dependencies
echo ""
echo "📦 Installing dependencies..."
flutter pub get

# Step 2: Run code generator for Freezed models
echo ""
echo "🔧 Generating code from models..."
flutter pub run build_runner build --delete-conflicting-outputs

# Step 3: Clean build
echo ""
echo "🧹 Cleaning build..."
flutter clean
flutter pub get

# Step 4: Display summary
echo ""
echo "================================================"
echo "✅ Setup Complete!"
echo "================================================"
echo ""
echo "📝 NEXT STEPS:"
echo "1. Update lib/utils/constants.dart with your Laravel API URL"
echo "2. Review lib/FLUTTER_API_INTEGRATION.md for architecture"
echo "3. Check Laravel backend for required endpoints"
echo "4. Run: flutter run"
echo ""
echo "📚 Key Files:"
echo "   - lib/providers/app_providers.dart (state management)"
echo "   - lib/api/dio_client.dart (HTTP client)"
echo "   - lib/models/*.dart (data models)"
echo "   - lib/services/api_services.dart (API logic)"
echo ""
echo "🔗 Integration Examples:"
echo "   - lib/screens/seller_kolam_screen.dart (Riverpod integration)"
echo "   - lib/screens/home_screen_integrated.dart (Products grid)"
echo ""
echo "================================================"
