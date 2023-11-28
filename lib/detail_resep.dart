import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projectakhir_kelompok_resep/resep/model_resep.dart';
import 'package:projectakhir_kelompok_resep/resep_card.dart';

class DetailResep extends StatefulWidget {
  final String name;
  final String images;
  final String rating;
  final String totalTime;
  final String description;
  final String videoUrl;
  final List<Instruction> instruction;
  final List<Section> sections;

  const DetailResep({
    required this.name,
    required this.images,
    required this.rating,
    required this.totalTime,
    required this.description,
    required this.videoUrl,
    required this.instruction,
    required this.sections,


  });

  @override
  State<DetailResep> createState() => _DetailResepState();

}

class _DetailResepState extends State<DetailResep> {
  bool isBookmarked = false;


  @override
  Widget build(BuildContext context) {
    List<Component> components = List.from(widget.sections[0].components);


    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu),
            SizedBox(width: 10),
            Text('Resep Makanan')
          ],
        ),
        backgroundColor: Color.fromARGB(255, 255, 202, 69),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ResepCard(
                title: widget.name,
                cookTime: widget.totalTime,
                rating: widget.rating,
                thumbnailUrl: widget.images,
                videoUrl: widget.videoUrl,
                isBookmarked: isBookmarked,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Description',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.description,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.justify),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Instructions',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: widget.instruction.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title:
                                  Text(widget.instruction[index].displayText),
                            );
                          },
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Ingredients',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: components.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                  components[index].rawText),
                            );
                          },
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
