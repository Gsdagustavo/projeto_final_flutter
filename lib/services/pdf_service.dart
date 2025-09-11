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
import '../domain/entities/travel.dart';
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
  final Travel travel;
  final BuildContext context;
  final String mapsApiKey;

  const PDFService({
    required this.travel,
    required this.context,
    required this.mapsApiKey,
  });

  static const double _pagePadding = 32;

  /// Generates a PDF file from a [Travel] instance
  ///
  /// [travel]: The travel data to be included in the PDF
  /// [context]: The Flutter [BuildContext] used to access localization
  /// and user preferences
  ///
  /// Returns a [File] representing the saved PDF, or null if an error occurs
  Future<File?> generatePDFFromTravel() async {
    // Initialize pdf document
    final document = pdf.Document();

    // AppLocalizations
    final as = AppLocalizations.of(context)!;

    // Load the font used for the PDF
    final font = await PdfGoogleFonts.nunitoExtraLight();

    // PDF page theme
    final pageTheme = pdf.PageTheme(
      margin: pdf.EdgeInsets.all(_pagePadding),
      pageFormat: PdfPageFormat.a5,
      theme: pdf.ThemeData(defaultTextStyle: pdf.TextStyle(font: font)),
    );

    if (!context.mounted) return null;

    // Locale
    final locale = context.read<UserPreferencesProvider>().languageCode;

    final pdfUtils = _PDFUtils(travel: travel, mapsApiKey: mapsApiKey);
    final pdfPages = _PDFPages(
      travel: travel,
      as: as,
      context: context,
      locale: locale,
      pageTheme: pageTheme,
    );

    if (!context.mounted) return null;

    // PDF cover page
    final coverPage = pdfPages.coverPage();

    // Add the cover page
    document.addPage(coverPage);

    // PDF participants page
    final participantsPage = pdfPages.participantsPage();

    // Add the participants page
    document.addPage(participantsPage);

    final travelRouteImage = await pdfUtils.generateMapRouteFile();

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

    if (!context.mounted) return null;

    // PDF stops pages
    final stopsPages = pdfPages.generateStopsPages();

    // Add stops pages to PDF
    for (final page in stopsPages) {
      document.addPage(page);
    }

    // PDF last page
    final lastPage = await pdfPages.finalPage();

    // Add PDF last page
    document.addPage(lastPage);

    // Save the PDF to the app's documents directory
    final pdfFile = await pdfUtils.savePDF(document: document);

    return pdfFile;
  }
}

class _PDFPages {
  final Travel travel;
  final AppLocalizations as;
  final BuildContext context;
  final String locale;
  final pdf.PageTheme pageTheme;

  const _PDFPages({
    required this.travel,
    required this.as,
    required this.context,
    required this.locale,
    required this.pageTheme,
  });

  pdf.Page _basePage({required pdf.BuildCallback build}) {
    return pdf.Page(pageTheme: pageTheme, build: build);
  }

  pdf.Page coverPage() {
    return _basePage(
      build: (context) {
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
      },
    );
  }

  /// Creates the participants page for the PDF
  ///
  /// Displays each participant's profile picture and name
  pdf.Page participantsPage() {
    return _basePage(
      build: (context) {
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
                  final participant = travel.participants[index];
                  final image = pdf.MemoryImage(
                    participant.profilePicture
                        .readAsBytesSync()
                        .buffer
                        .asUint8List(),
                  );

                  return pdf.Container(
                    padding: pdf.EdgeInsets.all(12),
                    decoration: pdf.BoxDecoration(
                      border: pdf.Border.all(
                        width: 1,
                        color: PdfColor(0, 0, 0),
                      ),
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
                itemCount: travel.participants.length,
              ),
            ),
          ],
        );
      },
    );
  }

  List<pdf.Page> generateStopsPages() {
    final pages = <pdf.Page>[];

    for (final stop in travel.stops) {
      final page = _basePage(
        build: (_) {
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
                  return _PDFWidgets().experienceContainer(
                    context,
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
  Future<pdf.Page> finalPage() async {
    final now = DateTime.now();
    final formatted = now.getFormattedDateWithYear(locale);

    final logoBytes = await rootBundle.load('assets/images/app_logo.png');
    final logoImage = pdf.MemoryImage(logoBytes.buffer.asUint8List());

    return _basePage(
      build: (context) {
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
            pdf.Center(
              child: pdf.Text(as.document_generated_timestamp(formatted)),
            ),
          ],
        );
      },
    );
  }
}

class _PDFWidgets {
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

class _PDFUtils {
  final Travel travel;
  final String mapsApiKey;

  const _PDFUtils({required this.travel, required this.mapsApiKey});

  Future<File?> generateMapRouteFile() async {
    final mapRouteUrl = await generateRouteUrl();

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

  Future<File>? savePDF({required pdf.Document document}) async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/${travel.travelTitle}.pdf';
    final pdfBytes = await document.save();

    final pdfFile = File(filePath);
    await pdfFile.writeAsBytes(pdfBytes);
    debugPrint('pdf file saved at: $filePath');
    return pdfFile;
  }

  Future<String?> generateRouteUrl() async {
    final waypoints = travel.stops
        .sublist(1, travel.stops.length - 1)
        .map((p) => p.place.latLng.toLatLngString())
        .join('|');

    final origin = travel.stops.first.place.latLng.toLatLngString();
    final destination = travel.stops.last.place.latLng.toLatLngString();

    final directionsUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&waypoints=$waypoints&key=$mapsApiKey';

    final directionsRes = await http.get(Uri.parse(directionsUrl));

    if (directionsRes.statusCode != 200) {
      throw Exception('directions request failed. body: ${directionsRes.body}');
    }

    final data = jsonDecode(directionsRes.body);

    if (data['routes'].isEmpty) {
      return null;
    }

    final encodedPolyline = data['routes'][0]['overview_polyline']['points'];

    final markers = travel.stops
        .map((p) => 'markers=color:red|${p.place.latLng.toLatLngString()}')
        .join('&');

    final staticMapUrl =
        'https://maps.googleapis.com/maps/api/staticmap'
        '?size=600x400&maptype=roadmap'
        '&path=color:0xFF0000FF|weight:5|enc:$encodedPolyline'
        '&$markers'
        '&key=$mapsApiKey';

    return staticMapUrl;
  }
}
