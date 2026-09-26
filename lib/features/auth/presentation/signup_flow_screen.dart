import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../models/user_model.dart';
import '../../../widgets/nanma_button.dart';
import '../../../widgets/nanma_text_field.dart';
import '../../../widgets/decorative_leaf_background.dart';
import '../../../providers/app_providers.dart';

class SignupFlowScreen extends ConsumerStatefulWidget {
  const SignupFlowScreen({super.key});

  @override
  ConsumerState<SignupFlowScreen> createState() => _SignupFlowScreenState();
}

class _SignupFlowScreenState extends ConsumerState<SignupFlowScreen> {
  int _currentStep = 0; // 0: Phone, 1: OTP, 2: Details, 3: Address, 4: Role, 5: Language, 6: Success

  // Form Controllers
  final _phoneController = TextEditingController(text: '9876543210');
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  final _fullNameController = TextEditingController(text: 'Anjali Menon');
  String _dob = '14 May 1994';
  String _gender = 'Female';

  final _addressController =
      TextEditingController(text: 'Flat 4B, Palm Grove Residency, Panampilly Nagar');
  final _pincodeController = TextEditingController(text: '682036');
  String _selectedDistrict = 'Ernakulam';

  UserRole _selectedRole = UserRole.customer;
  String _selectedLanguage = 'English';

  int _resendTimerSeconds = 45;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Pre-fill OTP for smooth demo
    const demoOtp = '123456';
    for (int i = 0; i < 6; i++) {
      _otpControllers[i].text = demoOtp[i];
    }
  }

  void _startResendTimer() {
    _timer?.cancel();
    setState(() => _resendTimerSeconds = 45);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimerSeconds > 0) {
        setState(() => _resendTimerSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _otpFocusNodes) {
      f.dispose();
    }
    _fullNameController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _onOtpDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
  }

  void _finishRegistration() {
    final newUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      phoneNumber: '+91 ${_phoneController.text.trim()}',
      fullName: _fullNameController.text.trim(),
      dateOfBirth: _dob,
      gender: _gender,
      address: _addressController.text.trim(),
      pincode: _pincodeController.text.trim(),
      district: _selectedDistrict,
      language: _selectedLanguage == 'മലയാളം' ? 'ml' : 'en',
      role: _selectedRole,
      helpPoints: 240,
    );

    ref.read(currentUserProvider.notifier).state = newUser;
    ref.read(currentRoleProvider.notifier).state = _selectedRole;

    if (_selectedRole == UserRole.worker) {
      context.go('/worker/home');
    } else {
      context.go('/location-permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecorativeLeafBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Top Back button & Step title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    if (_currentStep > 0 && _currentStep < 6)
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.borderSubtle),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              size: 16, color: AppColors.textDark),
                        ),
                        onPressed: () {
                          setState(() {
                            _currentStep--;
                          });
                        },
                      )
                    else
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.borderSubtle),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              size: 16, color: AppColors.textDark),
                        ),
                        onPressed: () => context.go('/login'),
                      ),
                    const Spacer(),
                    if (_currentStep < 6)
                      Text(
                        'Step ${_currentStep + 1} of 6',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      ),
                  ],
                ),
              ),

              // Step Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: _buildStepContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildPhoneStep();
      case 1:
        return _buildOtpStep();
      case 2:
        return _buildDetailsStep();
      case 3:
        return _buildAddressStep();
      case 4:
        return _buildRoleStep();
      case 5:
        return _buildLanguageStep();
      case 6:
        return _buildSuccessStep();
      default:
        return const SizedBox.shrink();
    }
  }

  // STEP 1: Phone
  Widget _buildPhoneStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Create Your Account',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        const SizedBox(height: 6),
        const Text(
          'Enter your mobile number to get started',
          style: TextStyle(fontSize: 14, color: AppColors.textMuted),
        ),
        const SizedBox(height: 36),
        NanmaTextField(
          controller: _phoneController,
          label: 'Mobile Number',
          hintText: 'Enter 10-digit number',
          keyboardType: TextInputType.phone,
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🇮🇳  +91', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                SizedBox(width: 8),
                VerticalDivider(width: 1, thickness: 1, color: AppColors.borderSubtle, indent: 10, endIndent: 10),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        NanmaButton(
          text: 'Continue →',
          onPressed: () {
            if (_phoneController.text.trim().length >= 10) {
              _startResendTimer();
              setState(() => _currentStep = 1);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a valid 10-digit phone number')),
              );
            }
          },
        ),
        const SizedBox(height: 24),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Already have an account? ', style: TextStyle(color: AppColors.textMuted)),
              GestureDetector(
                onTap: () => context.go('/login'),
                child: const Text('Log In', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // STEP 2: OTP
  Widget _buildOtpStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Verify Your Number',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        const SizedBox(height: 6),
        Text(
          'We\'ve sent a 6-digit code to +91 ${_phoneController.text}',
          style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
        ),
        const SizedBox(height: 36),
        // 6 Digit OTP fields
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return SizedBox(
              width: 48,
              height: 56,
              child: TextField(
                controller: _otpControllers[index],
                focusNode: _otpFocusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.borderSubtle),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                  ),
                ),
                onChanged: (val) => _onOtpDigitChanged(index, val),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),
        Center(
          child: Text(
            _resendTimerSeconds > 0
                ? 'Resend code in 00:${_resendTimerSeconds.toString().padLeft(2, '0')}'
                : 'Didn\'t receive code? Tap Resend',
            style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
        ),
        const SizedBox(height: 32),
        NanmaButton(
          text: 'Verify →',
          onPressed: () {
            setState(() => _currentStep = 2);
          },
        ),
      ],
    );
  }

  // STEP 3: Details
  Widget _buildDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Your Details',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        const SizedBox(height: 6),
        const Text(
          'Help us know you better',
          style: TextStyle(fontSize: 14, color: AppColors.textMuted),
        ),
        const SizedBox(height: 28),
        NanmaTextField(
          controller: _fullNameController,
          label: 'Full Name',
          hintText: 'Enter your full name',
          prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primaryGreen),
        ),
        const SizedBox(height: 18),
        // Date of Birth
        const Text(
          'Date of Birth',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime(1994, 5, 14),
              firstDate: DateTime(1930),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() {
                _dob = '${picked.day} / ${picked.month} / ${picked.year}';
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded, size: 20, color: AppColors.primaryGreen),
                const SizedBox(width: 12),
                Text(_dob, style: const TextStyle(fontSize: 15, color: AppColors.textDark)),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textLight),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        // Gender Selector
        const Text(
          'Gender',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark),
        ),
        const SizedBox(height: 10),
        Row(
          children: ['Male', 'Female', 'Other'].map((g) {
            final isSelected = _gender == g;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? AppColors.primaryGreen : Colors.white,
                    foregroundColor: isSelected ? Colors.white : AppColors.textDark,
                    elevation: 0,
                    side: BorderSide(
                      color: isSelected ? AppColors.primaryGreen : AppColors.borderSubtle,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => setState(() => _gender = g),
                  child: Text(g),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 36),
        NanmaButton(
          text: 'Continue →',
          onPressed: () {
            if (_fullNameController.text.trim().isNotEmpty) {
              setState(() => _currentStep = 3);
            }
          },
        ),
      ],
    );
  }

  // STEP 4: Address
  Widget _buildAddressStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Your Address',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        const SizedBox(height: 6),
        const Text(
          'Add your current location for better service',
          style: TextStyle(fontSize: 14, color: AppColors.textMuted),
        ),
        const SizedBox(height: 28),
        NanmaTextField(
          controller: _addressController,
          label: 'Address / House No.',
          hintText: 'Enter street, building, apartment',
          prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.primaryGreen),
          maxLines: 2,
        ),
        const SizedBox(height: 18),
        NanmaTextField(
          controller: _pincodeController,
          label: 'Pincode',
          hintText: '6-digit postal code',
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(Icons.pin_drop_outlined, color: AppColors.primaryGreen),
        ),
        const SizedBox(height: 18),
        const Text(
          'District',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedDistrict,
              items: [
                'Ernakulam',
                'Thiruvananthapuram',
                'Kozhikode',
                'Thrissur',
                'Kottayam',
                'Alappuzha',
                'Malappuram',
                'Kannur',
                'Palakkad',
                'Kollam',
                'Idukki',
                'Pathanamthitta',
                'Wayanad',
                'Kasaragod',
              ].map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedDistrict = val);
              },
            ),
          ),
        ),
        const SizedBox(height: 36),
        NanmaButton(
          text: 'Continue →',
          onPressed: () {
            setState(() => _currentStep = 4);
          },
        ),
      ],
    );
  }

  // STEP 5: Role
  Widget _buildRoleStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Choose Your Role',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        const SizedBox(height: 6),
        const Text(
          'You can change this later in settings',
          style: TextStyle(fontSize: 14, color: AppColors.textMuted),
        ),
        const SizedBox(height: 32),

        // Role Cards with RadioGroup
        RadioGroup<UserRole>(
          groupValue: _selectedRole,
          onChanged: (val) {
            if (val != null) setState(() => _selectedRole = val);
          },
          child: Column(
            children: [
              // Customer Role Card
              _buildRoleSelectionCard(
                role: UserRole.customer,
                title: 'Customer',
                subtitle: 'I need help with household services, delivery and more.',
                icon: Icons.person_rounded,
              ),
              const SizedBox(height: 16),

              // Worker Role Card
              _buildRoleSelectionCard(
                role: UserRole.worker,
                title: 'Worker',
                subtitle: 'I want to provide services and earn with Nanma.',
                icon: Icons.handyman_rounded,
              ),
            ],
          ),
        ),

        const SizedBox(height: 36),
        NanmaButton(
          text: 'Continue →',
          onPressed: () {
            setState(() => _currentStep = 5);
          },
        ),
      ],
    );
  }

  Widget _buildRoleSelectionCard({
    required UserRole role,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedRole == role;
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.cream.withValues(alpha: 0.5) : Colors.white,
        borderRadius: AppDimensions.roundedMd,
        border: Border.all(
          color: isSelected ? AppColors.primaryGreen : AppColors.borderSubtle,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: AppDimensions.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _selectedRole = role),
          borderRadius: AppDimensions.roundedMd,
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.ultraLightGreen : const Color(0xFFF1F4F1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.primaryGreen, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                Radio<UserRole>(
                  value: role,
                  activeColor: AppColors.primaryGreen,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // STEP 6: Language
  Widget _buildLanguageStep() {
    final languages = [
      {'name': 'English', 'native': 'English'},
      {'name': 'Malayalam', 'native': 'മലയാളം (Malayalam)'},
      {'name': 'Hindi', 'native': 'हिन्दी (Hindi)'},
      {'name': 'Tamil', 'native': 'தமிழ் (Tamil)'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Choose Your Language',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        const SizedBox(height: 6),
        const Text(
          'Select your preferred language',
          style: TextStyle(fontSize: 14, color: AppColors.textMuted),
        ),
        const SizedBox(height: 28),

        ...languages.map((lang) {
          final isSelected = _selectedLanguage == lang['name'];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.cream.withValues(alpha: 0.5) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? AppColors.primaryGreen : AppColors.borderSubtle,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: ListTile(
              onTap: () => setState(() => _selectedLanguage = lang['name']!),
              title: Text(
                lang['native']!,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen)
                  : const Icon(Icons.radio_button_unchecked_rounded, color: AppColors.textLight),
            ),
          );
        }),

        const SizedBox(height: 36),
        NanmaButton(
          text: 'Continue →',
          onPressed: () {
            setState(() => _currentStep = 6);
          },
        ),
      ],
    );
  }

  // STEP 7: Success
  Widget _buildSuccessStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 48),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGreen.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 58),
        ),
        const SizedBox(height: 28),
        const Text(
          'You\'re All Set!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Your Nanma account has been created successfully.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 48),
        NanmaButton(
          text: 'Start Exploring →',
          onPressed: _finishRegistration,
        ),
      ],
    );
  }
}
