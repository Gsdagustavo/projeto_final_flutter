import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../core/extensions/date_extensions.dart';
import '../core/extensions/place_extensions.dart';
import '../domain/entities/enums.dart';
import '../domain/entities/participant.dart';
import '../domain/entities/travel.dart';
import '../domain/entities/travel_stop.dart';
import '../l10n/app_localizations.dart';
import '../presentation/extensions/enums_extensions.dart';
import '../presentation/providers/user_preferences_provider.dart';

final _mapsKey = dotenv.get('MAPS_API_KEY');

/// Service to generate PDF documents for [Travel] objects
///
/// Provides methods to create a PDF containing a cover page and a list of
/// participants.
///
/// Saves the PDF to the app's document directory.
class PDFService {
  static const double _pagePadding = 32;

  /// Generates a PDF file from a [Travel] instance
  ///
  /// [travel]: The travel data to be included in the PDF
  /// [externalContext]: The Flutter [BuildContext] used to access localization
  /// and user preferences
  ///
  /// Returns a [File] representing the saved PDF, or null if an error occurs
  Future<File?> generatePDFFromTravel(
    Travel travel,
    BuildContext externalContext,
  ) async {
    final pdfUtils = PDFUtils();
    final pdfWidgets = PDFWidgets();

    final document = pdf.Document();

    // Load the font used for the PDF
    final font = await PdfGoogleFonts.nunitoExtraLight();

    if (!externalContext.mounted) return null;

    // AppLocalizations
    final as = AppLocalizations.of(externalContext)!;

    if (!externalContext.mounted) return null;

    final locale = externalContext.read<UserPreferencesProvider>().languageCode;

    final pageTheme = pdf.PageTheme(
      margin: pdf.EdgeInsets.all(_pagePadding),
      pageFormat: PdfPageFormat.a5,
      theme: pdf.ThemeData(defaultTextStyle: pdf.TextStyle(font: font)),
    );

    final cover = await coverPage(
      context: externalContext,
      travel: travel,
      document: document.document,
    );

    // Add the cover page
    document.addPage(pdf.Page(pageTheme: pageTheme, build: (context) => cover));

    // Add the participants page
    document.addPage(
      pdf.Page(
        pageTheme: pageTheme,
        build: (context) => participantsPage(
          context: externalContext,
          participants: travel.participants,
        ),
      ),
    );

    final travelRouteImage = await pdfUtils.generateMapRouteFile(
      stops: travel.stops,
    );

    if (travelRouteImage != null) {
      final fileBytes = await travelRouteImage.readAsBytes();
      final pdfFile = pdf.MemoryImage(fileBytes);

      // Add the travel overview page
      document.addPage(
        pdf.Page(
          pageTheme: pageTheme,
          build: (context) => pdf.Column(
            crossAxisAlignment: pdf.CrossAxisAlignment.center,
            children: [
              pdf.Text(
                as.travel_route,
                textAlign: pdf.TextAlign.center,
                style: pdf.TextStyle(fontSize: 32),
              ),
              pdf.Padding(padding: pdf.EdgeInsets.all(12)),
              pdf.Center(
                child: pdf.ClipRRect(
                  horizontalRadius: 16,
                  verticalRadius: 16,
                  child: pdf.Image(pdfFile),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!externalContext.mounted) return null;

    /// TODO: pages with stops details
    final pages = generateStopsPages(
      stops: travel.stops,
      pageTheme: pageTheme,
      locale: locale,
      as: as,
      externalContext: externalContext,
    );

    for (final page in pages) {
      document.addPage(page);
    }

    final lastPage = await finalPage(locale: locale, as: as);

    // Add last page
    document.addPage(
      pdf.Page(pageTheme: pageTheme, build: (context) => lastPage),
    );

    // Save the PDF to the app's documents directory
    final pdfFile = await pdfUtils.savePDF(
      document: document,
      travelTitle: travel.travelTitle,
    );

    return pdfFile;
  }

  /// Creates the cover page for the PDF
  ///
  /// Displays the travel title, start/end dates, and transport type
  Future<pdf.Center> coverPage({
    required BuildContext context,
    required Travel travel,
    required PdfDocument document,
  }) async {
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
        ],
      ),
    );
  }

  /// Creates the participants page for the PDF
  ///
  /// Displays each participant's profile picture and name
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

  List<pdf.Page> generateStopsPages({
    required List<TravelStop> stops,
    required pdf.PageTheme pageTheme,
    required String locale,
    required AppLocalizations as,
    required BuildContext externalContext,
  }) {
    final pages = <pdf.Page>[];

    for (final stop in stops) {
      final page = pdf.Page(
        pageTheme: pageTheme,
        build: (context) {
          return pdf.Column(
            children: [
              /// Stop city
              pdf.Text(
                stop.place.city!,
                style: const pdf.TextStyle(fontSize: 24),
              ),

              pdf.Padding(padding: const pdf.EdgeInsets.all(8)),

              /// Stop arrive and leave date
              pdf.Text(stop.arriveDate!.getFormattedDateWithYear(locale)),
              pdf.Text(stop.leaveDate!.getFormattedDateWithYear(locale)),

              pdf.Padding(padding: const pdf.EdgeInsets.all(8)),

              /// 'Experiences' label
              pdf.Align(
                child: pdf.Text(
                  as.experiences,
                  style: const pdf.TextStyle(fontSize: 20),
                ),
                alignment: pdf.Alignment.centerLeft,
              ),

              pdf.Padding(padding: const pdf.EdgeInsets.all(6)),

              /// Stop experiences
              pdf.Wrap(
                runAlignment: pdf.WrapAlignment.start,
                alignment: pdf.WrapAlignment.start,
                crossAxisAlignment: pdf.WrapCrossAlignment.start,
                direction: pdf.Axis.horizontal,
                verticalDirection: pdf.VerticalDirection.down,
                spacing: 6,
                runSpacing: 6,
                children: List.generate(stop.experiences!.length, (index) {
                  return PDFWidgets().experienceContainer(
                    externalContext,
                    stop.experiences![index],
                  );
                }),
              ),

              /// TODO: Reviews
            ],
          );
        },
      );

      pages.add(page);
    }

    return pages;
  }

  /// Creates the final page for the PDF
  ///
  /// Displays the app's logo, an impact phrase and a label to indicate when
  /// the document was generated
  Future<pdf.Column> finalPage({
    required String locale,
    required AppLocalizations as,
  }) async {
    final now = DateTime.now();
    final formatted = now.getFormattedDateWithYear(locale);

    final logoBytes = await rootBundle.load('assets/images/app_logo.png');
    final logoImage = pdf.MemoryImage(logoBytes.buffer.asUint8List());

    return pdf.Column(
      children: [
        pdf.ClipRRect(
          horizontalRadius: 16,
          verticalRadius: 16,
          child: pdf.Image(logoImage, fit: pdf.BoxFit.contain, height: 275),
        ),
        pdf.Padding(padding: pdf.EdgeInsets.all(8)),
        pdf.Text(
          '"${as.travel_phrase_intro}',
          textAlign: pdf.TextAlign.start,
          style: pdf.TextStyle(fontSize: 16),
        ),
        pdf.Padding(padding: pdf.EdgeInsets.all(12)),
        pdf.Text(
          '${as.travel_phrase_body}"',
          textAlign: pdf.TextAlign.start,
          style: pdf.TextStyle(fontSize: 16),
        ),
        pdf.Spacer(),
        pdf.Divider(),
        pdf.Center(child: pdf.Text(as.document_generated_timestamp(formatted))),
      ],
    );
  }
}

class PDFWidgets {
  pdf.Container experienceContainer(
    BuildContext context,
    Experience experience,
  ) {
    return pdf.Container(
      padding: const pdf.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: pdf.BoxDecoration(
        border: pdf.Border.all(width: 1),
        borderRadius: pdf.BorderRadius.circular(6),
      ),
      child: pdf.Text(
        experience.getIntlExperience(context),
        style: const pdf.TextStyle(fontSize: 10),
      ),
    );
  }
}

class PDFUtils {
  Future<File?> generateMapRouteFile({required List<TravelStop> stops}) async {
    final mapRouteUrl = await generateRouteUrl(stops, _mapsKey);

    File? file;

    if (mapRouteUrl != null) {
      try {
        final response = await http.get(Uri.parse(mapRouteUrl));

        debugPrint('Status code: ${response.statusCode}');

        if (response.statusCode == 200) {
          final dir = await getApplicationDocumentsDirectory();
          final filePath = '${dir.path}/travel_overview.png';
          file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    return file;
  }

  Future<File>? savePDF({
    required pdf.Document document,
    required String travelTitle,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$travelTitle.pdf';
    final pdfBytes = await document.save();

    final pdfFile = File(filePath);
    await pdfFile.writeAsBytes(pdfBytes);
    debugPrint('pdf file saved at: $filePath');
    return pdfFile;
  }

  Future<String?> generateRouteUrl(List<TravelStop> stops, String key) async {
    final waypoints = stops
        .sublist(1, stops.length - 1)
        .map((p) => p.place.latLng.toLatLngString())
        .join('|');

    final origin = stops.first.place.latLng.toLatLngString();
    final destination = stops.last.place.latLng.toLatLngString();

    final directionsUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&waypoints=$waypoints&key=$key';

    final directionsRes = await http.get(Uri.parse(directionsUrl));

    if (directionsRes.statusCode != 200) {
      throw Exception('directions request failed. body: ${directionsRes.body}');
    }

    final data = jsonDecode(directionsRes.body);

    if (data['routes'].isEmpty) {
      return null;
    }

    final encodedPolyline = data['routes'][0]['overview_polyline']['points'];

    final markers = stops
        .map((p) => 'markers=color:red|${p.place.latLng.toLatLngString()}')
        .join('&');

    final staticMapUrl =
        'https://maps.googleapis.com/maps/api/staticmap'
        '?size=600x400&maptype=roadmap'
        '&path=color:0xFF0000FF|weight:5|enc:$encodedPolyline'
        '&$markers'
        '&key=$key';

    return staticMapUrl;
  }
}
