class Note {
  int _noteId;
  int _categoryId;
  String _categoryName;
  String _noteTitle;
  String _noteContent;
  String _noteDate;
  int _notePrecedence;

  // Getter and Setter methods
  int get noteId => _noteId;

  set noteId(int noteId) {
    if (!noteId.isNaN) _noteId = noteId;
  }

  int get categoryId => _categoryId;

  set categoryId(int categoryId) {
    if (!categoryId.isNaN) _categoryId = categoryId;
  }

  String get categoryName => _categoryName;

  set categoryName(String categoryName) {
    if (categoryName.isNotEmpty) _categoryName = categoryName;
  }

  String get noteTitle => _noteTitle;

  set noteTitle(String noteTitle) {
    if (noteTitle.isNotEmpty) _noteTitle = noteTitle;
  }

  String get noteContent => _noteContent;

  set noteContent(String noteContent) {
    if (noteContent.isNotEmpty) _noteContent = noteContent;
  }

  String get noteDate => _noteDate;

  set noteDate(String noteDate) {
    if (noteDate.isNotEmpty) _noteDate = noteDate;
  }

  int get notePrecedence => _notePrecedence;

  set notePrecedence(int notePrecedence) {
    if (!notePrecedence.isNaN) _notePrecedence = notePrecedence;
  }

  // Constructors
  Note(
    this._categoryId,
    this._noteTitle,
    this._noteContent,
    this._noteDate,
    this._notePrecedence,
  );

  Note.withIds(
    this._noteId,
    this._categoryId,
    this._noteTitle,
    this._noteContent,
    this._noteDate,
    this._notePrecedence,
  );

  Map<String, dynamic> toMap() {
    var noteMap = Map<String, dynamic>();
    noteMap["noteId"] = _noteId;
    noteMap["categoryId"] = _categoryId;
    noteMap["noteTitle"] = _noteTitle;
    noteMap["noteContent"] = _noteContent;
    noteMap["noteDate"] = _noteDate;
    noteMap["notePrecedence"] = _notePrecedence;
    return noteMap;
  }

  Note.fromMap(Map<String, dynamic> noteMap) {
    this._noteId = noteMap["noteId"];
    this._categoryId = noteMap["categoryId"];
    this._categoryName = noteMap["categoryName"];
    this._noteTitle = noteMap["noteTitle"];
    this._noteContent = noteMap["noteContent"];
    this._noteDate = noteMap["noteDate"];
    this._notePrecedence = noteMap["notePrecedence"];
  }

  // Note.toString()
  @override
  String toString() {
    return "Note { NoteId : $_noteId}, CategoryId : $_categoryId, NoteTitle : $_noteTitle, NoteContent : $_noteContent, NoteDate : $_noteDate, NotePrecedence : $_notePrecedence";
  }
}
