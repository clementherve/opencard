import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:localstore/localstore.dart';
import 'package:opencard/model/card.dart';

import '../widget/homescreen_card.dart';

/// Page edit / delete a card
class EditionPage extends StatefulWidget {
  final CardModel card;
  final Localstore db;
  final bool? isnew;

  const EditionPage(
    this.db, {
    Key? key,
    required this.card,
    required this.isnew,
  }) : super(key: key);

  @override
  State<EditionPage> createState() => _EditionPageState();
}

class _EditionPageState extends State<EditionPage> {
  late bool wasUpdated;
  late Color backgroundColor;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  Widget _showModifiedAlert(BuildContext context) {
    return AlertDialog(
      title: const Text('Enregistrer cette carte ?'),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Quitter',
            style: TextStyle(color: Color(0xff2e3440)),
          ),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        TextButton(
          child: const Text(
            'Sauvegarder',
            style: TextStyle(color: Color(0xffa3be8c)),
          ),
          onPressed: () {
            widget.db.collection('cards').doc(widget.card.content).set({
              // on va avoir un problème avec l'id
              'name': nameController.value.text,
              'content': valueController.value.text,
              'type': typeController.value.text,
              'foregroundColor': 0xffffffff,
              'backgroundColor': backgroundColor.value,
            }).then((value) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            });
          },
        ),
      ],
    );
  }

  Widget _showBeforeDeleteAlert(BuildContext context) {
    return AlertDialog(
      title: const Text('Supprimer cette carte?'),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Ne pas supprimer',
            style: TextStyle(color: Color(0xffa3be8c)),
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        TextButton(
          child: const Text(
            'Supprimer',
            style: TextStyle(color: Color(0xff2e3440)),
          ),
          onPressed: () {
            widget.db
                .collection('cards')
                .doc(widget.card.content)
                .delete()
                .then((value) {
              widget.db.collection('cards').get().then((data) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              });
            });
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    wasUpdated = widget.isnew ?? false;
    backgroundColor = widget.card.backgroundColor;

    nameController.text = widget.card.name;
    valueController.text = widget.card.content;
    typeController.text = widget.card.type;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Modifier la carte',
          style: TextStyle(color: Color(0xff2e3440), fontSize: 18),
        ),
        leading: IconButton(
            onPressed: () {
              if (wasUpdated) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _showModifiedAlert(context);
                  },
                );
              } else {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.arrow_back, color: Color(0xff2e3440))),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _showBeforeDeleteAlert(context);
                  },
                );
              },
              icon: const Icon(Icons.delete, color: Color(0xffbf616a)))
        ],
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Hero(
              tag: 'card-${widget.card.content}',
              child: HomeScreenCard(
                card: widget.card,
                onTap: (CardModel card) => {},
                onLongPress: (CardModel card) => {},
              ),
            ),
            GestureDetector(
              onTap: () {
                wasUpdated = true;
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext ctxt) {
                      return MaterialColorPicker(
                        elevation: 1,
                        onlyShadeSelection: true,
                        selectedColor: widget.card.backgroundColor,
                        onColorChange: (Color newColor) {
                          setState(() {
                            backgroundColor = newColor;
                            widget.card.backgroundColor = backgroundColor;
                          });
                          Navigator.of(context).pop();
                        },
                      );
                    });
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Modifier la couleur',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Color(0xff3b4252)),
                      ),
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: widget.card.backgroundColor,
                        ),
                      )
                    ]),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: TextField(
                controller: nameController,
                onChanged: (String newName) {
                  wasUpdated = true;
                  setState(() {
                    widget.card.name = newName;
                  });
                },
                decoration: const InputDecoration(
                    labelText: 'Nom de la carte',
                    labelStyle: TextStyle(color: Color(0xff4c566a)),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Color.fromARGB(255, 248, 249, 252)),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: TextField(
                controller: valueController,
                onChanged: (String newValue) {
                  wasUpdated = true;
                  setState(() {
                    widget.card.content = newValue;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Valeur du code-barre',
                  labelStyle: TextStyle(color: Color(0xff4c566a)),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Color.fromARGB(255, 248, 249, 252),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: TextField(
                controller: typeController,
                onChanged: (String newValue) => wasUpdated = true,
                decoration: const InputDecoration(
                  labelText: 'Type de code-barre',
                  labelStyle: TextStyle(color: Color(0xff4c566a)),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Color.fromARGB(255, 248, 249, 252),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        onPressed: () {
          widget.db.collection('cards').doc(widget.card.content).set({
            // on va avoir un problème avec l'id
            'name': nameController.value.text,
            'content': valueController.value.text,
            'type': typeController.value.text,
            'foregroundColor': 0xffffffff, // TODO
            'backgroundColor': backgroundColor.value, // TODO
          }).then((value) {
            Navigator.of(context).pop(true);
          });
        },
        backgroundColor: const Color(0xffa3be8c),
        child: const Icon(Icons.save, color: Colors.white),
      ),
    );
  }
}
