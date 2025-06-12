import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/feature/cif/presentation/bloc/cif_bloc.dart';
import 'package:newsee/feature/dedupe/presentation/bloc/dedupe_bloc.dart';
import 'package:newsee/feature/cif/presentation/page/cif_search.dart';
import 'package:newsee/feature/dedupe/presentation/page/bottom_sheet_container.dart';
import 'package:newsee/feature/dedupe/presentation/page/dedupe_search.dart';
import 'package:newsee/widgets/response_widget.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DedupeView extends StatelessWidget {
  final String title;
  DedupeView(String s, {required this.title, super.key});

  final dedupeForm = AppForms.DEDUPE_DETAILS_FORM;
  final cifForm = AppForms.CIF_DETAILS_FORM;  

  void _openModalSheet(
    BuildContext context,
    bool isNewCustomer,
    FormGroup form,
  ) {
    final tabController = DefaultTabController.of(context);
    final dedupebloc = context.read<DedupeBloc>();
    final cifbloc = context.read<CifBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:(BuildContext context) => isNewCustomer ? 
        BlocProvider.value(
          value: dedupebloc,
          child: BottomSheetContainer(isNewCustomer: isNewCustomer, form: form, tabController: tabController)
        ) : 
        BlocProvider.value(
          value: cifbloc,
          child: BottomSheetContainer(isNewCustomer: isNewCustomer, form: form, tabController: tabController)
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    bool? selectedValue;
    List<Map<String, dynamic>> dataList;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dedupe Details"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
            child: StatefulBuilder(
              builder:
                  (context, setState) => Column(
                    children: [
                      Container(
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0,
                            color: Colors.grey
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey, blurStyle: BlurStyle.outer)]
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              title: const Text("New Customer"),
                              leading: Radio<bool>(
                                value: true,
                                groupValue: selectedValue,
                                onChanged: (value) {
                                  setState(() => selectedValue = value);
                                  _openModalSheet(context, true, dedupeForm);
                                },
                              ),
                              onTap: () {
                                setState(() => selectedValue = true);
                                _openModalSheet(context, true, dedupeForm);
                              },
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Divider(),
                            )
                            ,
                            ListTile(
                              title: const Text("Existing Customer"),
                              leading: Radio<bool>(
                                value: false,
                                groupValue: selectedValue,
                                onChanged: (value) {
                                  setState(() => selectedValue = value);
                                  _openModalSheet(context, false, cifForm);
                                },
                              ),
                              onTap: () {
                                setState(() => selectedValue = false);
                                _openModalSheet(context, false, cifForm);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        child: BlocBuilder<DedupeBloc, DedupeState>(
                          builder: (context, state) {
                            if (state.status == DedupeFetchStatus.success && state.aadharvalidateResponse == null) {
                              dataList = [
                                {"icon": Icons.currency_rupee, "label": "CBS", "value": "true"},
                                {"icon": Icons.assignment_add, "label": "Remarks", "value": state.dedupeResponse?.remarks as String},
                              ];
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text("Dedupe Response", style: TextStyle(fontWeight: FontWeight.bold),),
                                  ResponseWidget(heightSize: 0.32, dataList: dataList, buttonshow: false, onpressed: () {})
                                ],
                              );
                            } else if (state.status == DedupeFetchStatus.success && state.aadharvalidateResponse != null) {
                              dataList = [
                                {
                                  "icon": Icons.person,
                                  "label": "Name",
                                  "value": state.aadharvalidateResponse?.name as String,
                                },
                                {
                                  "icon":
                                      state.aadharvalidateResponse?.gender == "MALE"
                                          ? Icons.male
                                          : Icons.female,
                                  "label": "Gender",
                                  "value":
                                      state.aadharvalidateResponse?.gender as String,
                                },
                                {
                                  "icon": Icons.calendar_month,
                                  "label": "DOB",
                                  "value":
                                      state.aadharvalidateResponse?.dateOfBirth
                                          as String,
                                },
                                {
                                  "icon": Icons.contact_phone,
                                  "label": "Mobile",
                                  "value": "",
                                },
                                {
                                  "icon": Icons.home,
                                  "label": "Address",
                                  "value":
                                      '${state.aadharvalidateResponse?.house} ${state.aadharvalidateResponse?.street} ${state.aadharvalidateResponse?.locality} ${state.aadharvalidateResponse?.vtcName} ${state.aadharvalidateResponse?.postOfficeName}',
                                },
                              ];
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text("Aadhaar Response", style: TextStyle(fontWeight: FontWeight.bold),),
                                  ResponseWidget(heightSize: 0.4, dataList: dataList, buttonshow: false, onpressed: () {})
                                ],
                              );
                            }
                            return SizedBox(height: 50) ;
                          }
                        ),
                      ),
                          
                      BlocBuilder<CifBloc, CifState>(
                        builder: (context, state) {
                          if (state.status == DedupeFetchStatus.success) {
                            dataList = [
                              {"icon": Icons.currency_rupee, "label": "CBS", "value": "true"},
                              {"icon": Icons.assignment_add, "label": "Remarks", "value": state.cifResponseModel?.remarks as String},
                            ];
                            return Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Text("CiF Response", style: TextStyle(fontWeight: FontWeight.bold),),
                                ResponseWidget(heightSize: 0.32, dataList: dataList, buttonshow: false, onpressed: () {})
                              ]
                              
                            );
                          }
                          return SizedBox(height: 50) ;
                        }
                      )
                    ]
                  ),
            ),
          )
      );
  }
}
