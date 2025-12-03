import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/core/theme/theme_provider.dart';
import 'package:myapp/features/products/providers/product_provider.dart';
import 'package:myapp/shared/widgets/bottom_nav_bar.dart';
import 'package:myapp/core/theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Inventory Management',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const BottomNavBar(),
      debugShowCheckedModeBanner: false,
    );
  }
}
