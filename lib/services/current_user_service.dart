import 'package:coco_shop/models/user.dart';

class CurrentUserService {
  static final CurrentUserService _singleton = new CurrentUserService._internal();
  User currentUser;

  factory CurrentUserService() {
    return _singleton;
  }

  User getCurrentUser() {
    return this.currentUser;
  }

  void setCurrentUser(User user) {
    this.currentUser = user;
  }

  CurrentUserService._internal();
}