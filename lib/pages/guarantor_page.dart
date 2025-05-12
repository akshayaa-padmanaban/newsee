import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:flutter/services.dart';  

class GuarantorPage extends StatelessWidget {
  final String title;

  GuarantorPage(String s, {required this.title, Key? key}) : super(key: key);

  final form = FormGroup({
    'applicanttype': FormControl<String>(validators: [Validators.required]),
    'title': FormControl<String>(validators: [Validators.required]),
    'firstname': FormControl<String>(validators: [Validators.required]),
    'lastname': FormControl<String>(validators: [Validators.required]),
    'mobilenumber': FormControl<String>(validators: [Validators.required]),
    'networth': FormControl<String>(validators: [Validators.required]),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Additional Borrowers"),
      ),
      body: ReactiveForm(
        formGroup: form,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Dropdown(
                controlName: 'applicanttype',
                label: 'Applicant Type',
                items: ['Co-Applicant', 'Guarantor'],
              ),
              Dropdown(
                controlName: 'title',
                label: 'Title',
                items: ['COLONEL', 'DR', 'LT.COL', 'M/S', 'MAJOR', 'MASTER(MINOR)',
                'MESSERS', 'MIGRATION DEFAULT', 'MISS', 'MOHAMMAD', 'MR', 'MRS', 
                'MX', 'SHEIKH', 'SIR'],
              ),
              TextField('firstname', 'First Name'),
              TextField('lastname', 'Last Name'),
              TextField('mobilenumber', 'Mobile Number', isNumber: true), 
              TextField('networth', 'Networth of the Applicant(₹)', isNumber: true),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                  },
                  child: Text('Save'),
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

  Widget TextField(String controlName, String label, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ReactiveTextField<String>(
        formControlName: controlName,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,  
        inputFormatters: isNumber
            ? [FilteringTextInputFormatter.digitsOnly] 
            : [],
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}