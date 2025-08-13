class Solution:
    def longestConsecutive(self, nums: list[int]) -> int:
        n = len(nums)
        nums.sort()
        res = 0
        cur_len = 1
        for i in range(1, n):
            print(cur_len, "  ", res)
            if nums[i] == nums[i-1] + 1:
                cur_len = cur_len + 1
                res = max(res, cur_len)
            elif nums[i] == nums[i-1]:
                cur_len = cur_len
            else:
                res = max(res, cur_len)
                cur_len = 1
        return res
    
        # linear sol: using set to find the existing num
        s = set(nums)
        n = len(s)
        longest = 0
        
        for num in s:
            if num-1 not in s:
                seqLength = 1
                while num+seqLength in s:
                    seqLength = seqLength + 1
                longest = max(longest, seqLength)
        return longest
    
if __name__ == "__main__":
  sol = Solution()
  nums = [100, 4, 200, 1, 2, 2, 3]
  print("Result:", sol.longestConsecutive(nums))
  
