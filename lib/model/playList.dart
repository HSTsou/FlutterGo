class PlayList {
  String name;
  int age;
  PlayList(this.name, this.age);

  // named constructor
  PlayList.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        age = json['age'];

  // method
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
    };
  }

}
