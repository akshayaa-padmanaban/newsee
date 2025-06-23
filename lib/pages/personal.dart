import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/Model/personal_data.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/aadharvalidation/domain/modal/aadharvalidate_request.dart';
import 'package:newsee/feature/dedupe/presentation/bloc/dedupe_bloc.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/personaldetails/presentation/bloc/personal_details_bloc.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';

class Personal extends StatelessWidget {
  final String title;

  Personal({required this.title, super.key});

  final FormGroup form = AppForms.PERSONAL_DETAILS_FORM;
  bool refAadhaar = false;

  /* 
    @author     : ganeshkumar.b  13/06/2025
    @desc       : map Aadhaar response in personal form
    @param      : {AadharvalidateResponse val} - aadhaar response
  */
  mapAadhaarData(val) {
    try {
      if (val != null) {
        form.control('aadharRefNo').updateValue(val?.referenceId);
        refAadhaar = true;
        if (val.name != null) {
          String fullname = val?.name;
          List getNameArray = fullname.split(' ');
          if (getNameArray.length > 2) {
            String fullname = getNameArray.sublist(2).join();
            form.control('firstName').updateValue(getNameArray[0]);
            form.control('middleName').updateValue(getNameArray[1]);
            form.control('lastName').updateValue(fullname);
          } else if (getNameArray.length == 2) {
            form.control('firstName').updateValue(getNameArray[0]);
            form.control('lastName').updateValue(getNameArray[1]);
          } else if (getNameArray.length == 1) {
            form.control('firstName').updateValue(getNameArray[0]);
          }
        }
        form
            .control('dob')
            .updateValue(getCorrectDateFormat(val?.dateOfBirth!));
        // form.control('primaryMobileNumber').updateValue(val?.mobile!);
        form.control('email').updateValue(val?.email!);
      }
    } catch (error) {
      print("autoPopulateData-catch-error $error");
    }
  }

  /* 
    @author     : ganeshkumar.b  13/06/2025
    @desc       : map cif response in personal form
    @param      : {CifResponse val} - cifresponse
  */
  mapCifDate(val, state) {
    try {
      form.control('firstName').updateValue(val.lleadfrstname!);
      form.control('middleName').updateValue(val.lleadmidname!);
      form.control('lastName').updateValue(val.lleadlastname!);
      form.control('dob').updateValue(getDateFormat(val.lleaddob!));
      form.control('primaryMobileNumber').updateValue(val.lleadmobno!);
      form.control('email').updateValue(val.lleademailid!);
      form.control('panNumber').updateValue(val.lleadpanno!);
      form.control('aadharRefNo').updateValue(val.lleadadharno!);
      if (val.lleadadharno != null) {
        refAadhaar = true;
      }
    } catch (error) {
      print("autoPopulateData-catch-error $error");
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
            showSnack(context, message: 'Personal Details Saved Successfully');
            goToNextTab(context: context);
          } else if (state.status == SaveStatus.failure) {
            showSnack(context, message: 'Failed to Save Personal Details');
          }
        },
        builder: (context, state) {
          DedupeState? dedupeState;
          if (state.status == SaveStatus.init && state.aadhaarData != null) {
            mapAadhaarData(state.aadhaarData);
          } else if (state.status == SaveStatus.init) {
            dedupeState = context.watch<DedupeBloc>().state;
            if (dedupeState.cifResponse != null) {
              print(
                'cif response title => ${dedupeState.cifResponse?.lleadtitle}',
              );
              print('state.lovList =>${state.lovList}');
              mapCifDate(dedupeState.cifResponse, state);
            } else if (dedupeState.aadharvalidateResponse != null) {
              mapAadhaarData(dedupeState.aadharvalidateResponse);
            }
          } else if (state.status == SaveStatus.success) {
            print('saved personal data =>${state.personalData}');
          }
          return ReactiveForm(
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
                      selItem: () {
                        if (dedupeState?.cifResponse != null) {
                          Lov? lov = state.lovList?.firstWhere(
                            (lov) =>
                                lov.Header == 'Title' &&
                                lov.optvalue ==
                                    dedupeState?.cifResponse?.lleadtitle,
                          );
                          form.controls['title']?.updateValue(lov?.optvalue);
                          return lov;
                        } else if (state.personalData != null) {
                          Lov? lov = state.lovList?.firstWhere(
                            (lov) =>
                                lov.Header == 'Title' &&
                                lov.optvalue == state.personalData?.title,
                          );
                          form.controls['title']?.updateValue(lov?.optvalue);
                          return lov;
                        } else {
                          return null;
                        }
                      },
                      onChangeListener:
                          (Lov val) =>
                              form.controls['title']?.updateValue(val.optvalue),
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
                      autoCapitalize: true,
                    ),
                    refAadhaar
                        ? IntegerTextField(
                          controlName: 'aadharRefNo',
                          label: 'Aadhaar No',
                          mantatory: true,
                          maxlength: 12,
                          minlength: 12,
                        )
                        : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: IntegerTextField(
                                controlName: 'aadhaar',
                                label: 'Aadhaar Number',
                                mantatory: true,
                                maxlength: 12,
                                minlength: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  3,
                                  9,
                                  110,
                                ),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                final AadharvalidateRequest
                                aadharvalidateRequest = AadharvalidateRequest(
                                  aadhaarNumber: form.control('aadhaar').value,
                                );
                                context.read<PersonalDetailsBloc>().add(
                                  AadhaarValidateEvent(
                                    request: aadharvalidateRequest,
                                  ),
                                );
                              },
                              child:
                                  state.status == SaveStatus.loading
                                      ? CircularProgressIndicator()
                                      : const Text("Validate"),
                            ),
                          ],
                        ),
                    IntegerTextField(
                      controlName: 'loanAmountRequested',
                      label: 'Loan Amount Required',
                      mantatory: true,
                      isRupeeFormat: true,
                    ),
                    SearchableDropdown<Lov>(
                      controlName: 'natureOfActivity',
                      label: 'Nature of Activity',
                      items:
                          state.lovList!
                              .where((v) => v.Header == 'NatureOfActivity')
                              .toList(),
                      onChangeListener: (Lov val) {
                        form.controls['natureOfActivity']?.updateValue(
                          val.optvalue,
                        );
                      },
                      selItem: () {
                        final value = form.control('natureOfActivity').value;
                        return state.lovList!
                            .where((v) => v.Header == 'NatureOfActivity')
                            .firstWhere(
                              (lov) => lov.optvalue == value,
                              orElse:
                                  () => Lov(
                                    Header: 'NatureOfActivity',
                                    optDesc: '',
                                    optvalue: '',
                                    optCode: '',
                                  ),
                            );
                      },
                    ),
                    SearchableDropdown<Lov>(
                      controlName: 'occupationType',
                      label: 'Occupation Type',
                      items:
                          state.lovList!
                              .where((v) => v.Header == 'OccupationType')
                              .toList(),
                      onChangeListener: (Lov val) {
                        form.controls['occupationType']?.updateValue(
                          val.optvalue,
                        );
                      },
                      selItem: () {
                        final value = form.control('occupationType').value;
                        return state.lovList!
                            .where((v) => v.Header == 'OccupationType')
                            .firstWhere(
                              (lov) => lov.optvalue == value,
                              orElse:
                                  () => Lov(
                                    Header: 'OccupationType',
                                    optvalue: '',
                                    optDesc: '',
                                    optCode: '',
                                  ),
                            );
                      },
                    ),
                    SearchableDropdown<Lov>(
                      controlName: 'agriculturistType',
                      label: 'Agriculturist Type',
                      items:
                          state.lovList!
                              .where((v) => v.Header == 'AgricultType')
                              .toList(),
                      onChangeListener: (Lov val) {
                        form.controls['agriculturistType']?.updateValue(
                          val.optvalue,
                        );
                      },
                      selItem: () {
                        final value = form.control('agriculturistType').value;
                        return state.lovList!
                            .where((v) => v.Header == 'AgricultType')
                            .firstWhere(
                              (lov) => lov.optvalue == value,
                              orElse:
                                  () => Lov(
                                    Header: 'AgricultType',
                                    optvalue: '',
                                    optDesc: '',
                                    optCode: '',
                                  ),
                            );
                      },
                    ),
                    SearchableDropdown<Lov>(
                      controlName: 'farmerCategory',
                      label: 'Farmer Category',
                      items:
                          state.lovList!
                              .where((v) => v.Header == 'FarmerCategory')
                              .toList(),
                      onChangeListener: (Lov val) {
                        form.controls['farmerCategory']?.updateValue(
                          val.optvalue,
                        );
                      },
                      selItem: () {
                        final value = form.control('farmerCategory').value;
                        return state.lovList!
                            .where((v) => v.Header == 'FarmerCategory')
                            .firstWhere(
                              (lov) => lov.optvalue == value,
                              orElse:
                                  () => Lov(
                                    Header: 'FarmerCategory',
                                    optvalue: '',
                                    optDesc: '',
                                    optCode: '',
                                  ),
                            );
                      },
                    ),
                    SearchableDropdown<Lov>(
                      controlName: 'farmerType',
                      label: 'Farmer Type',
                      items:
                          state.lovList!
                              .where((v) => v.Header == 'FarmerType')
                              .toList(),
                      onChangeListener: (Lov val) {
                        form.controls['farmerType']?.updateValue(val.optvalue);
                      },
                      selItem: () {
                        final value = form.control('farmerType').value;
                        return state.lovList!
                            .where((v) => v.Header == 'FarmerType')
                            .firstWhere(
                              (lov) => lov.optvalue == value,
                              orElse:
                                  () => Lov(
                                    Header: 'FarmerType',
                                    optvalue: '',
                                    optDesc: '',
                                    optCode: '',
                                  ),
                            );
                      },
                    ),
                    SearchableDropdown<Lov>(
                      controlName: 'religion',
                      label: 'Religion',
                      items:
                          state.lovList!
                              .where((v) => v.Header == 'Religion')
                              .toList(),
                      onChangeListener: (Lov val) {
                        form.controls['religion']?.updateValue(val.optvalue);
                      },
                      selItem: () {
                        final value = form.control('religion').value;
                        return state.lovList!
                            .where((v) => v.Header == 'Religion')
                            .firstWhere(
                              (lov) => lov.optvalue == value,
                              orElse:
                                  () => Lov(
                                    Header: 'Religion',
                                    optvalue: '',
                                    optDesc: '',
                                    optCode: '',
                                  ),
                            );
                      },
                    ),
                    SearchableDropdown<Lov>(
                      controlName: 'caste',
                      label: 'Caste',
                      items:
                          state.lovList!
                              .where((v) => v.Header == 'Caste')
                              .toList(),
                      onChangeListener: (Lov val) {
                        form.controls['caste']?.updateValue(val.optvalue);
                      },
                      selItem: () {
                        final value = form.control('caste').value;
                        return state.lovList!
                            .where((v) => v.Header == 'Caste')
                            .firstWhere(
                              (lov) => lov.optvalue == value,
                              orElse:
                                  () => Lov(
                                    Header: 'Caste',
                                    optvalue: '',
                                    optDesc: '',
                                    optCode: '',
                                  ),
                            );
                      },
                    ), 
                    SearchableDropdown<Lov>(
                      controlName: 'residentialStatus',
                      label: 'Residential Status',
                      items: state.lovList!
                          .where((v) => v.Header == 'ResidentialStatus')
                          .toList(),
                      onChangeListener: (Lov val) {
                        form.controls['residentialStatus']?.updateValue(val.optvalue);
                      },
                      selItem: () {
                        final value = form.control('residentialStatus').value;
                        return state.lovList!
                            .where((v) => v.Header == 'ResidentialStatus')
                            .firstWhere(
                              (lov) => lov.optvalue == value,
                              orElse: () => Lov(
                                Header: 'ResidentialStatus', optvalue: '', optDesc: '', optCode: '',
                              ),
                            );
                      },
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
          );
        },
      ),
    );
  }
}
