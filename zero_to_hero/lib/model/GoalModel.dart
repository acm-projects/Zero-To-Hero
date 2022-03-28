class GoalModel{
  String? gid;
  String? description;
  Map<String, bool> activeDays = {"Monday":false, "Tuesday":false, "Wednesday":false, "Thursday":false, "Friday":false, "Saturday":false, "Sunday":false};
  Map<String, bool> reminders = {};//String military time (hh:mm), true
  Map<int, bool> pastGoalDays = {};//epoch time, true/false based on completion

  //constructor
  GoalModel(this.description, this.activeDays);

  //data from server and create the goalModel
  factory GoalModel.fromRTDB(String gid, Map<String, dynamic> data){
    GoalModel temp = GoalModel(
        data['description'] ?? 'Sample Description',
        data['activeDays'] ?? {"data[activeDays] was null in GoalMode.fromRTDB": false}
    );
    temp.gid = gid;
    temp.reminders = data['reminders'] ?? {};
    temp.pastGoalDays = data['pastGoalDays'] ?? {};
    return temp;
  }

  //write the data to the server in a map/json format
  Map<String, dynamic> toMap(){
    return {
      'description' : description,
      'reminders' : reminders,
      'activeDays' : activeDays,
      'pastGoalDays' : pastGoalDays
    };
  }
}