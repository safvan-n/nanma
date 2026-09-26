import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class VoiceInputButton extends StatefulWidget {
  final ValueChanged<String> onRecordedText;

  const VoiceInputButton({
    super.key,
    required this.onRecordedText,
  });

  @override
  State<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends State<VoiceInputButton> with SingleTickerProviderStateMixin {
  bool _isListening = false;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
    });

    if (_isListening) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Listening in Malayalam / English... Speak your request.'),
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.primaryGreen,
        ),
      );

      // Simulate voice recognition result after 2.5 seconds
      Future.delayed(const Duration(milliseconds: 2500), () {
        if (mounted && _isListening) {
          setState(() {
            _isListening = false;
          });
          widget.onRecordedText(
            'Please buy medicine (Telma 40mg) and deliver it to my mother.',
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _toggleListening,
          child: AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isListening ? AppColors.accentOrange : AppColors.primaryGreen,
                  boxShadow: [
                    BoxShadow(
                      color: (_isListening ? AppColors.accentOrange : AppColors.primaryGreen)
                          .withValues(alpha: _isListening ? (0.3 + 0.3 * _animController.value) : 0.2),
                      blurRadius: _isListening ? (12 + 10 * _animController.value) : 8,
                      spreadRadius: _isListening ? (2 + 4 * _animController.value) : 0,
                    ),
                  ],
                ),
                child: Icon(
                  _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _isListening ? 'Listening... (Speak now)' : 'Tap to speak your request',
          style: TextStyle(
            fontSize: 13,
            fontWeight: _isListening ? FontWeight.bold : FontWeight.w500,
            color: _isListening ? AppColors.darkOrange : AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
