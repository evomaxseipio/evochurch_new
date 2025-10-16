import 'package:evochurch_new/src/features/members/models/address_model.dart';
import 'package:evochurch_new/src/features/members/models/contact_model.dart';
import 'package:evochurch_new/src/features/members/models/member_model.dart';
import 'package:evochurch_new/src/features/members/widgets/personal_infomation_card.dart';
import 'package:evochurch_new/src/features/members/widgets/section_header.dart';
import 'package:evochurch_new/src/features/members/widgets/top_bar_menus.dart';
import 'package:evochurch_new/src/features/members/providers/members_provider.dart';
import 'package:evochurch_new/src/shared/constants/sizedbox.dart';
import 'package:evochurch_new/src/shared/maintanceWidgets/maintance_widgets.dart';
import 'package:evochurch_new/src/shared/text_editing_controllers.dart';
import 'package:evochurch_new/src/shared/utils/utils_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class MemberMaintance extends HookConsumerWidget {
  final Member? member;

  const MemberMaintance({this.member, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Member? currentMember;
    final formKey = GlobalKey<FormState>();
    final profile = useState<Member?>(null);
    final editMode = useState<String?>(null);
    final memberTextControllers =
        useState<Map<String, TextEditingController>>({});
    final addressTextControllers =
        useState<Map<String, TextEditingController>>({});
    final contactTextControllers =
        useState<Map<String, TextEditingController>>({});

    if (member != null) {
      profile.value = member;
    }

    useEffect(() {
      try {
        // Initialize member controllers
        for (var field in membersControllers) {
          memberTextControllers.value[field] = TextEditingController();
        }

        // Initialize address controllers
        for (var field in addressControllers) {
          addressTextControllers.value[field] = TextEditingController();
        }

        // Initialize contact controllers
        for (var field in contactControllers) {
          contactTextControllers.value[field] = TextEditingController();
        }

        // Populate controllers if profile exists
        if (profile.value != null) {
          currentMember = profile.value;

          // Member Information
          final memberFields = {
            'firstName': currentMember?.firstName ?? '',
            'lastName': currentMember?.lastName ?? '',
            'nickName': currentMember?.nickName ?? '',
            'dateOfBirth': currentMember?.dateOfBirth.toString() ?? '',
            'gender': currentMember?.gender ?? '',
            'maritalStatus': currentMember?.maritalStatus ?? '',
            'nationality': currentMember?.nationality ?? '',
            'idType': currentMember?.idType ?? '',
            'idNumber': currentMember?.idNumber ?? '',
          };

          memberFields.forEach((key, value) {
            memberTextControllers.value[key]?.text = value;
          });

          // Address Information
          final addressFields = {
            'streetAddress': currentMember?.address!.streetAddress ?? '',
            'cityState': currentMember?.address!.cityState ?? '',
            'country': currentMember?.address!.country ?? '',
            'stateProvince': currentMember?.address!.stateProvince ?? '',
          };

          addressFields.forEach((key, value) {
            addressTextControllers.value[key]?.text = value;
          });

          // Contact Information
          final contactFields = {
            'phone': currentMember!.contact!.phone ?? '',
            'mobilePhone': currentMember?.contact!.mobilePhone ?? '',
            'email': currentMember?.contact!.email ?? '',
          };

          contactFields.forEach((key, value) {
            contactTextControllers.value[key]?.text = value;
          });
        }
      } catch (e) {
        debugPrint(e.toString());
      }

      // Cleanup function
      return () {
        for (var controller in memberTextControllers.value.values) {
          controller.dispose();
        }
        for (var controller in addressTextControllers.value.values) {
          controller.dispose();
        }
        for (var controller in contactTextControllers.value.values) {
          controller.dispose();
        }
      };
    }, []);

    updateMember() async {
      try {
        String message = '';
        DateTime birthDate = DateFormat('dd/MM/yyyy')
            .parse(memberTextControllers.value['dateOfBirth']!.text);

        if (formKey.currentState?.validate() ?? false) {
          try {
            final membersNotifier = ref.read(membersProvider.notifier);

            // Address data
            final addressData = AddressModel(
                streetAddress:
                    addressTextControllers.value['streetAddress']!.text,
                stateProvince:
                    addressTextControllers.value['stateProvince']!.text,
                cityState: addressTextControllers.value['cityState']!.text,
                country: addressTextControllers.value['country']!.text);

            // Contact data
            final contactData = ContactModel(
                phone: contactTextControllers.value['phone']!.text,
                mobilePhone: contactTextControllers.value['mobilePhone']!.text,
                email: contactTextControllers.value['email']!.text);

            final memberData = Member(
                memberId: currentMember!.memberId,
                churchId: currentMember!.churchId,
                firstName: memberTextControllers.value['firstName']!.text,
                lastName: memberTextControllers.value['lastName']!.text,
                nickName: memberTextControllers.value['nickName']!.text,
                dateOfBirth: DateTime.parse(birthDate.toString()),
                gender: memberTextControllers.value['gender']!.text,
                maritalStatus:
                    memberTextControllers.value['maritalStatus']!.text,
                nationality: memberTextControllers.value['nationality']!.text,
                idType: memberTextControllers.value['idType']!.text,
                idNumber: memberTextControllers.value['idNumber']!.text,
                isMember: false,
                isActive: true,
                bio: memberTextControllers.value['firstName']!.text,
                address: addressData,
                contact: contactData,
                membershipRole: 'Member');

            await membersNotifier.updateMember(
                memberData, addressData, contactData);

            message = 'Profile updated successfully!';
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 12),
                    Text(message),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            Navigator.of(context, rootNavigator: true).pop();
          } catch (e) {
            debugPrint(e.toString());
          }
        } else {
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
        }
      } catch (e) {
        throw Exception('Failed to update member');
      }
    }

    printMember() async {
      debugPrint('Print Function');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Menu Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: MemberTopMenu(
                  onUpdate: updateMember,
                  onPrint: printMember,
                  headerTitle: sectionHeader(
                    context,
                    icon: Icons.person_outline,
                    title: 'Personal Information',
                    subtitle: 'Basic member details',
                  ),
                ),
              ),
            ],
          ),
        ),
        // EvoBox.h16,

        // Main Form Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 0.0, bottom: 16.0),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Theme.of(context).dividerColor.withAlpha(20),
                  width: 1,
                ),
              ),
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Personal Information Section

                    const SizedBox(height: 20),
                    buildInformationCard(
                      'Personal Information',
                      [
                        // Name fields row
                        buildResponsiveRow([
                          buildEditableField('First Name', 'firstName',
                              memberTextControllers.value),
                          buildEditableField('Last Name', 'lastName',
                              memberTextControllers.value),
                          buildEditableField('Nick Name', 'nickName',
                              memberTextControllers.value),
                        ]),
                        const SizedBox(height: 16),

                        // Personal details row
                        buildResponsiveRow([
                          buildDateField('Date of Birth', 'dateOfBirth',
                              context, memberTextControllers.value,
                              isRequired: false),
                          // buildDropdownField(
                          //   'Gender',
                          //   'gender',
                          //   memberTextControllers.value,
                          // ),
                          // buildDropdownField(
                          //   'Marital Status',
                          //   'maritalStatus',
                          //   memberTextControllers.value,
                          // ),
                        ]),
                        const SizedBox(height: 16),

                        // ID information row
                        buildResponsiveRow([
                          buildEditableField(
                            'Nationality',
                            'nationality',
                            memberTextControllers.value,
                          ),
                          // buildDropdownField(
                          //     'Id Type', 'idType', memberTextControllers.value,
                          //     isRequired: false),
                          buildEditableField('Id number', 'idNumber',
                              memberTextControllers.value,
                              isRequired: false),
                        ]),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Address Information Section
                    sectionHeader(
                      context,
                      icon: Icons.location_on_outlined,
                      title: 'Address Information',
                      subtitle: 'Residential details',
                    ),
                    const SizedBox(height: 20),
                    buildInformationCard(
                      'Address Information',
                      [
                        // Address row 1
                        buildResponsiveRow([
                          buildEditableField('Street Address', 'streetAddress',
                              addressTextControllers.value,
                              isRequired: false),
                          buildEditableField('Province', 'stateProvince',
                              addressTextControllers.value,
                              isRequired: false),
                        ]),
                        const SizedBox(height: 16),

                        // Address row 2
                        buildResponsiveRow([
                          buildEditableField('City/State', 'cityState',
                              addressTextControllers.value),
                          // buildDropdownField(
                          //     'Country', 'country', addressTextControllers.value),
                        ]),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Contact Information Section
                    sectionHeader(
                      context,
                      icon: Icons.contact_phone_outlined,
                      title: 'Contact Information',
                      subtitle: 'Communication details',
                    ),
                    const SizedBox(height: 20),
                    buildInformationCard(
                      'Contact Information',
                      [
                        // Contact row
                        buildResponsiveRow([
                          buildEditableField('Phone Number', 'phone',
                              contactTextControllers.value),
                          buildEditableField('Mobile Phone', 'mobilePhone',
                              contactTextControllers.value),
                          buildEditableField(
                              'Email', 'email', contactTextControllers.value,
                              isRequired: false),
                        ]),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  
}
