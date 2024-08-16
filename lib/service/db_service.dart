import 'package:chat_hub/utils/cache_utils.dart';
import 'package:chat_hub/entity/dialogue.dart';
import 'package:logging/logging.dart';
import 'package:sqflite/sqflite.dart';

class DBService {

  static Logger log = Logger("DBService");

  static late Database db;

  static Future<Dialogue?> getDialogue(String type, String ask) {
    return DBService.db.query(
        "dialogue",
        // columns: columns,
        orderBy: ' id DESC ',
        where: "ask=? AND reply!=? AND type=?",
        whereArgs: [ask, '', type],
        limit:1
      )
    .then((mapList){
      if (mapList.length==0) {
        return null;
      }
      return Dialogue.fromQueryMap(mapList[0]);
    });
  }

  static Future<List<Dialogue>> getDialogueList(int page) {
    return DBService.db.query(
        "dialogue",
        // columns: columns,
        // where: "ask !=? AND reply != ?",
        // whereArgs: ["", ""],
        orderBy: 'id desc',
        limit: 30,
        offset: page * 30
      )
    .then((mapList){
      List<Dialogue> dialogueList = [];
      for (Map<String, Object?> map in mapList) {
        Dialogue dialogue = Dialogue.fromQueryMap(map);
        dialogueList.add(dialogue);
      }
      return dialogueList;
    });
  }

  static Future<Dialogue> createDialogueByAsk(String type, String ask) {
    Dialogue dialogue = Dialogue();
    dialogue.type = type;
    dialogue.askUser = "U";
    dialogue.ask = ask;
    dialogue.replyUser = "G";
    dialogue.reply = "";
    dialogue.createTime = DateTime.now();
    return createDialogue(dialogue);
  }

  static Future<Dialogue> createDialogue(Dialogue dialogue) {
    return DBService.db.insert(
      "dialogue",
      {
        "type":dialogue.type,
        "ask_user":dialogue.askUser,
        "ask":dialogue.ask,
        "reply_user":dialogue.replyUser,
        "reply":dialogue.reply,
        "create_time":dialogue.createTime.toIso8601String()
      }
    ).then((r){
      dialogue.id = r;
      return dialogue;
    });
  }

  static Future<Dialogue> addDialogueReply(Dialogue dialogue, String reply) {
    return DBService.db.update(
      "dialogue",
      {"reply": reply},
      where:"id=?",
      whereArgs: [dialogue.id]
    ).then((r){
      dialogue.reply = reply;
      return dialogue;
    });
  }

  static Future<int> deleteDialogue(int id) {
    return DBService.db.delete(
      "dialogue",
      where:"id=?",
      whereArgs: [id]
    );
  }

  static Future<Database> initDababase() {
    return CacheUtils.getCacheFile("doopp_chat.db").then((dbFile) {
      return openDatabase(
        dbFile.path, 
        version: 1, 
        onCreate: createDatabase
      ).then((_db){
        db = _db;
        return _db;
      });
    });
  }

  static void createDatabase(Database db, int version) {
    db.execute(
      'CREATE TABLE dialogue ('
        'id INTEGER PRIMARY KEY autoincrement, '
        'parent_id INTEGER default 0, '
        'type TEXT not null,'
        'ask TEXT not null,'
        'ask_user TEXT not null,'
        'reply TEXT,'
        'reply_user TEXT,'
        'create_time DATETIME not null'
      ')'
    );
    db.insert(
      "dialogue",
      {
        "type":"CHAT",
        "ask_user":"U",
        "ask": "LIKE BARLEY BENDING",
        "reply_user": "G",
        "reply": "   大麦俯身偃，海滨有低地，巨风动地来，放歌殊未已；"
          "\n   大麦俯身偃，既偃且复起，颠仆不能折，昂扬伤痛里；"
          "\n   我生也柔弱，日夜逝如此，直把千古愁，化作临风曲。",
        "create_time": DateTime.now().toIso8601String()
      }
    );
  }
}
