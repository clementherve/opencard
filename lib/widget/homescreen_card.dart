import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:opencard/model/card.dart';

import '../utils/barcode_type.dart';

class HomeScreenCard extends StatefulWidget {
  final Function(CardModel card) onLongPress;
  final Function(CardModel card) onTap;
  final CardModel card;

  const HomeScreenCard({
    Key? key,
    required this.card,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  State<HomeScreenCard> createState() => _HomeScreenCardState();
}

class _HomeScreenCardState extends State<HomeScreenCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => widget.onLongPress(widget.card),
      onTap: () => widget.onTap(widget.card),
      child: Card(
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Container(
          height: 170,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: widget.card.backgroundColor,
            borderRadius: BorderRadius.circular(5.0),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                widget.card.name,
                style: TextStyle(
                  color: widget.card.foregroundColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              BarcodeWidget(
                barcode: BarcodeTypeUtil.getBarcode(
                  widget.card.type,
                ), // Barcode type and settings
                data: widget.card.content, // Content
                drawText: false,
                color: const Color(0xff2e3440),
                width: 140,
                height: 90,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
