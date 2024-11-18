
typedef enum bit [2:0] {ADDI, SUBI, ANDI, XORI, JMP, JMPC, CALL} op_t;
typedef enum bit [1:0] {REG0, REG1, REG2, REG3} req_t;
op_t opc;
req_t req;

// Class randomization: can only randomize class member varible 
ok = randomize(opc) with { opc inside {[ANDI: ANDD], JMP, JMPC};  }; 
ok = randomize(req) with { req dist {[REG0:REG1] := 2, [REG2:REG3] := 1}; };

// Scope randomization
std::randomize(a, b, c) with {a == 4*b; b = 4*c}; // normally for func, task scope varible 
//set the random seed
process::self.srandom(10);

// Class-based randomization