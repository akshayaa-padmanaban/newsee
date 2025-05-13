import 'package:flutter/material.dart';
import 'package:newsee/widgets/dropdown.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LoanDetailsPage extends StatelessWidget {
  final String title;

  LoanDetailsPage(String s, {required this.title, super.key});

  final form = FormGroup({
    'maincategory': FormControl<String>(validators: [Validators.required]),
    'subcategory': FormControl<String>(validators: [Validators.required]),
    'loanproduct': FormControl<String>(validators: [Validators.required]),
    'loanamount': FormControl<String>(validators: [Validators.required]),
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
                controlName: 'maincategory',
                label: 'Main Category',
                items: ['', ''],
              ),
              Dropdown(
                controlName: 'subcategory',
                label: 'Sub Category',
                items: ['', ''],
              ),
              Dropdown(
                controlName: 'loanproduct',
                label: 'Loan Product',
                items: ['', ''],
              ),
              IntegerTextField('loanamount', 'Loan Amount Requested(₹)'),
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
