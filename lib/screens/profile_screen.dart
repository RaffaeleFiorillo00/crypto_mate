import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilo'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: AppSizes.spacingLarge),
            _buildProfileOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final user = _authService.currentUser;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          children: [
            // Profile picture
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: user?.photoURL != null
                  ? ClipOval(
                      child: Image.network(
                        user!.photoURL!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            size: 50,
                            color: AppColors.primary,
                          );
                        },
                      ),
                    )
                  : Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.primary,
                    ),
            ),
            const SizedBox(height: AppSizes.spacing),
            
            // User info
            Text(
              user?.displayName ?? 'Utente',
              style: AppTextStyles.headline2.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.spacingSmall),
            Text(
              user?.email ?? 'email@example.com',
              style: AppTextStyles.body1.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: AppSizes.spacing),
            
            // Account type badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Account Gratuito',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOptions() {
    return Card(
      child: Column(
        children: [
          _buildProfileOption(
            icon: Icons.settings,
            title: 'Impostazioni',
            subtitle: 'Personalizza la tua esperienza',
            onTap: () {
              // Navigate to settings
            },
          ),
          _buildProfileOption(
            icon: Icons.notifications,
            title: 'Notifiche',
            subtitle: 'Gestisci le notifiche push',
            onTap: () {
              // Navigate to notifications settings
            },
          ),
          _buildProfileOption(
            icon: Icons.security,
            title: 'Sicurezza',
            subtitle: 'Password e autenticazione',
            onTap: () {
              // Navigate to security settings
            },
          ),
          _buildProfileOption(
            icon: Icons.help_outline,
            title: 'Aiuto e Supporto',
            subtitle: 'FAQ e contatti',
            onTap: () {
              // Navigate to help
            },
          ),
          _buildProfileOption(
            icon: Icons.info_outline,
            title: 'Informazioni App',
            subtitle: 'Versione e licenze',
            onTap: () {
              // Show app info
            },
          ),
          _buildProfileOption(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Esci dall\'account',
            onTap: _showLogoutDialog,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : AppColors.primary,
      ),
      title: Text(
        title,
        style: AppTextStyles.body1.copyWith(
          fontWeight: FontWeight.w600,
          color: isDestructive ? AppColors.error : null,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.caption.copyWith(
          color: Colors.grey[600],
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Sei sicuro di voler uscire dall\'account?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _logout();
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    try {
      await _authService.signOut();
      // Navigate to login screen
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore durante il logout: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
} 