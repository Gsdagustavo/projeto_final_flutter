import 'package:flutter/material.dart';

class CustomDateRangeWidget extends StatefulWidget {
  const CustomDateRangeWidget({
    super.key,
    required this.firstDateController,
    required this.lastDateController,
    required this.firstDateLabelText,
    required this.lastDateLabelText,
  });

  final TextEditingController firstDateController;
  final TextEditingController lastDateController;
  final String firstDateLabelText;
  final String lastDateLabelText;

  @override
  State<CustomDateRangeWidget> createState() => _CustomDateRangeWidgetState();
}

class _CustomDateRangeWidgetState extends State<CustomDateRangeWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          canRequestFocus: false,
          controller: widget.firstDateController,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            labelText: widget.firstDateLabelText,
          ),
        ),

        Padding(padding: EdgeInsets.all(16)),

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
