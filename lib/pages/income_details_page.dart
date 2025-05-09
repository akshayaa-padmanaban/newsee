import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
//import 'package:flutter/services.dart';

class IncomeDetailsPage extends StatelessWidget {
  final String title;

  IncomeDetailsPage(String s, {required this.title, Key? key}) : super(key: key);

  final form = FormGroup({
    'occupation': FormControl<String>(validators: [Validators.required]),
    'grossincome': FormControl<String>(validators: [Validators.required]),
    'grossmonthly': FormControl<String>(validators: [Validators.required]),
    'netincome': FormControl<String>(validators: [Validators.required]),
    'networth': FormControl<String>(validators: [Validators.required]),
    'company': FormControl<String>(validators: [Validators.required]),
    'totalyears': FormControl<String>(validators: [Validators.required]),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text("Income Details"),
       ),
      body: ReactiveForm(
        formGroup: form,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildDropdown(
                controlName: 'occupation',
                label: 'Occupation',
                items: ['MSME', 'Retail'],
              ),
              _buildTextField('grossincome', 'Gross Income/Salary(₹) (Per Month)'),
              _buildTextField('grossmonthly', 'Gross Monthly Deductions(₹) (Per Month)'),
              _buildTextField('netincome', 'Net Income(₹) (Per Year)'),
              _buildTextField('networth', 'Networth of the Applicant(₹)'),
              _buildTextField('company', 'Company'),
              _buildTextField('totalyears', 'Total Years of Employement'),
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