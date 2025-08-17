class dicNode:
    def __init__(self, key=0, val=0, next=None, prev=None):
        self.key = key
        self.val = val
        self.next = None
        self.prev = None


class LRUCache:

    def __init__(self, capacity: int):
        self.capacity = capacity
        self.cache = {}
        self.head = dicNode()
        self.tail = dicNode()
        self.head.next = self.tail
        self.tail.prev = self.head

    def _remove_node(self, node: dicNode):
        node.prev.next = node.next
        node.next.prev = node.prev  # remove this node

    def _add_node_to_tail(self, node: dicNode):
        node.prev = self.tail.prev
        self.tail.prev.next = node
        self.tail.prev = node
        node.next = self.tail  # add node to tail

    def get(self, key: int) -> int:
        if key not in self.cache:
            return -1
        else:
            getNode = self.cache[key]
            self._remove_node(getNode)
            self._add_node_to_tail(getNode)
            return self.cache[key].val

    def put(self, key: int, value: int) -> None:

        if key in self.cache:
            updateNode = self.cache[key]
            updateNode.val = value
            self._remove_node(updateNode)
            self._add_node_to_tail(updateNode)
            return

        if len(self.cache) == self.capacity:
            lru = self.head.next
            self._remove_node(lru)
            del self.cache[lru.key]

        newNode = dicNode(key, value)
        self.cache[key] = newNode
        self._add_node_to_tail(newNode)


# Your LRUCache object will be instantiated and called as such:
# obj = LRUCache(capacity)
# param_1 = obj.get(key)
# obj.put(key,value)
