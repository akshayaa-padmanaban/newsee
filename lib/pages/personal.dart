import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/Model/personal_data.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/personaldetails/presentation/bloc/personal_details_bloc.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';

class Personal extends StatelessWidget {
  final String title;

  Personal(String s, {required this.title, super.key});

  final form = FormGroup({
    'title': FormControl<String>(validators: [Validators.required]),
    'firstName': FormControl<String>(validators: [Validators.required]),
    'middleName': FormControl<String>(validators: [Validators.required]),
    'lastName': FormControl<String>(validators: [Validators.required]),
    'dob': FormControl<String>(validators: [Validators.required]),
    'primaryMobileNumber': FormControl<String>(
      validators: [Validators.required],
    ),
    'secondaryMobileNumber': FormControl<String>(
      validators: [Validators.required],
    ),
    'email': FormControl<String>(validators: [Validators.email]),
    'panNumber': FormControl<String>(validators: [Validators.required]),
    'aadharRefNo': FormControl<String>(validators: [Validators.required]),
    'loanAmountRequested': FormControl<String>(
      validators: [Validators.required],
    ),
    'natureOfActivity': FormControl<String>(validators: [Validators.required]),
  });

  void showSnack(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void goToNextTab(BuildContext context) {
    showSnack(context, message: 'Personal Details Saved Successfully');
    final tabController = DefaultTabController.of(context);
    if (tabController.index < tabController.length - 1) {
      tabController.animateTo(tabController.index + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personal Details"),
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<PersonalDetailsBloc, PersonalDetailsState>(
        listener: (context, state) {
          print(
            'personaldetail::BlocConsumer:listen => ${state.lovList} ${state.personalData} ${state.status?.name}',
          );
          if (state.status == SaveStatus.success) {
            goToNextTab(context);
          }
        },
        builder:
            (context, state) => ReactiveForm(
              formGroup: form,

              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SearchableDropdown(
                        controlName: 'title',
                        label: 'Title',
                        items:
                            state.lovList!
                                .where((v) => v.Header == 'Title')
                                .toList(),
                        onChangeListener:
                            (Lov val) => form.controls['title']?.updateValue(
                              val.optvalue,
                            ),
                      ),
                      CustomTextField(
                        controlName: 'firstName',
                        label: 'First Name',
                        mantatory: true,
                      ),
                      CustomTextField(
                        controlName: 'middleName',
                        label: 'Middle Name',
                        mantatory: true,
                      ),
                      CustomTextField(
                        controlName: 'lastName',
                        label: 'Last Name',
                        mantatory: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ReactiveTextField<String>(
                          formControlName: 'dob',
                          validationMessages: {
                            ValidationMessage.required:
                                (error) => 'Date of Birth is required',
                          },
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Date Of Birth',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: (control) async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now().subtract(
                                Duration(days: 365 * 18),
                              ),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              final formatted =
                                  "${pickedDate.day.toString().padLeft(2, '0')}/"
                                  "${pickedDate.month.toString().padLeft(2, '0')}/"
                                  "${pickedDate.year}";
                              form.control('dob').value = formatted;
                            }
                          },
                        ),
                      ),
                      IntegerTextField(
                        controlName: 'primaryMobileNumber',
                        label: 'Primary Mobile Number',
                        mantatory: true,
                        maxlength: 10,
                        minlength: 10,
                      ),
                      IntegerTextField(
                        controlName: 'secondaryMobileNumber',
                        label: 'Secondary Mobile Number',
                        mantatory: true,
                        maxlength: 10,
                        minlength: 10,
                      ),
                      CustomTextField(
                        controlName: 'email', 
                        label: 'Email Id',
                        mantatory: true,
                      ),
                      CustomTextField(
                        controlName: 'panNumber',
                        label: 'Pan No',
                        mantatory: true,
                      ),
                      IntegerTextField(
                        controlName: 'aadharRefNo', 
                        label: 'Aadhaar No',
                        mantatory: true,
                        maxlength: 12,
                        minlength: 12,
                      ),
                      IntegerTextField(
                        controlName: 'loanAmountRequested',
                        label: 'Loan Amount Required',
                        mantatory: true,
                      ),
                      SearchableDropdown(
                        controlName: 'natureOfActivity',
                        label: 'Nature of Activity',
                        items:
                            state.lovList!
                                .where((v) => v.Header == 'NatureOfActivity')
                                .toList(),
                        onChangeListener:
                            (Lov val) => form.controls['natureOfActivity']
                                ?.updateValue(val.optvalue),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 3, 9, 110),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            print("personal Details value ${form.value}");

                            if (form.valid) {
                              PersonalData personalData = PersonalData.fromMap(
                                form.value,
                              );
                              context.read<PersonalDetailsBloc>().add(
                                PersonalDetailsSaveEvent(
                                  personalData: personalData,
                                ),
                              );
                            } else {
                              form.markAllAsTouched();
                              showSnack(
                                context,
                                message:
                                    'Please Check Error Message and Enter Valid Data',
                              );
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(
                              //     content: Text(
                              //       'Please Check Error Message and Enter Valid Data ',
                              //     ),
                              //   ),
                              // );
                            }
                          },
                          child: Text('Next'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
