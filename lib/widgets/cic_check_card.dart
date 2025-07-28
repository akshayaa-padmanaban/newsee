import 'package:flutter/material.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/Utils/download_util.dart';
import 'package:newsee/feature/pdf_viewer/presentation/pages/pdf_viewer_page.dart';
import 'package:newsee/widgets/loader.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:path_provider/path_provider.dart';

class CicCheckCard extends StatelessWidget{
  final String title;
  final IconData icon;
  final CicCheckModel model;

  const CicCheckCard({
    super.key,
    required this.title,
    required this.icon,
    required this.model
  });

  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: model, 
      builder: (context, child){
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.teal.shade100,
                      child: Icon(icon, color: Colors.teal),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildActionButton(
                          context: context,
                          label: 'CIBIL',
                          isChecked: model.cibilChecked,
                          onCheck: model.markCibilChecked,
                          fileName: model.cibilFileName,
                          remoteUrl: AppConstants.remoteUrlCibilReport,
                          creatingMsg: AppConstants.creatingCibil,
                          downloadingMsg: AppConstants.downloadingCibil
                        ),
                        const SizedBox(width: 12),
                        buildActionButton(
                          context: context,
                          label: 'CRIF',
                          isChecked: model.crifChecked,
                          onCheck: model.markCrifChecked,
                          fileName: model.crifFileName,
                          remoteUrl: AppConstants.remoteUrlCrifReport,
                          creatingMsg: AppConstants.creatingCrif,
                          downloadingMsg: AppConstants.downloadingCrif
                        ),
                      ],
                    ),
                  ],
                ),
            ),
          );
      },
        );
  }
  Widget buildActionButton({
    required BuildContext context,
    required String label,
    required bool isChecked,
    required VoidCallback onCheck,
    required String fileName,
    required String remoteUrl,
    required String creatingMsg,
    required String downloadingMsg
  }) {
    return ElevatedButton.icon(
      onPressed: () async {
        if (!isChecked) {
          presentLoading(context, creatingMsg);
          await Future.delayed(const Duration(seconds: 2));
          dismissLoading(context);
          onCheck();
        } else {
          await downloadAndOpenPdf(
            context: context,
            remoteUrl: remoteUrl,
            fileName: fileName,
            loadingMessage: downloadingMsg
          );
        }
      }, 
      icon: Icon(isChecked ? Icons.picture_as_pdf : Icons.check),
      label: Text(isChecked ? 'View $label' : 'Check $label'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 3, 9, 110),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
      ),
      ),
    );
  }
Future<void> downloadAndOpenPdf({
    required BuildContext context,
    required String remoteUrl,
    required String fileName,
    required String loadingMessage,
  }) async {
    try {
      presentLoading(context, loadingMessage);
      final directory = await getTemporaryDirectory();
      final dirPath = directory.path;

      await downloadPDF(
        remoteFilePath: remoteUrl,
        fileName: fileName,
        dirPath: dirPath,
        downloadedFilePath: (String path) {
          dismissLoading(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PdfViewerPage(path: path)),
          );
        },
      );
    } catch (error) {
      dismissLoading(context);
      showDialog(
        context: context,
        builder: (context) => SysmoAlert(
          message: AppConstants.FAILED_TO_LOAD_PDF_MESSAGE,
          icon: Icons.error_outline,
          iconColor: Colors.red,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          buttonText: AppConstants.OK,
          onButtonPressed: () => Navigator.pop(context),
        ),
      );
    }
  }
}

class CicCheckModel extends ChangeNotifier {
  bool cibilChecked = false;
  bool crifChecked = false;

  final String cibilFileName;
  final String crifFileName;

  CicCheckModel({
    required this.cibilFileName,
    required this.crifFileName,
  });

  void markCibilChecked() {
    cibilChecked = true;
    notifyListeners();
  }

  void markCrifChecked() {
    crifChecked = true;
    notifyListeners();
  }
}
