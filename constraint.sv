// constraint that ensures each element of the array a is unique in SystemVerilog
rand bit [31:0] a [99:0];
constraint c1 {
    foreach(a[i]) begin
        foreach (a[j])
            if(i!=j) a[i]!=a[j];
    end
    // unique a;
}

// how to write a one hot/ one cold constraint? do not use function
rand bit [31:0] b;
constraint one_hot {
    b & (b - 1) == 0 && b != 0;
}

constraint one_cold {
    b & (b + 1) == 0 && ~b != 0;
}

// how to write a constraint for 8 queue? board[8][8]
rand bit [7:0] board[8][8];
constraint c_queue { 
    foreach(board[i][j]) begin
        board[i][j].size() <= 8;
    end
} 

// how to write a constraint to constraint the size of dynamic array 
rand bit [7:0] arr [];
constraint size_arr {
    $size(arr) <= 'd8;
}

// how to write a constraint for increasing array
rand bit [7:0] arr3 [7:0]
constraint incre {
    foreach(arr3[i]) begin
        if (i < arr3.size() - 1) 
            arr3[i] < arr3[i+1];
    end
}