import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
//import 'package:flutter/services.dart';

class PersonalDetailsPage extends StatelessWidget {
  final String title;

  PersonalDetailsPage(String s, {required this.title, Key? key}) : super(key: key);

  final form = FormGroup({
    'customertype': FormControl<String>(validators: [Validators.required]),
    'constitution': FormControl<String>(validators: [Validators.required]),
    'leadcategory': FormControl<String>(validators: [Validators.required]),
    'title': FormControl<String>(validators: [Validators.required]),
    'mobilenumber': FormControl<String>(validators: [Validators.required]),
    'emailid': FormControl<String>(validators: [Validators.required]),
    'address': FormControl<String>(validators: [Validators.required]),
    'addressline1': FormControl<String>(validators: [Validators.required]),
    'state': FormControl<String>(validators: [Validators.required]),
    'city': FormControl<String>(validators: [Validators.required]),
    'pincode': FormControl<String>(validators: [Validators.required]),
    'guarantorapplicable': FormControl<String>(validators: [Validators.required]),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text("Personal Details"),
       ),
      body: ReactiveForm(
        formGroup: form,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildDropdown(
                controlName: 'customertype',
                label: 'Customer Type',
                items: ['Existing Customer', 'New Customer'],
              ),
              _buildDropdown(
                controlName: 'constitution',
                label: 'Constitution',
                items: ['HUF', 'Individual', 'LLP', 'Partnership', 'Private Ltd'],
              ),
              _buildDropdown(
                controlName: 'leadcategory',
                label: 'Lead Category',
                items: ['Cold', 'Hot', 'Warm'],
              ),
              _buildDropdown(
                controlName: 'title',
                label: 'Title',
                items: ['COLONEL', 'DR', 'MAJOR'],
              ),
              _buildTextField('mobilenumber', 'Mobile Number'),
              _buildTextField('emailid', 'Email Id'),
              _buildTextField('address', 'Address'),
              _buildTextField('addressline1', 'Address Line 1'),
              _buildTextField('state', 'State'),
              _buildTextField('city', 'City'),
              _buildTextField('pincode', 'Pincode'),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ReactiveDropdownField<String>(
                        formControlName: 'guarantorapplicable',
                        decoration: InputDecoration(
                          labelText: 'Whether Co-App/Guarantor Applicable?',
                          hintText: '--Select--',
                          ),
                          items: ['Yes', 'No']
                          .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                            ))
                            .toList(),
                          ),
                          ),
                          SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              },
                              child: Text("+"),
                              ),
                            ],
                          ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String controlName,
    required String label,
    required List<String> items,
  }) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ReactiveDropdownField<String>(
        formControlName: controlName,
        decoration: InputDecoration(
          labelText: label,
          hintText: '--Select--',
        ),
        items: items
            .map((e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildTextField(String controlName, String label) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ReactiveTextField<String>(
        formControlName: controlName,
        //  keyboardType: controlName == 'mobilenumber' ? TextInputType.number : TextInputType.text,
        //  inputFormatters: controlName == 'mobilenumber'
        //   ? [FilteringTextInputFormatter.digitsOnly]
        //   : [],
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}