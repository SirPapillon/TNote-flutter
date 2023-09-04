
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geocoder/geocoder.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:styled_text/styled_text.dart';
import '../NotesList.dart' as nt;


Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

class showMap extends StatefulWidget {
  int id;
  bool update;
  var TodosList;
  var index;

  showMap(this.id,
      [this.update = false, this.TodosList = null, this.index = null]);

  @override
  _showMapState createState() => _showMapState();
}

class _showMapState extends State<showMap> {
  LatLng centerLocation = LatLng(35.68, 70.41);
  Map allLocations = {"markedLocations": []};

  static LatLng london = LatLng(51.5, -0.09);
  late double searchZoom;

  double _height = 0;

  late final MapController mapController;
  double rotation = 0.0;

  void animateMarkedLocationsListContainer(double height) {
    setState(() {
      _height = height;
    });
  }

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  Map tCordination = {"markedLocation": null};

  @override
  Widget build(BuildContext context) {
//    if (allLocations["markedLocations"].length == 0) {

    allLocations["markedLocations"].clear();

    widget.TodosList.forEach((value) {
      if (value["location"] != null) {
        try {
          var latitude = value["location"]["cordination"]["latitude"];

          var longitude = value["location"]["cordination"]["longitude"];

          LatLng latLngLoc = LatLng(latitude, longitude);

          value["location"]["cordination"] = latLngLoc;
        } catch (e) {}

        allLocations["markedLocations"].add(value["location"]);
      } else {
        allLocations["markedLocations"].add(null);
      }
    });

    if (widget.TodosList[widget.index]["location"] != null &&
        tCordination["markedLocation"] == null) {
      tCordination["markedLocation"] = {};
      widget.TodosList[widget.index]["location"].forEach((key, value) {
        tCordination["markedLocation"][key] = value;

      });
      tCordination["markedLocation"]["Map_Description"]=widget.TodosList[widget.index]["Map_Description"];
      tCordination["markedLocation"]["Description"]=widget.TodosList[widget.index]["Description"];
      tCordination["markedLocation"]["Map_Description_isChanged"]=widget.TodosList[widget.index]["Map_Description_isChanged"];


      allLocations["markedLocations"].forEach((value) {
        if (value != null) {
          if (value["cordination"] ==
              widget.TodosList[widget.index]["location"]["cordination"]) {
            value["cordination"] = null;
          }
        }
      });
    }
    return WillPopScope(
        onWillPop: () async {
          if (tCordination["markedLocation"] != null) {
            widget.TodosList[widget.index]["location"] =
            tCordination["markedLocation"];

            tCordination["markedLocation"].forEach((key,value){
              if (widget.TodosList[widget.index].containsKey(key)){
                widget.TodosList[widget.index][key]=value;
              }
            });


          }

          widget.TodosList.forEach((value) {
            if (value["location"] != null) {
              value["location"]["cordination"] = {
                "latitude":
                value["location"]["cordination"].latitude,
                "longitude":
                value["location"]["cordination"].longitude
              };
            }
          });

          Navigator.pop(context, widget.TodosList);
          return false;
        },
      child: Scaffold(
        body: Stack(children: [
          FlutterMap(
            mapController: mapController,
            layers: [
//            TileLayerOptions(
//              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//              subdomains: ['a', 'b', 'c'],
//            ),
              TileLayerOptions(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/arshiayp/ckzwso91s000914muy0yt4af8/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYXJzaGlheXAiLCJhIjoiY2t6d3JyYmprMDJ2MDJ2cDdudTJoZW5qZyJ9.LDd94llzEXYs38GmznjmKQ",
                  subdomains: [
                    'a',
                    'b',
                    'c'
                  ],
                  additionalOptions: {
                    "accessToken":
                        "pk.eyJ1IjoiYXJzaGlheXAiLCJhIjoiY2t6d3JyYmprMDJ2MDJ2cDdudTJoZW5qZyJ9.LDd94llzEXYs38GmznjmKQ",
                    "id": "mapbox.satellite"
                  }),

              MarkerLayerOptions(
                  markers: List.generate(
                      tCordination["markedLocation"] != null ? 1 : 0, (index) {
                return Marker(
                  width: 45.0,
                  height: 45.0,
                  point: tCordination["markedLocation"]["cordination"],
                  builder: (context) => Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.yellow,
                      ),
                      onPressed: () {},
                    ),
                  ),
                );
              })),
              MarkerLayerOptions(
                  markers: List.generate(
                      allLocations.containsKey("user_location") ? 1 : 0, (index) {
                return Marker(
                  point: allLocations["user_location"]["cordination"],
                  width: 50.0,
                  height: 50.0,
                  builder: (context) => Container(
                    height: 5,
                    width: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              spreadRadius: -6)
                        ]),
                    child: IconButton(
                      tooltip: "your current location",
                      icon: Icon(
                        Icons.my_location,
                        color: Colors.blue,
                      ),
                      onPressed: () {},
                    ),
                  ),
                );
              })),
              MarkerLayerOptions(
                  markers: List.generate(allLocations["markedLocations"].length,
                      (index) {
                if (allLocations["markedLocations"][index] != null) {
                  if (allLocations["markedLocations"][index]["isSelected"] ==
                      true) {
                    return Marker(
                        width: 145.0,
                        height: 130.0,
                        point: allLocations["markedLocations"][index]
                            ["cordination"],
                        builder: (context) => Container(
                            height: 300,
                            width: 200,
                            child: Stack(children: [
                              Center(
                                child: IconButton(
                                    icon: Icon(
                                      Icons.location_on,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () {}),
                              ),
                              Positioned(
                                  top: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: EdgeInsets.all(5),
                                    child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    CircleAvatar(
                                                      child: IconButton(
                                                        padding: EdgeInsets.zero,
                                                        icon: Icon(Icons.close,
                                                            color: Colors.white,
                                                            size: 15),
                                                        onPressed: () {
                                                          widget.TodosList[index]
                                                              ["location"] = null;
                                                          allLocations[
                                                                  "markedLocations"]
                                                              .removeAt(index);
                                                          setState(() {});
                                                        },
                                                      ),
                                                      radius: 12,
                                                      backgroundColor: Colors.red,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .black26,
                                                                spreadRadius: 0.1,
                                                                blurRadius: 5,
                                                                offset:
                                                                    Offset(0, 2))
                                                          ]),
                                                      child: CircleAvatar(
                                                        child: IconButton(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          icon: Icon(
                                                              Icons.edit_outlined,
                                                              color: Colors.black,
                                                              size: 15),
                                                          onPressed: () {
                                                            showEditDialog(index);
                                                          },
                                                        ),
                                                        radius: 12,
                                                        backgroundColor:
                                                            Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    GestureDetector(
                                                      onTap: () {
                                                       if (tCordination["markedLocation"]!=null) {
                                                         widget.TodosList[
                                                         widget.index]
                                                         ["location"] =
                                                         tCordination[
                                                         "markedLocation"];

                                                         widget.TodosList[widget
                                                             .index]["Map_Description"] =
                                                         tCordination["markedLocation"]["Map_Description"];
                                                         widget.TodosList[widget
                                                             .index]["Description"] =
                                                         tCordination["markedLocation"]["Description"];
                                                         widget.TodosList[widget
                                                             .index]["Map_Description_isChanged"] =
                                                         tCordination["markedLocation"]["Map_Description_isChanged"];
                                                         widget.TodosList[widget
                                                             .index]["information_loaded"] =
                                                         tCordination["markedLocation"]["information_loaded"];
                                                       }
                                                        tCordination[
                                                                "markedLocation"] =
                                                            null;

                                                        allLocations[
                                                                    "markedLocations"]
                                                                [index][
                                                            "isSelected"] = false;

                                                        widget.index = index;

//                                                      if(tCordination["markedLocation"]!=null) {
//
//                                                      }

                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .black26,
                                                                  spreadRadius:
                                                                      0.1,
                                                                  blurRadius: 5,
                                                                  offset: Offset(
                                                                      0, 2))
                                                            ]),
                                                        child: CircleAvatar(
                                                          child: FittedBox(
                                                            fit: BoxFit.cover,
                                                            child: Image.asset(
                                                              "images/all-directions.png",
                                                              color: Colors.black,
                                                              scale: 25,
                                                            ),
                                                          ),
                                                          radius: 12,
                                                          backgroundColor:
                                                              Colors.white,
                                                        ),
                                                      ),
                                                    ),
//                                                    SizedBox(width: 10),
//                                                    Container(
//                                                      decoration: BoxDecoration(
//                                                          borderRadius:
//                                                              BorderRadius
//                                                                  .circular(10),
//                                                          boxShadow: [
//                                                            BoxShadow(
//                                                                color: Colors
//                                                                    .black26,
//                                                                spreadRadius: 0.1,
//                                                                blurRadius: 5,
//                                                                offset:
//                                                                    Offset(0, 2))
//                                                          ]),
//                                                      child: CircleAvatar(
//                                                        child: IconButton(
//                                                          padding:
//                                                              EdgeInsets.zero,
//                                                          icon: Icon(
//                                                              Icons.info_outline,
//                                                              color: Colors.black,
//                                                              size: 15),
//                                                          onPressed: () {
//
//                                                            showLocationsDetailDialog(
//                                                                index);
//                                                          },
//                                                        ),
//                                                        radius: 12,
//                                                        backgroundColor:
//                                                            Colors.white,
//                                                      ),
//                                                    ),
                                                  ])
                                            ])),
                                  ))
                            ])));
                  } else {
                    return Marker(
                      width: 45.0,
                      height: 45.0,
                      point: allLocations["markedLocations"][index]
                          ["cordination"],
                      builder: (context) => Container(
                        child: IconButton(
                          icon: Icon(
                            Icons.location_on,
                            color: Colors.red,
                          ),
                          onPressed: () {
//                      allLocations["markedLocations"].removeAt(index);
                            if (allLocations["markedLocations"][index] != null) {
                              if (allLocations["markedLocations"][index]
                                      ["isSelected"] ==
                                  false) {
                                allLocations["markedLocations"].forEach((value) {
                                  if (value != null) {
                                    value["isSelected"] = false;
                                  }
                                });

                                allLocations["markedLocations"][index]
                                    ["isSelected"] = true;
                              } else {
                                allLocations["markedLocations"][index]
                                    ["isSelected"] = false;
                              }
                            }

                            setState(() {});
                          },
                        ),
                      ),
                    );
                  }
                } else {
                  return Marker();
                }
              })),
            ],
            options: MapOptions(
              interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              center: centerLocation,
              maxZoom: 18,
              onTap: (markedLocation) async {
                tCordination["markedLocation"] = {
                  "Map_Description":widget.TodosList[widget.index]["Map_Description"],
                  "Map_Description_isChanged":widget.TodosList[widget.index]["Map_Description_isChanged"],
                  "Description":widget.TodosList[widget.index]["Description"],
                  "information_loaded": false,
                  "cordination": markedLocation,
                  "isSelected": false
                };
                setState(() {});
              },
            ),
          ),


          Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                  padding: EdgeInsets.only(right: 15, bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: Offset(1, 3))
                        ]),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 20,
                      child: CircleAvatar(
                          radius: 19.5,
                          backgroundColor: Colors.blue,
                          child: Align(
                            alignment: Alignment.center,
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.my_location_sharp,
                                    size: 25, color: Colors.white),
                                onPressed: () {
                                  _determinePosition().then((userPos) {
                                    LatLng userPosLatLng = LatLng(
                                        userPos.latitude, userPos.longitude);
                                    mapController.move(userPosLatLng, 15);

                                    allLocations["user_location"] = {
                                      "cordination": userPosLatLng,
                                      "used": false,
                                    };
                                    setState(() {});
                                  });
                                }),
                          )),
                    ),
                  ))),

          Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                  padding: EdgeInsets.only(left: 15, bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: Offset(1, 3))
                        ]),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: CircleAvatar(
                          radius: 19.5,
                          backgroundColor: Colors.white,
                          child: Align(
                            alignment: Alignment.center,
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.list,
                                    size: 25, color: Colors.black87),
                                onPressed: () {
                                  animateMarkedLocationsListContainer(400);
                                }),
                          )),
                    ),
                  ))),

          Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  width: double.infinity,
                  height: _height,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: GestureDetector(
                          onTap: () {
                            animateMarkedLocationsListContainer(0);
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.black,
                            child: CircleAvatar(
                              radius: 19,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.arrow_drop_down,
                                  color: Colors.black, size: 35),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            tCordination["markedLocation"]!=null?
                            Padding(
                              padding:  EdgeInsets.only(left:5.0,top:20,),
                              child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
                              GestureDetector(
                                onTap:(){
                                  mapController.move(
                                      tCordination["markedLocation"]
                                      ["cordination"],
                                      15);
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on,color:Colors.yellow),
                                    Text(
                                        nt.handleOverFlow(tCordination["markedLocation"]["Map_Description"]
                                            ,
                                            25),
                                        style: GoogleFonts.lato(
                                            fontSize: 22)),
                                  ],
                                ),
                              ),

                              Row(
                                children:[

                                  GestureDetector(
                                    onTap:(){
                                      print(tCordination);
                                      showEditDialog(-1)
                                          .whenComplete(() =>
                                          setState(() {}));
                                    },
                                    child:Icon(Icons.edit_outlined)
                                  ),
                                  SizedBox(width: 10),

//                                GestureDetector(
//                                  onTap:(){
//
//                                  print(allLocations);
//                                  print(tCordination);
//
//                                  if (tCordination[
//                                  "markedLocation"][
//                                  "information_loaded"] ==
//                                      false) {
//                                    findLocationNameByCords(
//                                        tCordination[
//                                        "markedLocation"]
//                                        ["cordination"])
//                                        .then((location) {
//                                      print("Here");
//
//                                      switch (location) {
//                                        case false:
//                                          break;
//
//                                        case "ConnectionError":
//                                          break;
//                                        case "NotFound":
//                                          break;
//
//                                        default:
//                                          tCordination[
//                                          "markedLocation"] = {
//                                            "information_loaded":
//                                            true,
//                                            "address": location
//                                                .addressLine,
//                                            "province": location
//                                                .adminArea,
//                                            "city": location
//                                                .locality,
//                                            "district": location
//                                                .featureName,
//                                            "country": location
//                                                .countryName,
//                                            "isSelected": false
//                                          };
//
//                                          break;
//                                      }
//                                    }).whenComplete(() {
//                                      showLocationsDetailDialog(
//                                          -1);
//                                    });
//                                  }
//                                  else{
//                                    showLocationsDetailDialog(
//                                        -1);
//                                  }
//
//                                  },
//                                  child:Icon(Icons.info_outline)
//                                ),
 SizedBox(width: 10),


                                ]
                              )
                              ]),

                            ):Visibility(visible:false ,child:Text("hidden statement")),
                            Expanded(
                              child: ListView.separated(
                                  physics: BouncingScrollPhysics(),
                                  separatorBuilder: (BuildContext context, int index) =>
                                      Divider(
                                        height: 1,
                                      ),
                                  itemCount: allLocations["markedLocations"].length,
                                  itemBuilder: (BuildContext context, int index) {
                                    List markedLocations =
                                        allLocations["markedLocations"];
                                    if (allLocations["markedLocations"][index] !=
                                        null &&allLocations["markedLocations"][index]["cordination"]!=null ) {
                                      return Container(
                                        padding: EdgeInsets.only(
                                            left: 20,
                                            right: 10,
                                            top: index == 0 ? 0 : 20),
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              GestureDetector(

                                                  child: Row(children: [
                                                    Icon(Icons.location_on,color:Colors.red),
                                                    Text(
                                                        nt.handleOverFlow(
                                                            widget.TodosList[index]
                                                                ["Map_Description"],
                                                            25),
                                                        style: GoogleFonts.lato(
                                                            fontSize: 18)),
                                                  ]),
                                                  onTap: () {

                                                    print(markedLocations);
                                                    print(tCordination);
                                                    mapController.move(
                                                        markedLocations[index]
                                                            ["cordination"],
                                                        15);
                                                  }),
                                              Expanded(
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                    GestureDetector(
                                                        child:
                                                            Icon(Icons.edit_outlined),
                                                        onTap: () {
                                                          showEditDialog(index)
                                                              .whenComplete(() =>
                                                                  setState(() {}));
                                                        }),
                                                    SizedBox(width: 10),
                                                    GestureDetector(
                                                        child: Icon(Icons.info_outline),
                                                        onTap: () {


                                                          if (allLocations[
                                                                          "markedLocations"]
                                                                      [index][
                                                                  "information_loaded"] ==
                                                              false) {
                                                            findLocationNameByCords(
                                                                    allLocations[
                                                                                "markedLocations"]
                                                                            [index]
                                                                        ["cordination"])
                                                                .then((location) {

                                                              switch (location) {
                                                                case false:
                                                                  break;

                                                                case "ConnectionError":
                                                                  break;
                                                                case "NotFound":
                                                                  break;

                                                                default:
                                                                  allLocations[
                                                                          "markedLocations"]
                                                                      [index]["locationsInfo"] = {
                                                                    "information_loaded":
                                                                        true,
                                                                    "address": location
                                                                        .addressLine,
                                                                    "province": location
                                                                        .adminArea,
                                                                    "city": location
                                                                        .locality,
                                                                    "district": location
                                                                        .featureName,
                                                                    "country": location
                                                                        .countryName,
                                                                    "isSelected": false
                                                                  };

                                                                  break;
                                                              }
                                                            }).whenComplete(() {
                                                              showLocationsDetailDialog(
                                                                  index);
                                                            });
                                                          }
                                                          else{
                                                            showLocationsDetailDialog(
                                                                index);
                                                          }
                                                        })
                                                  ])),
                                            ]),
                                      );
                                    } else {
                                      return Visibility(
                                          visible: false,
                                          child: Text("hidden statment"));
                                    }
                                  }),
                            ),
                          ],
                        ),
                      )
                    ],
                  ))),
          Align(
              alignment: Alignment.topCenter,
              child: Container(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  margin: EdgeInsets.only(left: 10, right: 10, top: 40),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(children: [
                    GestureDetector(
                        onTap: () {

                          if (tCordination["markedLocation"] != null) {
                            widget.TodosList[widget.index]["location"] =
                                tCordination["markedLocation"];

                            tCordination["markedLocation"].forEach((key,value){
                              if (widget.TodosList[widget.index].containsKey(key)){
                                widget.TodosList[widget.index][key]=value;
                              }
                            });


                          }

                          widget.TodosList.forEach((value) {
                            if (value["location"] != null) {
                              value["location"]["cordination"] = {
                                "latitude":
                                    value["location"]["cordination"].latitude,
                                "longitude":
                                    value["location"]["cordination"].longitude
                              };
                            }
                          });

                          Navigator.pop(context, widget.TodosList);
                        },
                        child: Icon(Icons.arrow_back)),
                    SizedBox(width: 10),
                    Expanded(
                        child: TextField(                          keyboardType: TextInputType.visiblePassword,

                          style: GoogleFonts.lato(),
                      onSubmitted: (query) {
                        findLocationCordByAddress(query).then((cord) {
                          switch (cord) {
                            case false:
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("unknown error"),
                              ));
                              break;

                            case "ConnectionError":
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "error occured , check your network connection"),
                              ));
                              break;
                            case "NotFound":
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("entered place not found"),
                              ));
                              break;

                            default:
                              mapController.move(cord, searchZoom);
                              break;
                          }
                        });
                      },
                      decoration: InputDecoration(
                          hintText: "Search a location",
                          border: InputBorder.none,
                          suffixIcon: Icon(Icons.search, color: Colors.black)),
                    ))
                  ]))),
        ]),
      ),
    );
  }

  Future findLocationNameByCords(LatLng cordination) async {
    try {
      final coordinates =
          new Coordinates(cordination.latitude, cordination.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;

      return first;
    } catch (e) {
      if (e.toString().contains("available")) {
        return "NotFound";
      } else if (!e.toString().contains("available")) {
        return "ConnectionError";
      } else {
        return false;
      }
    }
  }

  Future findLocationCordByAddress(String query) async {
    try {
      var addresses = await Geocoder.local.findAddressesFromQuery(query);
      var first = addresses.first;

      if (first.countryName == first.featureName) {
        searchZoom = 5;
      } else {
        searchZoom = 10;
      }
      return LatLng(first.coordinates.latitude, first.coordinates.longitude);
      //PlatformException(not_available, Empty, null, null) placce no
      //PlatformException(failed, Failed, null, null)
    } catch (e) {
      if (e.toString().contains("available")) {
        return "NotFound";
      } else if (!e.toString().contains("available")) {
        return "ConnectionError";
      } else {
        return false;
      }
    }
  }

  Future showEditDialog(int index) async {
    final editController = TextEditingController();
    editController.text =index!=-1? widget.TodosList[index]["Map_Description"]:tCordination["markedLocation"]["Map_Description"];
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              titlePadding: EdgeInsets.only(left: 10, top: 10, right: 10),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Edit", style: GoogleFonts.lato()),
                    GestureDetector(
                        onTap: () {
                          if (index==-1){

                            editController.text =
                            tCordination["markedLocation"]["Description"];
                          }
                          else {
                            widget
                                .TodosList[index]["Map_Description_isChanged"] =
                            false;

                            editController.text =
                            widget.TodosList[index]["Description"];
                          }
                        },
                        child: Icon(Icons.sync))
                  ]),
              contentPadding: EdgeInsets.only(left: 10, top: 10, right: 10),
              content: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                          controller: editController,
                          maxLines: 5,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(),
                              ),
                              hintStyle: GoogleFonts.lato(),
                              labelText: "What do you want to do here ?",
                              labelStyle: GoogleFonts.lato())),
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
                                  Navigator.pop(context);
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
                                  "Save",
                                  style: GoogleFonts.lato(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  if(index==-1){
                                    tCordination["markedLocation"]["Map_Description"]=  editController.text;
                                    tCordination["markedLocation"]["Map_Description_isChanged"] =
                                    false;

                                  }
                                  else {

                                    widget.TodosList[index]["Map_Description"] =
                                        editController.text;
                                    widget.TodosList[index]
                                    ["Map_Description_isChanged"] = true;
                                  }

                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ])
                    ]
//              children:[
//
//                StyledText(
//                    text:"<country_title>country</country_title> : <country> ${markedLocations[index]["locationInfos"]["country"]} </country> ",
//                    tags:{
//                      "country_title":StyledTextTag(
//                          style: GoogleFonts.lato(
//                              fontWeight: FontWeight.bold)),
//                      "country":StyledTextTag(
//                          style: GoogleFonts.lato(
//                          )),
//                    }
//                ),
//                StyledText(
//                  text:"<province_title>province</province_title> : <province> ${markedLocations[index]["locationInfos"]["province"]} </province> ",
//                  tags:{
//                    "province_title":StyledTextTag(
//                        style: GoogleFonts.lato(
//                            fontWeight: FontWeight.bold)),
//                    "province":StyledTextTag(
//                        style: GoogleFonts.lato(
//                            )),
//
//                  }
//
//                ),
//                StyledText(
//                    text:"<city_title>city</city_title> : <city> ${markedLocations[index]["locationInfos"]["city"]} </city> ",
//                    tags:{
//                      "city_title":StyledTextTag(
//                          style: GoogleFonts.lato(
//                              fontWeight: FontWeight.bold)),
//                      "city":StyledTextTag(
//                          style: GoogleFonts.lato(
//                          )),
//
//                    }
//
//                )
//
//              ]
                    ),
              ));
        });
  }

  Future showLocationsDetailDialog(int index) async {
    List titlesName = [];
    if (index!=-1){
    allLocations["markedLocations"][index]["locationsInfo"].forEach((key, value) {
      if (key!="information_loaded" && key!="isSelected") {
        titlesName.add(key);
      }
    });}
    else{
      tCordination["markedLocation"].forEach((key, value) {
        if (key!="information_loaded" && key!="isSelected") {
          titlesName.add(key);
        }
      });
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              titlePadding: EdgeInsets.only(left: 10, top: 10),
              title: StyledText(text: "<mapIcon/>Info", tags: {
                "mapIcon": StyledTextIconTag(Icons.info_outlined,
                    size: 19, color: Colors.black),
              }),
              contentPadding: EdgeInsets.only(left: 10, top: 10, right: 10),
              content: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        index==-1?tCordination["markedLocation"].length:titlesName.length,
                        (secondIndex) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StyledText(
                                text:
                                    "<title>${titlesName[secondIndex]}</title> : <detail> ${index==-1?tCordination["markedLocation"][titlesName[secondIndex]]:allLocations["markedLocations"][index]["locationsInfo"][titlesName[secondIndex]] == null ? "no reasult found" : allLocations["markedLocations"][index]["locationsInfo"][titlesName[secondIndex]]} </detail>   <copyIcon/> ",
                                tags: {
                                  "copyIcon": StyledTextIconTag(Icons.copy,
                                      color: Colors.black54),
                                  "title": StyledTextTag(
                                      style: GoogleFonts.lato(
                                          fontWeight: FontWeight.bold)),
                                  "detail":
                                      StyledTextTag(style: GoogleFonts.lato()),
                                }),
                            Divider(
                              thickness: 0.5,
                            )
                          ]);
                    })

                    ),
              ));
        });
  }
}
