import 'package:flutter/material.dart';
import 'package:preproject_books/Constants/app_colors.dart';
import 'package:preproject_books/Constants/books_information.dart';

class SettingsView extends StatefulWidget {
  final VoidCallback? onBack;
  const SettingsView({super.key, this.onBack});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  static const Color _rose = Color(0xFFA8434B);
  static const Color _grey = Color(0xFF8A8A8A);

  String get fontLabel {
    if (fontScale.value < 1.0) return tr('صغير', 'Small');
    if (fontScale.value > 1.0) return tr('كبير', 'Large');
    return tr('متوسط', 'Medium');
  }

  void soon() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(tr('قريباً', 'Coming soon'))),
    );
  }
  void pickOption(String title, List<List> options) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 14),
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              for (var option in options)
                ListTile(
                  title: Text(option[0],
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  trailing: option[2] == true
                      ? const Icon(Icons.check_circle, color: _rose)
                      : const Icon(Icons.circle_outlined, color: _grey),
                  onTap: () {
                    (option[1] as VoidCallback)();
                    Navigator.pop(context);
                    setState(() {});
                  },
                ),
            ],
          ),
        );
      },
    );
  }
  void pickTheme() {
    pickOption(tr('المظهر', 'Theme'), [
      [tr('فاتح', 'Light'), () => isDark.value = false, !isDark.value],
      [tr('داكن', 'Dark'), () => isDark.value = true, isDark.value],
    ]);
  }
  void pickFontSize() {
    pickOption(tr('حجم الخط', 'Font size'), [
      [tr('صغير', 'Small'), () => fontScale.value = 0.9, fontScale.value < 1.0],
      [tr('متوسط', 'Medium'), () => fontScale.value = 1.0, fontScale.value == 1.0],
      [tr('كبير', 'Large'), () => fontScale.value = 1.15, fontScale.value > 1.0],
    ]);
  }
  void showPrivacy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.bg,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(tr('الخصوصية', 'Privacy'),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          tr('Bookia لا يطلب حساباً ولا يجمع بياناتك الشخصية. مفضلتك ومكتبتك محفوظة على جهازك أثناء استخدام التطبيق، وبيانات الكتب تأتي من Open Library.',
              'Bookia does not require an account or collect your personal data. Your favorites and library stay on your device while the app is open, and book data comes from Open Library.'),
          style: TextStyle(height: 1.6, color: context.subText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr('حسناً', 'OK'), style: const TextStyle(color: _rose)),
          ),
        ],
      ),
    );
  }

  Widget tile(IconData icon, String title,
      {String? value, VoidCallback? onTap, Widget? trailing}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          children: [
            Icon(icon, color: context.subText, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
            ),
            if (value != null) ...[
              Text(value, style: const TextStyle(color: _grey, fontSize: 13)),
              const SizedBox(width: 8),
            ],
            trailing ??
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: _grey),
          ],
        ),
      ),
    );
  }

  Widget group(List<Widget> children) {
    List<Widget> items = [];
    for (int i = 0; i < children.length; i++) {
      items.add(children[i]);
      if (i != children.length - 1) {
        items.add(Divider(height: 1, indent: 52, color: context.divider));
      }
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(color: context.card, child: Column(children: items)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        backgroundColor: context.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _rose),
          onPressed: () => widget.onBack?.call(),
        ),
        title: Text(
          tr('الإعدادات', 'Settings'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          group([
            tile(
                isDark.value
                    ? Icons.dark_mode_outlined
                    : Icons.wb_sunny_outlined,
                tr('المظهر', 'Theme'),
                value: isDark.value ? tr('داكن', 'Dark') : tr('فاتح', 'Light'),
                onTap: pickTheme),
            tile(Icons.text_fields_rounded, tr('حجم الخط', 'Font size'),
                value: fontLabel, onTap: pickFontSize),
            tile(
              Icons.notifications_none_rounded,
              tr('الإشعارات', 'Notifications'),
              trailing: ValueListenableBuilder<bool>(
                valueListenable: notificationsOn,
                builder: (context, on, child) => Switch(
                  value: on,
                  activeColor: Colors.white,
                  activeTrackColor: _rose,
                  onChanged: (v) => notificationsOn.value = v,
                ),
              ),
            ),
            tile(Icons.download_outlined, tr('التنزيلات', 'Downloads'),
                onTap: soon),
            tile(Icons.lock_outline_rounded, tr('الخصوصية', 'Privacy'),
                onTap: showPrivacy),
          ]),
          group([
            tile(Icons.star_border_rounded, tr('قيّم التطبيق', 'Rate the app'),
                onTap: soon),
            tile(Icons.share_outlined, tr('شارك التطبيق', 'Share the app'),
                onTap: soon),
          ]),
          const SizedBox(height: 8),
          Center(
            child: Text('Bookia  •  v1.0.0',
                style: TextStyle(color: _grey.withOpacity(0.8), fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
