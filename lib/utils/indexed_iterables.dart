extension ExtendedIterable<E> on Iterable<E> {
  /// Like Iterable<T>.map but callback have index as second argument
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }

  void forEachIndexed(void Function(E e, int i) f) {
    var i = 0;
    forEach((e) => f(e, i++));
  }
}

List splitPairs(List list) {
  int len = list.length;
  int size = 2;
  List pairs = [];

  for (int i = 0; i < list.length; i++) {
    int end = (i + size < len) ? i + size : len;
    pairs.add(list.sublist(i, end));
  }
  pairs.removeLast();

  return pairs;
}
