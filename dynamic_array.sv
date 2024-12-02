// array locator (find/find_index/find_first/find_first_with/find_last/find_last_with)
logic array_int [$], q_int [$];
int idx [$];
q_int = array_int.find with (item>5);
idx = array_int.find_last_index with (item == 1); 
res = array_int.unique();


// array ordering (sort, rsort, reverse, shuffle)
string qstr[$];
qstr = {"A","D","C","B","E"}; 
qstr.sort; // {"A","B","C","D","E"}
qstr.reverse; // {"E","D","C","B","A"}
qstr.shuffle; // {"D","C","E","A","B"}


// array reduction( sum(), product(), and(), or(), xor() )
byte b[]={1,2,3,4};
int d = b.sum() with(int'(item>=2)); //find total count of numbers bigger or equal to 2 notice you must have an int'casting
int d = b.sum() with(item>=2?item:0); //sum of numbers bigger or equal to 2 

logic bit_arr[1024];
int y = bit_arr.sum() with(int'(item)); //without the casting total result will be 0/1 ONLY!