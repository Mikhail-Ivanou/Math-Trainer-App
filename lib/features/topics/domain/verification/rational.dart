/// Exact fraction arithmetic, so 0.1 + 0.2 equals 3/10.
final class Rational implements Comparable<Rational> {
  factory Rational(BigInt numerator, [BigInt? denominator]) {
    var den = denominator ?? BigInt.one;
    if (den == BigInt.zero) {
      throw const FormatException('division by zero');
    }
    var num = numerator;
    if (den.isNegative) {
      num = -num;
      den = -den;
    }
    final divisor = num.gcd(den);
    return Rational._(
      divisor == BigInt.zero ? num : num ~/ divisor,
      divisor == BigInt.zero ? den : den ~/ divisor,
    );
  }

  const Rational._(this.numerator, this.denominator);

  factory Rational.fromInt(int value) => Rational(BigInt.from(value));

  final BigInt numerator;
  final BigInt denominator;

  static final zero = Rational.fromInt(0);
  static final one = Rational.fromInt(1);

  /// Parses "12 450", "-7", "2,5", "-0.75", "3/4", "−7/3".
  /// Mixed numbers are rejected: a space is a thousands separator.
  static Rational parse(String text) {
    final source = text
        .trim()
        .replaceAll(RegExp(r'[\s  ]'), '')
        .replaceAll(RegExp('[–−—]'), '-')
        .replaceAll(',', '.');
    final match = RegExp(
      r'^(-?)(\d+)(?:\.(\d+))?(?:/(\d+))?$',
    ).firstMatch(source);
    if (match == null) {
      throw FormatException('not a number: $text');
    }
    final sign = match.group(1) == '-' ? BigInt.from(-1) : BigInt.one;
    final whole = match.group(2);
    if (whole == null) {
      throw FormatException('not a number: $text');
    }
    final fractionDigits = match.group(3) ?? '';
    var value = Rational(
      BigInt.parse('$whole$fractionDigits'),
      BigInt.from(10).pow(fractionDigits.length),
    );
    final denominatorText = match.group(4);
    if (denominatorText != null) {
      if (fractionDigits.isNotEmpty) {
        throw FormatException('not a number: $text');
      }
      value = value / Rational(BigInt.parse(denominatorText));
    }
    return Rational(value.numerator * sign, value.denominator);
  }

  Rational operator +(Rational other) => Rational(
    numerator * other.denominator + other.numerator * denominator,
    denominator * other.denominator,
  );

  Rational operator -(Rational other) => Rational(
    numerator * other.denominator - other.numerator * denominator,
    denominator * other.denominator,
  );

  Rational operator *(Rational other) =>
      Rational(numerator * other.numerator, denominator * other.denominator);

  Rational operator /(Rational other) {
    if (other.numerator == BigInt.zero) {
      throw const FormatException('division by zero');
    }
    return Rational(
      numerator * other.denominator,
      denominator * other.numerator,
    );
  }

  Rational operator -() => Rational(-numerator, denominator);

  Rational pow(int exponent) {
    if (exponent < 0) {
      return one / pow(-exponent);
    }
    if (exponent > 64) {
      throw const FormatException('exponent is too large');
    }
    return Rational(numerator.pow(exponent), denominator.pow(exponent));
  }

  bool get isInteger => denominator == BigInt.one;

  @override
  int compareTo(Rational other) =>
      (numerator * other.denominator).compareTo(other.numerator * denominator);

  @override
  bool operator ==(Object other) =>
      other is Rational &&
      other.numerator == numerator &&
      other.denominator == denominator;

  @override
  int get hashCode => Object.hash(numerator, denominator);

  @override
  String toString() => isInteger ? '$numerator' : '$numerator/$denominator';
}
