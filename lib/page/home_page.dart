import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:opencard/model/card.dart';
import 'package:opencard/page/presentation_page.dart';
import 'package:opencard/widget/homescreen_card.dart';

import 'edit_page.dart';

class HomePage extends StatefulWidget {
  final Localstore db;
  const HomePage(this.db, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? data;

  void loadCards() {
    widget.db.collection('cards').get().then((data) {
      setState(() {
        print('date: $data');
        this.data = data;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: ListView.builder(
          itemCount: data == null ? 1 : data!.values.length + 1,
          itemBuilder: ((context, index) {
            if (index == 0) {
              return Container(
                margin: const EdgeInsets.only(top: 10),
                child: AppBar(
                  title: const Text(
                    'OpenCard',
                    style: TextStyle(color: Color(0xff9F9F9F), fontSize: 24),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.white,
                ),
              );
            } else {
              final Widget w = Hero(
                tag: 'card-${data!.values.elementAt(index - 1)['content']}',
                child: HomeScreenCard(
                  card: CardModel.fromJSON({
                    ...data!.values.elementAt(index - 1),
                  }),
                  onTap: (CardModel card) => {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: ((context) => PresentationPage(card: card)),
                        ))
                        .then((value) => loadCards())
                  },
                  onLongPress: (CardModel card) => {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: ((context) =>
                              EditionPage(widget.db, card: card, isnew: false)),
                        ))
                        .then((value) => loadCards())
                  },
                ),
              );
              return index == data!.keys.length
                  ? Column(children: [w, const SizedBox(height: 95)])
                  : w;
            }
          }),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        onPressed: () {
          BarcodeScanner.scan().then((ScanResult result) {
            if (result.rawContent.isEmpty) return;
            final d = DateTime.now();
            final name =
                'Carte du ${d.day}/${d.month}/${d.year} à ${d.hour}:${d.minute}';
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: ((context) => EditionPage(
                          widget.db,
                          card: CardModel(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            content: result.rawContent,
                            name: name,
                            type: result.type.name,
                          ),
                          isnew: true,
                        )),
                  ),
                )
                .then((value) => loadCards());
          });
        },
        backgroundColor: const Color(0xff2e3440),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
