import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

enum ContractNodeType { client, contract, zone, state, store }

class ContractTreeNode extends StatefulWidget {
  final ContractNodeType type;
  final String title;
  final String subtitle;
  final String? code;
  final bool isSelected;
  final bool initialExpanded;
  final VoidCallback? onTap;
  final List<Widget>? children;

  ContractTreeNode({
    super.key,
    required this.type,
    required this.title,
    required this.subtitle,
    this.code,
    this.isSelected = false,
    this.initialExpanded = false,
    this.onTap,
    this.children,
  });

  @override
  State<ContractTreeNode> createState() => _ContractTreeNodeState();
}

class _ContractTreeNodeState extends State<ContractTreeNode> {
  late bool _isExpanded;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initialExpanded;
  }

  void _toggleExpand() {
    if (widget.children != null && widget.children!.isNotEmpty) {
      setState(() {
        _isExpanded = !_isExpanded;
      });
    }
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLeaf = widget.children == null || widget.children!.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _toggleExpand,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? AppColors.blue.withOpacity(0.1)
                    : _isHovering
                        ? AppColors.blue.withOpacity(0.05)
                        : Colors.transparent,
                border: widget.isSelected
                    ? Border.all(color: AppColors.blue.withOpacity(0.2))
                    : Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  _buildIcon(),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: context.textColor,
                          ),
                        ),
                        Text(
                          widget.subtitle,
                          style: TextStyle(
                            fontSize: 10,
                            color: context.mutedTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.code != null)
                    Text(
                      widget.code!,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blue,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (!isLeaf && _isExpanded)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Indent line
                Container(
                  width: 2,
                  margin: EdgeInsets.only(left: 14, right: 10, top: 4, bottom: 4),
                  decoration: BoxDecoration(
                    color: context.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Children
                Expanded(
                  child: Column(
                    children: widget.children!,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildIcon() {
    Color bgColor;
    String letter;

    switch (widget.type) {
      case ContractNodeType.client:
        bgColor = AppColors.navy;
        letter = 'S'; // Prototype uses S for Soriana? Or should it be dynamic? Let's use first letter of title
        break;
      case ContractNodeType.contract:
        bgColor = Color(0xFF8C9EBB);
        letter = 'C';
        break;
      case ContractNodeType.zone:
        bgColor = Color(0xFFA3D9A5);
        letter = 'Z';
        break;
      case ContractNodeType.state:
        bgColor = Color(0xFFF4D38C);
        letter = 'E';
        break;
      case ContractNodeType.store:
        bgColor = Color(0xFFA8C8E6);
        letter = 'T';
        break;
    }

    // Default to first letter if needed, but prototype uses fixed S, C, Z, E, T
    if (widget.type == ContractNodeType.client && widget.title.isNotEmpty) {
      letter = widget.title[0].toUpperCase();
    }

    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(7),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
