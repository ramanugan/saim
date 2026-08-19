import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import 'app_drawer.dart';
import '../widgets/saim_button.dart';
import '../../core/theme/app_theme.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;

  AppLayout({
    Key? key,
    required this.child,
    required this.title,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      actions: actions ??
          [
            IconButton(
              icon: Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
            Consumer(
              builder: (context, ref, child) {
                final profile = ref.watch(currentUserProfileProvider).value;
                final initials = profile?.initials ?? 'U';
                
                return Padding(
                  padding: EdgeInsets.only(right: 16.0, left: 8.0),
                  child: Center(
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.navy,
                      child: Text(
                        initials,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 800) {
          return Scaffold(
            appBar: appBar,
            body: Row(
              children: [
                SizedBox(
                  width: 280,
                  child: AppDrawer(isModal: false),
                ),
                Expanded(child: child),
              ],
            ),
          );
        }

        return Scaffold(
          drawer: AppDrawer(isModal: true),
          appBar: appBar,
          body: child,
        );
      },
    );
  }
}
