import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../core/extensions/date_extensions.dart';
import '../domain/entities/participant.dart';
import '../domain/entities/travel.dart';
import '../l10n/app_localizations.dart';
import '../presentation/extensions/enums_extensions.dart';
import '../presentation/providers/user_preferences_provider.dart';

class PDFService {
  Future<File?> generatePDFFromTravel(
    Travel travel,
    BuildContext externalContext,
  ) async {
    final document = pdf.Document();

    final font = await PdfGoogleFonts.nunitoExtraLight();

    const double pagePadding = 32;

    document.addPage(
      index: 0,
      pdf.Page(
        pageTheme: pdf.PageTheme(
          margin: pdf.EdgeInsets.all(pagePadding),
          pageFormat: PdfPageFormat.a5,
          theme: pdf.ThemeData(defaultTextStyle: pdf.TextStyle(font: font)),
        ),
        build: (context) {
          return coverPage(context: externalContext, travel: travel);
        },
      ),
    );

    document.addPage(
      index: 1,
      pdf.Page(
        pageTheme: pdf.PageTheme(
          margin: pdf.EdgeInsets.all(pagePadding),
          pageFormat: PdfPageFormat.a5,
          theme: pdf.ThemeData(defaultTextStyle: pdf.TextStyle(font: font)),
        ),
        build: (context) {
          return participantsPage(
            context: externalContext,
            participants: travel.participants,
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/${travel.travelTitle}.pdf';
    final pdfBytes = await document.save();

    final file = File(filePath);

    await file.writeAsBytes(pdfBytes);

    debugPrint('pdf file saved at: $filePath');
    return file;
  }

  /// PDF Cover
  pdf.Center coverPage({
    required BuildContext context,
    required Travel travel,
  }) {
    final locale = context.read<UserPreferencesProvider>().languageCode;

    return pdf.Center(
      child: pdf.Column(
        crossAxisAlignment: pdf.CrossAxisAlignment.center,
        mainAxisAlignment: pdf.MainAxisAlignment.center,
        children: [
          pdf.Text(
            travel.travelTitle,
            textAlign: pdf.TextAlign.center,
            style: pdf.TextStyle(fontSize: 40),
          ),
          pdf.Padding(padding: pdf.EdgeInsets.all(24)),
          pdf.Text(travel.startDate.getFullDate(locale)),
          pdf.Text(travel.endDate.getFullDate(locale)),
          pdf.Text(travel.transportType.getIntlTransportType(context)),
        ],
      ),
    );
  }

  /// First page
  pdf.Column participantsPage({
    required BuildContext context,
    required List<Participant> participants,
  }) {
    final as = AppLocalizations.of(context)!;

    return pdf.Column(
      mainAxisSize: pdf.MainAxisSize.min,
      crossAxisAlignment: pdf.CrossAxisAlignment.center,
      children: [
        pdf.Text(
          as.participants,
          textAlign: pdf.TextAlign.center,
          style: pdf.TextStyle(fontSize: 32),
        ),

        pdf.Padding(padding: pdf.EdgeInsets.all(16)),

        pdf.Expanded(
          child: pdf.ListView.separated(
            direction: pdf.Axis.vertical,
            itemBuilder: (context, index) {
              final participant = participants[index];
              final image = pdf.MemoryImage(
                participant.profilePicture
                    .readAsBytesSync()
                    .buffer
                    .asUint8List(),
              );

              return pdf.Container(
                padding: pdf.EdgeInsets.all(12),
                decoration: pdf.BoxDecoration(
                  border: pdf.Border.all(width: 1, color: PdfColor(0, 0, 0)),
                  borderRadius: pdf.BorderRadius.circular(12),
                ),
                child: pdf.Row(
                  children: [
                    pdf.Image(
                      image,
                      width: 32,
                      height: 32,
                      fit: pdf.BoxFit.cover,
                    ),

                    pdf.Padding(padding: pdf.EdgeInsets.all(6)),

                    pdf.Text(
                      participant.name,
                      style: pdf.TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return pdf.Padding(padding: pdf.EdgeInsets.all(8));
            },
            itemCount: participants.length,
          ),
        ),
      ],
    );
  }
}
