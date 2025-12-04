import 'package:flutter/material.dart';
import '/core/constants/colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // 상단 제목
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
            child: Center(
              child: Text(
                '설정',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.border),

          // 다크모드 전환
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: _SettingsSwitchTile(
              icon: Icons.nightlight_round,
              iconBgColor: Color(0xFFF2ECFF),
              iconColor: Color(0xFF5C6BC0),
              title: '다크모드 전환',
              value: false, // TODO: 나중에 상태 연동
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.border),

          // 알림 설정
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: _SettingsSwitchTile(
              icon: Icons.notifications_rounded,
              iconBgColor: Color(0xFFEDE7FF),
              iconColor: Color(0xFF3F51B5),
              title: '알림 설정',
              value: true, // TODO: 나중에 상태 연동
            ),
          ),

          const Divider(height: 1, thickness: 1, color: AppColors.border),

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

          const Divider(height: 1, thickness: 1, color: AppColors.border),

          // 언어
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: _SettingsInfoTile(
              icon: Icons.language_rounded,
              iconBgColor: Color(0xFFE8F5E9),
              iconColor: Color(0xFF43A047),
              title: '언어',
              trailingText: '한국어',
              showArrow: true,
            ),
          ),

          const Divider(height: 1, thickness: 1, color: AppColors.border),

          // 로그인
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: _SettingsInfoTile(
              icon: Icons.person_rounded,
              iconBgColor: Color(0xFFF5F5F5),
              iconColor: Colors.grey,
              title: '로그인',
              showArrow: true,
            ),
          ),

          const Divider(height: 1, thickness: 1, color: AppColors.border),

          // 개인정보 처리방침
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: _SettingsInfoTile(
              icon: Icons.shield_rounded,
              iconBgColor: Color(0xFFF3E5F5),
              iconColor: Color(0xFF8E24AA),
              title: '개인정보 처리방침',
              showArrow: true,
            ),
          ),

          const Divider(height: 1, thickness: 1, color: AppColors.border),

          // 이용약관
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: _SettingsInfoTile(
              icon: Icons.description_rounded,
              iconBgColor: Color(0xFFFFF3E0),
              iconColor: Color(0xFFFFA726),
              title: '이용약관',
              showArrow: true,
            ),
          ),

          const Divider(height: 1, thickness: 1, color: AppColors.border),
        ],
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

  const _SettingsSwitchTile({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.value,
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
        style: const TextStyle(
          fontSize: 15,
          color: AppColors.textPrimary,
        ),
      ),
      value: value,
      activeColor: AppColors.primary,
      inactiveTrackColor: Colors.grey[300],
      onChanged: (bool _) {
        // TODO: 나중에 Riverpod 상태랑 연결
      },
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

  const _SettingsInfoTile({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    this.trailingText,
    this.showArrow = false,
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
        style: const TextStyle(
          fontSize: 15,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (trailingText != null)
            Text(
              trailingText!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          if (showArrow)
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.textSecondary,
            ),
        ],
      ),
      onTap: () {
        // TODO: 각 메뉴에 맞는 화면으로 이동
      },
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
