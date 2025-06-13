import 'package:flutter/material.dart';
import 'package:newsee/widgets/success_bottom_sheet.dart';
import 'package:newsee/widgets/customLead.dart';

class CheckPage extends StatelessWidget {
  final String title;

  const CheckPage(String s, {required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          customLead(
            icon: Icons.person_outline,
            name: "Rajesh",
            type: "Applicant | Existing Customer",
            product: "Kisan Credit Card",
            cifid: "121212",
            loanamount: "7,50,000",
            location: "Chennai",
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                showSuccessBottomSheet(
                  context,
                  "Submitted",
                  "Lead ID : LEAD/202526/00008213",
                  "Lead details successfully submitted",
                );
              },
              icon: const Icon(Icons.send, color: Colors.white),
              label: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(text: 'Push to '),
                    TextSpan(text: 'LEND', style: TextStyle(color: Colors.white)),
                    TextSpan(text: 'perfect', style: TextStyle(fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50)),
                backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 75, 33, 83)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
