import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:flutter/services.dart';

class LoanDetailsPage extends StatelessWidget {
  final String title;

  LoanDetailsPage(String s, {required this.title, super.key});

  final form = FormGroup({
    'applicanttype': FormControl<String>(validators: [Validators.required]),
    'panno': FormControl<String>(validators: [Validators.required]),
    'aadhaarno': FormControl<String>(
      validators: [
        Validators.required,
        Validators.pattern(r'^\d{12}$'),
      ],
    ),
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
              Dropdown(
                controlName: 'applicanttype',
                label: 'Applicant Type',
                items: ['MSME', 'Retail'],
              ),
              TextField('panno','PAN No',
                onIconTap: () {},
              ),
              TextField('aadhaarno','Aadhaar No',
                onIconTap: () {},
                keyboardType: TextInputType.number, 
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, 
                ],
              ),
              Dropdown(
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
                    if (form.valid) {
                      final tabController = DefaultTabController.of(context);
                      if (tabController.index < tabController.length - 1) {
                        tabController.animateTo(tabController.index + 1);
                      }
                    } else {
                      form.markAllAsTouched();
                    }
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

  Widget Dropdown({
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

  Widget TextField(
    String controlName,
    String label, {
    VoidCallback? onIconTap,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ReactiveTextField<String>(
        formControlName: controlName,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
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
