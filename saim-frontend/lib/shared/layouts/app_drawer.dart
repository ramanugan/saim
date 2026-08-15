import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/theme/theme_provider.dart';
import '../widgets/require_permission.dart';
import '../../core/theme/app_theme.dart';
import '../../features/catalogs/widgets/modals/crud_paises_modal.dart';
import '../../features/catalogs/widgets/modals/crud_estados_modal.dart';
import '../../features/catalogs/widgets/modals/crud_municipios_modal.dart';
import '../../features/catalogs/widgets/modals/crud_tipos_tienda_modal.dart';
import '../../features/catalogs/widgets/modals/crud_tipos_servicio_modal.dart';
import '../../features/catalogs/widgets/modals/crud_iguala_condiciones_modal.dart';
import '../../features/catalogs/widgets/modals/crud_igualas_modal.dart';
import '../../features/catalogs/widgets/modals/crud_iguala_servicios_modal.dart';
import '../../features/catalogs/widgets/modals/crud_almacenes_modal.dart';
import '../../features/catalogs/widgets/modals/crud_movimientos_inventario_modal.dart';
import '../../features/catalogs/widgets/modals/crud_inventario_refacciones_modal.dart';
import '../../features/catalogs/widgets/modals/crud_categorias_refaccion_modal.dart';
import '../../features/catalogs/widgets/modals/crud_refacciones_modal.dart';
import '../../features/catalogs/widgets/modals/crud_refacciones_compatibilidad_modal.dart';

class AppDrawer extends ConsumerWidget {
  AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: AppColors.navy,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: context.surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'S',
                      style: TextStyle(
                        color: context.textColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SAIM',
                        style: TextStyle(
                          color: context.surfaceColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        'v0.2 PROTOTIPO',
                        style: TextStyle(
                          color: Color(0xFFCBD9E8),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: context.surfaceColor.withOpacity(0.24), height: 1),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                children: [
                  RequirePermission(
                    module: 'tablero',
                    action: 'ver',
                    child: _buildNavItem(
                      context: context,
                      icon: Icons.home_outlined,
                      label: 'Tablero',
                      route: '/',
                      isActive: GoRouterState.of(context).uri.toString() == '/',
                    ),
                  ),
                  RequirePermission(
                    module: 'contratos',
                    action: 'ver',
                    child: _buildNavItem(
                      context: context,
                      icon: Icons.business_outlined,
                      label: 'Contrato y cobertura',
                      route: '/contrato',
                      isActive: GoRouterState.of(context).uri.toString().contains('/contrato'),
                    ),
                  ),
                  RequirePermission(
                    module: 'catalogos',
                    action: 'ver',
                    child: _buildExpandableNavItem(
                      context: context,
                      icon: Icons.list_alt_outlined,
                      label: 'Catálogos',
                      isActive: GoRouterState.of(context).uri.toString().contains('/catalogos'),
                      children: [
                        _buildSubNavItem(
                          context: context,
                          label: 'Principal',
                          isActive: GoRouterState.of(context).uri.toString() == '/catalogos',
                          paddingLeft: 40,
                          onTap: () {
                            context.go('/catalogos');
                            Navigator.pop(context);
                          },
                        ),
                        if (ref.watch(currentUserProfileProvider).value?.role?.name == 'Administrador')
                          _buildNestedExpandableNavItem(
                            context: context,
                            label: 'Básicos',
                            isActive: false, // You might want to update this logic later
                            children: [
                              _buildSubNavItem(
                                context: context,
                                label: 'País',
                                isActive: false,
                                paddingLeft: 60,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => const CrudPaisesModal(),
                                  );
                                },
                              ),
                              _buildSubNavItem(
                                context: context,
                                label: 'Estado',
                                isActive: false,
                                paddingLeft: 60,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => const CrudEstadosModal(),
                                  );
                                },
                              ),
                              _buildSubNavItem(
                                context: context,
                                label: 'Municipio',
                                isActive: false,
                                paddingLeft: 60,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => const CrudMunicipiosModal(),
                                  );
                                },
                              ),
                              _buildSubNavItem(
                                context: context,
                                label: 'Tipo tienda',
                                isActive: false,
                                paddingLeft: 60,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => const CrudTiposTiendaModal(),
                                  );
                                },
                              ),
                              _buildSubNavItem(
                                context: context,
                                label: 'Tipo servicio',
                                isActive: false,
                                paddingLeft: 60,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => const CrudTiposServicioModal(),
                                  );
                                },
                              ),
                            ],
                          ),
                          _buildNestedExpandableNavItem(
                            context: context,
                            label: 'Igualas',
                            isActive: false, 
                            children: [
                              _buildSubNavItem(
                                context: context,
                                label: 'Iguala',
                                isActive: false,
                                paddingLeft: 60,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => const CrudIgualasModal(),
                                  );
                                },
                              ),
                              _buildSubNavItem(
                                context: context,
                                label: 'Iguala servicio',
                                isActive: false,
                                paddingLeft: 60,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => const CrudIgualaServiciosModal(),
                                  );
                                },
                              ),
                              _buildSubNavItem(
                                context: context,
                                label: 'Iguala condición',
                                isActive: false,
                                paddingLeft: 60,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => const CrudIgualaCondicionesModal(),
                                  );
                                },
                              ),
                            ],
                          ),
                          _buildNestedExpandableNavItem(
                            context: context,
                            label: 'Inventario',
                            isActive: false, 
                            children: [
                              _buildSubNavItem(
                                context: context,
                                label: 'Almacén',
                                isActive: false,
                                paddingLeft: 60,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => const CrudAlmacenesModal(),
                                  );
                                },
                              ),
                              _buildSubNavItem(
                                context: context,
                                label: 'Movimiento inventario',
                                isActive: false,
                                paddingLeft: 60,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => const CrudMovimientosInventarioModal(),
                                  );
                                },
                              ),
                              _buildSubNavItem(
                                context: context,
                                label: 'Inventario refacción',
                                isActive: false,
                                paddingLeft: 60,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => const CrudInventarioRefaccionesModal(),
                                  );
                                },
                              ),
                            ],
                          ),
                          _buildNestedExpandableNavItem(
                            context: context,
                            label: 'Refacciones',
                            isActive: false, 
                            children: [
                              _buildSubNavItem(
                                context: context,
                                label: 'Categoría refacción',
                                isActive: false,
                                paddingLeft: 60,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => const CrudCategoriasRefaccionModal(),
                                  );
                                },
                              ),
                              _buildSubNavItem(
                                context: context,
                                label: 'Refacción',
                                isActive: false,
                                paddingLeft: 60,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => const CrudRefaccionesModal(),
                                  );
                                },
                              ),
                              _buildSubNavItem(
                                context: context,
                                label: 'Refacción compatibilidad',
                                isActive: false,
                                paddingLeft: 60,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => const CrudRefaccionesCompatibilidadModal(),
                                  );
                                },
                              ),
                              _buildSubNavItem(
                                context: context,
                                label: 'Refacción alias',
                                isActive: false,
                                paddingLeft: 60,
                                onTap: () {
                                  // TODO: Modal Refacción alias
                                },
                              ),
                              _buildSubNavItem(
                                context: context,
                                label: 'Suministro refacción',
                                isActive: false,
                                paddingLeft: 60,
                                onTap: () {
                                  // TODO: Modal Suministro refacción
                                },
                              ),
                              _buildSubNavItem(
                                context: context,
                                label: 'Suministro refacción detalle',
                                isActive: false,
                                paddingLeft: 60,
                                onTap: () {
                                  // TODO: Modal Suministro refacción detalle
                                },
                              ),
                              _buildSubNavItem(
                                context: context,
                                label: 'Proveedor refacción',
                                isActive: false,
                                paddingLeft: 60,
                                onTap: () {
                                  // TODO: Modal Proveedor refacción
                                },
                              ),
                              _buildSubNavItem(
                                context: context,
                                label: 'Precio refacción',
                                isActive: false,
                                paddingLeft: 60,
                                onTap: () {
                                  // TODO: Modal Precio refacción
                                },
                              ),
                              _buildSubNavItem(
                                context: context,
                                label: 'Oportunidad suministro',
                                isActive: false,
                                paddingLeft: 60,
                                onTap: () {
                                  // TODO: Modal Oportunidad suministro
                                },
                              ),
                              _buildSubNavItem(
                                context: context,
                                label: 'Solicitud refacción detalle',
                                isActive: false,
                                paddingLeft: 60,
                                onTap: () {
                                  // TODO: Modal Solicitud refacción detalle
                                },
                              ),
                              _buildSubNavItem(
                                context: context,
                                label: 'Instalación refacción',
                                isActive: false,
                                paddingLeft: 60,
                                onTap: () {
                                  // TODO: Modal Instalación refacción
                                },
                              ),
                              _buildSubNavItem(
                                context: context,
                                label: 'Solicitud refacción',
                                isActive: false,
                                paddingLeft: 60,
                                onTap: () {
                                  // TODO: Modal Solicitud refacción
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  RequirePermission(
                    module: 'iguala',
                    action: 'ver',
                    child: _buildNavItem(
                      context: context,
                      icon: Icons.store_outlined,
                      label: 'Iguala de tienda',
                      route: '/iguala',
                      isActive: GoRouterState.of(context).uri.toString().contains('/iguala'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 5, left: 12),
                    child: Text(
                      'OPERACIÓN PREVENTIVA',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: context.mutedTextColor,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  RequirePermission(
                    module: 'calendario',
                    action: 'ver',
                    child: _buildNavItem(
                      context: context,
                      icon: Icons.calendar_month_outlined,
                      label: 'Calendario',
                      route: '/calendario',
                      isActive: GoRouterState.of(context).uri.toString().contains('/calendario'),
                    ),
                  ),
                  RequirePermission(
                    module: 'cuadrillas',
                    action: 'ver',
                    child: _buildNavItem(
                      context: context,
                      icon: Icons.people_outline,
                      label: 'Cuadrillas',
                      route: '/cuadrillas',
                      isActive: GoRouterState.of(context).uri.toString().contains('/cuadrillas'),
                    ),
                  ),
                  RequirePermission(
                    module: 'orden_campo',
                    action: 'ver',
                    child: _buildNavItem(
                      context: context,
                      icon: Icons.assignment_outlined,
                      label: 'Orden en campo',
                      route: '/orden-campo',
                      isActive: GoRouterState.of(context).uri.toString().contains('/orden-campo'),
                    ),
                  ),
                  RequirePermission(
                    module: 'captura_central',
                    action: 'ver',
                    child: _buildNavItem(
                      context: context,
                      icon: Icons.assignment_turned_in_outlined,
                      label: 'Captura central',
                      route: '/captura-central',
                      isActive: GoRouterState.of(context).uri.toString().contains('/captura-central'),
                    ),
                  ),
                  RequirePermission(
                    module: 'validacion',
                    action: 'ver',
                    child: _buildNavItem(
                      context: context,
                      icon: Icons.fact_check_outlined,
                      label: 'Validación',
                      route: '/validacion',
                      isActive: GoRouterState.of(context).uri.toString().contains('/validacion'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 5, left: 12),
                    child: Text(
                      'CONTINUIDAD Y FINANZAS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: context.mutedTextColor,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  RequirePermission(
                    module: 'refacciones',
                    action: 'ver',
                    child: _buildNavItem(
                      context: context,
                      icon: Icons.inventory_2_outlined,
                      label: 'Refacciones y backlog',
                      route: '/refacciones',
                      isActive: GoRouterState.of(context).uri.toString().contains('/refacciones'),
                    ),
                  ),
                  RequirePermission(
                    module: 'correctivos',
                    action: 'ver',
                    child: _buildNavItem(
                      context: context,
                      icon: Icons.warning_amber_outlined,
                      label: 'Correctivos',
                      route: '/correctivos',
                      isActive: GoRouterState.of(context).uri.toString().contains('/correctivos'),
                    ),
                  ),
                  RequirePermission(
                    module: 'gastos',
                    action: 'ver',
                    child: _buildNavItem(
                      context: context,
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'Gastos y recursos',
                      route: '/gastos',
                      isActive: GoRouterState.of(context).uri.toString().contains('/gastos'),
                    ),
                  ),
                  RequirePermission(
                    module: 'cobranza',
                    action: 'ver',
                    child: _buildNavItem(
                      context: context,
                      icon: Icons.attach_money_outlined,
                      label: 'Facturación y cobranza',
                      route: '/cobranza',
                      isActive: GoRouterState.of(context).uri.toString().contains('/cobranza'),
                    ),
                  ),
                  if (ref.watch(currentUserProfileProvider).value?.role?.name == 'Administrador') ...[
                    Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 5, left: 12),
                      child: Text(
                        'ADMINISTRACIÓN',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: context.mutedTextColor,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Icons.admin_panel_settings_outlined,
                      label: 'Usuarios y roles',
                      route: '/admin/usuarios',
                      isActive: GoRouterState.of(context).uri.toString().contains('/admin/usuarios'),
                    ),
                  ],
                ],
              ),
            ),
            Divider(color: context.surfaceColor.withOpacity(0.24), height: 1),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Consumer(
                builder: (context, ref, child) {
                  final profile = ref.watch(currentUserProfileProvider).value;
                  final initials = profile?.initials ?? 'U';
                  final fullName = profile?.fullName ?? 'Cargando...';
                  final roleName = profile?.role?.name ?? 'Rol no asignado';

                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: Text(
                          initials,
                          style: TextStyle(
                            color: AppColors.navy,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fullName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              roleName,
                              style: TextStyle(
                                color: Color(0xFFD9E6F3),
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          ref.watch(themeProvider) == ThemeMode.dark
                              ? Icons.light_mode_outlined
                              : Icons.dark_mode_outlined,
                          color: Color(0xFFD9E6F3),
                          size: 20,
                        ),
                        onPressed: () {
                          ref.read(themeProvider.notifier).toggleTheme();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.logout, color: Color(0xFFD9E6F3), size: 20),
                        onPressed: () async {
                          await ref.read(authServiceProvider).signOut();
                          if (context.mounted) Navigator.pop(context); // close drawer
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
    required bool isActive,
  }) {
    return InkWell(
      onTap: () {
        context.go(route);
        // Ensure to close drawer
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(9),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          boxShadow: isActive 
              ? [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 14, offset: Offset(0, 5))]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? AppColors.navy : Color(0xFFD9E6F3),
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.navy : Color(0xFFD9E6F3),
                fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isActive,
    required List<Widget> children,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        collapsedIconColor: isActive ? Colors.white : Color(0xFFD9E6F3),
        iconColor: isActive ? Colors.white : Color(0xFFD9E6F3),
        title: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? Colors.white : Color(0xFFD9E6F3),
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Color(0xFFD9E6F3),
                fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
          ],
        ),
        children: children,
      ),
    );
  }

  Widget _buildNestedExpandableNavItem({
    required BuildContext context,
    required String label,
    required bool isActive,
    required List<Widget> children,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.only(left: 40, right: 12),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Color(0xFFD9E6F3),
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        collapsedIconColor: isActive ? Colors.white : Color(0xFFD9E6F3),
        iconColor: isActive ? Colors.white : Color(0xFFD9E6F3),
        children: children,
      ),
    );
  }

  Widget _buildSubNavItem({
    required BuildContext context,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    double paddingLeft = 40,
  }) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.only(left: paddingLeft, right: 12, top: 8, bottom: 8),
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Color(0xFFD9E6F3),
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

