class UserModel{
  String? uid;
  String? email;

  UserModel({this.uid, this.email});

  //data from server
  factory UserModel.fromMap(map){
    return UserModel(
      uid: map['uid'],
      email: map['email']
    );
    }

    //sending data to the server
  Map<String, dynamic> toMap(){
    return {
      'uid': uid,
      'email': email
    };
  }
}