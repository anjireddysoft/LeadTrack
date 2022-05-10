/*
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:team_trackeradmin/task_model.dart';

import 'mobile.dart' if (dart.library.html) 'web.dart';

class Detalis extends StatefulWidget {
  String name;

  Detalis({Key key, this.name}) : super(key: key);

  @override
  DetalisState createState() => DetalisState();
}

class _DetalisState extends State<Detalis> {
  List<TaskModel> taskList = [];
  DatabaseReference reference =
  FirebaseDatabase.instance.reference().child('Tasks');
  List<dynamic> tasks = [];

  getData(String name) {
    //print("name$name");
    FirebaseDatabase.instance
        .reference()
        .child('Tasks')
        .child("${name}")
        .once()
        .then((DataSnapshot snapshot) {
      print("snapshot${snapshot.value}");

      var keys = snapshot.value.keys;
      print("keys${keys}");
      var values = snapshot.value;
      print("values${values}");
      for (String key in keys) {
        print("key $key");



        TaskModel model = TaskModel(
          date: values[key]['date'],
          time: values[key]['hrs'],
          task: values[key]['task'],
        );

        setState(() {
          taskList.add(model);
          print("model is${model.time}");
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getData(widget.name);
    createPDF(widget.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.name}",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) =>View()),
              // );
              createPDF(widget.name);
            },
            icon: Icon(Icons.add),
            color: Colors.black,
          )
        ],
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.all(10),
        child: ListView.builder(
            itemCount: taskList.length,
            //  reverse: true,
            itemBuilder: (context, index) {
              tasks = taskList[index].task;
              return Card(
                elevation: 1,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "Date : ${taskList[index].date}",
                              style:
                              TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          ),
                          Text(
                            "hour : ${taskList[index].time}",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: taskList[index].task.length,
                          itemBuilder: (context, int) {
                            // taskList[index].task.insert(index, element)
                            return Text('${taskList[index].task[int]}');
                          })
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Future<void> createPDF(String name) async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    page.graphics.drawString('Welcome to PDF Succinctly!',
        PdfStandardFont(PdfFontFamily.helvetica, 30));

    // page.graphics.drawImage(
    //     PdfBitmap(await _readImageData('Pdf_Succinctly.jpg')),
    //     Rect.fromLTWH(0, 100, 440, 550));

    PdfGrid grid = PdfGrid();
    grid.style = PdfGridStyle(
        font: PdfStandardFont(PdfFontFamily.helvetica, 30),
        cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));

    grid.columns.add(count: 4);
    grid.headers.add(1);

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Roll No';
    header.cells[1].value = 'Name';
    header.cells[2].value = 'task';
    header.cells[3].value = 'hrs';

    PdfGridRow row = grid.rows.add();
    row.cells[0].value = '1';
    row.cells[1].value = 'Arya';
    row.cells[2].value = "lzsgf";
    row.cells[3].value = '6';
    for (var i = 0; i <= taskList.length - 1; i++) {
      print("number is${i}");
      row = grid.rows.add();
      row.cells[0].value = '${taskList[i].date}';
      row.cells[1].value = '${name}';

      row.cells[2].value = "${taskList[i].task.join(",\n-")}" ;
      row.cells[3].value = '${taskList[i].time}';
      //

    }

    // row = grid.rows.add();
    // row.cells[0].value = '3';
    // row.cells[1].value = 'Tony';
    // row.cells[2].value = '8';

    grid.draw(
        page: document.pages.add(), bounds: const Rect.fromLTWH(0, 100, 440, 550));

    List<int> bytes = document.save();
    document.dispose();

    saveAndLaunchFile(bytes, '${name}.pdf');
  }


}*/
