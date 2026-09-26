import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../widgets/nanma_app_bar.dart';
import '../../../widgets/nanma_button.dart';

class WhatsAppAssistScreen extends StatelessWidget {
  const WhatsAppAssistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NanmaAppBar(
        title: 'WhatsApp Assistance',
        subtitle: 'വാട്ട്സ്ആപ്പ് സഹായം',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            // WhatsApp Icon Circle
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F8EE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_rounded,
                size: 50,
                color: AppColors.whatsAppGreen,
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Need help? Just message Nanma.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Even without browsing the app, you or your elderly family members can simply send a message or voice note on WhatsApp.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textMuted, height: 1.45),
            ),
            const SizedBox(height: 28),

            // 4 Input methods supported
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Send Any of These on WhatsApp:',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
            ),
            const SizedBox(height: 12),
            _buildConceptTile(Icons.mic_rounded, 'Voice Message in Malayalam or English', 'Send a voice clip saying what groceries or medicines you need.'),
            _buildConceptTile(Icons.photo_camera_rounded, 'Photo of Handwritten List', 'Snap your grocery paper or doctor prescription.'),
            _buildConceptTile(Icons.location_on_rounded, 'Live WhatsApp Location Pin', 'Share where the helper needs to arrive.'),
            _buildConceptTile(Icons.text_fields_rounded, 'Simple Text Message', 'Type in your own words in English or Manglish.'),
            const SizedBox(height: 24),

            // Flow Diagram Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppDimensions.roundedMd,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                children: [
                  const Text(
                    'How the Flow Works',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StepBadge(icon: Icons.chat_rounded, label: 'WhatsApp'),
                      Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.textLight),
                      _StepBadge(icon: Icons.smart_toy_rounded, label: 'Nanma AI'),
                      Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.textLight),
                      _StepBadge(icon: Icons.person_pin_rounded, label: 'Worker Assigned'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),

            // Action Button
            NanmaButton(
              text: 'OPEN WHATSAPP CHAT',
              backgroundColor: AppColors.whatsAppGreen,
              icon: Icons.chat_rounded,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Connecting to Nanma Official WhatsApp: +91 94470 NANMA'),
                    backgroundColor: AppColors.whatsAppGreen,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildConceptTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F8EE),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.whatsAppGreen, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textDark)),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StepBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: AppColors.ultraLightGreen,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryGreen, size: 20),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark)),
      ],
    );
  }
}
