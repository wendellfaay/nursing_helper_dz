import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/theme.dart';
import '../providers/app_provider.dart';
import 'home_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'المظهر',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: const Text('الوضع الليلي'),
              subtitle: Text(appProvider.isDarkMode ? 'مفعل' : 'غير مفعل'),
              secondary: Icon(
                appProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: AppTheme.primaryColor,
              ),
              value: appProvider.isDarkMode,
              onChanged: (_) => appProvider.toggleTheme(),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'اللغة',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: RadioGroup<String>(
              groupValue: appProvider.languageCode,
              onChanged: (value) {
                if (value == null) return;
                appProvider.setLocale(Locale(value));
              },
              child: const Column(
                children: [
                  RadioListTile<String>(
                    value: 'ar',
                    title: Text('العربية'),
                  ),
                  Divider(height: 1, indent: 16, endIndent: 16),
                  RadioListTile<String>(
                    value: 'fr',
                    title: Text('Français'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'البيانات',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_sweep, color: AppTheme.errorColor),
              title: const Text('إعادة تعيين البيانات'),
              subtitle: const Text('حذف جميع البيانات وإعادة تحميلها'),
              onTap: () => _confirmReset(context),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'حول التطبيق',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline, color: AppTheme.primaryColor),
                  title: Text('الإصدار'),
                  trailing: Text('1.0.0'),
                ),
                Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: Icon(Icons.description_outlined, color: AppTheme.primaryColor),
                  title: Text('الترخيص'),
                  trailing: Text('MIT'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد'),
        content: const Text('سيتم حذف جميع البيانات بما فيها تقدمك. هل أنت متأكد؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('تأكيد', style: TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      }
    }
  }
}
