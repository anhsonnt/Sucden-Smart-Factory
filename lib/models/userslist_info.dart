class UserListInfo {
  // final int? userId;
  final String? userName;
  final String? userPwdMobile;

  UserListInfo(this.userName, this.userPwdMobile);

  factory UserListInfo.fromJson(Map<String, dynamic> json) {
    // ignore: unnecessary_new
    return new UserListInfo(
      // json["userId"],
      json["userName"],
      json["userPwdMobile"]
    );
  }
      Map<String, dynamic> toJson() => {
        // "userId":userId,
        "userName": userName,
        "userPwdMobile": userPwdMobile,
    };
    Map<String, dynamic> toMap() {
    return {
        // 'userId':userId,
        'userName': userName,
        "userPwdMobile": userPwdMobile,
    };
    
  }

  toList() {}
}
