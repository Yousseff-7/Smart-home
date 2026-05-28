class DeviceModel {

  String? id;
  String name;
  String roomId;
  String? image;
  String state;

  DeviceModel({

    this.id,

    required this.name,

    required this.roomId,

    this.image,

    this.state = "off",

  });

  factory DeviceModel.fromJson(
      Map<String,dynamic> json,
      ) {

    return DeviceModel(

      id: json["_id"],

      name: json["name"],

      roomId: json["roomId"],

      image: json["image"],

      state: json["state"] ?? "off",

    );

  }

  Map<String,dynamic> toJson(){

    return {

      "name": name,
      "roomId": roomId,
      "image": image,
      "state": state,

    };

  }

}