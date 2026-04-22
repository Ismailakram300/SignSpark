import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.orange.withOpacity(0.2) : Colors.orange.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.gavel_rounded, size: 60, color: Colors.orange.shade700),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "App Terms & Conditions",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildTermCard(
              context,
              number: "1",
              title: "Usage License",
              content: "By downloading or using the app, these terms will automatically apply to you. You are not allowed to copy, or modify the app, any part of the app, or our trademarks in any way.",
            ),
            _buildTermCard(
              context,
              number: "2",
              title: "Intellectual Property",
              content: "You’re not allowed to attempt to extract the source code, translate the app, or make derivative versions. All rights remain with the respective owners.",
            ),
            _buildTermCard(
              context,
              number: "3",
              title: "App Changes & Fees",
              content: "We reserve the right to make changes to the app at any time. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for.",
            ),
            _buildTermCard(
              context,
              number: "4",
              title: "Connectivity Requirements",
              content: "Certain functions of the app will require an active internet connection. We cannot take responsibility for the app not working at full functionality if you don’t have access to Wi-Fi or data.",
            ),
            _buildTermCard(
              context,
              number: "5",
              title: "Policy Updates",
              content: "We may update our Terms and Conditions from time to time. You are advised to review this page periodically for any changes.",
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTermCard(BuildContext context, {required String number, required String title, required String content}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.orange.shade100,
                  child: Text(
                    number,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange.shade800),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: isDark ? Colors.grey.shade400 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
