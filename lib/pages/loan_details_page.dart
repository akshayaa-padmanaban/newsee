import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LoanDetailsPage extends StatelessWidget {
  final String title;

  LoanDetailsPage(String s, {required this.title, super.key});

  final form = FormGroup({
    'applicanttype': FormControl<String>(validators: [Validators.required]),
    'panno': FormControl<String>(validators: [Validators.required]),
    'aadhaarno': FormControl<String>(validators: [Validators.required]),
    'otheridproof': FormControl<String>(validators: [Validators.required]),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Loan Details"),
      ),
      body: ReactiveForm(
        formGroup: form,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildDropdown(
                controlName: 'applicanttype',
                label: 'Applicant Type',
                items: ['MSME', 'Retail'],
              ),
              _buildTextField(
                'panno',
                'PAN No',
                onIconTap: () {
                },
              ),
              _buildTextField(
                'aadhaarno',
                'Aadhaar No',
                onIconTap: () {
                },
              ),
              _buildDropdown(
                controlName: 'otheridproof',
                label: 'Other ID Proof',
                items: [
                  'Direct Call',
                  'Lead Management System',
                  'Online',
                  'Partner',
                  'Website',
                ],
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                  },
                  child: Text('Next'),
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
      padding: const EdgeInsets.all(16),
      child: ReactiveDropdownField<String>(
        formControlName: controlName,
        decoration: InputDecoration(
          labelText: label,
          hintText: '--Select--',
        ),
        items: items
            .map(
              (e) => DropdownMenuItem<String>(
                value: e,
                child: Text(e),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildTextField(String controlName, String label,
      {VoidCallback? onIconTap}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ReactiveTextField<String>(
        formControlName: controlName,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: onIconTap != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(60, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: onIconTap,
                    child: Icon(Icons.camera_alt, size: 20),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
