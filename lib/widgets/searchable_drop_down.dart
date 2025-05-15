import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SearchableDropdown extends StatelessWidget {
  final String controlName;
  final String label;
  final List<String> items;

  const SearchableDropdown({
    required this.controlName,
    required this.label,
    required this.items,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveFormField<String, String>(
      formControlName: controlName,
      validationMessages: {
        ValidationMessage.required: (error) => '$label is required',
      },
      builder: (field) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            child: DropdownSearch<String>(
              items: items,
              selectedItem: field.value,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: label,
                  errorText: field.errorText,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: const UnderlineInputBorder(),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
              ),
              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
              onChanged: (value) => field.didChange(value),
            ),
          ),
        );
      },
    );
  }
}
