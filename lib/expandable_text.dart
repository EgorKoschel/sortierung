import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextOverflow? overflow;
  final TextStyle? style;

  const ExpandableText({
    super.key,
    required this.text,
    this.maxLines = 2,
    this.overflow = TextOverflow.ellipsis,
    this.style,
  });

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              maxLines: isExpanded ? null : widget.maxLines,
              overflow: isExpanded ? TextOverflow.visible : widget.overflow,
              style: widget.style,
            ),
          ],
        ),
      ),
    );
  }
}
