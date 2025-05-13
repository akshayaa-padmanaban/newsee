import 'package:flutter/material.dart';
import 'package:newsee/widgets/dropdown.dart';
import 'package:newsee/widgets/integer_text_field.dart';
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
                items: ['', ''],
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
                items: ['Driving License','Nrega Card'],
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
