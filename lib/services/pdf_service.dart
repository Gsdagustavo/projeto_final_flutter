import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

/// Service responsible for generating PDF documents for a given [Travel].
///
/// The PDF contains:
/// - A **cover page** with travel title and dates
/// - A **participants page** with participant names and pictures
/// - A **route page** with a map showing the travel path
/// - A **stops section** with details of each stop (dates, experiences, etc.)
/// - A **final page** with app logo, a travel phrase, and a timestamp.
///
/// PDFs are saved in the application documents directory.
class PDFService {
  /// Travel data to be represented in the PDF.
  final Travel travel;

  /// Flutter [BuildContext], used for localization and user preferences.
  final BuildContext context;

  /// Google Maps API key, required to generate static map images for the PDF.
  final String mapsApiKey;

  /// Creates a new [PDFService].
  const PDFService({
    required this.travel,
    required this.context,
    required this.mapsApiKey,
  });

  /// Default padding used across all PDF pages.
  static const double _pagePadding = 32;

  /// Generates a PDF file for the current [travel].
  ///
  /// - Builds the document structure (cover, participants, route, stops, final
  /// page).
  /// - Fetches map images via Google Maps API.
  /// - Saves the final PDF to the app's documents directory.
  ///
  /// Returns a [File] pointing to the generated PDF, or `null` if an error
  /// occurred.
  Future<File?> generatePDFFromTravel() async {
    final document = pdf.Document();
    final as = AppLocalizations.of(context)!;

    // Load PDF font
    final font = await PdfGoogleFonts.nunitoExtraLight();

    // Page theme definition
    final pageTheme = pdf.PageTheme(
      margin: pdf.EdgeInsets.all(_pagePadding),
      pageFormat: PdfPageFormat.a5,
      orientation: pdf.PageOrientation.portrait,
      clip: true,
      theme: pdf.ThemeData(defaultTextStyle: pdf.TextStyle(font: font)),
    );

    if (!context.mounted) return null;

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

    // Add cover page
    document.addPage(pdfPages.coverPage());

    // Add participants page
    document.addPage(pdfPages.participantsPage());

    // Add travel route page if available
    final travelRouteImage = await pdfUtils.generateMapRouteFile();
    if (travelRouteImage != null) {
      final fileBytes = await travelRouteImage.readAsBytes();
      final pdfFile = pdf.MemoryImage(fileBytes);

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

    // Add stops pages
    for (final page in pdfPages.generateStopsPages()) {
      document.addPage(page);
    }

    // Add final page
    final lastPage = await pdfPages.finalPage();
    document.addPage(lastPage);

    // Save the PDF
    final pdfFile = await pdfUtils.savePDF(document: document);
    return pdfFile;
  }
}

/// Utility class for building structured PDF pages for a [Travel].
///
/// Contains methods for generating:
/// - Cover page
/// - Participants page
/// - Stops pages
/// - Final summary page
class _PDFPages {
  /// Travel being represented.
  final Travel travel;

  /// App localization strings.
  final AppLocalizations as;

  /// BuildContext for localization and preferences.
  final BuildContext context;

  /// Current locale (e.g., `en`, `pt`).
  final String locale;

  /// Shared page theme for the document.
  final pdf.PageTheme pageTheme;

  /// Constructor.
  const _PDFPages({
    required this.travel,
    required this.as,
    required this.context,
    required this.locale,
    required this.pageTheme,
  });

  /// Base template for all pages.
  pdf.Page _basePage({required pdf.BuildCallback build}) {
    return pdf.Page(pageTheme: pageTheme, build: build);
  }

  /// Creates the **cover page** with travel title and dates.
  pdf.Page coverPage() {
    return _basePage(
      build: (context) {
        return pdf.Center(
          child: pdf.Column(
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

  /// Creates the **participants page**.
  ///
  /// Displays:
  /// - Profile picture
  /// - Participant name
  pdf.Page participantsPage() {
    return _basePage(
      build: (context) {
        return pdf.Column(
          children: [
            pdf.Text(
              as.participants,
              textAlign: pdf.TextAlign.center,
              style: pdf.TextStyle(fontSize: 32),
            ),
            pdf.Padding(padding: pdf.EdgeInsets.all(16)),
            pdf.Expanded(
              child: pdf.ListView.separated(
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
                separatorBuilder: (_, __) =>
                    pdf.Padding(padding: pdf.EdgeInsets.all(8)),
                itemCount: travel.participants.length,
              ),
            ),
          ],
        );
      },
    );
  }

  /// Generates one page for each travel stop.
  ///
  /// Each page includes:
  /// - Stop city
  /// - Arrival/leave dates
  /// - Experiences (as tags/labels)
  List<pdf.Page> generateStopsPages() {
    final pages = <pdf.Page>[];

    for (final stop in travel.stops) {
      debugPrint('Stop: $stop');
    }

    for (final stop in travel.stops) {
      final page = _basePage(
        build: (_) {
          return pdf.Column(
            children: [
              pdf.Text(stop.place.city!, style: pdf.TextStyle(fontSize: 24)),
              pdf.Padding(padding: pdf.EdgeInsets.all(8)),
              pdf.Text(stop.arriveDate!.getFormattedDateWithYear(locale)),
              pdf.Text(stop.leaveDate!.getFormattedDateWithYear(locale)),
              pdf.Padding(padding: pdf.EdgeInsets.all(8)),
              pdf.Align(
                alignment: pdf.Alignment.centerLeft,
                child: pdf.Text(
                  as.experiences,
                  style: pdf.TextStyle(fontSize: 20),
                ),
              ),
              pdf.Padding(padding: pdf.EdgeInsets.all(6)),
              pdf.Wrap(
                spacing: 6,
                runSpacing: 6,
                children: List.generate(stop.experiences!.length, (i) {
                  return _PDFWidgets().experienceContainer(
                    context,
                    stop.experiences![i],
                  );
                }),
              ),

              if (stop.reviews!.isNotEmpty)
                pdf.Column(
                  children: [
                    pdf.Align(
                      alignment: pdf.Alignment.centerLeft,
                      child: pdf.Text(
                        as.reviews,
                        style: pdf.TextStyle(fontSize: 20),
                      ),
                    ),
                    pdf.Padding(padding: pdf.EdgeInsets.all(8)),

                    for (final review in stop.reviews!)
                      pdf.Container(
                        decoration: pdf.BoxDecoration(
                          borderRadius: pdf.BorderRadius.circular(12),
                          border: pdf.Border.all(
                            width: 1,
                            color: PdfColors.grey,
                          ),
                        ),
                        margin: pdf.EdgeInsets.only(top: 8),
                        padding: pdf.EdgeInsets.all(16),
                        child: pdf.Column(
                          crossAxisAlignment: pdf.CrossAxisAlignment.start,
                          mainAxisAlignment: pdf.MainAxisAlignment.start,
                          children: [
                            pdf.Row(
                              mainAxisAlignment: pdf.MainAxisAlignment.start,
                              crossAxisAlignment: pdf.CrossAxisAlignment.start,
                              children: [
                                pdf.SizedBox(
                                  height: 32,
                                  width: 32,
                                  child: pdf.ClipRRect(
                                    verticalRadius: 12,
                                    horizontalRadius: 12,
                                    child: pdf.Image(
                                      pdf.MemoryImage(
                                        review.author.profilePicture
                                            .readAsBytesSync(),
                                      ),
                                    ),
                                  ),
                                ),
                                pdf.Padding(padding: pdf.EdgeInsets.all(8)),
                                pdf.Column(
                                  mainAxisAlignment:
                                      pdf.MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      pdf.CrossAxisAlignment.start,
                                  children: [
                                    pdf.Text(
                                      review.author.name,
                                      style: pdf.TextStyle(fontSize: 20),
                                    ),
                                    pdf.Text(
                                      review.reviewDate.getFormattedDate(
                                        locale,
                                      ),
                                      style: pdf.TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                pdf.Padding(padding: pdf.EdgeInsets.all(8)),
                                pdf.Text(
                                  '${review.stars} stars',
                                  style: pdf.TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            pdf.Padding(padding: pdf.EdgeInsets.all(4)),
                            pdf.Text(
                              review.description,
                              style: pdf.TextStyle(fontSize: 18),
                            ),
                            pdf.Padding(padding: pdf.EdgeInsets.all(4)),
                            pdf.GridView(
                              children: [
                                for (final image in review.images)
                                  pdf.ClipRRect(
                                    child: pdf.Image(
                                      pdf.MemoryImage(image.readAsBytesSync()),
                                    ),
                                    horizontalRadius: 12,
                                    verticalRadius: 12,
                                  ),
                              ],
                              crossAxisCount: 2,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
            ],
          );
        },
      );
      pages.add(page);
    }
    return pages;
  }

  /// Creates the **final page**.
  ///
  /// Contains:
  /// - App logo
  /// - Inspirational travel phrase
  /// - Timestamp of generation
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
              style: pdf.TextStyle(fontSize: 16),
            ),
            pdf.Padding(padding: pdf.EdgeInsets.all(12)),
            pdf.Text(
              '${as.travel_phrase_body}"',
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

/// Helper widgets for PDF rendering.
///
/// Contains reusable UI blocks such as experience containers.
class _PDFWidgets {
  /// Renders an experience as a labeled container.
  pdf.Container experienceContainer(
    BuildContext context,
    Experience experience,
  ) {
    return pdf.Container(
      padding: pdf.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: pdf.BoxDecoration(
        border: pdf.Border.all(width: 1),
        borderRadius: pdf.BorderRadius.circular(6),
      ),
      child: pdf.Text(
        experience.getIntlExperience(context),
        style: pdf.TextStyle(fontSize: 10),
      ),
    );
  }
}

/// Utility class for interacting with Google Maps API and saving PDFs.
class _PDFUtils {
  /// Travel data used for generating routes and saving files.
  final Travel travel;

  /// Google Maps API key.
  final String mapsApiKey;

  /// Constructor.
  const _PDFUtils({required this.travel, required this.mapsApiKey});

  /// Generates a static map route image for the travel itinerary.
  ///
  /// - Uses Google Directions API to generate polyline.
  /// - Uses Static Maps API to render the route with markers.
  /// - Saves the image locally as `travel_overview.png`.
  ///
  /// Returns the saved [File], or `null` if the request fails.
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

  /// Saves the generated [pdf.Document] as a file.
  ///
  /// File is named after the [travelTitle].
  Future<File>? savePDF({required pdf.Document document}) async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/${travel.travelTitle}.pdf';
    final pdfBytes = await document.save();

    final pdfFile = File(filePath);
    await pdfFile.writeAsBytes(pdfBytes);
    debugPrint('pdf file saved at: $filePath');
    return pdfFile;
  }

  /// Generates a static Google Maps route URL for the given travel stops.
  ///
  /// Steps:
  /// - Calls **Directions API** to get encoded polyline.
  /// - Builds a **Static Maps API** URL with the polyline and markers.
  ///
  /// Returns the generated URL, or `null` if no routes are available.
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
    if (data['routes'].isEmpty) return null;

    final encodedPolyline = data['routes'][0]['overview_polyline']['points'];
    final markers = travel.stops
        .map((p) => 'markers=color:red|${p.place.latLng.toLatLngString()}')
        .join('&');

    return 'https://maps.googleapis.com/maps/api/staticmap'
        '?size=600x400&maptype=roadmap'
        '&path=color:0xFF0000FF|weight:5|enc:$encodedPolyline'
        '&$markers'
        '&key=$mapsApiKey';
  }
}
