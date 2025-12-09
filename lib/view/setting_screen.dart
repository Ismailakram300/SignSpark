// // settings_screen.dart
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// final _secureStorage = FlutterSecureStorage();
//
// class SettingsScreen extends StatefulWidget {
//   final String apiBaseUrl;
//   final String userId;
//   final String role; // "parent" | "child" | "admin"
//
//   const SettingsScreen({
//     Key? key,
//     required this.apiBaseUrl,
//     required this.userId,
//     required this.role,
//   }) : super(key: key);
//
//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }
//
// class _SettingsScreenState extends State<SettingsScreen> {
//   bool _loading = false;
//   bool _notificationsEnabled = true;
//   String _appVersion = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _loadPackageInfo();
//     _loadLocalPrefs();
//   }
//
//   Future<void> _loadPackageInfo() async {
//     final info = await PackageInfo.fromPlatform();
//     setState(() => _appVersion = info.version);
//   }
//
//   Future<void> _loadLocalPrefs() async {
//     // Read persisted preference for notifications (example)
//     final val = await _secureStorage.read(key: 'notifications_enabled');
//     setState(() => _notificationsEnabled = val != 'false');
//   }
//
//   Future<void> _setNotificationsEnabled(bool enabled) async {
//     setState(() => _notificationsEnabled = enabled);
//     await _secureStorage.write(key: 'notifications_enabled', value: enabled ? 'true' : 'false');
//
//     // TODO: Call your backend to register/unregister FCM token for the user.
//     // Example:
//     // await ApiService.toggleNotifications(widget.apiBaseUrl, widget.userId, enabled);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(enabled ? 'Notifications enabled' : 'Notifications disabled')),
//     );
//   }
//
//   Future<void> _logout() async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Logout'),
//         content: const Text('Are you sure you want to logout?'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
//           TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Logout')),
//         ],
//       ),
//     );
//
//     if (confirmed != true) return;
//
//     setState(() => _loading = true);
//     try {
//       final refreshToken = await _secureStorage.read(key: 'refresh_token');
//       // Call API to invalidate refresh token (optional but recommended)
//       if (refreshToken != null) {
//       //  await ApiService.logout(widget.apiBaseUrl, refreshToken);
//       }
//
//       // Clear stored tokens and local user data
//       await _secureStorage.delete(key: 'access_token');
//       await _secureStorage.delete(key: 'refresh_token');
//       await _secureStorage.delete(key: 'user_profile');
//
//       // navigate to login (replace with your auth flow)
//       if (!mounted) return;
//       Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
//     } catch (e) {
//       debugPrint('Logout error: $e');
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logout failed')));
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }
//
//   Future<void> _shareApp() async {
//     final message = 'Check out this app to learn sign language for kids!\nDownload: https://example.com/app';
//     await Share.share(message, subject: 'Deaf Kids Learning App');
//   }
//
//   Future<void> _openAbout() async {
//     // Could navigate to an About screen or open a WebView/URL
//     // Example: open internal about page
//     Navigator.of(context).push(MaterialPageRoute(builder: (_) => AboutScreen(version: _appVersion)));
//   }
//
//   Future<void> _openPrivacy() async {
//     final url = Uri.parse('https://example.com/privacy');
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url, mode: LaunchMode.externalApplication);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cannot open privacy policy')));
//     }
//   }
//
//   Future<void> _openTerms() async {
//     final url = Uri.parse('https://example.com/terms');
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url, mode: LaunchMode.externalApplication);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cannot open terms')));
//     }
//   }
//
//   Future<void> _contactSupport() async {
//     final Uri emailUri = Uri(
//       scheme: 'mailto',
//       path: 'support@example.com',
//       queryParameters: {
//         'subject': 'Support Request - App (${_appVersion})',
//         'body': 'Hi team,\n\nI need help with...'
//       },
//     );
//     if (await canLaunchUrl(emailUri)) {
//       await launchUrl(emailUri);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cannot open email client')));
//     }
//   }
//
//   Future<void> _clearCache() async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Clear Cache'),
//         content: const Text('This will remove downloaded lessons and cached data. Continue?'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
//           TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Clear')),
//         ],
//       ),
//     );
//
//     if (confirmed != true) return;
//
//     setState(() => _loading = true);
//     try {
//       // Implement your cache clearing logic here (e.g., Hive, files)
//       // Example: delete app temp directory (careful in real app!)
//       final tempDir = Directory.systemTemp;
//       if (await tempDir.exists()) {
//         // Keep minimal—don't delete entire systemTemp in production.
//       }
//
//       // Remove your local DB entries for downloads
//       // await LocalDb.deleteAllDownloads();
//
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cache cleared')));
//     } catch (e) {
//       debugPrint('Clear cache error: $e');
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to clear cache')));
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }
//
//   Future<void> _rateApp() async {
//     final url = Uri.parse(
//         Platform.isAndroid ? 'market://details?id=com.yourcompany.yourapp' : 'itms-apps://itunes.apple.com/app/idYOUR_APP_ID');
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url, mode: LaunchMode.externalApplication);
//     } else {
//       // fallback web
//       final web = Uri.parse('https://example.com/app');
//       if (await canLaunchUrl(web)) await launchUrl(web, mode: LaunchMode.externalApplication);
//     }
//   }
//
//   Future<void> _deleteAccount() async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Delete Account'),
//         content: const Text('This will permanently delete your account and all data. Are you sure?'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
//           TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
//         ],
//       ),
//     );
//
//     if (confirmed != true) return;
//
//     setState(() => _loading = true);
//     try {
//       final accessToken = await _secureStorage.read(key: 'access_token');
//       // Call backend delete endpoint
//      // await ApiService.deleteAccount(widget.apiBaseUrl, widget.userId, accessToken ?? '');
//       // Clear local data
//       await _secureStorage.deleteAll();
//
//       if (!mounted) return;
//       Navigator.of(context).pushNamedAndRemoveUntil('/signup', (r) => false);
//     } catch (e) {
//       debugPrint('Delete account error: $e');
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to delete account')));
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isParent = widget.role == 'parent';
//     return Scaffold(
//       appBar: AppBar(title: const Text('Settings')),
//       body: Stack(
//         children: [
//           ListView(
//             padding: const EdgeInsets.all(12),
//             children: [
//               Card(
//                 child: ListTile(
//                   leading: const Icon(Icons.person),
//                   title: const Text('Account'),
//                   subtitle: const Text('Manage your account'),
//                   onTap: () => Navigator.pushNamed(context, '/profile'),
//                 ),
//               ),
//               Card(
//                 child: SwitchListTile(
//                   title: const Text('Notifications'),
//                   subtitle: const Text('Enable visual notifications and reminders'),
//                   value: _notificationsEnabled,
//                   onChanged: (v) => _setNotificationsEnabled(v),
//                   secondary: const Icon(Icons.notifications),
//                 ),
//               ),
//               Card(
//                 child: ListTile(
//                   leading: const Icon(Icons.language),
//                   title: const Text('Language'),
//                   subtitle: const Text('Change app language'),
//                   onTap: () => _showLanguageSelector(),
//                 ),
//               ),
//               Card(
//                 child: ListTile(
//                   leading: const Icon(Icons.share),
//                   title: const Text('Share App'),
//                   subtitle: const Text('Tell a friend about this app'),
//                   onTap: _shareApp,
//                 ),
//               ),
//               Card(
//                 child: ListTile(
//                   leading: const Icon(Icons.info),
//                   title: const Text('About Us'),
//                   subtitle: const Text('Who we are'),
//                   onTap: _openAbout,
//                 ),
//               ),
//               Card(
//                 child: ListTile(
//                   leading: const Icon(Icons.privacy_tip),
//                   title: const Text('Privacy Policy'),
//                   onTap: _openPrivacy,
//                 ),
//               ),
//               Card(
//                 child: ListTile(
//                   leading: const Icon(Icons.article),
//                   title: const Text('Terms & Conditions'),
//                   onTap: _openTerms,
//                 ),
//               ),
//               Card(
//                 child: ListTile(
//                   leading: const Icon(Icons.mail),
//                   title: const Text('Contact / Feedback'),
//                   subtitle: const Text('Contact support or send feedback'),
//                   onTap: _contactSupport,
//                 ),
//               ),
//               Card(
//                 child: ListTile(
//                   leading: const Icon(Icons.download),
//                   title: const Text('Clear Cache'),
//                   subtitle: const Text('Remove downloaded lessons'),
//                   onTap: _clearCache,
//                 ),
//               ),
//
//               if (isParent) ...[
//                 const SizedBox(height: 8),
//                 Card(
//                   child: ListTile(
//                     leading: const Icon(Icons.family_restroom),
//                     title: const Text('Parental Controls'),
//                     subtitle: const Text('Manage child settings and permissions'),
//                     onTap: () => Navigator.pushNamed(context, '/parent-controls'),
//                   ),
//                 ),
//               ],
//
//               const SizedBox(height: 8),
//               Card(
//                 color: Colors.red.shade50,
//                 child: ListTile(
//                   leading: const Icon(Icons.delete_forever, color: Colors.red),
//                   title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
//                   onTap: _deleteAccount,
//                 ),
//               ),
//
//               const SizedBox(height: 12),
//               Center(child: Text('App version: $_appVersion')),
//               const SizedBox(height: 28),
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.logout),
//                 label: const Text('Logout'),
//                 style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
//                 onPressed: _logout,
//               ),
//               const SizedBox(height: 24),
//               Center(
//                 child: TextButton(
//                   onPressed: _rateApp,
//                   child: const Text('Rate the app'),
//                 ),
//               ),
//               const SizedBox(height: 24),
//             ],
//           ),
//
//           if (_loading)
//             Positioned.fill(
//               child: Container(
//                 color: Colors.black26,
//                 child: const Center(child: CircularProgressIndicator()),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   void _showLanguageSelector() {
//     showModalBottomSheet(
//       context: context,
//       builder: (ctx) => Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ListTile(title: const Text('Select language')),
//           ListTile(title: const Text('English'), onTap: () => _selectLanguage('en')),
//           ListTile(title: const Text('Urdu'), onTap: () => _selectLanguage('ur')),
//           ListTile(title: const Text('Cancel'), onTap: () => Navigator.pop(ctx)),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _selectLanguage(String code) async {
//     // persist language in secure storage or local prefs
//     await _secureStorage.write(key: 'app_language', value: code);
//     Navigator.pop(context);
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Language changed')));
//     // You might also trigger app-level locale change here
//   }
// }
//
// class AboutScreen extends StatelessWidget {
//   final String version;
//   const AboutScreen({Key? key, required this.version}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('About Us')),
//       body: Padding(
//         padding: const EdgeInsets.all(18.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Deaf Kids Learning', style: Theme.of(context).textTheme.titleLarge),
//             const SizedBox(height: 8),
//             Text('Our mission: To make sign-language learning joyful and accessible for children.'),
//             const SizedBox(height: 12),
//             Text('Features:', style: Theme.of(context).textTheme.titleMedium),
//             const SizedBox(height: 6),
//             const Text('• Short sign-language videos\n• Interactive quizzes\n• Offline downloads\n• Parental controls'),
//             const SizedBox(height: 20),
//             Text('Version: $version'),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sign_spark/firebase_serivces/firebase_auth.dart';
import 'package:sign_spark/view/login.dart';

import '../controllers/theme_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notification = true;
  bool darkMode = false;
  bool locationTracking = true;
  final ThemeController themeController = Get.find();
  final auth=FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // appBar: AppBar(title: const Text("Settings"), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(height: 40,),
          // 🔵 Profile Section
          // Container(
          //   padding: const EdgeInsets.all(16),
          //   decoration: BoxDecoration(
          //     color: Colors.blue.shade50,
          //     borderRadius: BorderRadius.circular(16),
          //   ),
          //   child: Row(
          //     children: [
          //       const CircleAvatar(
          //         radius: 35,
          //         backgroundImage: NetworkImage(
          //           "https://i.pravatar.cc/150?img=3",
          //         ),
          //       ),
          //       const SizedBox(width: 16),
          //       Expanded(
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: const [
          //             Text(
          //               "User",
          //               style: TextStyle(
          //                 fontSize: 18,
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             ),
          //             SizedBox(height: 4),
          //             Text(
          //               "ismail@example.com",
          //               style: TextStyle(color: Colors.black54),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          const SizedBox(height: 25),

          const Text(
            "Account",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          buildSettingTile(
            title: "Edit Profile",
            icon: Icons.person,
            onTap: () {},
          ),
          buildSettingTile(
            title: "Change Password",
            icon: Icons.lock,
            onTap: () {},
          ),
          buildSettingTile(
            title: "Privacy Policy",
            icon: Icons.privacy_tip,
            onTap: () {},
          ),
          buildSettingTile(
            title: "Terms & Conditions",
            icon: Icons.description,
            onTap: () {},
          ),

          const SizedBox(height: 25),

          const Text(
            "Preferences",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // 🔘 Notification Toggle
          SwitchListTile(
            title: const Text("Notifications"),
            value: notification,
            secondary: const Icon(Icons.notifications),
            onChanged: (value) {
              setState(() => notification = value);
            },
          ),

          // 🔘 Dark Mode Toggle
          SwitchListTile(
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.dark_mode),
            value: themeController.isDarkMode,
            onChanged: (value) {
              themeController.toggleTheme(value);
            },
          ),

          // 🔘 Location Tracking Toggle
          SwitchListTile(
            title: const Text("Location Tracking"),
            value: locationTracking,
            secondary: const Icon(Icons.location_on),
            onChanged: (value) {
              setState(() => locationTracking = value);
            },
          ),

          const SizedBox(height: 25),

          const Text(
            "App",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          buildSettingTile(title: "About App", icon: Icons.info, onTap: () {}),
          buildSettingTile(
            title: "Help & Support",
            icon: Icons.help_outline,
            onTap: () {},
          ),

          const SizedBox(height: 25),

          // 🔴 Logout Button
          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async{

            await  auth.logout();
            await Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=>LoginScreen()));
              print("User Logged Out");
            },
          ),
        ],
      ),
    );
  }

  // 🔧 Reusable List Tile Widget
  Widget buildSettingTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
