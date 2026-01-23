import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsdigest_flutter/presentation/screens/news_webview_screen.dart';
import 'package:newsdigest_flutter/presentation/settings/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const String _privacyUrl = '';
  static const String _termsUrl = '';

  void _openIfNotEmpty(BuildContext context, String url) {
    if (url.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewsWebViewScreen(url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final bool isDarkMode =
        ref.watch(themeModeProvider) == ThemeMode.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 상단 제목
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Center(
                child: Text(
                  '설정',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: scheme.outlineVariant,
            ),

            // 다크모드 전환
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: _SettingsSwitchTile(
                icon: Icons.nightlight_round,
                iconBgColor: scheme.primaryContainer,
                iconColor: scheme.onPrimaryContainer,
                title: '다크모드 전환',
                value: isDarkMode,
                onChanged: (bool value) {
                  ref.read(themeModeProvider.notifier).state =
                      value ? ThemeMode.dark : ThemeMode.light;
                },
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: scheme.outlineVariant,
            ),

            // 앱 버전 정보
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: _SettingsInfoTile(
                icon: Icons.info_rounded,
                iconBgColor: Color(0xFFF3F4F6),
                iconColor: Colors.grey,
                title: '앱 버전 정보',
                trailingText: 'v1.0.0',
              ),
            ),

            Divider(
              height: 1,
              thickness: 1,
              color: scheme.outlineVariant,
            ),

            // 개인정보 처리방침
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: _SettingsInfoTile(
                icon: Icons.shield_rounded,
                iconBgColor: scheme.secondaryContainer,
                iconColor: scheme.onSecondaryContainer,
                title: '개인정보 처리방침',
                showArrow: true,
                onTap: () => _openIfNotEmpty(context, _privacyUrl),
              ),
            ),

            Divider(
              height: 1,
              thickness: 1,
              color: scheme.outlineVariant,
            ),

            // 이용약관
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: _SettingsInfoTile(
                icon: Icons.description_rounded,
                iconBgColor: scheme.tertiaryContainer,
                iconColor: scheme.onTertiaryContainer,
                title: '이용약관',
                showArrow: true,
                onTap: () => _openIfNotEmpty(context, _termsUrl),
              ),
            ),

            Divider(
              height: 1,
              thickness: 1,
              color: scheme.outlineVariant,
            ),
          ],
        ),
      ),
    );
  }
}

/// 스위치가 있는 설정 행 (다크모드, 알림)
class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _SettingsSwitchTile({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      secondary: _SettingsIcon(
        icon: icon,
        bgColor: iconBgColor,
        iconColor: iconColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      value: value,
      activeColor: Theme.of(context).colorScheme.primary,
      inactiveTrackColor: Theme.of(context).colorScheme.surfaceVariant,
      onChanged: onChanged,
    );
  }
}

/// 화살표/텍스트가 있는 일반 설정 행
class _SettingsInfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String? trailingText;
  final bool showArrow;
  final VoidCallback? onTap;

  const _SettingsInfoTile({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    this.trailingText,
    this.showArrow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: _SettingsIcon(
        icon: icon,
        bgColor: iconBgColor,
        iconColor: iconColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (trailingText != null)
            Text(
              trailingText!,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          if (showArrow)
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}

/// 왼쪽 동그란 아이콘
class _SettingsIcon extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  const _SettingsIcon({
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: bgColor,
      radius: 20,
      child: Icon(
        icon,
        color: iconColor,
        size: 20,
      ),
    );
  }
}
