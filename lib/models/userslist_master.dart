class UserList {
  final int? userId;
  final String? userName;
  final String? userPwdMobile;

  UserList(this.userId, this.userName, this.userPwdMobile);

  factory UserList.fromJson(Map<String, dynamic> json) {
    // ignore: unnecessary_new
    return new UserList(
      json["userId"],
      json["userName"],
      json["userPwdMobile"]
    );
  }
      Map<String, dynamic> toJson() => {
        "userId":userId,
        "userName": userName,
        "userPwdMobile": userPwdMobile,
    };
    Map<String, dynamic> toMap() {
    return {
        'userId':userId,
        'userName': userName,
        "userPwdMobile": userPwdMobile,
    };
    
  }
}
