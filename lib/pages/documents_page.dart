import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DocumentsPage extends StatelessWidget {
  final String title;

  DocumentsPage(String s, {required this.title, super.key});

  final form = FormGroup({
    'applicanttype': FormControl<String>(validators: [Validators.required]),
    'document': FormControl<String>(validators: [Validators.required]),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text("Document Details"),
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
              _buildDropdown(
                controlName: 'document',
                label: 'Document Classification',
                items: ['Direct Call', 'Lead Management System', 'Online', 'Partner', 'Website'],
              ),
              SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                },
                child: Text("ADD"),
              ),
              SizedBox(width: 12),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                  },
                  child: Text('Submit'),
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
}