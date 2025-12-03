import 'package:flutter/material.dart';
import 'package:myapp/core/widgets/responsive_scaffold.dart';
import 'package:myapp/features/dashboard/screens/dashboard_screen.dart';
import 'package:myapp/features/products/screens/user_products_screen.dart';
import 'package:myapp/features/settings/screens/settings_screen.dart';

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const DashboardScreen(),
    const UserProductsScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      selectedIndex: _selectedIndex,
      onNavigationIndexChange: _onItemTapped,
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
