import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'contract_tree_node.dart';
import '../../../core/theme/app_theme.dart';

class ContractTreePanel extends StatelessWidget {
  ContractTreePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
        boxShadow: AppColors.shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estructura contractual',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: context.surfaceColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Selecciona una tienda para consultar su iguala',
                        style: TextStyle(
                          fontSize: 13,
                          color: context.mutedTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search, size: 20, color: context.mutedTextColor),
                  onPressed: () {},
                  splashRadius: 20,
                ),
              ],
            ),
          ),
          Divider(height: 1, color: context.borderColor),
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: ContractTreeNode(
              type: ContractNodeType.client,
              title: 'Soriana',
              subtitle: '1 contrato vigente',
              initialExpanded: true,
              children: [
                ContractTreeNode(
                  type: ContractNodeType.contract,
                  title: 'Mantenimiento nacional 2026',
                  subtitle: '4 zonas',
                  initialExpanded: true,
                  children: [
                    ContractTreeNode(
                      type: ContractNodeType.zone,
                      title: 'Zona Occidente',
                      subtitle: '5 estados · 52 tiendas',
                      initialExpanded: true,
                      children: [
                        ContractTreeNode(
                          type: ContractNodeType.state,
                          title: 'Jalisco',
                          subtitle: '21 tiendas',
                          initialExpanded: true,
                          children: [
                            ContractTreeNode(
                              type: ContractNodeType.store,
                              title: 'Río Nilo',
                              subtitle: 'Det. 28 · Súper',
                              code: 'IG-00028',
                              isSelected: true,
                            ),
                            ContractTreeNode(
                              type: ContractNodeType.store,
                              title: 'Bugambilias',
                              subtitle: 'Det. 16 · Híper',
                              code: 'IG-00016',
                            ),
                            ContractTreeNode(
                              type: ContractNodeType.store,
                              title: 'Malecón',
                              subtitle: 'Det. 30 · City Club',
                              code: 'IG-00030',
                            ),
                            ContractTreeNode(
                              type: ContractNodeType.store,
                              title: 'Cordilleras',
                              subtitle: 'Det. 61 · Mercado',
                              code: 'IG-00061',
                            ),
                          ],
                        ),
                        ContractTreeNode(
                          type: ContractNodeType.state,
                          title: 'Nayarit',
                          subtitle: '7 tiendas',
                        ),
                        ContractTreeNode(
                          type: ContractNodeType.state,
                          title: 'Colima',
                          subtitle: '6 tiendas',
                        ),
                      ],
                    ),
                    ContractTreeNode(
                      type: ContractNodeType.zone,
                      title: 'Zona Norte',
                      subtitle: '8 estados · 61 tiendas',
                    ),
                    ContractTreeNode(
                      type: ContractNodeType.zone,
                      title: 'Zona Centro',
                      subtitle: '7 estados · 48 tiendas',
                    ),
                    ContractTreeNode(
                      type: ContractNodeType.zone,
                      title: 'Zona Sureste',
                      subtitle: '6 estados · 23 tiendas',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
