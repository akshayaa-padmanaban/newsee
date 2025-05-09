import 'package:flutter/material.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/pages/documents_page.dart';
import 'package:newsee/pages/kyc_page.dart';
import 'package:newsee/pages/income_details_page.dart';
import 'package:newsee/pages/loan_details_page.dart';
import 'package:newsee/pages/personal_details_page.dart';
import 'package:newsee/pages/sourcing_page.dart';
import 'package:newsee/widgets/side_navigation.dart';

class NewLeadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar:
            Globalconfig.isInitialRoute
                ? null
                : AppBar(
                  // leading: IconButton(
                  //   onPressed: () {
                  //     print('');
                  //   },
                  //   icon: Icon(Icons.menu),
                  //   color: Colors.white,
                  // ),
                  title: Text(
                    'Lead Details',
                    style: TextStyle(color: Colors.white),
                  ),
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red, Colors.blue],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                      ),
                    ),
                  ),
                  bottom: TabBar(
                    indicatorColor: Colors.white,
                    indicatorWeight: 3,
                    tabs: <Widget>[
                      Tab(
                        icon: Icon(Icons.file_copy, color: Colors.white),
                      ),
                      Tab(
                        icon: Icon(Icons.face, color: Colors.white),
                      ),
                      Tab(
                        icon: Icon(Icons.home, color: Colors.white),
                      ),
                      Tab(
                        icon: Icon(Icons.currency_rupee_sharp, color: Colors.white),
                      ),
                      Tab(
                        icon: Icon(Icons.currency_rupee_sharp, color: Colors.white),
                      ),
                      Tab(
                        icon: Icon(Icons.edit_document, color: Colors.white),
                      ),
                    ],
                  ),
                  actions: <Widget>[],
                ),
        drawer: Globalconfig.isInitialRoute ? null : Sidenavigationbar(),
        body: TabBarView(
          children: [
            SourcingPage('Sourcing', title: 'Sourcing',),
            PersonalDetailsPage('Personal', title: 'Personal'),
            KycPage('KYC', title: 'kyc'),
            IncomeDetailsPage('Income', title: 'Income'),
            LoanDetailsPage('Loan', title: 'loan'),
            DocumentsPage('Document', title: 'documents'),
          ],
        ),
      ),
    );
  }
}
