import 'package:flutter/material.dart';
import '../../shared/layouts/app_layout.dart';
import 'widgets/iguala_header.dart';
import 'widgets/iguala_hero.dart';
import 'widgets/iguala_tab_bar.dart';
import 'widgets/tabs/summary_tab.dart';
import 'widgets/tabs/empty_tab.dart';

class StoreIgualaScreen extends StatefulWidget {
  StoreIgualaScreen({super.key});

  @override
  State<StoreIgualaScreen> createState() => _StoreIgualaScreenState();
}

class _StoreIgualaScreenState extends State<StoreIgualaScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Iguala de tienda',
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IgualaHeader(),
            IgualaHero(),
            IgualaTabBar(
              selectedIndex: _selectedTab,
              onTabSelected: (index) {
                setState(() {
                  _selectedTab = index;
                });
              },
            ),
            _buildTabContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return SummaryTab();
      case 1:
        return EmptyTab(
          icon: Icons.calendar_month_outlined,
          title: 'Calendario preventivo de IG-00028',
          description: 'Seis eventos bimestrales durante 2026; cinco ejecutados y uno próximo.',
          buttonText: 'Abrir calendario',
        );
      case 2:
        return EmptyTab(
          icon: Icons.warning_amber_outlined,
          title: 'Correctivos vinculados',
          description: 'Se muestran todos los correctivos reportados en esta iguala.',
        );
      case 3:
        return EmptyTab(
          icon: Icons.inventory_2_outlined,
          title: 'Equipos vinculados a la iguala',
          description: 'Lista de equipos a los que se les da mantenimiento.',
        );
      case 4:
        return EmptyTab(
          icon: Icons.settings_input_component_outlined,
          title: 'Historial de refacciones',
          description: 'Refacciones solicitadas y utilizadas en esta iguala.',
        );
      case 5:
        return EmptyTab(
          icon: Icons.folder_open_outlined,
          title: 'Expediente documental',
          description: 'Documentos asociados a esta iguala.',
        );
      default:
        return SizedBox.shrink();
    }
  }
}
