import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.green.withOpacity(0.2) : Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.support_agent_rounded, size: 60, color: Colors.green.shade700),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "How can we help you?",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Find answers or get in touch with us",
                    style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.black54),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Standard Contact Cards
            Row(
              children: [
                Expanded(
                  child: _buildContactCard(
                    context, 
                    icon: Icons.email, 
                    title: "Email", 
                    subtitle: "Send a message", 
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildContactCard(
                    context, 
                    icon: Icons.phone, 
                    title: "Phone", 
                    subtitle: "+1 234 567 890", 
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // FAQ Section
            Text(
              "Frequently Asked Questions",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildFaqItem(
              context,
              "How do I reset my password?",
              "You can reset your password by going to the login screen and tapping on 'Forgot Password'. Follow the instructions sent to your email.",
            ),
            _buildFaqItem(
              context,
              "How do I track my progress?",
              "Your progress is automatically tracked on the Home screen. You can view your current streak and completed lessons there.",
            ),
            _buildFaqItem(
              context,
              "Can I use the app offline?",
              "Currently, some features require an internet connection, but we are working on offline capabilities for future updates.",
            ),
            _buildFaqItem(
              context,
              "How to turn off notifications?",
              "You can manage your notification preferences directly from the Settings screen.",
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required Color color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black12 : Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? color.withOpacity(0.2) : color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey.shade400 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, String question, String answer) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
      ),
      child: Theme(
        data: Theme.of(context).copyWith( dividerColor: Colors.transparent ),
        child: ExpansionTile(
          iconColor: Colors.blue,
          collapsedIconColor: isDark ? Colors.white54 : Colors.black54,
          title: Text(
            question, 
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: isDark ? Colors.white : Colors.black87,
            )
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Text(
                answer, 
                style: TextStyle(
                  color: isDark ? Colors.grey.shade400 : Colors.black54, 
                  height: 1.5,
                  fontSize: 14,
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
