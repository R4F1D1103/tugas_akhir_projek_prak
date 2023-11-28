import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'feedback/feedback_model.dart';

class FeedbackForm extends StatefulWidget {
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final TextEditingController _saranController = TextEditingController();
  final TextEditingController _kesanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Form Keluhan dan Saran',
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 202, 69),
        foregroundColor: Colors.grey[600],
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Keluhan:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600]
                  ),
                ),
                TextField(
                  controller: _saranController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Masukkan Keluhan Anda...',
                    border: OutlineInputBorder(),
                    hintStyle: TextStyle(
                        color: Colors.grey[600]
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!)
                    ),
                  ),
                  cursorColor: Colors.grey[600],
                ),
                SizedBox(height: 16.0),
                Text(
                  'Saran:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600]
                  ),
                ),
                TextField(
                  controller: _kesanController,
                  maxLines: 3,
                  decoration: InputDecoration(
                      hintText: 'Masukkan Saran Anda...',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[600]!)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[600]!)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[600]!)
                      ),
                      hintStyle: TextStyle(
                          color: Colors.grey[600]
                      )
                  ),
                  cursorColor: Colors.grey[600],
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    submitFeedback();
                  },
                  child: Text(
                    'Kirim',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 255, 202, 69),)
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  'Keluhan & Saran',
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: Hive.box<FeedbackModel>('feedbackBox').listenable(),
                    builder: (BuildContext context, Box<FeedbackModel> box, _) {
                      if (box.values.isEmpty) {
                        return Center(
                          child: Text('Feedback is empty.'),
                        );
                      }
                      return ListView.builder(
                        itemCount: box.values.length,
                        itemBuilder: (context, index) {
                          FeedbackModel? feedback = box.getAt(index);
                          return Card(
                            elevation: 3,
                            color: Color.fromARGB(255, 224, 190, 89),
                            margin: EdgeInsets.all(6),
                            child: ListTile(
                              leading: Icon(Icons.chat_outlined),
                              title: Text('Kesan: ${feedback?.kesan}'),
                              subtitle: Text('Saran: ${feedback?.saran}'),
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),

    );
  }

  void submitFeedback() async {
    try {
      var feedbackBox = await Hive.openBox<FeedbackModel>('feedbackBox');

      FeedbackModel feedback = FeedbackModel(
        saran: _saranController.text,
        kesan: _kesanController.text,
      );

      await feedbackBox.add(feedback);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pesan berhasil disubmit.'),
            backgroundColor: Colors.green,
          )
      );
      print('Feedback berhasil disimpan ke dalam Hive box.');
      _saranController.clear();
      _kesanController.clear();
    } catch (e) {
      print('Error: $e');
    }
  }
}
