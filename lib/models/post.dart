class Post {
  String description;
  String picURL1;
  String authorUID;

  Post(
    this.description, 
    this.picURL1,
    this.authorUID
  );

  Post.fromMap(Map<String, dynamic> data) {
    this.description = data["description"];
    this.picURL1 = data["pic_url1"];
    this.authorUID = data["author_firebase_uid"];
  }
}