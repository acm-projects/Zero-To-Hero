class GoalModel{
  String? gid;
  String? description;
  Map<String, bool> activeDays = {"Monday":false, "Tuesday":false, "Wednesday":false, "Thursday":false, "Friday":false, "Saturday":false, "Sunday":false};
  Map<String, bool> reminders = {};//12-hour time, true
  Map<int, bool> pastGoalDays = {};//epoch time, true/false based on completion
  bool isImportant = false;

  //constructor
  GoalModel(this.description, this.activeDays);

  //data from server and create the goalModel
  factory GoalModel.fromRTDB(String gid, Map<String, dynamic> data){
    Map<String, bool> activeDaysMap = {
      'Sunday': false,
      'Monday': false,
      'Tuesday': false,
      'Wednesday': false,
      'Thursday': false,
      'Friday': false,
      'Saturday': false
    };
    if(data['activeDays'] != null) {
      for (String weekday in data['activeDays'].keys) {
        activeDaysMap[weekday] = data['activeDays'][weekday];
      }
    }
    GoalModel temp = GoalModel(
        data['description'] ?? 'Sample Description',
        activeDaysMap
    );
    temp.gid = gid;

    Map<String, bool> remindersMap = {};
    if(data['reminders'] != null) {
      for (String reminder in data['reminders'].keys) {
        remindersMap[reminder] = data['reminders'][reminder];
      }
    }
    temp.reminders = remindersMap;

    Map<int, bool> pastGoalDaysMap = {};
    if(data['pastGoalDays'] != null) {
      for (String pastGoalDay in data['pastGoalDays'].keys) {
        pastGoalDaysMap[int.parse(pastGoalDay)] = data['pastGoalDays'][pastGoalDay];
      }
    }
    temp.pastGoalDays = pastGoalDaysMap;
    return temp;
  }

  //write the data to the server in a map/json format
  Map<String, dynamic> toMap(){
    return {
      'description' : description,
      'reminders' : reminders,
      'activeDays' : activeDays,
      'pastGoalDays' : pastGoalDays,
      'isImportant' : isImportant
    };
  }
}