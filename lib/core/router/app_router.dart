import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_flow_screen.dart';
import '../../features/location/presentation/location_permission_screen.dart';
import '../../features/home/presentation/customer_home_screen.dart';
import '../../features/services/presentation/grocery_flow_screen.dart';
import '../../features/services/presentation/medicine_flow_screen.dart';
import '../../features/services/presentation/parcel_flow_screen.dart';
import '../../features/services/presentation/home_service_flow_screen.dart';
import '../../features/requests/presentation/smart_request_screen.dart';
import '../../features/requests/presentation/worker_matching_screen.dart';
import '../../features/tracking/presentation/live_tracking_screen.dart';
import '../../features/chat/presentation/chat_screen.dart';
import '../../features/payments/presentation/payment_screen.dart';
import '../../features/payments/presentation/completion_screen.dart';
import '../../features/rating/presentation/rating_screen.dart';
import '../../features/profile/presentation/help_points_screen.dart';
import '../../features/elderly/presentation/elderly_mode_screen.dart';
import '../../features/family/presentation/family_assist_screen.dart';
import '../../features/whatsapp/presentation/whatsapp_assist_screen.dart';
import '../../features/emergency/presentation/emergency_screen.dart';
import '../../features/worker/presentation/worker_dashboard_screen.dart';
import '../../features/admin/presentation/admin_dashboard_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupFlowScreen(),
    ),
    GoRoute(
      path: '/location-permission',
      builder: (context, state) => const LocationPermissionScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const CustomerHomeScreen(),
    ),
    // Service Specific Flows
    GoRoute(
      path: '/services/grocery',
      builder: (context, state) => const GroceryFlowScreen(),
    ),
    GoRoute(
      path: '/services/medicine',
      builder: (context, state) => const MedicineFlowScreen(),
    ),
    GoRoute(
      path: '/services/parcel',
      builder: (context, state) => const ParcelFlowScreen(),
    ),
    GoRoute(
      path: '/services/home-service',
      builder: (context, state) {
        final cat = state.uri.queryParameters['cat'] ?? 'Plumbing';
        return HomeServiceFlowScreen(categoryName: cat);
      },
    ),
    // Request & Lifecycle Flows
    GoRoute(
      path: '/requests/smart-request',
      builder: (context, state) => const SmartRequestScreen(),
    ),
    GoRoute(
      path: '/matching/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'req_101';
        return WorkerMatchingScreen(requestId: id);
      },
    ),
    GoRoute(
      path: '/tracking/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'req_101';
        return LiveTrackingScreen(requestId: id);
      },
    ),
    GoRoute(
      path: '/chat/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'req_101';
        return ChatScreen(requestId: id);
      },
    ),
    GoRoute(
      path: '/payment/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'req_101';
        return PaymentScreen(requestId: id);
      },
    ),
    GoRoute(
      path: '/completion/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'req_101';
        final total = state.uri.queryParameters['total'];
        return CompletionScreen(requestId: id, total: total);
      },
    ),
    GoRoute(
      path: '/rating/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'req_101';
        return RatingScreen(requestId: id);
      },
    ),
    // Points, Care & Community
    GoRoute(
      path: '/profile/points',
      builder: (context, state) => const HelpPointsScreen(),
    ),
    GoRoute(
      path: '/elderly',
      builder: (context, state) => const ElderlyModeScreen(),
    ),
    GoRoute(
      path: '/family',
      builder: (context, state) => const FamilyAssistScreen(),
    ),
    GoRoute(
      path: '/whatsapp-assist',
      builder: (context, state) => const WhatsAppAssistScreen(),
    ),
    GoRoute(
      path: '/emergency',
      builder: (context, state) => const EmergencyScreen(),
    ),
    // Worker Flow
    GoRoute(
      path: '/worker/home',
      builder: (context, state) => const WorkerDashboardScreen(),
    ),
    // Admin Flow
    GoRoute(
      path: '/admin/dashboard',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
  ],
);
