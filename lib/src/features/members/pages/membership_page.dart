import 'package:evochurch_new/src/features/members/widgets/section_header.dart';
import 'package:evochurch_new/src/features/members/widgets/top_bar_menus.dart';
import 'package:evochurch_new/src/shared/constants/sizedbox.dart';
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
    final formKey = useState(GlobalKey<FormState>());
    // MembersViewModel viewModel =
    //     ref.read(membersViewModelProvider);

    final membershipTextControllers =
        useState<Map<String, TextEditingController>>({});
    final historyControllers = useState<Map<String, TextEditingController>>({});
    final membershipData = useState<Map<String, dynamic>>({});

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

      // Fetch membership data
      getMembershipData() async {
        try {
          // await viewModel.getMemberRoles();

          // membershipData.value = await viewModel.getMembershipByMemberId(
          //     viewModel.selectedMember!.memberId.toString());

          if (membershipData.value['membership'].isNotEmpty) {
            membershipTextControllers.value['baptismChurch']!.text =
                membershipData.value['membership'][0]['baptismChurch'];
            membershipTextControllers.value['baptismPastor']!.text =
                membershipData.value['membership'][0]['baptismPastor'];
            membershipTextControllers.value['membershipRole']!.text =
                membershipData.value['membership'][0]['membershipRole'];
            membershipTextControllers.value['baptismChurchCity']!.text =
                membershipData.value['membership'][0]['baptismChurchCity'];
            membershipTextControllers.value['baptismChurchCountry']!.text =
                membershipData.value['membership'][0]['baptismChurchCountry'];
            membershipTextControllers.value['baptismDate']!.text =
                membershipData.value['membership'][0]['baptismDate'].toString();
            membershipTextControllers.value['hasCredential']!.text =
                membershipData.value['membership'][0]['hasCredential']
                    .toString();
            membershipTextControllers.value['isBaptizedInSpirit']!.text =
                membershipData.value['membership'][0]['isBaptizedInSpirit']
                    .toString();
          } else {
            membershipTextControllers.value['baptismChurch']!.text = '';
            membershipTextControllers.value['baptismPastor']!.text = '';
            membershipTextControllers.value['membershipRole']!.text = '';
            membershipTextControllers.value['baptismChurchCity']!.text = '';
            membershipTextControllers.value['baptismChurchCountry']!.text = '';
            membershipTextControllers.value['baptismDate']!.text = '';
            membershipTextControllers.value['hasCredential']!.text = 'false';
            membershipTextControllers.value['isBaptizedInSpirit']!.text =
                'false';
          }
        } catch (e) {
          throw Exception('Failed to load members $e');
        }
      }

      getMembershipData();

      return () {
        disposeControllers();
      };
    }, []);

    updateMembership() async {
      try {
        if (!formKey.value.currentState!.validate()) {
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
        } else {
          // TODO: Implement membership maintenance functionality
          // final response = await viewModel.setMembershipMaintance({
          //   'profileId': viewModel.selectedMember!.memberId,
          //   'baptismDate': convertDateFormat(membershipTextControllers
          //       .value['baptismDate']!.text
          //       .toString()),
          //   'baptismChurch':
          //       membershipTextControllers.value['baptismChurch']!.text,
          //   'baptismPastor':
          //       membershipTextControllers.value['baptismPastor']!.text,
          //   'membershipRole':
          //       membershipTextControllers.value['membershipRole']!.text,
          //   'baptismChurchCity':
          //       membershipTextControllers.value['baptismChurchCity']!.text,
          //   'baptismChurchCountry':
          //       membershipTextControllers.value['baptismChurchCountry']!.text,
          //   'hasCredential':
          //       membershipTextControllers.value['hasCredential']!.text,
          //   'isBaptizedInSpirit':
          //       membershipTextControllers.value['isBaptizedInSpirit']!.text,
          // });

          if (!context.mounted) return;
          // TODO: Show success message when functionality is implemented
          // if (response['success'] == true) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: const Row(
          //         children: [
          //           Icon(Icons.check_circle, color: Colors.white),
          //           SizedBox(width: 12),
          //           Text('Membership updated successfully'),
          //         ],
          //       ),
          //       backgroundColor: Colors.green,
          //       behavior: SnackBarBehavior.floating,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //     ),
          //   );
          // } else {
          //   if (!context.mounted) return;
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Row(
          //         children: [
          //           const Icon(Icons.error, color: Colors.white),
          //           const SizedBox(width: 12),
          //           Expanded(child: Text('Error: ${response['message']}')),
          //         ],
          //       ),
          //       backgroundColor: Colors.red,
          //     ),
          //   );
          // }
          formKey.value.currentState!.save();
        }
      } catch (e) {
        throw Exception('Failed to update membership $e');
      }
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
        EvoBox.h16,
        Expanded(
          child: Form(
            key: formKey.value,
            child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      // Membership Status Card
                      _buildStatusCard(context, membershipData.value),
                      const SizedBox(height: 24),

                      // Baptism Information Section
                      _buildSectionHeader(
                        context,
                        icon: Icons.water_drop_outlined,
                        title: 'Baptism Information',
                        subtitle: 'Water baptism details',
                      ),
                      const SizedBox(height: 20),
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color:
                                Theme.of(context).dividerColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
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
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Membership Role Section
                      _buildSectionHeader(
                        context,
                        icon: Icons.badge_outlined,
                        title: 'Membership Role',
                        subtitle: 'Current position in church',
                      ),
                      const SizedBox(height: 20),
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color:
                                Theme.of(context).dividerColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        // child: Padding(
                        //   padding: const EdgeInsets.all(20),
                        //   child: Column(
                        //     children: [
                        //       buildDropdownField(
                        //           'Membership Role',
                        //           'membershipRole',
                        //           membershipTextControllers.value,
                        //           viewModel: viewModel),
                        //     ],
                        //   ),
                        // ),
                      ),

                      const SizedBox(height: 24),

                      // Additional Information
                      _buildSectionHeader(
                        context,
                        icon: Icons.info_outline,
                        title: 'Additional Information',
                        subtitle: 'Credentials and spiritual status',
                      ),
                      const SizedBox(height: 20),
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color:
                                Theme.of(context).dividerColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              buildSwitchTile(
                                  'Has Ministerial Credential',
                                  'hasCredential',
                                  context,
                                  membershipTextControllers.value),
                              const SizedBox(height: 16),
                              buildSwitchTile(
                                  'Baptized in the Holy Spirit',
                                  'isBaptizedInSpirit',
                                  context,
                                  membershipTextControllers.value),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Membership History Section
                      if (membershipData.value['membership'] != null &&
                          membershipData.value['membership'].isNotEmpty &&
                          membershipData.value['membership'][0]
                                  ['membershipHistory'] !=
                              null)
                        _buildHistorySection(
                          context,
                          membershipData.value['membership'][0]
                              ['membershipHistory'],
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
        data['membership'].isNotEmpty;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: hasMembership
                ? [Colors.green.shade400, Colors.green.shade600]
                : [Colors.orange.shade400, Colors.orange.shade600],
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
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
                      color: Colors.white.withOpacity(0.9),
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
              color: Theme.of(context).dividerColor.withOpacity(0.2),
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
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
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
                            Theme.of(context).primaryColor.withOpacity(0.1),
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
