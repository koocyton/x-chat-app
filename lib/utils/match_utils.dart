class MatchUtils {

  static Iterable<RegExpMatch> matchAll(String regex, String? text) {
    if (text==null) {
      return [];
    }
    return RegExp(
      regex.replaceAll(RegExp(r"[\r\n|\n]"), ""), 
      multiLine:true
    )
    .allMatches(
      text.replaceAll(RegExp(r"[\r\n|\n]"), " ")
    );
  }

  static RegExpMatch? match(String regex, String? text) {
    if (text==null) {
      text = "";
    }
    return RegExp(
      regex.replaceAll(RegExp(r"[\r\n|\n]"), ""), 
      multiLine:true
    )
    .firstMatch(
      text.replaceAll(RegExp(r"[\r\n|\n]"), " ")
    );
  }
}