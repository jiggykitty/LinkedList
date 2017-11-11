enum LinkedListError: Error {
case indexTooBig
case negativeIndex
}

public class Node<T: Equatable> {
  var item: T
  var next: Node?

  public init(item: T) {
    self.item = item
  }
}

public class LinkedList<T: Equatable>: CustomStringConvertible, Equatable {
  var head: Node<T>?
  public var size: Int = 0

  public var description: String {
    var list: [T] = []
    var node = head
    while node != nil {
      list.append(node!.item)
      node = node!.next
    }
    return list.description
  }

  public init() {}

  public subscript(index: Int) -> T {
    // I've read that subscripts cannot throw errors
    // Even if they did, I would have to handle them with try every time I use them
    // I will do that already when I'm using insert or remove
    // So I will use an assertion here

    let node = self.node(atIndex: index)
    assert(node != nil)
    return node!.item
  }

  public static func == (lhs: LinkedList<T>, rhs: LinkedList<T>) -> Bool {
    if lhs.size == rhs.size {
      var node1 = lhs.head
      var node2 = rhs.head
      while node1 != nil {
        if node1!.item != node2!.item {
          return false
        }
        node1 = node1!.next
        node2 = node2!.next
      }
      return true
    }
    else {
      return false
    }
  }

  public func insert(item: T, atIndex: Int) throws {
    guard atIndex <= self.size else {
      throw LinkedListError.indexTooBig
    }
    guard atIndex >= 0 else {
      throw LinkedListError.negativeIndex
    }
    let newNode = Node(item: item)
    self.size += 1

    if atIndex == 0 {
      newNode.next = self.head
      self.head = newNode
      return
    }
    if atIndex == 1 {
      let tail = self.head!.next
      newNode.next = tail
      head!.next = newNode
      return
    }
    var node = self.head
    for _ in 0...(atIndex-2) {
      node = node!.next
    }
    let tail = node!.next
    newNode.next = tail
    node!.next = newNode
    return
  }

  public func node(atIndex: Int) -> Node<T>? {
    guard atIndex <= (size - 1) else {
      return nil
    }
    guard atIndex >= 0 else {
      return nil
    }
    if atIndex == 0 {
      return self.head
    }
    else {
      var node = self.head
      for _ in 0...(atIndex-1) {
        node = node!.next
      }
      return node
    }
  }

  public func remove(item: T) {
    var node = self.head
    while node != nil && node!.next != nil {
      if node!.next!.item == item {
        node!.next = node!.next!.next
        self.size -= 1
      }
      node = node!.next
    }
    if self.head!.item == item {
      self.head = head!.next
      self.size -= 1
    }
  }

  public func remove(atIndex: Int) throws {
    guard atIndex <= self.size else {
      throw LinkedListError.indexTooBig
    }
    guard atIndex >= 0 else {
      throw LinkedListError.negativeIndex
    }
    self.size -= 1
    if atIndex == 0 {
      self.head = self.head!.next
      return
    }
    if atIndex == 1 {
      let tail = self.head!.next!.next
      self.head!.next = tail
      return
    }
    else {
      var node = head!
      for _ in 0...(atIndex-2) {
        node = node.next!
      }
      node.next = node.next!.next
    }
  }

  // In class, someone pointed out that find() and node() are the same
  // Andrew said we should only do one
  // I think find may also mean find the nodes that have a certain value
  // So this function finds those nodes and puts them in a list
  public func find(item: T) -> [Node<T>]? {
    var returnList: [Node<T>] = []
    var node = self.head
    while node != nil {
      if node!.item == item {
        returnList.append(node!)
      }
      node = node!.next
    }
    return returnList
  }

  // Returns the first occurence of forItem
  public func index(forItem: T) -> Int? {
    var node = head
    for i in 0...self.size-1 {
      if node!.item == forItem {
        return i
      }
      node = node!.next
    }
    return nil
  }

  public func reverse() {
    var node = head
    var prev: Node<T>?
    var next: Node<T>?
    while node != nil {
      next = node!.next
      node!.next = prev
      prev = node
      node = next
    }
    head = prev
  }
}
