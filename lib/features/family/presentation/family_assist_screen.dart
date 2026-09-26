import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../models/family_member_model.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../widgets/nanma_app_bar.dart';
import '../../../widgets/nanma_button.dart';

class FamilyAssistScreen extends StatefulWidget {
  const FamilyAssistScreen({super.key});

  @override
  State<FamilyAssistScreen> createState() => _FamilyAssistScreenState();
}

class _FamilyAssistScreenState extends State<FamilyAssistScreen> {
  late List<FamilyMemberModel> _familyMembers;

  @override
  void initState() {
    super.initState();
    _familyMembers = List.from(MockDataService.sampleFamilyMembers);
  }

  void _addFamilyMemberDialog() {
    final nameController = TextEditingController();
    final relationController = TextEditingController(text: 'Mother');
    final phoneController = TextEditingController();
    final addressController = TextEditingController(text: 'Thevara, Kochi');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Family Member', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: relationController,
                decoration: const InputDecoration(labelText: 'Relationship (e.g. Father, Mother)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Residence Address'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                setState(() {
                  _familyMembers.add(
                    FamilyMemberModel(
                      id: 'fam_${DateTime.now().millisecondsSinceEpoch}',
                      name: nameController.text.trim(),
                      relationship: relationController.text.trim(),
                      phoneNumber: phoneController.text.trim(),
                      address: addressController.text.trim(),
                      activeRequestsCount: 0,
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add Member'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NanmaAppBar(
        title: 'Family Assist',
        subtitle: 'കുടുംബാംഗങ്ങൾക്കുള്ള സഹായം',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informative Kerala family care banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: AppDimensions.roundedMd,
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.family_restroom_rounded, color: AppColors.primaryGreen, size: 32),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Care for loved ones remotely',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Order medicine, groceries, and hospital escorts for elderly parents in Kerala with live updates.',
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Family Members List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Connected Family Members',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                TextButton.icon(
                  onPressed: _addFamilyMemberDialog,
                  icon: const Icon(Icons.add_rounded, size: 18, color: AppColors.primaryGreen),
                  label: const Text('Add Member', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ..._familyMembers.map((member) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppDimensions.roundedMd,
                  border: Border.all(color: AppColors.borderSubtle),
                  boxShadow: AppDimensions.cardShadow,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: AppColors.ultraLightGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.elderly_rounded, color: AppColors.primaryGreen, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark),
                              ),
                              Text(
                                '${member.relationship} • ${member.phoneNumber}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                member.address,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: AppColors.divider),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          member.activeRequestsCount > 0
                              ? '1 active care task in progress'
                              : 'No ongoing tasks',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: member.activeRequestsCount > 0 ? AppColors.primaryGreen : AppColors.textLight,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.push('/services/grocery');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            minimumSize: const Size(120, 36),
                          ),
                          child: const Text('Request Help', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 24),
            NanmaButton(
              text: '+ Add New Loved One to Family Care',
              onPressed: _addFamilyMemberDialog,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
