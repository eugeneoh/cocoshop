class User {

  String firstName;
  String lastName;
  String firebaseUID;
  String fbUID;
  String username;
  String fbAccessToken;
  String email;
  String photoUrl;
  String aboutMe;
  DateTime tokenExpiration;

  User(
    this.firstName, 
    this.lastName, 
    this.firebaseUID,
    this.fbUID, 
    this.username, 
    this.fbAccessToken, 
    this.email,
    this.photoUrl,
    this.aboutMe,
    this.tokenExpiration,
    );

  User.fromMap(Map<String, dynamic> data) {
    this.firstName = data["first_name"];
    this.lastName = data["last_name"];
    this.firebaseUID = data["firebase_uid"];
    this.fbUID = data["fb_uid"];
    this.username = data["username"];
    this.fbAccessToken = data["fb_access_token"];
    this.email = data["email"];
    this.photoUrl = data["photo_url"];
    this.aboutMe = data["about_me"];
    this.tokenExpiration = data["token_expiration"];
  }
}