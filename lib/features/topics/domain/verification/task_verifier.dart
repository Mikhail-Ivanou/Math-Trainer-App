import 'dart:math';

import 'package:math_trainer_app/features/topics/domain/entities/task.dart';
import 'package:math_trainer_app/features/topics/domain/verification/rational.dart';

/// Result of checking a generated task. [reason] says why it was rejected.
final class Verdict {
  const Verdict.ok() : reason = null;

  const Verdict.rejected(this.reason);

  final String? reason;

  bool get ok => reason == null;
}

final _spaces = RegExp(r'[\s  ]');

/// Checks a task's answer against its machine-checkable form.
Verdict verifyTask(Task task, {Random? random}) {
  try {
    switch (task.type) {
      case TaskType.expression:
        final expr = task.expr;
        if (expr == null) {
          throw const FormatException('missing expr');
        }
        final shown = _numbers(task.question);
        final missing = _numbers(
          expr,
        ).where((number) => !shown.contains(number)).toList();
        if (missing.isNotEmpty) {
          return Verdict.rejected(
            'question is missing numbers ${missing.join(', ')}',
          );
        }
        final value = evaluate(expr);
        final answer = Rational.parse(task.answer);
        return value == answer
            ? const Verdict.ok()
            : Verdict.rejected('expression equals $value, not ${task.answer}');
      case TaskType.equation:
        final equation = task.equation;
        final variable = task.variable;
        if (equation == null) {
          throw const FormatException('missing equation');
        }
        if (variable == null) {
          throw const FormatException('missing variable');
        }
        final sides = equation.split('=');
        if (sides.length != 2) {
          return Verdict.rejected('equation needs one equals sign: $equation');
        }
        if (!sides.join().contains(variable)) {
          return Verdict.rejected('equation has no variable $variable');
        }
        final left = evaluate(
          sides[0],
          vars: {variable: Rational.parse(task.answer)},
        );
        final right = evaluate(
          sides[1],
          vars: {variable: Rational.parse(task.answer)},
        );
        return left == right
            ? const Verdict.ok()
            : Verdict.rejected('at ${task.answer}: $left ≠ $right');
      case TaskType.word:
        final solution = task.solutionExpr;
        if (solution == null) {
          throw const FormatException('missing solution_expr');
        }
        final value = evaluate(solution);
        final answer = Rational.parse(task.answer);
        return value == answer
            ? const Verdict.ok()
            : Verdict.rejected('solution gives $value, not ${task.answer}');
      case TaskType.simplify:
        final expr = task.expr;
        if (expr == null) {
          throw const FormatException('missing expr');
        }
        return sameExpression(expr, task.answer, random: random)
            ? const Verdict.ok()
            : Verdict.rejected('"${task.answer}" is not equal to "$expr"');
    }
  } on FormatException catch (error) {
    return Verdict.rejected(error.message);
  }
}

/// Whether two expressions with variables are equal at several random points.
bool sameExpression(String left, String right, {Random? random}) {
  final source = random ?? Random();
  final names = {...variablesOf(left), ...variablesOf(right)};
  for (var i = 0; i < 5; i++) {
    final vars = {
      for (final name in names)
        name: Rational(
          BigInt.from(source.nextInt(19) - 9),
          BigInt.from(source.nextInt(4) + 1),
        ),
    };
    try {
      if (evaluate(left, vars: vars) != evaluate(right, vars: vars)) {
        return false;
      }
    } on FormatException catch (error) {
      if (error.message == 'division by zero') {
        continue;
      }
      rethrow;
    }
  }
  return true;
}

Set<String> _numbers(String text) {
  final values = <String>{};
  for (final match in RegExp(
    r'\d(?:[\d\s  ]*\d)?(?:[.,]\d+)?',
  ).allMatches(text)) {
    final raw = match.group(0);
    if (raw == null) {
      continue;
    }
    values.add(raw.replaceAll(_spaces, '').replaceAll(',', '.'));
  }
  return values;
}

String _clean(String source) => source
    .replaceAll(_spaces, '')
    .replaceAll(RegExp('[–−—]'), '-')
    .replaceAll(RegExp('[·×∙]'), '*')
    .replaceAll(':', '/')
    .replaceAll('²', '^2')
    .replaceAll('³', '^3');

/// Single-letter variables, Latin or Cyrillic, used in [source].
Set<String> variablesOf(String source) {
  final names = <String>{};
  for (final match in RegExp(r'[a-zA-Zа-яА-Я]').allMatches(_clean(source))) {
    final name = match.group(0);
    if (name != null) {
      names.add(name);
    }
  }
  return names;
}

/// Evaluates + − · : ^ and brackets over exact fractions.
Rational evaluate(String source, {Map<String, Rational> vars = const {}}) {
  final text = _clean(source);
  var pos = 0;

  Never fail(String what) => throw FormatException('$what in "$source"');
  bool at(String symbol) => pos < text.length && text[pos] == symbol;
  bool startsAtom() =>
      pos < text.length && RegExp(r'[0-9a-zA-Zа-яА-Я(]').hasMatch(text[pos]);

  late Rational Function() sum;

  Rational atom() {
    if (at('(')) {
      pos++;
      final value = sum();
      if (!at(')')) {
        fail('missing closing parenthesis');
      }
      pos++;
      return value;
    }
    final number = RegExp(r'\d+(?:[.,]\d+)?').matchAsPrefix(text, pos);
    if (number != null) {
      pos = number.end;
      final raw = number.group(0);
      if (raw == null) {
        fail('expected a number');
      }
      return Rational.parse(raw);
    }
    if (pos < text.length && RegExp(r'[a-zA-Zа-яА-Я]').hasMatch(text[pos])) {
      final name = text[pos];
      pos++;
      return vars[name] ?? fail('unknown variable $name');
    }
    fail('expected a number');
  }

  Rational power() {
    final base = atom();
    if (!at('^')) {
      return base;
    }
    pos++;
    final negative = at('-');
    if (negative) {
      pos++;
    }
    final exponent = RegExp(r'\d+').matchAsPrefix(text, pos);
    if (exponent == null) {
      fail('exponent must be an integer');
    }
    final digits = exponent.group(0);
    if (digits == null) {
      fail('exponent must be an integer');
    }
    pos = exponent.end;
    return base.pow(int.parse(digits) * (negative ? -1 : 1));
  }

  Rational unary() {
    if (at('-')) {
      pos++;
      return -unary();
    }
    if (at('+')) {
      pos++;
      return unary();
    }
    return power();
  }

  Rational product() {
    var value = unary();
    while (true) {
      if (at('*') || at('/')) {
        final operator = text[pos];
        pos++;
        final right = unary();
        value = operator == '*' ? value * right : value / right;
      } else if (startsAtom()) {
        value = value * power();
      } else {
        return value;
      }
    }
  }

  sum = () {
    var value = product();
    while (at('+') || at('-')) {
      final operator = text[pos];
      pos++;
      final right = product();
      value = operator == '+' ? value + right : value - right;
    }
    return value;
  };

  if (text.isEmpty) {
    fail('empty expression');
  }
  final value = sum();
  if (pos != text.length) {
    fail('unexpected characters');
  }
  return value;
}
