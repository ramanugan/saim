import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class FormGrid extends StatelessWidget {
  final List<Widget> children;
  final int columns;

  FormGrid({
    super.key,
    required this.children,
    this.columns = 4,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int currentCols = constraints.maxWidth < 600 ? 1 : (constraints.maxWidth < 900 ? 2 : columns);
        double spacing = 16.0;
        double width = (constraints.maxWidth - (spacing * (currentCols - 1))) / currentCols;
        if (width < 0) width = constraints.maxWidth;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children.map((child) => SizedBox(width: width, child: child)).toList(),
        );
      },
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String value;
  final bool isReadOnly;
  final bool isRequired;
  final int maxLines;
  final String? placeholder;

  CustomTextField({
    super.key,
    required this.label,
    this.value = '',
    this.isReadOnly = false,
    this.isRequired = false,
    this.maxLines = 1,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label${isRequired ? ' *' : ''}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: context.mutedTextColor,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          readOnly: isReadOnly,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: context.mutedTextColor),
            filled: true,
            fillColor: isReadOnly ? context.backgroundColor : context.surfaceColor,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: context.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: context.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.blue),
            ),
          ),
          style: TextStyle(
            fontSize: 14,
            color: isReadOnly ? AppColors.muted : AppColors.navy,
          ),
        ),
      ],
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String label;
  final String value;
  final bool isRequired;
  final List<String> items;

  CustomDropdown({
    super.key,
    required this.label,
    required this.value,
    this.isRequired = false,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label${isRequired ? ' *' : ''}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: context.mutedTextColor,
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: value.isNotEmpty ? value : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: context.surfaceColor,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: context.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: context.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.blue),
            ),
          ),
          icon: Icon(Icons.expand_more, size: 16),
          style: TextStyle(
            fontSize: 14,
            color: context.textColor,
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (val) {},
        ),
      ],
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  final String label;
  final bool isChecked;

  CustomCheckbox({
    super.key,
    required this.label,
    this.isChecked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: isChecked,
            onChanged: (v) {},
            activeColor: AppColors.blue,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: context.textColor),
          ),
        ),
      ],
    );
  }
}
