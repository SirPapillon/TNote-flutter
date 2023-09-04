import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../DataBaseMa.dart';
import 'dart:convert';
import 'package:custom_check_box/custom_check_box.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:styled_text/styled_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../NotesList.dart';
import 'Map.dart';

class TodoManager extends StatefulWidget {
  int id;

  TodoManager([this.id = -1]);

  @override
  _TodoManagerState createState() => _TodoManagerState();
}

class _TodoManagerState extends State<TodoManager> {
  List TodosList = [];

  final _task_title_controller = TextEditingController();
  bool ensure_init = false;

  int isFavorite=0;

  initialize_db_todos() {
    if (widget.id != -1 && TodosList.length == 0) {
      if (ensure_init == true) return;
      ReadNotes().then((value) {

        value.forEach((data) {

          if (data["ID"] == widget.id) {
            isFavorite=data["isFavorite"];

            List TodosItem = json.decode(data["Todos"]);
            TodosItem.forEach((todo) {
              if (!TodosList.contains(todo)) {
                TodosList.add(todo);
              }
            });
            _task_title_controller.text = data["Title"];
          }
        });
      }).whenComplete(() {
        ensure_init = true;
        setState(() {});
      });
    } else {}
  }

  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    initialize_db_todos();

    return Scaffold(
      backgroundColor: HexColor("FFFAF0"),
      appBar:
          AppBar(backgroundColor: Colors.transparent, elevation: 0, actions: [
        Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                UpdateInDataBase();

                Navigator.pop(context);
              }),
          Text("Checklist",
              style: GoogleFonts.actor(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ])),
        PopupMenuButton<int>(
          onSelected: (indexS) {
            switch (indexS) {
              case 0:
                String shareContent="";
                int todoCounter=1;
                if(_task_title_controller.text.trim().length!=0){
                  shareContent+=_task_title_controller.text+'\n';
                }
                TodosList.forEach((todo){
                  if (todo["Title"].trim().length!=0){
                    if (todo["Description"].trim().length==0){
                      shareContent+="$todoCounter- ${todo["Title"]}\n";
                    }
                    else{
                      shareContent+="$todoCounter- ${todo["Title"]} : ${todo["Description"]}\n";
                    }
                  }

                  else if (todo["Description"].trim()!=0){
                    shareContent+="$todoCounter- ${todo["Description"]}\n";

                  }

                  else{
                    todoCounter--;
                  }

                  todoCounter++;
                });
                Share.share(shareContent);
                break;
              case 1:
                if (isFavorite == 1) {
                  RemoveFromFavorites(widget.id);
                  isFavorite = 0;
                } else {
                  AddToFavorites(widget.id);
                  isFavorite = 1;
                }
                break;

              case 2:
                MoveToTrash(widget.id).whenComplete(() => Navigator.pop(context));
                break;
            }
          },
          icon: Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
          color: HexColor("FFFAF0"),
          elevation: 4,
          itemBuilder: (context) => [
            PopupMenuItem<int>(
                value: 0,
                child: Row(children: [
                  Icon(Icons.share_outlined, color: Colors.black),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Share'),
                ])),
            PopupMenuItem<int>(
                value: 1,
                child: Row(children: [
                  Icon(isFavorite==0?Icons.favorite_border:Icons.favorite, color: Colors.black),
                  SizedBox(
                    width: 5,
                  ),
                  Text(isFavorite==0?
                    'Add to Favorite':"Remove Favorite",
                  ),
                ])),
            PopupMenuItem<int>(
                value: 2,
                child: Row(children: [
                  Icon(Icons.delete_outline, color: Colors.black),
                  SizedBox(width: 5),
                  Text('Delete'),
                ])),
          ],
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Scrollbar(
            radius: Radius.circular(30),
            thickness: 7,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(                          keyboardType: TextInputType.visiblePassword,

                  controller: _task_title_controller,
                  style: GoogleFonts.actor(
                      fontSize: 23, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      prefixText: "- ",
                      hintText: "Task title",
                      border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 20,
                child: Divider(height: 1, color: Colors.black54),
              ),
              Expanded(child: AllTodos()),
              _AddB()
            ])),
      ),
    );
  }

  AddTodos(Title, Description, bool isChecked, date) {
    setState(() {
      Map Template = {
        "Title": Title,
        "Description": Description,
        "isChecked": isChecked,
        "Map_Description": null,
        "Map_Description_isChanged": false,
        "Date": date.toString(),
        "location": null
      };

      TodosList.add(Template);
    });
  }

  UpdateTodos(index, Title, Description, bool isChecked, date) {
    setState(() {
      Map Template = {
        "Title": Title,
        "Description": Description,
        "isChecked": isChecked,
        "Date": date.toString(),
        "Map_Description":
            TodosList[index]["Map_Description_isChanged"] == false
                ? Description
                : TodosList[index]["Map_Description"]
      };
      Template.forEach((key, value) {
        TodosList[index][key] = value;
      });
    });
    print(TodosList[index]);
  }

  ListView AllTodos() {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: TodosList.length,
        itemBuilder: (BuildContext context, index) {
          return PartTodos(index);
        });
  }

  GestureDetector PartTodos(index) {
    return GestureDetector(
      key: Key(index.toString()),
      onTap: () {
        PopupForTodosInfo(index);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Card(
          elevation: 0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              height: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomCheckBox(
                        value: TodosList[index]["isChecked"],
                        checkedIcon: Icons.check,
                        borderColor: Colors.black54,
                        checkedFillColor: Colors.black,
                        borderRadius: 2,
                        tooltip: "activity done",
                        checkBoxSize: 15,
                        onChanged: (val) {
                          TodosList[index]["isChecked"] = val;
                          setState(() {});
                        },
                      ),
//                      Text(
//                        "${index + 1} : ",
//                        style: GoogleFonts.actor(
//                            fontSize: 23, fontWeight: FontWeight.bold),
//                      ),
                      Text(
                        "${handleOverFlow(TodosList[index]["Title"],15)}",
                        style: GoogleFonts.actor(
                          fontSize: 20,
                        ),
                      ),
                      Expanded(
                          child: Align(
                        alignment: Alignment.topRight,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(Icons.map_outlined),
                                  onPressed: () {
                                    TodosList.forEach((element) {
                                      element["Map_Description"] == null
                                          ? element["Map_Description"] =
                                              element["Description"]
                                          : element["Map_Description"] =
                                              element["Map_Description"];
                                    });

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => showMap(
                                                widget.id,
                                                false,
                                                TodosList,
                                                index))).then((value) {
                                      TodosList = value;

                                      setState(() {});
                                    });
                                  }),
                              IconButton(
                                  splashRadius: 17,
                                  onPressed: () {
                                    DeleteFromTodos(index);
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.black,
                                  )),
                            ]),
                      ))
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            flex: 1,
                            child: Tooltip(
                              message: TodosList[index]["Description"],
                              child: Text(
                                "${TodosList[index]["Description"].toString().replaceAll("\n", "")}",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.actor(
                                    color: Colors.black54,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),

                        Flexible(
                          flex: 1,
                          child: StyledText(
                            text: TodosList[index]["Date"] == "null"
                                ? ""
                                : "<date>${TodosList[index]["Date"].split(" ")[0]}</date> <seprator>|</seprator> <time>${TodosList[index]["Date"].split(" ")[1].split(":")[0]}:${TodosList[index]["Date"].split(" ")[1].split(":")[1]}</time>  <icon_clock/>",
                            tags: {
                              "date": StyledTextTag(style: GoogleFonts.lato()),
                              "seprator": StyledTextTag(
                                  style: GoogleFonts.lato(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              'icon_clock': StyledTextIconTag(
                                  FontAwesomeIcons.clock,
                                  size: 19,
                                  color: Colors.black),
                              'time': StyledTextTag(style: GoogleFonts.lato())
                            },
                          ),
                        ),
//                        Text(
//
//                          style: GoogleFonts.lato(
//                              color: Colors.black54,
//                              fontSize: 12,
//                              fontWeight: FontWeight.bold),
//                        ),
                      ])
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  DeleteFromTodos(index) {
    setState(() {
      TodosList.removeAt(index);
    });
  }

  Future PopupForTodosInfo([index]) {
    final TodoTitleController = TextEditingController(),
        TodoDescriptionController = TextEditingController();

    var new_task_date_str;
    var new_task_date;

    if (index != null) {
      TodoDescriptionController.text = TodosList[index]["Description"];
      TodoTitleController.text = TodosList[index]["Title"];

      if (TodosList[index]["Date"] != "null") {
        new_task_date_str = TodosList[index]["Date"];
        new_task_date =
            new DateFormat("yyyy-MM-dd hh:mm:ss").parse(new_task_date_str);
      } else
        new_task_date = null;
    } else
      new_task_date = null;

    return showDialog(
        context: context,
        builder: (context) {
          return ValueListenableBuilder(
              valueListenable: _counter,
              builder: (context, value, child) {
                return AlertDialog(
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("New task", style: GoogleFonts.lato()),
                        Row(children: [
                          new_task_date == null
                              ? IconButton(
                                  padding: EdgeInsets.zero,
                                  splashRadius: 15,
                                  icon: Icon(Icons.date_range),
                                  onPressed: () {
                                    DatePicker.showDateTimePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime.now(),
                                        onConfirm: (date) {
                                      new_task_date = date;
                                      _counter.value += 1;
                                    },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.en);
                                  })
                              : Row(children: [
                                  TextButton(
                                      onPressed: () {
                                        DatePicker.showDateTimePicker(context,
                                            onCancel: () {
                                              new_task_date = null;
                                              _counter.value += 1;
                                            },
                                            showTitleActions: true,
                                            minTime: DateTime.now(),
                                            onConfirm: (date) {
                                              new_task_date = date;
                                              _counter.value += 1;
                                            },
                                            currentTime: new_task_date,
                                            locale: LocaleType.en);
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateColor.resolveWith(
                                                  (states) => Colors.black54)),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              new_task_date
                                                  .toString()
                                                  .split(" ")[0],
                                              style: GoogleFonts.lato(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            ),
                                            Text(
                                              new_task_date
                                                      .toString()
                                                      .split(" ")[1]
                                                      .split(":")[0] +
                                                  ":" +
                                                  new_task_date
                                                      .toString()
                                                      .split(" ")[1]
                                                      .split(":")[1],
                                              style: GoogleFonts.lato(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            ),
                                          ])),
                                ]),
                          SizedBox(width: 5),
                        ]),
                      ]),
                  titlePadding: EdgeInsets.only(
                    top: 8,
                    left: 8,
                    bottom: 8,
                  ),
                  contentPadding: EdgeInsets.zero,
                  elevation: 0,
                  content: SingleChildScrollView(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        TextField(
                          keyboardType: TextInputType.visiblePassword,

                          onChanged: (c) {},
                          maxLength: 30,
                          controller: TodoTitleController,
                          style: GoogleFonts.lato(fontSize: 16),
                          decoration: InputDecoration(
                              hintText: "Title", counterText: ""),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          maxLines: 5,
                          controller: TodoDescriptionController,
                          style: GoogleFonts.lato(fontSize: 16),
                          decoration: InputDecoration(hintText: "Description"),
                        ),
                        SizedBox(height: 15),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: TextButton(
                                  child: Text(
                                    "Cancel",
                                    style: GoogleFonts.lato(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    index == null
                                        ? AddTodos(
                                            TodoTitleController.text,
                                            TodoDescriptionController.text,
                                            false,
                                            new_task_date)
                                        : UpdateTodos(
                                            index,
                                            TodoTitleController.text,
                                            TodoDescriptionController.text,
                                            false,
                                            new_task_date);
                                    Navigator.pop(context);
                                    TodoTitleController.text = "";
                                    TodoDescriptionController.text = "";
                                  },
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: TextButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.black)),
                                  child: Text(
                                    "Add",
                                    style: GoogleFonts.lato(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    if (index == null) {
                                      AddTodos(
                                          TodoTitleController.text,
                                          TodoDescriptionController.text,
                                          false,
                                          new_task_date);
                                    } else {
                                      UpdateTodos(
                                          index,
                                          TodoTitleController.text,
                                          TodoDescriptionController.text,
                                          false,
                                          new_task_date);
                                    }

                                    UpdateInDataBase();
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ])
                      ],
                    ),
                  )),
                );
              });
        });
  }

  Future UpdateInDataBase() async {
    String tds = json.encode(TodosList);
    SaveChanges("", _task_title_controller.text, widget.id, "", tds);
  }

  Future SaveTodos() async {
    String tds = json.encode(TodosList);

    SaveNote("", _task_title_controller.text, "", 1, tds);
  }

  Padding _AddB() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
              color: HexColor("00000d"),
              borderRadius: BorderRadius.circular(5)),
          width: double.infinity,
          child: TextButton(
            child: Text("Add",
                style: GoogleFonts.actor(color: Colors.white, fontSize: 18)),
            onPressed: () {
              PopupForTodosInfo();
            },
          )),
    );
  }
}
