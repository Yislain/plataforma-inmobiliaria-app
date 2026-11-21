import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/properties/domain/entities/property.dart';
import '../../features/properties/presentation/screens/add_property_screen.dart';
import '../../features/properties/presentation/screens/property_detail_screen.dart';
import '../../features/properties/presentation/screens/property_map_screen.dart';
import '../../features/maintenance/presentation/bloc/maintenance_bloc.dart';
import '../../features/maintenance/presentation/screens/maintenance_list_screen.dart';
import '../../features/maintenance/presentation/screens/maintenance_report_screen.dart';
import '../../features/payments/presentation/screens/payment_history_screen.dart';
import '../../features/rent_requests/presentation/screens/rent_request_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) => const PropertyMapScreen(),
    ),
    GoRoute(
      path: '/add-property',
      builder: (context, state) => const AddPropertyScreen(),
    ),
    GoRoute(
      path: '/property-detail',
      builder: (context, state) {
        final property = state.extra as Property;
        return PropertyDetailScreen(property: property);
      },
    ),
    GoRoute(
      path: '/maintenance-list',
      builder: (context, state) => const MaintenanceListScreen(),
    ),
    GoRoute(
      path: '/maintenance-report',
      builder: (context, state) {
        return BlocProvider(
          create: (context) => MaintenanceBloc(),
          child: const MaintenanceReportScreen(),
        );
      },
    ),
    GoRoute(
      path: '/payments',
      builder: (context, state) => const PaymentHistoryScreen(),
    ),
    GoRoute(
      path: '/rent-request',
      builder: (context, state) => const RentRequestScreen(),
    ),
  ],
);