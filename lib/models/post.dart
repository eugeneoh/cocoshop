class Post {
  String description;
  String picURL1;

  Post(
    this.description, 
    this.picURL1
  );

  Post.fromMap(Map<String, dynamic> data) {
    this.description = data["description"];
    this.picURL1 = data["pic_url1"];
  }
}