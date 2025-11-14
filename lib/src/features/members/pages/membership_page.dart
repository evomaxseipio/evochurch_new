import 'package:evochurch_new/src/features/members/widgets/personal_infomation_card.dart';
import 'package:evochurch_new/src/features/members/widgets/section_header.dart';
import 'package:evochurch_new/src/features/members/widgets/top_bar_menus.dart';
import 'package:evochurch_new/src/features/members/providers/members_provider.dart';
import 'package:evochurch_new/src/shared/text_editing_controllers.dart';
import 'package:evochurch_new/src/shared/utils/utils_index.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:evochurch_new/src/shared/maintanceWidgets/maintance_widgets.dart';

class MembershipPage extends HookConsumerWidget {
  const MembershipPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final selectedMember = ref.watch(selectedMemberProvider);
    final membershipNotifier = ref.watch(membershipNotifierProvider);
    final memberRolesAsync = ref.watch(memberRolesProvider);

    final membershipTextControllers =
        useState<Map<String, TextEditingController>>({});
    final historyControllers = useState<Map<String, TextEditingController>>({});

    // Get membership data if member is selected
    final membershipDataAsync = selectedMember != null
        ? ref.watch(membershipDataProvider(selectedMember.memberId))
        : null;

    disposeControllers() {
      for (var controller in membershipTextControllers.value.values) {
        controller.dispose();
      }
      for (var controller in historyControllers.value.values) {
        controller.dispose();
      }
    }

    useEffect(() {
      for (var field in membershipControllers) {
        membershipTextControllers.value[field] = TextEditingController();
      }

      for (var field in historyControllers.value.keys) {
        historyControllers.value[field] = TextEditingController();
      }

      return () {
        disposeControllers();
      };
    }, []);

    // Populate controllers when membership data is loaded
    useEffect(() {
      if (membershipDataAsync != null) {
        membershipDataAsync.when(
          data: (data) {
            // Use addPostFrameCallback to avoid modifying state during build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final membership = data['membership'];
              if (membership != null && membership is List && membership.isNotEmpty) {
                final membershipItem = membership[0];
                membershipTextControllers.value['baptismChurch']?.text =
                    membershipItem['baptismChurch']?.toString() ?? '';
                membershipTextControllers.value['baptismPastor']?.text =
                    membershipItem['baptismPastor']?.toString() ?? '';
                membershipTextControllers.value['membershipRole']?.text =
                    membershipItem['membershipRole']?.toString() ?? '';
                membershipTextControllers.value['baptismChurchCity']?.text =
                    membershipItem['baptismChurchCity']?.toString() ?? '';
                membershipTextControllers.value['baptismChurchCountry']?.text =
                    membershipItem['baptismChurchCountry']?.toString() ?? '';
                membershipTextControllers.value['baptismDate']?.text =
                    membershipItem['baptismDate']?.toString() ?? '';
                membershipTextControllers.value['hasCredential']?.text =
                    membershipItem['hasCredential']?.toString() ?? 'false';
                membershipTextControllers.value['isBaptizedInSpirit']?.text =
                    membershipItem['isBaptizedInSpirit']?.toString() ?? 'false';
              } else {
                // Initialize with empty/default values
                membershipTextControllers.value['baptismChurch']?.text = '';
                membershipTextControllers.value['baptismPastor']?.text = '';
                membershipTextControllers.value['membershipRole']?.text = '';
                membershipTextControllers.value['baptismChurchCity']?.text = '';
                membershipTextControllers.value['baptismChurchCountry']?.text = '';
                membershipTextControllers.value['baptismDate']?.text = '';
                membershipTextControllers.value['hasCredential']?.text = 'false';
                membershipTextControllers.value['isBaptizedInSpirit']?.text = 'false';
              }
            });
          },
          loading: () {},
          error: (error, stack) {
            debugPrint('Error loading membership data: $error');
            // Use addPostFrameCallback to avoid modifying state during build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Initialize with empty/default values on error
              membershipTextControllers.value['baptismChurch']?.text = '';
              membershipTextControllers.value['baptismPastor']?.text = '';
              membershipTextControllers.value['membershipRole']?.text = '';
              membershipTextControllers.value['baptismChurchCity']?.text = '';
              membershipTextControllers.value['baptismChurchCountry']?.text = '';
              membershipTextControllers.value['baptismDate']?.text = '';
              membershipTextControllers.value['hasCredential']?.text = 'false';
              membershipTextControllers.value['isBaptizedInSpirit']?.text = 'false';
            });
          },
        );
      }
      return null;
    }, [membershipDataAsync]);

    updateMembership() async {
      if (selectedMember == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No member selected'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!formKey.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.warning, color: Colors.white),
                SizedBox(width: 12),
                Text('Please fill in all required fields.'),
              ],
            ),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        return;
      }

      // Prepare membership data
      final membershipData = {
        'baptismDate': membershipTextControllers.value['baptismDate']?.text.isNotEmpty == true
            ? convertDateFormat(membershipTextControllers.value['baptismDate']!.text)
            : null,
        'baptismChurch': membershipTextControllers.value['baptismChurch']?.text ?? '',
        'baptismPastor': membershipTextControllers.value['baptismPastor']?.text ?? '',
        'membershipRole': membershipTextControllers.value['membershipRole']?.text ?? '',
        'baptismChurchCity': membershipTextControllers.value['baptismChurchCity']?.text ?? '',
        'baptismChurchCountry': membershipTextControllers.value['baptismChurchCountry']?.text ?? '',
        'hasCredential': membershipTextControllers.value['hasCredential']?.text == 'true',
        'isBaptizedInSpirit': membershipTextControllers.value['isBaptizedInSpirit']?.text == 'true',
      };

      // Update membership using provider
      await ref.read(membershipNotifierProvider.notifier).updateMembership(
        selectedMember.memberId,
        membershipData,
      );

      // Show result message
      if (!context.mounted) return;
      
      membershipNotifier.when(
        data: (response) {
          if (response['success'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Text('Membership updated successfully'),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        loading: () {},
        error: (error, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Error: ${error.toString()}')),
                ],
              ),
              backgroundColor: Colors.red,
            ),
          );
        },
      );

      formKey.currentState!.save();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MemberTopMenu(onUpdate: updateMembership, onPrint: () {},
        headerTitle: sectionHeader(
          context,
          icon: Icons.badge_outlined,
          title: 'Membership Information',
          subtitle: 'Membership details',
        ),
        ),
        // EvoBox.h16,
        Expanded(
          child: Form(
            key: formKey,
            child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      // Membership Status Card
                      membershipDataAsync != null
                          ? membershipDataAsync.when(
                              data: (data) => _buildStatusCard(context, data),
                              loading: () => const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              error: (_, __) => _buildStatusCard(context, {}),
                            )
                          : _buildStatusCard(context, {}),
                      const SizedBox(height: 24),

                      // Baptism Information Section
                      buildInformationCard(
                        [
                          buildResponsiveRow([
                            buildEditableField(
                                'Baptism Church',
                                'baptismChurch',
                                membershipTextControllers.value),
                            buildEditableField(
                                'Baptism Pastor',
                                'baptismPastor',
                                membershipTextControllers.value),
                          ]),
                          const SizedBox(height: 16),
                          buildResponsiveRow([
                            buildEditableField(
                                'Church City',
                                'baptismChurchCity',
                                membershipTextControllers.value),
                            buildEditableField(
                                'Church Country',
                                'baptismChurchCountry',
                                membershipTextControllers.value),
                          ]),
                          const SizedBox(height: 16),
                          buildResponsiveRow([
                            buildDateField('Baptism Date', 'baptismDate',
                                context, membershipTextControllers.value,
                                isRequired: false),
                          ]),
                        ],
                        header: sectionHeader(
                          context,
                          icon: Icons.water_drop_outlined,
                          title: 'Baptism Information',
                          subtitle: 'Water baptism details',
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Membership Role and Additional Information
                      buildInformationCard(
                        [
                          buildResponsiveRow([
                            memberRolesAsync.when(
                              data: (roles) => buildDropdownField(
                                'Membership Role',
                                'membershipRole',
                                membershipTextControllers.value,
                                items: roles,
                              ),
                              loading: () => const CircularProgressIndicator(),
                              error: (_, __) => buildEditableField(
                                'Membership Role',
                                'membershipRole',
                                membershipTextControllers.value,
                              ),
                            ),
                            buildSwitchTile(
                                'Has Ministerial Credential',
                                'hasCredential',
                                context,
                                membershipTextControllers.value),
                            buildSwitchTile(
                                'Baptized in the Holy Spirit',
                                'isBaptizedInSpirit',
                                context,
                                membershipTextControllers.value),
                          ]),
                        ],
                        header: sectionHeader(
                          context,
                          icon: Icons.badge_outlined,
                          title: 'Membership Role & Additional Information',
                          subtitle: 'Current position, credentials and spiritual status',
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Membership History Section
                      if (membershipDataAsync != null)
                        membershipDataAsync.when(
                          data: (data) {
                            final membership = data['membership'];
                            if (membership != null &&
                                membership is List &&
                                membership.isNotEmpty &&
                                membership[0] is Map &&
                                membership[0]['membershipHistory'] != null) {
                              return _buildHistorySection(
                                context,
                                membership[0]['membershipHistory'],
                              );
                            }
                            return const SizedBox.shrink();
                          },
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(BuildContext context, Map<String, dynamic> data) {
    bool hasMembership = data.isNotEmpty &&
        data['membership'] != null &&
        data['membership'] is List &&
        (data['membership'] as List).isNotEmpty;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: hasMembership
                ? [Colors.green.shade400, Colors.green.shade600]
                : [Colors.orange.shade600, Colors.orange.shade400],
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                hasMembership ? Icons.verified_user : Icons.pending_actions,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasMembership ? 'Active Member' : 'Pending Membership',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hasMembership
                        ? 'Member information is complete'
                        : 'Complete the form to activate membership',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withOpacity(0.6),
                  ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildHistorySection(BuildContext context, List<dynamic> history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          icon: Icons.history,
          title: 'Membership History',
          subtitle: 'Previous roles and transitions',
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: history.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final item = history[index];
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.badge,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                title: Text(
                  item['membershipRole'] ?? 'Unknown Role',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  '${item['dateStart'] ?? 'N/A'} - ${item['dateReturned'] ?? 'Present'}',
                ),
                trailing: item['reason'] != null
                    ? Chip(
                        label: Text(item['reason']),
                        backgroundColor:
                            Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      )
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }
}

