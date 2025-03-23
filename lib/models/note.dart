class Note {
  int? _id; // Make id nullable because it may not be set for a new note
  late String _title;
  late String _description;
  late String _date;
  late int _priority;

  // Constructor with required fields and an optional description
  Note(this._title, this._date, this._priority, [this._description = ""]);

  // Constructor when the Note already has an id (for updates)
  Note.withId(
    this._id,
    this._title,
    this._date,
    this._priority, [
    this._description = "",
  ]);

  // Getters
  int? get id => _id; // Nullable, because a new note might not have an id
  String get title => _title;
  String get description => _description;
  int get priority => _priority;
  String get date => _date;

  // Setters
  set title(String newTitle) {
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      _description = newDescription;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      _priority = newPriority;
    }
  }

  set date(String newDate) {
    _date = newDate;
  }

  // Convert a Note object into a Map object (for database operations)
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (_id != null) {
      map['id'] = _id; // Only add id if it's not null (for existing notes)
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;
    return map;
  }

  // Extract a Note object from a Map object (when fetching from the database)
  Note.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _title = map['title'];
    _description = map['description'];
    _priority = map['priority'];
    _date = map['date'];
  }
}
