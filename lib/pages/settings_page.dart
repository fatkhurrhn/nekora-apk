import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'SETTINGS',
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('PREFERENCES'),
          const SizedBox(height: 8),
          _buildMenuItem(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            trailing: const Text(
              'ON',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.notifications_none,
            title: 'Notifications',
            trailing:
                const Icon(Icons.chevron_right, color: Colors.white, size: 20),
            onTap: () {
              _showComingSoon(context);
            },
          ),
          _buildMenuItem(
            icon: Icons.language_outlined,
            title: 'Language',
            trailing: const Text(
              'EN',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            onTap: () {},
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('PRIVACY & SECURITY'),
          const SizedBox(height: 8),
          _buildMenuItem(
            icon: Icons.lock_outline,
            title: 'Privacy',
            trailing:
                const Icon(Icons.chevron_right, color: Colors.white, size: 20),
            onTap: () {
              _showComingSoon(context);
            },
          ),
          _buildMenuItem(
            icon: Icons.security_outlined,
            title: 'Security',
            trailing:
                const Icon(Icons.chevron_right, color: Colors.white, size: 20),
            onTap: () {
              _showComingSoon(context);
            },
          ),
          _buildMenuItem(
            icon: Icons.visibility_off_outlined,
            title: 'Blocked Users',
            trailing:
                const Icon(Icons.chevron_right, color: Colors.white, size: 20),
            onTap: () {
              _showComingSoon(context);
            },
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('SUPPORT'),
          const SizedBox(height: 8),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'Help Center',
            trailing:
                const Icon(Icons.chevron_right, color: Colors.white, size: 20),
            onTap: () {
              _showComingSoon(context);
            },
          ),
          _buildMenuItem(
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            trailing:
                const Icon(Icons.chevron_right, color: Colors.white, size: 20),
            onTap: () {
              _showComingSoon(context);
            },
          ),
          _buildMenuItem(
            icon: Icons.info_outline,
            title: 'About Nekora',
            trailing:
                const Icon(Icons.chevron_right, color: Colors.white, size: 20),
            onTap: () {
              _showAboutDialog(context);
            },
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('LEGAL'),
          const SizedBox(height: 8),
          _buildMenuItem(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            trailing:
                const Icon(Icons.chevron_right, color: Colors.white, size: 20),
            onTap: () {
              _showComingSoon(context);
            },
          ),
          _buildMenuItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            trailing:
                const Icon(Icons.chevron_right, color: Colors.white, size: 20),
            onTap: () {
              _showComingSoon(context);
            },
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('DANGER ZONE'),
          const SizedBox(height: 8),
          _buildMenuItem(
            icon: Icons.delete_outline,
            title: 'Delete Account',
            trailing:
                const Icon(Icons.chevron_right, color: Colors.white, size: 20),
            color: Colors.red,
            onTap: () {
              _showDeleteAccountDialog(context);
            },
          ),
          const SizedBox(height: 40),
          Center(
            child: Text(
              '🐱 NEKORA v1.0',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 10,
                letterSpacing: 2,
                color: const Color.fromRGBO(255, 255, 255, 0.2),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 11,
          letterSpacing: 1.5,
          color: const Color.fromRGBO(255, 255, 255, 0.45),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required Widget trailing,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.05)),
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.white, size: 22),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 13,
            color: color ?? Colors.white,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '🚧 COMING SOON',
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: Color(0xFF161616),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF161616),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color.fromRGBO(255, 255, 255, 0.08)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.pets, size: 48, color: Colors.white),
              const SizedBox(height: 16),
              Text(
                'NEKORA',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'social media for cats',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 11,
                  color: const Color.fromRGBO(255, 255, 255, 0.45),
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 24),
              _buildInfoRow('Version', '1.0.0'),
              const SizedBox(height: 12),
              _buildInfoRow('Developer', '@nekora'),
              const SizedBox(height: 12),
              _buildInfoRow('License', 'Proprietary'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: Color.fromRGBO(255, 255, 255, 0.2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'CLOSE',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 12,
                      letterSpacing: 1,
                      color: const Color.fromRGBO(255, 255, 255, 0.7),
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 12,
            color: const Color.fromRGBO(255, 255, 255, 0.45),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF161616),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color.fromRGBO(255, 255, 255, 0.08)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  size: 48, color: Color(0xFFEF4444)),
              const SizedBox(height: 16),
              Text(
                'DELETE ACCOUNT',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                  color: const Color(0xFFEF4444),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'This action cannot be undone. All your data, including posts, followers, and messages will be permanently deleted.',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 11,
                  color: const Color.fromRGBO(255, 255, 255, 0.45),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color.fromRGBO(255, 255, 255, 0.2)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 12,
                          letterSpacing: 1,
                          color: const Color.fromRGBO(255, 255, 255, 0.7),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showComingSoon(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'DELETE',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
