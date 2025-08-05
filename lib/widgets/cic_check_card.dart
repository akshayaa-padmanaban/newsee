import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/Utils/download_util.dart';
import 'package:newsee/feature/pdf_viewer/presentation/pages/pdf_viewer_page.dart';
import 'package:newsee/widgets/loader.dart';
import 'package:newsee/widgets/sysmo_alert.dart';

class CicCheckCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final String cibilFileName;
  final String crifFileName;

  const CicCheckCard({
    super.key,
    required this.title,
    required this.icon,
    required this.cibilFileName,
    required this.crifFileName,
  });

  @override
  State<CicCheckCard> createState() => CicCheckCardState();
}

class CicCheckCardState extends State<CicCheckCard> {
  bool isCibilChecked = false;
  bool isCrifChecked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.teal.withOpacity(0.1),
                  child: Icon(widget.icon, color: Colors.teal),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
                  label: 'CIBIL',
                  checked: isCibilChecked,
                  onCheckPressed: () async {
                    presentLoading(context, AppConstants.creatingCibil);
                    await Future.delayed(const Duration(seconds: 2));
                    dismissLoading(context);
                    setState(() {
                      isCibilChecked = true;
                    });
                  },
                  onViewPressed: () async {
                    await downloadAndOpenPdf(
                      AppConstants.remoteUrlCibilReport,
                      widget.cibilFileName,
                      AppConstants.downloadingCibil,
                    );
                  },
                ),
                const SizedBox(width: 12),
                buildActionButton(
                  label: 'CRIF',
                  checked: isCrifChecked,
                  onCheckPressed: () async {
                    presentLoading(context, AppConstants.creatingCrif);
                    await Future.delayed(const Duration(seconds: 2));
                    dismissLoading(context);
                    setState(() {
                      isCrifChecked = true;
                    });
                  },
                  onViewPressed: () async {
                    await downloadAndOpenPdf(
                      AppConstants.remoteUrlCrifReport,
                      widget.crifFileName,
                      AppConstants.downloadingCrif,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildActionButton({
    required String label,
    required bool checked,
    required VoidCallback onCheckPressed,
    required Future<void> Function() onViewPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: () async {
        if (!checked) {
          onCheckPressed();
        } else {
          await onViewPressed();
        }
      },
      icon: Icon(checked ? Icons.picture_as_pdf : Icons.check),
      label: Text(checked ? 'View $label' : 'Check $label'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 3, 9, 110),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Future<void> downloadAndOpenPdf(
    String remoteUrl,
    String fileName,
    String loadingMessage,
  ) async {
    try {
      presentLoading(context, loadingMessage);
      final directory = await getTemporaryDirectory();
      final path = directory.path;

      await downloadPDF(
        remoteFilePath: remoteUrl,
        fileName: fileName,
        dirPath: path,
        downloadedFilePath: (String filePath) {
          dismissLoading(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfViewerPage(path: filePath),
            ),
          );
        },
      );
    } catch (_) {
      dismissLoading(context);
      showDialog(
        context: context,
        builder:
            (_) => SysmoAlert(
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
