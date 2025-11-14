
import 'package:evochurch_new/src/shared/text/index_text.dart';
import 'package:evochurch_new/src/shared/utils/utils_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

// Side Bar Items
Widget buildSidebarItem(String title, String selectedItem, IconData icon,
    {required VoidCallback onTap, bool isDestructive = false}) {
  final isActive = title == selectedItem;

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isActive ? Colors.blue[100] : Colors.transparent,
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center, // Center text
          children: [
            isDestructive
                ? Icon(icon, size: 20, color: Colors.red)
                : Icon(
                    icon,
                    color: isActive
                        ? const Color.fromARGB(255, 18, 67, 152)
                        : Colors.grey.shade400,
                    size: isActive ? 23 : 20,
                  ),
            const SizedBox(width: 8), // Space between icon and text
            Text(
              title,
              style: TextStyle(
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
                color: isDestructive
                    ? Colors.red
                    : isActive
                        ? const Color.fromARGB(255, 18, 67, 152)
                        : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class FormEditableField extends StatelessWidget {
  final String label;
  final String? value;

  const FormEditableField({
    super.key,
    required this.label,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value!,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

String splitCamelCase(String input) {
  return input.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'), (Match m) => '${m[1]} ${m[2]}');
}

Widget buildEditableField(
    String label, String field, Map<String, TextEditingController> controllers,
    {bool isRequired = true,
    bool isNumeric = false,
    bool isReadOnly = false,
    bool isPassword = false,
    int? maxLength,
    int? maxLine = 1}) {
  // Add null check and debug information
  final controller = controllers[field];
  if (controller == null) {
    return const SizedBox
        .shrink(); // Return empty widget if controller not found
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        (splitCamelCase(label.capitalize)),
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      EvoCustomTextField(
        // labelText: label,
        keyboardType: isNumeric
            ? const TextInputType.numberWithOptions(decimal: true)
            : null,
        controller: controllers[field],
        obscureText: isPassword,
        maxLines: maxLine,
        maxLength: maxLength,
        isNumberOnly: isNumeric,
        // allowDecimals: isNumeric,
        // decimalPlaces: isNumeric ? 0 : 0,
        readOnly: isReadOnly,
        validator: isRequired
            ? (value) {
                if (value?.isEmpty == true || value!.trim().isEmpty) {
                  return 'Please enter $label';
                }

                if (field == 'email' &&
                    !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }

                return null;
              }
            : null,
      ),
    ],
  );
}

Widget buildDateField(String label, String field, BuildContext context,
    Map<String, TextEditingController> controllers,
    {bool isRequired = true}) {
  // Verify is field is null and add the today
  if (controllers[field]!.text.isEmpty) {
    controllers[field] = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
  } else {
    controllers[field] =
        TextEditingController(text: formatDate(controllers[field]!.text));
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        splitCamelCase(label.capitalize),
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: EvoCustomTextField(
          controller: controllers[field] ?? TextEditingController(),
          suffixIcon: const Icon(Icons.calendar_today),
          validator: isRequired
              ? (value) => value?.isEmpty == true
                  ? 'Please enter ${splitCamelCase(label.capitalize)}'
                  : null
              : null,
          onTap: () async {
            DateTime initialDate;
            try {
              initialDate = controllers[field]?.text.isNotEmpty == true
                  ? DateFormat('dd/MM/yyyy').parse(controllers[field]!.text)
                  : DateTime.now();
            } catch (e) {
              initialDate = DateTime.now();
            }

            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(1900),
                lastDate: DateTime.now().add(const Duration(days: 365 * 100)));
            if (pickedDate != null) {
              controllers[field]?.text =
                  DateFormat('dd/MM/yyyy').format(pickedDate);
            }
          },
          readOnly: true,
        ),
      ),
    ],
  );
}



Widget buildDropdownField(
    String label, 
    String field, 
    Map<String, TextEditingController> controllers,
    {required List<String> items, 
    bool isRequired = true, 
    bool isReadOnly = false}) {
  
  final controller = controllers[field];
  if (controller == null) {
    return const SizedBox.shrink();
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        splitCamelCase(label.capitalize),
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      _DropdownFieldHook(
        field: field,
        label: label,
        controller: controller,
        items: items,
        isRequired: isRequired,
        isReadOnly: isReadOnly,
      ),
    ],
  );
}

class _DropdownFieldHook extends HookWidget {
  final String field;
  final String label;
  final TextEditingController controller;
  final List<String> items;
  final bool isRequired;
  final bool isReadOnly;

  const _DropdownFieldHook({
    required this.field,
    required this.label,
    required this.controller,
    required this.items,
    required this.isRequired,
    required this.isReadOnly,
  });

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(4),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final selectedValue = useState<String?>(
      controller.text.isNotEmpty && items.contains(controller.text)
          ? controller.text
          : null,
    );

    useEffect(() {
      void listener() {
        final newValue = controller.text;
        if (newValue.isNotEmpty && 
            items.contains(newValue) && 
            newValue != selectedValue.value) {
          selectedValue.value = newValue;
        }
      }

      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [controller]);

    return DropdownButtonFormField<String>(
      value: selectedValue.value,
      hint: Text(
        'Select $label',
        style: theme.inputDecorationTheme.hintStyle ??
            theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
      ),
      isExpanded: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        suffixIconConstraints: const BoxConstraints(minWidth: 30),
        filled: true,
        fillColor: theme.inputDecorationTheme.fillColor ?? 
                   theme.colorScheme.surface,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 13, 
          vertical: 11,
        ),
        errorStyle: theme.inputDecorationTheme.errorStyle ??
            const TextStyle(fontSize: 14, height: 0.7, color: Colors.red),
        enabledBorder: _buildBorder(
          theme.inputDecorationTheme.enabledBorder?.borderSide.color ??
              theme.colorScheme.outline,
        ),
        focusedBorder: _buildBorder(
          theme.inputDecorationTheme.focusedBorder?.borderSide.color ??
              theme.colorScheme.primary,
        ),
        errorBorder: _buildBorder(
          theme.inputDecorationTheme.errorBorder?.borderSide.color ??
              theme.colorScheme.error,
        ),
        focusedErrorBorder: _buildBorder(
          theme.inputDecorationTheme.focusedErrorBorder?.borderSide.color ??
              theme.colorScheme.error,
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: isReadOnly
          ? null
          : (value) {
              if (value != null) {
                selectedValue.value = value;
                controller.text = value;
              }
            },
      validator: isRequired
          ? (value) => value == null
              ? 'Please enter $label'
              : null
          : null,
      dropdownColor: theme.inputDecorationTheme.fillColor ?? 
                     theme.colorScheme.surface,
    );
  }
}
/*
Widget buildDropdownFieldNew<T>({
  required String label,
  required String field,
  required Map<String, TextEditingController> controllers,
  required List<Map<String, String>> items, // List of items to show in dropdown
  required String valueKey, // Key for the value (e.g., 'id')
  required String displayKey, // Key for display text (e.g., 'fundname')
  MembersViewModel? viewModel,
  bool isRequired = true,
  bool isReadOnly = false,
}) {
  // Get initial value based on controller's text
  String? initialValue = controllers[field]?.text.isNotEmpty == true
      ? items.firstWhere(
          (item) => item[valueKey] == controllers[field]?.text,
          orElse: () => items.first,
        )[valueKey]
      : null;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        splitCamelCase(label).capitalize,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: StatefulBuilder(
          builder: (context, setState) => DropdownButtonFormField<String>(
            initialValue: initialValue,
            isDense: true,
            hint: Text('Select $label'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              suffixIconConstraints: const BoxConstraints(minWidth: 30),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              errorStyle:
                  const TextStyle(fontSize: 14, height: 0.7, color: Colors.red),
            ),
            items: items
                .map((item) => DropdownMenuItem(
                      value: item[valueKey],

                      // enabled: isReadOnly,
                      child: Text(item[displayKey] ?? ''),
                    ))
                .toList(),
            onChanged: isReadOnly
                ? null
                : (value) {
                    try {
                      if (value != null) {
                        controllers[field]!.text = value;
                        setState(() => initialValue = value);
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  },
            validator: isRequired
                ? (value) => value == null
                    ? 'Please select ${splitCamelCase(label.capitalize)}'
                    : null
                : null,
          ),
        ),
      ),
    ],
  );
}

List<String> _getDropdownItems(String field, {MembersViewModel? viewModel}) {
  // Initialize the membershipRoles list
  List<String> membershipRoles = [];

  // Get the data from database in case field is membershipRole
  if (field == 'membershipRole') {
    membershipRoles = viewModel!.memberRoles;
  }

  if (field == 'gender') {
    return ['Male', 'Female'];
  } else if (field == 'identificationType') {
    return ['passport', 'idCard'];
  } else if (field == 'maritalStatus') {
    return ['Single', 'Married', 'Divorced', 'Widowed'];
  } else if (field == 'idType') {
    return ['Passport', 'ID Card', 'Drivers License'];
  } else if (field == 'isMember') {
    return ['Active Member', 'Not a Member'];
  } else if (field == 'isActive') {
    return ['Active', 'Inactive'];
  } else if (field == 'country') {
    return countryList;
  } else if (field == 'membershipRole') {
    return membershipRoles;
  } else if (field == 'fundName') {
    return fundDataList;
  } else if (field == 'paymentMethod' || field == 'payment_method') {
    return paymentMethodList;
  } else if (field == 'expenseCategory') {
    return categoryExpensetypeList; // For descending order
  } else {
    return [];
  }
}*/



Widget buildSwitchTile(
  String label,
  String field,
  BuildContext context,
  Map<String, TextEditingController> controllers, {
  bool isRequired = true,
}) {
  // Initialize the controller if it doesn't exist
  if (!controllers.containsKey(field) || controllers[field] == null) {
    controllers[field] = TextEditingController(text: 'false');
  }
  // Parse the current value, default to false if empty or invalid
  bool isPrimary = false;

  try {
    isPrimary = controllers[field]!.text.isNotEmpty
        ? controllers[field]!.text.toLowerCase() == 'true'
        : false;
  } catch (e) {
    isPrimary = false;
    controllers[field]!.text = 'false';
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        splitCamelCase(label.capitalize),
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controllers[field]!,
          builder: (context, value, child) {
            final currentValue = value.text.toLowerCase() == 'true';
            return ToggleSwitch(
              minWidth: 90.0,
              initialLabelIndex: !currentValue ? 1: 0,
              cornerRadius: 20.0,
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.grey,
              inactiveFgColor: Colors.white,
              totalSwitches: 2,
              labels: const ['Si', 'No'],
              icons: const [
                FontAwesomeIcons.circleCheck,
                FontAwesomeIcons.circleXmark,
              ],
              activeBgColors: const [
                [Colors.purpleAccent, Colors.purple],
                [Colors.red],
              ],
              onToggle: (selectedIndex) {
                final newValue = selectedIndex == 0;
                controllers[field]!.text = newValue.toString();
              },
            );
          },
        ),
      ),
    ],
  );
}

