class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

class solution:
    def ReverseLinkList(self, head: Optional[ListNode]) -> Optional[ListNode]:
        prev = None
        cur = head

        while cur:
            cur = head.next
            head.next = prev
            prev = head
            head = cur

        return prev
