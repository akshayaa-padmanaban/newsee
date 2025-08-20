import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/feature/draft/domain/draft_lead_model.dart';

class HeroAnimationPage extends StatelessWidget {
  final DraftLead draft;
  const HeroAnimationPage({super.key, required this.draft});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(draft.personal['firstName'] ?? 'Lead Detail')),
      body: Center(
        child: Hero(
          tag: draft.leadref,
          child: Material(
            borderRadius: BorderRadius.circular(20),
            elevation: 6,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      draft.personal['firstName'] ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    infoRow("Lead Ref", draft.leadref),
                    infoRow(
                      "Customer Type",
                      draft.dedupe['isNewCustomer'] == false
                          ? 'Existing Customer'
                          : 'New Customer',
                    ),
                    infoRow(
                      "Product",
                      draft.loan['selectedProductScheme']['optionDesc'] ??
                          'N/A',
                    ),
                    infoRow(
                      "Phone",
                      draft.personal['primaryMobileNumber'] ?? 'N/A',
                    ),
                    infoRow("DOB", draft.personal['dob'] ?? 'N/A'),
                    infoRow("Location", draft.address['state'] ?? 'N/A'),
                    infoRow(
                      "Loan Amount",
                      draft.personal['loanAmountRequested']?.toString() ?? '',
                    ),
                    ElevatedButton(
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
                        context.pushNamed(
                          'newlead',
                          extra: {'leadData': draft, 'tabType': 'draft'},
                        );
                      },
                      child: Text('Next'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}