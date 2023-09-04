import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:styled_text/styled_text.dart';
import '../NotesList.dart' as nt;
import '../DataBaseMa.dart' as db;

class showTrash extends StatefulWidget {
  var ThemeColors;
  showTrash(this.ThemeColors);
  @override
  _showTrashState createState() => _showTrashState();
}

class _showTrashState extends State<showTrash> {
  List Datas=[];
  int ItemLength = 0;
  int inTrashItemLength=0;
  Map Ids = {};

  @override
  Widget build(BuildContext context) {
    db.ReadNotes().then((value)  {
      inTrashItemLength=0;

      int Counter = 0;
      Ids.clear();

      Datas = value;


      Datas.forEach((element) {

          Ids[Counter] = element["ID"];
          Counter += 1;
          if (element["inTrash"]==1){
            inTrashItemLength++;
          }


      });



      ItemLength = value.length;


      setState((){});

    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
          actions: [
      Expanded(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

        Row(
          children: [
            IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {


                  Navigator.pop(context);
                }),
            Text("Trash",
                style: GoogleFonts.actor(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        inTrashItemLength>0?TextButton(
          onPressed:(){
            deleteAllTrash().whenComplete(() => setState((){}));
          },
          child:Text("Empty",style: GoogleFonts.lato(color:Colors.black,fontSize: 18,fontWeight:FontWeight.bold),),
        ):Visibility(child:Text(""),visible:false),
      ]))],
        ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[

          inTrashItemLength>0?Padding( padding:EdgeInsets.only(left:15),child: Text("$inTrashItemLength Items",style:GoogleFonts.lato(fontWeight: FontWeight.bold,fontSize: 15))):Visibility(child:Text(""),visible: false,),
          Expanded(
            child:inTrashItemLength>0?M1():Center(child:Text("Trash Is Empty",style: GoogleFonts.lato(color:Colors.black54,fontSize:20),))
          )

        ]
      ),
    );
  }

  ListView M1() {


    return ListView.separated(
        physics: BouncingScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 1,
        ),
        padding: const EdgeInsets.only(top: 1),
        itemCount: ItemLength,
        itemBuilder: (BuildContext context, int index) {

          int Id = Ids[index];


            return Datas[index]["inTrash"]==1? Datas[index]["isTodo"] == 0
                ? listItem(Id, index)
                : listItem_todo(Id, index):Visibility(visible:false,child:Text("hidden"));

        });
  }

  GestureDetector listItem_todo(Id, int index) {

    print(Datas[index]);
    List TodosItem = json.decode(Datas[index]["Todos"]);

    Color AvatarColor = DataBaseColorDetector(Datas[index]["AvatarColor"]);

    return GestureDetector(
      onTap: () {
      },
      child: Container(
          child: ListTile(
            subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:TodosItem.length>0? List.generate(TodosItem.length >= 7 ? 7 : TodosItem.length,
                        (secondIndex) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: secondIndex == TodosItem.length - 1 ? 10.0 : 0),
                        child: Row(children: [
                          Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blue,
                              )),
                          SizedBox(width: 5),
                          StyledText(
                            text:
                            "<title>${nt.handleOverFlow(TodosItem[secondIndex]["Title"], 8)}</title>  <description>${nt.handleOverFlow(TodosItem[secondIndex]["Description"], 13)}</description>",
                            tags: {
                              'title': StyledTextTag(
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black)),
                              'description': StyledTextTag(
                                  style: TextStyle(fontSize: 15, color: Colors.black))
                            },
                          ),
                          Visibility(
                            visible: secondIndex == TodosItem.length - 1 ? true : false,
                            child: Expanded(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        Datas[index]['Date'],
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ])),
                          ),
                        ]),
                      );
                    }):[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          Datas[index]['Date'],
                          style: TextStyle(fontSize: 12,),
                        ),
                      ])

                ]),
            title: Row(children: [
              GestureDetector(
                  onTap: () {

                  },
                  child: CircleAvatar(backgroundColor: AvatarColor, radius: 10)),
              SizedBox(width: 5),
              Text(Datas[index]['Title'] == "" ? "Untitled" :nt.handleOverFlow(Datas[index]['Title'],15),
                  ),
              Expanded(
                  child: Row( children: [
                    Visibility(
                      visible: Datas[index]["isAlarmed"] == 1 ? true : false,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text("Alarmed",
                              style: TextStyle(
                                  color: widget.ThemeColors["fabForeGroundColor"],
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                        ),
                        decoration: BoxDecoration(
                            color: widget.ThemeColors["fabBackGroundColor"],
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    Icon(Icons.checklist),

                  ])),

              Expanded(
                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [

                    IconButton(
                      onPressed: () {

                        db.RemoveFromTrash(Id).whenComplete(() => setState((){}));

                      },
                      splashRadius: 15,
                      icon: Icon(Icons.restore,size: 20,
                        color: Colors.black, ),

                    ),

                    IconButton(
                      onPressed: () {

                        db.DeleteItem(Datas[index]["ID"]).whenComplete(() => setState((){}));

                      },
                      splashRadius: 15,
                      icon: Icon(Icons.close,size: 20,
                        color: Colors.black, ),

                    ),

                  ]))
            ]),
          )),
    );
  }

  DataBaseColorDetector(ColorName) {
    switch (ColorName) {
      case "black87":
        return Colors.black87;
      case "darkblue":
        return HexColor("0C4FF1");
      case "orange":
        return Colors.orange;
      case "yellow":
        return Colors.yellow;
      case "red":
        return Colors.red;
      case "green":
        return Colors.green;
    }
  }

  ListTile listItem(Id, index) {


    Color AvatarColor = DataBaseColorDetector(Datas[index]["AvatarColor"]);
    return ListTile(

      onTap: () {

      },
      tileColor: widget.ThemeColors["fabColor"],
      //shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20) ),

      title: Row(children: [
        GestureDetector(
            onTap: () {

            },
            child: CircleAvatar(backgroundColor: AvatarColor, radius: 10)),
        SizedBox(width: 5),
        Text(Datas[index]['Title'] == "" ? "Untitled" : nt.handleOverFlow(Datas[index]['Title'],15),
            ),
        Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [

              IconButton(
                onPressed: () {
                  
                  db.RemoveFromTrash(Id).whenComplete(() => setState((){}));

                },
                splashRadius: 15,
                icon: Icon(Icons.restore,size: 20,
                  color: Colors.black, ),

                ),

              IconButton(
                onPressed: () {

                  db.DeleteItem(Datas[index]["ID"]).whenComplete(() => setState((){}));

                },
                splashRadius: 15,
                icon: Icon(Icons.close,size: 20,
                  color: Colors.black, ),

              ),
              
            ]))
      ]),

      subtitle: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
            width: 175,
            child: Text(
              Datas[index]['NoteBody'].trim(),
              overflow: TextOverflow.ellipsis,

            )),
        Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(
                Datas[index]['Date'],
                style: TextStyle(fontSize: 12),
              ),
            ]))
      ]),
    );
  }
  
  
  Future deleteAllTrash()async{
    Datas.forEach((element) { 
      if(element["inTrash"]==1){
        db.DeleteItem(element["ID"]);
      }
    });
  }
}
