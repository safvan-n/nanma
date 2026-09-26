import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../widgets/nanma_app_bar.dart';
import '../../../widgets/nanma_button.dart';
import '../../../widgets/nanma_text_field.dart';
import '../../../widgets/state_feedback_widgets.dart';
import '../../../providers/app_providers.dart';

class RatingScreen extends ConsumerStatefulWidget {
  final String requestId;

  const RatingScreen({super.key, required this.requestId});

  @override
  ConsumerState<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends ConsumerState<RatingScreen> {
  double _rating = 5.0;
  final List<String> _availableTags = [
    'Helpful',
    'Friendly',
    'On Time',
    'Professional',
    'Careful',
    'Good Communication',
  ];
  final Set<String> _selectedTags = {'Helpful', 'On Time', 'Friendly'};
  final _reviewController = TextEditingController(
    text: 'Ravi was very polite, got the exact items requested and arrived promptly.',
  );

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitRating() async {
    await ref.read(requestsProvider.notifier).submitRating(
          id: widget.requestId,
          rating: _rating,
          review: _reviewController.text.trim(),
          tags: _selectedTags.toList(),
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you! Your rating and feedback were shared with your worker.'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final worker = MockDataService.primaryWorker;

    return Scaffold(
      appBar: const NanmaAppBar(
        title: 'Rate Worker',
        subtitle: 'അഭിപ്രായം രേഖപ്പെടുത്തുക',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            // Worker Avatar & Details
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.ultraLightGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_rounded, size: 48, color: AppColors.primaryGreen),
            ),
            const SizedBox(height: 12),
            Text(
              worker.fullName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Verified Nanma Worker • ${worker.primarySkill}',
              style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
            const SizedBox(height: 24),

            // 5-Star Interactive Rating Widget
            const Text(
              'How was your experience?',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark),
            ),
            const SizedBox(height: 12),
            RatingWidget(
              rating: _rating,
              size: 40,
              onRatingChanged: (newRating) {
                setState(() => _rating = newRating);
              },
            ),
            const SizedBox(height: 8),
            Text(
              '${_rating.toInt()} of 5 Stars',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.accentOrange),
            ),
            const SizedBox(height: 24),

            // Feedback Tags
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'What went well?',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableTags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: isSelected,
                  selectedColor: AppColors.ultraLightGreen,
                  checkmarkColor: AppColors.primaryGreen,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppColors.primaryGreen : AppColors.textDark,
                  ),
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        _selectedTags.add(tag);
                      } else {
                        _selectedTags.remove(tag);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Written review
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Write a short review (Optional)',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
            ),
            const SizedBox(height: 8),
            NanmaTextField(
              controller: _reviewController,
              hintText: 'Share a note of encouragement or feedback...',
              maxLines: 3,
            ),
            const SizedBox(height: 36),

            // Submit Button
            NanmaButton(
              text: 'Submit Feedback & Earn Points →',
              onPressed: _submitRating,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
