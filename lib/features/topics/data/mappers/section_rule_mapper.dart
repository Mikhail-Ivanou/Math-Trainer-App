/// The `rule` field of a section document, or an empty string when it is absent.
String sectionRuleFromMap(Map<String, dynamic>? data) {
  final value = data?['rule'];
  if (value is! String) {
    return '';
  }
  return value.trim();
}
