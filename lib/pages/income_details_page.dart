import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:flutter/services.dart';

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
              Dropdown(
                controlName: 'occupation',
                label: 'Occupation',
                items: ['Agriculturalist', 'Business', 'Chartered Accountant',
                'Ex Servicemen', 'Others', 'Pensioner', 'Prof/Self Employed',
                'Salaried'],
              ),
              IntegerTextField('grossincome','Gross Income/Salary(₹) (Per Month)'),
              IntegerTextField('grossmonthly','Gross Monthly Deductions(₹) (Per Month)'),
              IntegerTextField('netincome','Net Income(₹) (Per Year)'),
              IntegerTextField('networth','Networth of the Applicant(₹)'),
              TextField('company', 'Company'),
              IntegerTextField('totalyears','Total Years of Employment'),
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
}
