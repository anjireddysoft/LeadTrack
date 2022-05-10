import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lead_track/models/task_model.dart';
import 'package:lead_track/models/usermodel.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class UserTask extends StatefulWidget {
  UserModel userModel;

  UserTask({Key key, this.userModel}) : super(key: key);

  @override
  _UserTaskState createState() => _UserTaskState();
}

class _UserTaskState extends State<UserTask> {
  List<TaskModel> taskList = [];

  getData() {
    FirebaseDatabase.instance
        .reference()
        .child('Tasks')
        .child(widget.userModel.userId)
        .once()
        .then((DataSnapshot snapshot) {
      print("snapshot${snapshot.value}");

      var keys = snapshot.value.keys;
      print("keys${keys}");
      var values = snapshot.value;
      print("values${values}");
      for (String key in keys) {
        print("key $key");
        TaskModel data = TaskModel(
            date: values[key]['date'],
            logInTime: values[key]['logInTime'],
            logOutTime: values[key]['logOutTime'],
            task: values[key]['tasks']);
        print("taskListDate${data.date}");
        setState(() {
          taskList.add(data);
          taskList.sort((a, b) {
            var adate = a.date; //before -> var adate = a.date;
            var bdate = b.date; //before -> var bdate = b.date;
            return bdate.compareTo(
                adate); //to get the order other way just switch `adate & bdate`
          });
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    // createPDF(widget.userModel.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.userModel.name),
        actions: [
          Center(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                createPDF(widget.userModel.name);
              },
              child: Text(
                "Download",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ))
        ],
      ),
      body: taskList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                //    reverse: true,
                    itemCount: taskList.length,
                    itemBuilder: (context, index) {
                      // print("tasklength${taskList[index].task.length}");
                      return Container(
                        child: Card(
                          elevation: 5,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Date : ${taskList[index].date}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      " ${taskList[index].logInTime}-${taskList[index].logOutTime}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      //  reverse: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: taskList[index].task.length,
                                      itemBuilder: (context, ind) {
                                        return Column(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.arrow_forward),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                        "${taskList[index].task[ind]}")),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        );
                                      }),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
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
    header.cells[0].value = 'Date';
    header.cells[1].value = 'User';
    header.cells[2].value = 'task';
    header.cells[3].value = 'hours';

    PdfGridRow row = grid.rows.add();
    /*row.cells[0].value = '1';
    row.cells[1].value = 'Arya';
    row.cells[2].value = "lzsgf";
    row.cells[3].value = '6';*/
    for (var i = 0; i <= taskList.length - 1; i++) {
      print("number is${i}");
      row = grid.rows.add();
      row.cells[0].value = '${taskList[i].date}';
      row.cells[1].value = '${name}';

      row.cells[2].value = "${taskList[i].task.join(",\n-")}";
      row.cells[3].value = '${taskList[i].logInTime}-${taskList[i].logOutTime}';
      //

    }

    // row = grid.rows.add();
    // row.cells[0].value = '3';
    // row.cells[1].value = 'Tony';
    // row.cells[2].value = '8';

    grid.draw(
        page: document.pages.add(),
        bounds: const Rect.fromLTWH(0, 100, 440, 550));

    List<int> bytes = document.save();
    document.dispose();

    saveAndLaunchFile(bytes, '${name}.pdf');
  }

  saveAndLaunchFile(bytes, String pdfName) async {
    Directory directory = (await getApplicationDocumentsDirectory());
//Get directory path
    String path = directory.path;
//Create an empty file to write PDF data
    File file = File('$path/$pdfName');
//Write PDF data
    await file.writeAsBytes(bytes, flush: true).whenComplete(() {
      showSnackBar("$pdfName downloaded Successfully");
    });
//Open the PDF document in mobile
    OpenFile.open('$path/$pdfName');
  }

  showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(message)));
  }
}
