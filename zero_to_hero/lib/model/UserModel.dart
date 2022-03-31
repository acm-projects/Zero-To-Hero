class UserModel{
  String? uid;
  String? email;
  int streak = 0;
  int longestStreak = 0;
  int totalGoals = 0;
  int totalGoalsCompleted = 0;
  //Map<Goal ID, true>
  Map<String, bool> allGoals = {};
  //Map<Epoch Time, Map<goal id, Map<(description, completed), (string, bool)>>>
  Map<int, Map<String, Map<String, bool>>> calendarDays = {};

  UserModel(this.uid);

  //data from server
  factory UserModel.fromRTDB(String uid, String email, Map<String, dynamic> data){
    UserModel temp = UserModel(
      uid
    );
    temp.email = data['email'] ?? 0;
    temp.streak = data['streak'] ?? 0;
    temp.longestStreak = data['longestStreak'] ?? 0;
    temp.totalGoals = data['totalGoals'] ?? 0;
    temp.totalGoalsCompleted = data['totalGoalsCompleted'] ?? 0;
    temp.allGoals = data['allGoals'] ?? {};
    temp.calendarDays = data['calendarDays'] ?? {};

    return temp;
  }

  //sending data to the server
  Map<String, dynamic> toMap(){
    return {
      'email' : email,
      'streak': streak,
      'longestStreak': longestStreak,
      'totalGoals': totalGoals,
      'totalGoalsCompleted': totalGoalsCompleted,
      'calendarDays': calendarDays,
      'allGoals': allGoals
    };
  }
}