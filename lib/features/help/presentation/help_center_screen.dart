import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../widgets/nanma_app_bar.dart';
import '../../../widgets/nanma_search_bar.dart';
import '../../../widgets/whatsapp_button.dart';

class HelpCenterScreen extends StatefulWidget {
  final bool isEmbedded;

  const HelpCenterScreen({super.key, this.isEmbedded = false});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  String _searchFilter = '';

  final List<Map<String, String>> _faqs = [
    {
      'q': 'How does Nanma work?',
      'a': 'Nanma connects you directly with verified neighborhood helpers for groceries, medicines, repairs, elderly companionship and local tasks. Once you create a request, a nearby worker accepts and completes it.',
    },
    {
      'q': 'How are Nanma workers verified?',
      'a': 'All workers undergo in-person Aadhaar identity verification, background checks, police clearance verification, and basic training before being accepted into the network.',
    },
    {
      'q': 'Can I order groceries with a handwritten list?',
      'a': 'Yes! You can either type items or upload a photo of your handwritten paper list in the Grocery section. The worker will verify items before billing.',
    },
    {
      'q': 'What is WhatsApp Assistance?',
      'a': 'If you or your parents find the app difficult, simply message or send a voice note to our Nanma WhatsApp bot. Our system converts it into a request and assigns a worker.',
    },
    {
      'q': 'How do payments and tips work?',
      'a': 'You can pay securely via UPI (Google Pay, PhonePe, Paytm), Cards, Net Banking, or Cash. You can also add an optional tip to support your worker.',
    },
    {
      'q': 'What should I do in an emergency?',
      'a': 'Use the red SOS Emergency button on the Home screen or Elderly Mode. It immediately connects you with your family emergency contact and emergency response helpline.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredFaqs = _faqs.where((f) {
      if (_searchFilter.isEmpty) return true;
      return f['q']!.toLowerCase().contains(_searchFilter.toLowerCase()) ||
          f['a']!.toLowerCase().contains(_searchFilter.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: NanmaAppBar(
        title: 'Help Center',
        subtitle: 'സഹായ കേന്ദ്രം',
        showBackButton: !widget.isEmbedded,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search FAQ
            NanmaSearchBar(
              hintText: 'Search FAQ or help topic...',
              onChanged: (val) => setState(() => _searchFilter = val),
            ),
            const SizedBox(height: 16),

            // WhatsApp Direct Help Banner
            WhatsAppButton(
              onTap: () => context.push('/whatsapp-assist'),
              label: 'Chat with Nanma Support on WhatsApp',
            ),
            const SizedBox(height: 20),

            // Quick Help Category Grid
            const Text(
              'Browse by Topic',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildTopicCard(Icons.shopping_bag_outlined, 'Requests'),
                const SizedBox(width: 10),
                _buildTopicCard(Icons.payment_outlined, 'Payments'),
                const SizedBox(width: 10),
                _buildTopicCard(Icons.shield_outlined, 'Safety'),
                const SizedBox(width: 10),
                _buildTopicCard(Icons.handyman_outlined, 'Workers'),
              ],
            ),
            const SizedBox(height: 24),

            // FAQ Accordion List
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 12),
            ...filteredFaqs.map((faq) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppDimensions.roundedMd,
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: ExpansionTile(
                  shape: const RoundedRectangleBorder(side: BorderSide.none),
                  collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
                  iconColor: AppColors.primaryGreen,
                  collapsedIconColor: AppColors.textLight,
                  title: Text(
                    faq['q']!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      child: Text(
                        faq['a']!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),

            // Report a Problem / Call Helpline card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: AppDimensions.roundedMd,
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.support_agent_rounded, size: 36, color: AppColors.primaryGreen),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Still need help?',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Our local Kerala support team is available 24/7',
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Calling Nanma Support Toll-Free Helpline: 1800-425-NANMA'),
                          backgroundColor: AppColors.primaryGreen,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      minimumSize: const Size(60, 36),
                    ),
                    child: const Text('Call', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard(IconData icon, String title) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderSubtle),
          boxShadow: AppDimensions.cardShadow,
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: AppColors.primaryGreen),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark),
            ),
          ],
        ),
      ),
    );
  }
}
