class ItemPair<T1, T2> {
  final T1 item;
  final T2 priority;

  ItemPair(this.item, this.priority);
}

class PriorityQueue<T> {
  final List<ItemPair<T, int>> _queue = [];
  final int _length = 0;

  void dequeue() {
    _queue.removeAt(0);
  }

  void enqueue(itemToAdd, int priority) {
    for (int i = _length; i >= 0; i -= 1) {
      if ((i == 0) || (_queue[i].priority > priority)) {
        if (i == _length) {
          _queue.add(ItemPair(itemToAdd, priority));
        } else {
          _queue.insert(i + 1, ItemPair(itemToAdd, priority));
        }
      }
    }
  }

  List<T> getList() {
    return _queue.map((itemPair) => itemPair.item).toList();
  }
}
