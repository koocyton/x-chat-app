class Dialogue {

  late int id;
  late int parentId;
  late String type;
  late String askUser;
  late String ask;
  late String replyUser;
  late String reply;
  late DateTime createTime;

  static Dialogue fromQueryMap(dynamic dyn) {
    Dialogue dialogue   = Dialogue();
    dialogue.id         = dyn["id"];
    dialogue.parentId   = dyn["parent_id"];
    dialogue.type       = dyn["type"];
    dialogue.askUser    = dyn["ask_user"];
    dialogue.ask        = dyn["ask"];
    dialogue.replyUser  = dyn["reply_user"];
    dialogue.reply      = dyn["reply"];
    dialogue.createTime = DateTime.parse(dyn["create_time"]);
    return dialogue;
  }
}