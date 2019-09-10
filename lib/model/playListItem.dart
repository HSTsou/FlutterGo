class PlayListItem {
  String name;
  int age;
  PlayListItem(this.name, this.age);

  // named constructor
  PlayListItem.fromJson(Map<String, dynamic> json)
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
