import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/addressdetails/presentation/bloc/address_details_bloc.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/masters/domain/modal/statecitymaster.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';

class Address extends StatelessWidget {
  final String title;

  Address(String s, {required this.title, super.key});

  final form = FormGroup({
    'addresstype': FormControl<String>(validators: [Validators.required]),
    'address1': FormControl<String>(validators: [Validators.required]),
    'address2': FormControl<String>(validators: [Validators.required]),
    'address3': FormControl<String>(validators: [Validators.required]),
    'state': FormControl<String>(validators: [Validators.required]),
    'city': FormControl<String>(validators: [Validators.required]),
    'district': FormControl<String>(validators: [Validators.required]),
    'pincode': FormControl<String>(validators: [Validators.required]),
  });

  void showSnack(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void goToNextTab(BuildContext context) {
    showSnack(context, message: 'Address Details Saved Successfully');
    final tabController = DefaultTabController.of(context);
    if (tabController.index < tabController.length - 1) {
      tabController.animateTo(tabController.index + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Address Details"),
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<AddressDetailsBloc, AddressDetailsState>(
        listener: (context, state) {
          print(
            'addressdetail::BlocConsumer:listen => ${state.lovList} ${state.addressData} ${state.status?.name}',
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
                        controlName: 'addresstype',
                        label: 'Address Type',
                        items:
                            state.lovList!
                                .where((v) => v.Header == 'AddressType')
                                .toList(),
                        onChangeListener:
                            (Lov val) => form.controls['addresstype']
                                ?.updateValue(val.optvalue),
                      ),
                      CustomTextField(
                        controlName: 'address1',
                        label: 'Address 1',
                        mantatory: true,
                      ),
                      CustomTextField(
                        controlName: 'address2',
                        label: 'Address 2',
                        mantatory: true,
                      ),
                      CustomTextField(
                        controlName: 'address3',
                        label: 'Address 3',
                        mantatory: true,
                      ),
                      SearchableDropdown(
                        controlName: 'state',
                        label: 'State',
                        items: state.stateCityMaster!,
                        onChangeListener:
                            (GeographyMaster val) =>
                                form.controls['state']?.updateValue(val.code),
                      ),
                      SearchableDropdown(
                        controlName: 'city',
                        label: 'City',
                        items: ['Chennai', 'Madurai'],
                      ),
                      SearchableDropdown(
                        controlName: 'district',
                        label: 'District',
                        items: ['Sholinganallur', 'Navalur'],
                      ),
                      IntegerTextField(
                        controlName: 'pincode',
                        label: 'Pin Code',
                        mantatory: true,
                        maxlength: 6,
                        minlength: 6,
                      ),
                      SizedBox(height: 20),
                      // ElevatedButton(onPressed: () {}, child: Text("ADD")),
                      // SizedBox(height: 50),
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
                            print("Address Details value ${form.value}");
                            if (form.valid) {
                              final tabController = DefaultTabController.of(
                                context,
                              );
                              if (tabController.index <
                                  tabController.length - 1) {
                                tabController.animateTo(
                                  tabController.index + 1,
                                );
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
            ),
      ),
    );
  }
}
