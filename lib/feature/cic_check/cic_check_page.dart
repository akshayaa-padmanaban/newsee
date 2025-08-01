import 'package:flutter/material.dart';
import 'package:newsee/widgets/cic_check_card.dart';

/*
  @author     : akshayaa.p
  @date       : 16/07/2025
  @desc       : Stateless widget for CIC Check screen.
                - Displays Applicant and Co-Applicant CIBIL/CRIF check options.
                - Results toggle between "Check" and "View".
*/

class CicCheckData {
  final String title;
  final IconData icon;
  final String cibilFileName;
  final String crifFileName;
  final CicCheckModel model;

  CicCheckData({
    required this.title,
    required this.icon,
    required this.cibilFileName,
    required this.crifFileName,
    required this.model,
  });
}

class CicCheckPage extends StatelessWidget {
  final Map<String, dynamic> proposal;

  const CicCheckPage({super.key, required this.proposal});

  @override
  Widget build(BuildContext context) {
    final applicantName = proposal['applicantName'] ?? 'Applicant';
    final coapplicantName = proposal['coApplicantName'] ?? 'Co-Applicant';

    final applicantModel = CicCheckModel(
      cibilFileName: '${proposal['propNo']}_applicant_cibil.pdf',
      crifFileName: '${proposal['propNo']}_applicant_crif.pdf',
    );

    final coapplicantModel = CicCheckModel(
      cibilFileName: '${proposal['propNo']}_coapplicant_cibil.pdf',
      crifFileName: '${proposal['propNo']}_coapplicant_crif.pdf',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('CIC Check'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CicCheckCard(
              title: applicantName,
              icon: Icons.person,
              model: applicantModel,
            ),
            CicCheckCard(
              title: coapplicantName,
              icon: Icons.group,
              model: coapplicantModel,
            ),
          ],
        ),
      ),
    );
  }
}
 