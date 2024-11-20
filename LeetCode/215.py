import heapq

class solution:
    def q215(self, nums: List[int], k: int) -> int:
        minheap = []
        heapq.heapify(minheap)
        for num in nums:
            heapq.heappush(minheap,num*(-1))

        while k>1:
            heapq.heappop(minheap)
            k -= 1 
        return minheap[0]*(-1)