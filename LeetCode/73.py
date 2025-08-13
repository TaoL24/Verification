from typing import List


class Solution:
    def setZeroes(self, matrix: List[List[int]]) -> None:
        """
        Do not return anything, modify matrix in-place instead.
        """
        row = len(matrix)
        col = len(matrix[0])

        rowZero = False

        for r in range(row):
            for c in range(col):
                if matrix[r][c] == 0:
                    matrix[0][c] = 0
                    if r == 0:
                        rowZero = True
                    else:
                        matrix[r][0] = 0
        
        for r in range(1, row):
            if matrix[r][0] == 0:
                matrix[r] = [0]*col
        
        for r in range(1, row):
            for c in range(1, col):
                if matrix[0][c] == 0:
                    matrix[r][c] = 0

        # clear first col if ness
        if matrix[0][0] == 0:
            for r in range(row):
                matrix[r][0] = 0

        # clear first row if ness
        if rowZero:
            matrix[0] = [0]*col  

if __name__ == "__main__":
  sol = Solution()
  nums = [[-4,-2147483648,6,-7,0],[-8,6,-8,-6,0],[2147483647,2,-9,-6,-10]]
  sol.setZeroes(nums)
  print("Result:", nums)