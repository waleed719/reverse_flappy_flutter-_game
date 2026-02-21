import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../player_progress/player_progress.dart';
import '../style/juicy_button.dart';
import '../style/palette.dart';
import 'custom_name_dialog.dart';
import 'settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final palette = context.watch<Palette>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: palette.backgroundLightBlue),
        child: SafeArea(
          child: Column(
            children: [
              // Yellow header bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: palette.primaryYellow,
                  boxShadow: [
                    BoxShadow(
                      color: palette.buttonYellowShadow,
                      offset: const Offset(0, 4),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Back button
                    Material(
                      color: Colors.white.withAlpha(60),
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: () => GoRouter.of(context).pop(),
                        customBorder: const CircleBorder(),
                        child: const SizedBox(
                          width: 40,
                          height: 40,
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'SETTINGS',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),

              // Settings body
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        // AUDIO section
                        _SectionHeader(label: 'AUDIO', palette: palette),
                        const SizedBox(height: 12),
                        _buildCard(
                          palette,
                          children: [
                            ValueListenableBuilder<bool>(
                              valueListenable: settings.musicOn,
                              builder: (context, musicOn, _) => _JuicyToggleRow(
                                label: 'Music',
                                subtitle: 'Background music',
                                icon: Icons.music_note_rounded,
                                value: musicOn,
                                activeColor: palette.primaryOrange,
                                onChanged: (_) => settings.toggleMusicOn(),
                              ),
                            ),
                            Divider(
                              color: palette.textDark.withAlpha(20),
                              height: 1,
                            ),
                            ValueListenableBuilder<bool>(
                              valueListenable: settings.soundsOn,
                              builder: (context, soundsOn, _) =>
                                  _JuicyToggleRow(
                                    label: 'SFX',
                                    subtitle: 'Sound effects',
                                    icon: Icons.graphic_eq_rounded,
                                    value: soundsOn,
                                    activeColor: palette.primaryOrange,
                                    onChanged: (_) => settings.toggleSoundsOn(),
                                  ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // GAMEPLAY section
                        _SectionHeader(label: 'GAMEPLAY', palette: palette),
                        const SizedBox(height: 12),
                        _buildCard(
                          palette,
                          children: [
                            _JuicyToggleRow(
                              label: 'Haptics',
                              subtitle: 'Vibrate on crash',
                              icon: Icons.vibration_rounded,
                              value: true,
                              activeColor: palette.primaryOrange,
                              onChanged: (_) {},
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ACCOUNT section
                        _SectionHeader(label: 'ACCOUNT', palette: palette),
                        const SizedBox(height: 12),
                        _buildCard(
                          palette,
                          children: [
                            _ActionRow(
                              label: 'Player Name',
                              icon: Icons.person_rounded,
                              palette: palette,
                              onTap: () => showCustomNameDialog(context),
                              trailing: ValueListenableBuilder(
                                valueListenable: settings.playerName,
                                builder: (_, name, _) => Text(
                                  name,
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: palette.primaryCyan,
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              color: palette.textDark.withAlpha(20),
                              height: 1,
                            ),
                            _ActionRow(
                              label: 'Reset Progress',
                              icon: Icons.delete_outline_rounded,
                              palette: palette,
                              onTap: () {
                                context.read<PlayerProgress>().reset();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Player progress has been reset.',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // Save button
                        Center(
                          child: JuicyButton(
                            label: 'SAVE CHANGES',
                            icon: Icons.check_rounded,
                            color: palette.buttonYellow,
                            shadowColor: palette.buttonYellowShadow,
                            fontSize: 16,
                            height: 52,
                            onPressed: () => GoRouter.of(context).pop(),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Footer
                        Center(
                          child: Text(
                            'v1.2.4',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 12,
                              color: palette.textDark.withAlpha(100),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(Palette palette, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: palette.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final Palette palette;

  const _SectionHeader({required this.label, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.beVietnamPro(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: palette.textDark.withAlpha(130),
        letterSpacing: 2,
      ),
    );
  }
}

class _JuicyToggleRow extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final bool value;
  final Color activeColor;
  final ValueChanged<bool> onChanged;

  const _JuicyToggleRow({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: activeColor, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    color: const Color(0xFF1A1A2E).withAlpha(120),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: activeColor,
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final Palette palette;
  final VoidCallback onTap;
  final Widget? trailing;

  const _ActionRow({
    required this.label,
    required this.icon,
    required this.palette,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: palette.primaryCyan, size: 24),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: palette.textDark,
                ),
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right_rounded,
                  color: palette.textDark.withAlpha(80),
                  size: 20,
                ),
          ],
        ),
      ),
    );
  }
}
