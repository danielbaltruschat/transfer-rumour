class ItemPair<T1, T2> {
  final T1 item;
  final T2 priority;

  ItemPair(this.item, this.priority);
}

class PriorityQueue {
  final List queue = [];
  final int length = 0;

  void dequeue() {
    queue.removeLast();
  }

  void enqueue(itemToAdd, int priority) {
    for (int i = length; i >= 0; i -= 1) {
      if (queue[i].priority < priority) {
        if (i == length) {
          queue.add(ItemPair(itemToAdd, priority));
        } else {
          queue.insert(i + 1, ItemPair(itemToAdd, priority));
        }
      }
    }
  }

  List getList() {
    return queue;
  }
}
