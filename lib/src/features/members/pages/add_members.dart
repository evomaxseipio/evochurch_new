// lib/src/view/members/add_member.dart

import 'package:evochurch_new/src/features/members/models/address_model.dart';
import 'package:evochurch_new/src/features/members/models/contact_model.dart';
import 'package:evochurch_new/src/features/members/widgets/personal_infomation_card.dart';
import 'package:evochurch_new/src/shared/button/button.dart';
import 'package:evochurch_new/src/shared/constants/enum.dart';
import 'package:evochurch_new/src/shared/constants/sizedbox.dart';
import 'package:evochurch_new/src/shared/maintanceWidgets/maintance_widgets.dart';
import 'package:evochurch_new/src/shared/modal/modal.dart';
import 'package:evochurch_new/src/shared/text_editing_controllers.dart';
import 'package:evochurch_new/src/shared/utils/utils_index.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/member_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/members_provider.dart';

/// Widget principal que muestra el botón para agregar miembros
class AddMember extends HookConsumerWidget {
  const AddMember({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return EvoButton(
      onPressed: () => callAddEmployeeModal(context, ref),
      text: 'Add Member',
      icon: const Icon(Icons.person_add),
    );
  }
}

// Variables globales para el formulario
ValueNotifier<List<Map<String, dynamic>>> _routeZoneList = ValueNotifier([]);
final _formKey = GlobalKey<FormState>();
final Map<String, TextEditingController> _memberControllers = {};
final Map<String, TextEditingController> _addressControllers = {};
final Map<String, TextEditingController> _contactControllers = {};

/// Función que muestra el modal para agregar un nuevo miembro
void callAddEmployeeModal(BuildContext context, WidgetRef ref) {
  // Inicializar controladores de texto para información personal
  for (var field in membersControllers) {
    _memberControllers[field] = TextEditingController();
  }

  // Inicializar controladores de dirección
  for (var field in addressControllers) {
    _addressControllers[field] = TextEditingController();
  }

  // Inicializar controladores de contacto
  for (var field in contactControllers) {
    _contactControllers[field] = TextEditingController();
  }

  // Mostrar el modal
  EvoModal.showModal(
    barrierDismissible: true,
    context: context,
    modelType: ModalType.extraLarge,
    modalType: ModalType.extraLarge,
    title: "Agregar Persona",
    leadingIcon: const Icon(
      Icons.people_alt_outlined,
      size: 34,
    ),
    content: Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SECCIÓN 1: INFORMACIÓN PERSONAL
                InformationCard(
                  title: 'Personal Information',
                  children: [
                    // Fila de nombres
                    buildResponsiveRow([
                      buildEditableField(
                        'First Name',
                        'firstName',
                        _memberControllers,
                      ),
                      buildEditableField(
                        'Last Name',
                        'lastName',
                        _memberControllers,
                      ),
                      buildEditableField(
                        'Nick Name',
                        'nickName',
                        _memberControllers,
                      ),
                    ]),
                    const SizedBox(height: 16),

                    // Fila de datos personales
                    buildResponsiveRow([
                      buildDateField(
                        'Date of Birth',
                        'dateOfBirth',
                        context,
                        _memberControllers,
                        isRequired: false,
                      ),
                      // buildDropdownField(
                      //   'Gender',
                      //   'gender',
                      //   _memberControllers,
                      // ),
                      // buildDropdownField(
                      //   'Marital Status',
                      //   'maritalStatus',
                      //   _memberControllers,
                      // ),
                    ]),
                    const SizedBox(height: 16),

                    // Fila de identificación
                    buildResponsiveRow([
                      buildEditableField(
                        'Nationality',
                        'nationality',
                        _memberControllers,
                      ),
                      // buildDropdownField(
                      //   'Id Type',
                      //   'idType',
                      //   _memberControllers,
                      //   isRequired: false,
                      // ),
                      buildEditableField(
                        'Id number',
                        'idNumber',
                        _memberControllers,
                        isRequired: false,
                      ),
                    ]),
                  ],
                ),
                EvoBox.h12,

                // SECCIÓN 2: INFORMACIÓN DE DIRECCIÓN
                buildInformationCard(
                  'Address Information',
                  [
                    // Fila 1 de dirección
                    buildResponsiveRow([
                      buildEditableField(
                        'Street Address',
                        'streetAddress',
                        _addressControllers,
                        isRequired: false,
                      ),
                      buildEditableField(
                        'Province',
                        'stateProvince',
                        _addressControllers,
                        isRequired: false,
                      ),
                    ]),
                    const SizedBox(height: 16),

                    // Fila 2 de dirección
                    buildResponsiveRow([
                      buildEditableField(
                        'City/State',
                        'cityState',
                        _addressControllers,
                      ),
                      // buildDropdownField(
                      //   'Country',
                      //   'country',
                      //   _addressControllers,
                      // ),
                    ]),
                  ],
                ),
                EvoBox.h12,

                // SECCIÓN 3: INFORMACIÓN DE CONTACTO
                buildInformationCard(
                  'Contact Information',
                  [
                    buildResponsiveRow([
                      buildEditableField(
                        'Phone Number',
                        'phone',
                        _contactControllers,
                      ),
                      buildEditableField(
                        'Mobile Phone',
                        'mobilePhone',
                        _contactControllers,
                      ),
                      buildEditableField(
                        'Email',
                        'email',
                        _contactControllers,
                        isRequired: false,
                      ),
                    ]),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    trailingIcon: const Icon(Icons.cancel_rounded),

    // BOTÓN DE GUARDAR
    actions: [
      ValueListenableBuilder(
        valueListenable: _routeZoneList,
        builder: (context, value, child) {
          return EvoButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              // 1. Validar formulario
              if (!_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please fill in all required fields.')));
                return;
              }

              try {
                // 2. Obtener información del usuario autenticado
                final authService = ref.read(authServiceProvider);
                final churchId =
                    int.parse(authService.userMetaData?['church_id'] ?? '0');

                // 3. Parsear fecha de nacimiento
                DateTime birthDate = DateFormat('dd/MM/yyyy')
                    .parse(_memberControllers['dateOfBirth']!.text);

                // 4. Crear modelo de Address
                final addressData = AddressModel(
                    streetAddress:
                        _addressControllers['streetAddress']?.text ?? '',
                    stateProvince:
                        _addressControllers['stateProvince']?.text ?? '',
                    cityState: _addressControllers['cityState']!.text,
                    country: _addressControllers['country']?.text ??
                        'Not Specified');

                // 5. Crear modelo de Contact
                final contactData = ContactModel(
                    phone: _contactControllers['phone']!.text,
                    mobilePhone: _contactControllers['mobilePhone']!.text,
                    email: _contactControllers['email']!.text);

                // 6. Crear modelo de Member
                final newProfile = Member(
                  memberId: '',
                  membershipRole: 'Member',
                  churchId: churchId,
                  firstName: _memberControllers['firstName']!.text,
                  lastName: _memberControllers['lastName']!.text,
                  nickName: _memberControllers['nickName']!.text,
                  dateOfBirth: birthDate,
                  gender: _memberControllers['gender']?.text ?? 'Not Specified',
                  maritalStatus: _memberControllers['maritalStatus']?.text ??
                      'Not Specified',
                  nationality: _memberControllers['nationality']!.text,
                  idType: _memberControllers['idType']?.text ?? 'Not Specified',
                  idNumber: _memberControllers['idNumber']!.text,
                  isMember: false,
                  isActive: true,
                  bio: _memberControllers['firstName']!.text,
                  address: addressData,
                  contact: contactData,
                );

                // 7. Llamar a la función de inserción usando el notifier
                final membersNotifier = ref.read(membersProvider.notifier);
                await membersNotifier.addMember(
                    newProfile, addressData, contactData);

                // 8. Manejar respuesta exitosa
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Member added successfully!')),
                  );
                  Navigator.of(context, rootNavigator: true).pop();
                }
              } catch (e) {
                debugPrint('Error: $e');
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            text: "Save",
            buttonType: ButtonType.save,
          );
        },
      ),
    ],
  );
}
