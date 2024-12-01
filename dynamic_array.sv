
// array reduction( sum(), product(), and(), or(), xor() )
byte b[]={1,2,3,4}
int d = b.sum() with(int'(item>=2)) //find total count of numbers bigger or equal to 2 notice you must have an int'casting
int d = b.sum() with(item>=2?item:0)//sum of numbers bigger or equal to 2 

logic bit_arr[1024]
int y = bit_arr.sum() with(int'(item));//without the casting total result will be 0/1 ONLY!