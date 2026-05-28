class RoomModel {

  String? id;
  String name;
  String? image;

  RoomModel({

    this.id,
    required this.name,
    this.image,

  });

  factory RoomModel.fromJson(Map<String,dynamic> json){

    return RoomModel(

      id: json["_id"],
      name: json["name"],
      image: json["image"],

    );

  }

  Map<String,dynamic> toJson(){

    return {

      "name": name,
      "image": image,

    };

  }

}