import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/feature/cic_check/presentation/bloc/cicbloc.dart';
import 'package:newsee/feature/landholding/presentation/page/land_holding_page.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_event.dart';
import 'package:newsee/widgets/cic_check_card.dart';

class CicCheckPage extends StatelessWidget {
  final Map<String, dynamic> proposal;
  const CicCheckPage({super.key, required this.proposal});

  @override
  Widget build(BuildContext context) {
    final globalLoadingBloc = context.read<GlobalLoadingBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('CIC Check'),
        backgroundColor: Colors.teal,
      ),
      body: BlocProvider(
        create:
            (context) => CICBloc()..add(CICInitEvent(proposalData: proposal)),
        child: BlocConsumer<CICBloc, CICInboxState>(
          listener:
              (context, state) => {
                if (state.leadStatus == SaveStatus.loading)
                  {
                    globalLoadingBloc.add(
                      ShowLoading(message: 'Fetching CIC Data'),
                    ),
                  }
                else
                  {globalLoadingBloc.add(HideLoading())},
              },
          builder: (context, state) {
            return state.leadStatus != SaveStatus.success
                ? const Center(child: Text("No CIC data available"))
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Column(
                        children:
                            state.coappandGauList!.map<Widget>((user) {
                              final name = user['name'] ?? 'Unknown';
                              final roleKey = user['roleKey'] ?? 'applicant';

                              IconData icon;
                              switch (roleKey) {
                                case 'applicant':
                                  icon = Icons.person;
                                case 'coapplicant':
                                  icon = Icons.group;
                                case 'guarantor':
                                  icon = Icons.verified_user;
                                default:
                                  icon = Icons.person_outline;
                              }
                              final propRefNo =
                                  state.proposalData!['propRefNo']
                                      ?.toString() ??
                                  'N/A';
                              final cibilFileName =
                                  '${roleKey}_cibil_$propRefNo.pdf';
                              final crifFileName =
                                  '${roleKey}_crif_$propRefNo.pdf';

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: CicCheckCard(
                                  title: name,
                                  icon: icon,
                                  cibilFileName: cibilFileName,
                                  crifFileName: crifFileName,
                                ),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => LandHoldingPage(
                                    title: 'Land Holding Details',
                                    proposalNumber: proposal['propNo'],
                                    applicantName: proposal['applicantName'],
                                  ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 3, 9, 110),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
          },
        ),
      ),
    );
  }
}
