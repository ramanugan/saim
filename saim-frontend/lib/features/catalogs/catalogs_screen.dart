import 'package:flutter/material.dart';
import '../../shared/layouts/app_layout.dart';
import 'widgets/catalog_header.dart';
import 'widgets/catalog_summary.dart';
import 'widgets/catalog_tab_bar.dart';
import 'widgets/tabs/coverage_tab.dart';
import 'widgets/tabs/stores_tab.dart';
import 'widgets/tabs/technical_tab.dart';
import 'widgets/tabs/people_tab.dart';
import 'widgets/tabs/parts_tab.dart';

class CatalogsScreen extends StatefulWidget {
  CatalogsScreen({super.key});

  @override
  State<CatalogsScreen> createState() => _CatalogsScreenState();
}

class _CatalogsScreenState extends State<CatalogsScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Catálogos',
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CatalogHeader(),
            CatalogSummary(),
            CatalogTabBar(
              selectedIndex: _selectedTab,
              onTabSelected: (index) {
                setState(() {
                  _selectedTab = index;
                });
              },
            ),
            _buildTabContent(),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return CoverageTab();
      case 1:
        return StoresTab();
      case 2:
        return TechnicalTab();
      case 3:
        return PeopleTab();
      case 4:
        return PartsTab();
      default:
        return SizedBox.shrink();
    }
  }
}
