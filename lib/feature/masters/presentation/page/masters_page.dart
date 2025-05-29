import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/feature/masters/data/repository/master_repo_impl.dart';
import 'package:newsee/feature/masters/domain/modal/master_request.dart';
import 'package:newsee/feature/masters/domain/modal/master_response.dart';
import 'package:newsee/feature/masters/domain/modal/master_types.dart';
import 'package:newsee/feature/masters/presentation/bloc/masters_bloc.dart';

class MastersPage extends StatelessWidget {
  const MastersPage({super.key});
  debugMasters(BuildContext context, MastersState state) {
    // context.read<MastersBloc>().add(
    //   MasterFetch(
    //     request: MasterRequest(
    //       setupfinal: '1',
    //       setupmodule: 'AGRI',
    //       setupTypeOfMaster: 'Listofvalues',
    //     ),
    //   ),
    // );

    print(
      '${state.masterResponse?.masterType.name}  MasterDownload Status => ${state.status}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create:
            (context) => MastersBloc(
              masterRepo: MasterRepoImpl(),
              initState: MastersState(
                status: MasterdownloadStatus.init,
                masterResponse: MasterResponse(
                  master: [],
                  masterType: MasterTypes.lov,
                ),
              ),
            ),
        child: BlocListener<MastersBloc, MastersState>(
          listener: (context, state) {
            switch (state.masterResponse?.masterType) {
              case MasterTypes.lov:
                break;
              case MasterTypes.products:
                context.read<MastersBloc>().add(
                  MasterFetch(
                    request: MasterRequest(
                      setupVersion: '4',
                      setupmodule: 'AGRI',
                      setupTypeOfMaster: ApiConstants.master_key_products,
                    ),
                  ),
                );

              case MasterTypes.productschema:
                break;

              default:
                break;
            }
          },
          child: BlocBuilder<MastersBloc, MastersState>(
            builder: (context, state) {
              final bool isLoading =
                  state.status == MasterdownloadStatus.loading;
              final MasterTypes currentMaster =
                  state.masterResponse?.masterType ?? MasterTypes.lov;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(
                          Color.fromARGB(255, 2, 59, 105),
                        ),
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                        minimumSize: WidgetStatePropertyAll(Size(400, 70)),
                      ),
                      onPressed:
                          isLoading
                              ? null
                              : () {
                                // on successfull completion of one type of master
                                // have to sequentially call next master
                                context.read<MastersBloc>().add(
                                  MasterFetch(
                                    request: MasterRequest(
                                      setupVersion: '4',
                                      setupmodule: 'AGRI',
                                      setupTypeOfMaster:
                                          ApiConstants.master_key_lov,
                                    ),
                                  ),
                                );
                                debugMasters(context, state);
                              },
                      child:
                          isLoading
                              ? SizedBox(
                                width: 200,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Dowloading ${currentMaster.name}'),
                                    SizedBox(width: 8),
                                    CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.0,
                                    ),
                                  ],
                                ),
                              )
                              : Text(
                                state.status != MasterdownloadStatus.success
                                    ? "Download Master"
                                    : "Download Completed",
                              ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
