import 'package:flutter/material.dart';

/// A reusable widget for selecting a date range using two [TextField]s.
///
/// This widget displays two [TextField]s: one for the start date and one for
/// the end date. The text fields are controlled via [TextEditingController]s
/// passed from the parent.
///
/// Note: Currently, the text fields are read-only (`canRequestFocus: false`),
/// so you can use them with a [showDatePicker] or similar mechanism to select
/// dates.
class CustomDateRangeWidget extends StatefulWidget {
  /// Creates a [CustomDateRangeWidget].
  ///
  /// [firstDateController] and [lastDateController] control the text of the
  /// start and end date fields, respectively.
  ///
  /// [firstDateLabelText] and [lastDateLabelText] provide the label text for
  /// the respective fields.
  const CustomDateRangeWidget({
    super.key,
    required this.firstDateController,
    required this.lastDateController,
    required this.firstDateLabelText,
    required this.lastDateLabelText,
  });

  /// Controller for the start date text field.
  final TextEditingController firstDateController;

  /// Controller for the end date text field.
  final TextEditingController lastDateController;

  /// Label text displayed above the start date text field.
  final String firstDateLabelText;

  /// Label text displayed above the end date text field.
  final String lastDateLabelText;

  @override
  State<CustomDateRangeWidget> createState() => _CustomDateRangeWidgetState();
}

class _CustomDateRangeWidgetState extends State<CustomDateRangeWidget> {
  @override
  Widget build(BuildContext modalContext) {
    return Column(
      children: [
        /// Start Date TextField
        TextField(
          canRequestFocus: false,
          controller: widget.firstDateController,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            labelText: widget.firstDateLabelText,
          ),
        ),

        const Padding(padding: EdgeInsets.all(16)),

        /// End Date TextField
        TextField(
          canRequestFocus: false,
          controller: widget.lastDateController,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            labelText: widget.lastDateLabelText,
          ),
        ),
      ],
    );
  }
}
