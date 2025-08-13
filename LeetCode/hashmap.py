class HashMap:
  def __init__(self):
    self.size = 100
    self.bucket = [ [] for _ in range(len(self.size)) ]

  def __hash__(self, key):
    return hash(key) % self.size 
  
  def put(self, key, value):
    idx = self.__hash__(key)
    for i, (k,v) in enumerate(self.bucket):
      if k == key: # hash collision
        self.bucket[idx][i].append((key,value))
        return
    self.bucket[idx] = (key, value)

  def get(self, key) -> int:
    idx = self.__hash__(key)
    for (k,v) in self.bucket[idx]:
      if k == key:
        return v
    return -1
  
    