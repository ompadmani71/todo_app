import 'dart:convert';

TODO TODOFromJson(String str) => TODO.fromJson(jsonDecode(str));

class TODO{

  TODO({
    this.todo_id,
    this.todo_title,
    this.todo_description
  });

  int? todo_id;
  String? todo_title;
  String? todo_description;

  factory TODO.fromJson(Map<String, dynamic> json) => TODO(
      todo_id: json["todo_id"],
      todo_title: json["todo_title"],
      todo_description: json["todo_description"]
  );


}