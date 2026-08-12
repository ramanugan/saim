import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/contracts/contract_coverage_screen.dart';
import '../../features/catalogs/catalogs_screen.dart';
import '../../features/store_iguala/store_iguala_screen.dart';
import '../../features/calendar/calendar_screen.dart';
import '../../features/crews/crews_screen.dart';
import '../../features/field_order/field_order_screen.dart';
import '../../features/central_capture/central_capture_screen.dart';
import '../../features/validation/validation_screen.dart';
import '../../features/parts_backlog/parts_backlog_screen.dart';
import '../../features/correctivos/correctivos_screen.dart';
import '../../features/expenses/screens/expenses_screen.dart';
import '../../features/billing/screens/billing_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/users_admin/screens/users_admin_screen.dart';
import '../../shared/widgets/role_guard.dart';
import '../providers/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final userProfileAsync = ref.watch(currentUserProfileProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isAuth = session != null;
      final uri = state.uri.toString();
      final isLoggingIn = uri == '/login';
      final isGoingHome = uri == '/';
      final isLoading = uri == '/loading';

      if (!isAuth && !isLoggingIn) return '/login';
      
      if (isAuth) {
        // Si el perfil se está cargando (o aún tiene el valor nulo de cuando estábamos deslogueados)
        if (userProfileAsync.isLoading || userProfileAsync.value == null) {
          if (isLoggingIn || isGoingHome) {
            return '/loading';
          }
          return null; // Si está cargando y en otra ruta, que se quede ahí.
        }

        // Aquí ya estamos seguros de que cargó y tenemos un valor real
        final isTecnico = userProfileAsync.value?.role?.name == 'Técnico';
        
        if (isLoggingIn || isLoading) {
          return isTecnico ? '/orden-campo' : '/';
        }
        
        if (isGoingHome && isTecnico) {
          return '/orden-campo';
        }
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/loading',
        builder: (context, state) => Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => DashboardScreen(),
      ),
      GoRoute(
        path: '/contrato',
        builder: (context, state) => ContractCoverageScreen(),
      ),
      GoRoute(
        path: '/catalogos',
        builder: (context, state) => CatalogsScreen(),
      ),
      GoRoute(
        path: '/iguala',
        builder: (context, state) => StoreIgualaScreen(),
      ),
      GoRoute(
        path: '/calendario',
        builder: (context, state) => CalendarScreen(),
      ),
      GoRoute(
        path: '/cuadrillas',
        builder: (context, state) => CrewsScreen(),
      ),
      GoRoute(
        path: '/orden-campo',
        builder: (context, state) => FieldOrderScreen(),
      ),
      GoRoute(
        path: '/captura-central',
        builder: (context, state) => CentralCaptureScreen(),
      ),
      GoRoute(
        path: '/validacion',
        builder: (context, state) => ValidationScreen(),
      ),
      GoRoute(
        path: '/refacciones',
        builder: (context, state) => PartsBacklogScreen(),
      ),
      GoRoute(
        path: '/correctivos',
        builder: (context, state) => CorrectivosScreen(),
      ),
      GoRoute(
        path: '/gastos',
        builder: (context, state) => ExpensesScreen(),
      ),
      GoRoute(
        path: '/cobranza',
        builder: (context, state) => BillingScreen(),
      ),
      GoRoute(
        path: '/admin/usuarios',
        builder: (context, state) => RoleGuard(
          allowedRoles: ['Administrador'],
          child: UsersAdminScreen(),
        ),
      ),
    ],
  );
});
