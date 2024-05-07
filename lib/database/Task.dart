class Task{
  String id;
  String title;
  String description;
  DateTime date;
  bool isDone;

  Task({
    this.id='',
    required this.title,
    required this.description,
    required this.date,
    this.isDone=false,

  });
  Task.FromFireStore(Map<String,dynamic>data):
      this(
        id: data['id'],
        title: data['title'],
        description: data['description'],
        date: DateTime.fromMillisecondsSinceEpoch(data['dateTime']),
        isDone: data['isDone'],

      );
  Map<String,dynamic> tOFireStore(){
   return{
    'id':id,
    'title':title,
    'description':description,
    'dateTime':date.millisecondsSinceEpoch,
     'isDone':isDone
  };

  }


}