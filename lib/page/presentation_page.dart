import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:opencard/model/card.dart';
import 'package:opencard/utils/barcode_type.dart';

class PresentationPage extends StatefulWidget {
  final CardModel card;

  const PresentationPage({Key? key, required this.card}) : super(key: key);

  @override
  State<PresentationPage> createState() => _PresentationPageState();
}

class _PresentationPageState extends State<PresentationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.55,
          width: MediaQuery.of(context).size.width,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: widget.card.backgroundColor,
            borderRadius: BorderRadius.circular(0.0),
          ),
          padding: const EdgeInsets.all(10),
          child: Hero(
            tag: 'card-${widget.card.content}',
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 55,
                ),
                BarcodeWidget(
                  barcode: BarcodeTypeUtil.getBarcode(
                      widget.card.type), // Barcode type and settings
                  data: widget.card.content, // Content
                  drawText: false,
                  color: const Color(0xff2e3440),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 90,
                ),
                const SizedBox(
                  height: 55,
                ),
                Text(
                  widget.card.name,
                  style: TextStyle(
                    color: widget.card.foregroundColor,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        onPressed: () => Navigator.of(context).pop(),
        backgroundColor: const Color(0xff2e3440),
        child: const Icon(Icons.arrow_back, color: Colors.white),
      ),
    );
  }
}
