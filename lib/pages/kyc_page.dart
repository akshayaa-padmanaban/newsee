import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:flutter/services.dart';

class KycPage extends StatelessWidget {
  final String title;

  KycPage(String s, {required this.title, super.key});

  final form = FormGroup({
    'applicanttype': FormControl<String>(validators: [Validators.required]),
    'panno': FormControl<String>(validators: [Validators.required]),
    'aadhaarno': FormControl<String>(validators: [Validators.required]),
    'otheridproof': FormControl<String>(validators: [Validators.required]),
    'otheridno': FormControl<String>(validators: [Validators.required]),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KYC"),
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
              TextField('panno', 'PAN No'),
              IntegerTextField('aadhaarno', 'Aadhaar No'),
              Dropdown(
                controlName: 'otheridproof',
                label: 'Other ID Proof',
                items: ['Driving License', 'Nrega Card'],
              ),
              ReactiveValueListenableBuilder<String>(
                formControlName: 'otheridproof',
                builder: (context, control, child) {
                  return control.value != null && control.value!.isNotEmpty
                  ? IntegerTextField('otheridno', 'Other ID No')
                  : SizedBox.shrink();
                  },
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

  Widget IntegerTextField(String controlName, String label) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ReactiveTextField<String>(
        formControlName: controlName,
        keyboardType: TextInputType.number, 
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, 
        ],
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }

  Widget TextField(String controlName, String label) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ReactiveTextField<String>(
        formControlName: controlName,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}
