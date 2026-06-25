import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'DynamicDevicesPage.dart';
import '../../models/room_model.dart';
import '../../services/room_service.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {

  Uint8List? selectedImage;

  final RoomService roomService = RoomService();

  List<RoomModel> rooms = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    getRooms();
  }

  Future getRooms() async {

    setState(() {
      loading = true;
    });

    try {

      rooms =
      await roomService.getRooms();

    } catch (e) {

      print(e);

    }

    setState(() {
      loading = false;
    });

  }

  Future pickImage(
      StateSetter setDialog
      ) async {

    try {

      final picker =
      ImagePicker();

      final XFile? image =
      await picker.pickImage(

        source:
        ImageSource.gallery,

        imageQuality: 50,

      );

      if(image == null) return;

      final bytes =
      await image.readAsBytes();

      setDialog(() {

        selectedImage =
            bytes;

      });

    }

    catch(e){

      print(
          "IMAGE ERROR $e"
      );

    }

  }

  Future addRoom() async {

    TextEditingController controller =
    TextEditingController();

    selectedImage = null;

    await showDialog(

      context: context,

      builder:(dialogContext){

        return StatefulBuilder(

          builder:
              (context,setDialog){

            return AlertDialog(

              backgroundColor:
              Theme.of(context).scaffoldBackgroundColor,

              title:
              Text(
                "Add Room",
                style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.color,
                ),
              ),

              content:

              Column(

                mainAxisSize:
                MainAxisSize.min,

                children:[

                  GestureDetector(

                    onTap:(){

                      pickImage(
                        setDialog,
                      );

                    },

                    child:

                    Container(

                      width:140,

                      height:140,

                      decoration:
                      BoxDecoration(

                        color:
                        const Color(
                          0xFF2A2A2A,
                        ),

                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),

                        border:
                        Border.all(

                          color:
                          Colors.orange,

                          width:2,

                        ),

                      ),

                      child:

                      selectedImage==null

                          ?

                      const Column(

                        mainAxisAlignment:
                        MainAxisAlignment.center,

                        children:[

                          Icon(

                            Icons.add_a_photo,

                            color:
                            Colors.orange,

                            size:40,

                          ),

                          SizedBox(
                            height:10,
                          ),

                          Text(

                            "Choose Image",

                            style:
                            TextStyle(

                              color:
                              Colors.white70,

                            ),

                          ),

                        ],

                      )

                          :

                      ClipRRect(

                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),

                        child:

                        Image.memory(

                          selectedImage!,

                          fit:
                          BoxFit.cover,

                        ),

                      ),

                    ),

                  ),

                  const SizedBox(
                    height:20,
                  ),

                  TextField(

                    controller:
                    controller,

                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface,
                    ),

                    decoration:
                    const InputDecoration(

                      hintText:
                      "Room Name",

                    ),

                  ),

                ],

              ),

              actions:[

                TextButton(

                  onPressed:(){

                    Navigator.pop(
                      dialogContext,
                    );

                  },

                  child:
                  const Text(
                    "Cancel",
                  ),

                ),

                ElevatedButton(

                  onPressed:() async {

                    if(
                    controller.text
                        .trim()
                        .isEmpty
                    ){

                      return;

                    }

                    try{

                      await roomService.addRoom(

                        RoomModel(

                          name:
                          controller.text.trim(),

                        ),

                        selectedImage,

                      );

                      Navigator.pop(
                        dialogContext,
                      );

                      await getRooms();

                    }

                    catch(e){

                      print(
                          "ADD ROOM ERROR $e"
                      );

                    }

                  },

                  child:
                  const Text(
                    "Add",
                  ),

                ),

              ],

            );

          },

        );

      },

    );

  }

  Future deleteRoom(
      String id
      ) async {

    await roomService
        .deleteRoom(id);

    getRooms();

  }

  @override
  Widget build(
      BuildContext context
      ) {

    return Scaffold(

      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,

      floatingActionButton:

      FloatingActionButton(

        backgroundColor:
        Theme.of(context)
            .colorScheme
            .primary,

        foregroundColor:
        Theme.of(context)
            .colorScheme
            .onPrimary,

        onPressed: addRoom,

        child: const Icon(Icons.add),

      ),

      body:

      SafeArea(

        child:

        Padding(

          padding:
          const EdgeInsets.all(
            20,
          ),

          child:

          Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children:[

              Text(
                "Your Rooms",
                style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),

              const SizedBox(
                height:20,
              ),

              if(loading)

                const Expanded(

                  child:

                  Center(

                    child:
                    CircularProgressIndicator(),

                  ),

                )

              else

                Expanded(

                  child:

                  GridView.builder(

                    itemCount:
                    rooms.length,

                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(

                      crossAxisCount:2,

                      crossAxisSpacing:15,

                      mainAxisSpacing:15,

                      childAspectRatio:.9,

                    ),

                    itemBuilder:(context,index){

                      RoomModel room = rooms[index];

                      return GestureDetector(

                        onTap: () async {

                          await Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (_) => DynamicDevicesPage(

                                roomName: room.name,

                                roomId: room.id!,

                              ),

                            ),

                          );

                        },

                        child: Container(

                          decoration: BoxDecoration(

                            borderRadius:
                            BorderRadius.circular(20),

                            image: DecorationImage(

                              image: AssetImage(

                                room.name.toLowerCase().contains("kitchen")

                                    ? "assets/images/Kitchen Room.jpg"

                                    : room.name.toLowerCase().contains("bath")

                                    ? "assets/images/Bath Room.jpg"

                                    : room.name.toLowerCase().contains("bed")

                                    ? "assets/images/Bed Room.jpg"

                                    : room.name.toLowerCase().contains("kids")

                                    ? "assets/images/kids.jpg"

                                    : "assets/images/living room decore.jpg",

                              ),

                              fit: BoxFit.cover,

                            ),

                          ),

                          child: Container(

                            decoration: BoxDecoration(

                              borderRadius:
                              BorderRadius.circular(20),

                              gradient: LinearGradient(

                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,

                                colors: [

                                  Colors.black.withOpacity(.2),
                                  Colors.black.withOpacity(.8),

                                ],

                              ),

                            ),

                            child: Stack(

                              children:[

                                Center(

                                  child: Text(

                                    room.name,

                                    style: const TextStyle(

                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,

                                    ),

                                  ),

                                ),

                                Positioned(

                                  top: 5,
                                  right: 5,

                                  child: IconButton(

                                    onPressed: () {

                                      deleteRoom(room.id!);

                                    },

                                    icon: const Icon(

                                      Icons.delete,
                                      color: Colors.red,

                                    ),

                                  ),

                                ),

                              ],

                            ),

                          ),

                        ),

                      );

                    },


                  ),

                ),

            ],

          ),

        ),

      ),

    );

  }

}