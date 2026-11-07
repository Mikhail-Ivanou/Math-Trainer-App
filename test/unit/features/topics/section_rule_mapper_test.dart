import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/features/topics/data/mappers/section_rule_mapper.dart';

void main() {
  test('reads the section rule', () {
    expect(
      sectionRuleFromMap({'rule': '  Multiply each term.  '}),
      'Multiply each term.',
    );
  });

  test('returns an empty string when the rule is missing', () {
    expect(sectionRuleFromMap(null), '');
    expect(sectionRuleFromMap({'title': 'Numbers'}), '');
    expect(sectionRuleFromMap({'rule': 3}), '');
  });
}
