/*
    EQ0: A(x1) * B(y1) + C(x2) = D (y2) * 2 ** 16 + op (y3)
*/
machine Arith(latch,operation_id){
    operation eq0<0> x1[3],x1[2],x1[1],x1[0], y1[3],y1[2],y1[1],y1[0], x2[3],x2[2],x2[1],x2[0] -> y3[3],y3[2],y3[1],y3[0];
    pol constant latch = [0,0,0,0,0,0,0,1]*;
    col witness operation_id;

    constant %N = 4; // chunks
    constant %BASE = 2**4;
    let EL_RANGE = |i| i % %BASE ; 
    let CR_RANGE = |i| i % 2 ** 6;  //  64 

    pol commit x1[%N],y1[%N],x2[%N]; pol witness y2[%N],y3[%N];

    let clock = |j, row| row % 8 == j;
    let CLK_0 = |row| clock(0, row);
    let CLK_1 = |row| clock(1, row);
    let CLK_2 = |row| clock(2, row);
    let CLK_3 = |row| clock(3, row);
    let CLK_4 = |row| clock(4, row);
    let CLK_5 = |row| clock(5, row);
    let CLK_6 = |row| clock(6, row);
    let CLK_7 = |row| clock(7, row);
    let CLK = [CLK_0,CLK_1,CLK_2,CLK_3,CLK_4,CLK_5,CLK_6,CLK_7];

    let fold = |length, f, initial, folder| match length {
        0 => initial,
        _ => folder(fold(length - 1, f, initial, folder), f(length - 1))
    };

    let make_array = |length, f| fold(length, f, [], |acc, e| acc + [e]);
    let sum = |length, f| fold(length, f, 0, |acc, e| acc + e);

    let fixed_inside_block = [|x,clk| (x - x') * (1 - clk) == 0][0];

    let array_as_fun = |arr, len| |i| match i < len {
		1 => arr[i],
		_ => 0,
	};
    let prepend_zeros = |arr, amount| |i| match i < amount { 1 => 0, _ => arr(i - amount) };
    let dot_prod = |n, a, b| sum(n, |i| a(i) * b(i));
	let product = |a, b| |n| dot_prod(n + 1, a, |i| b(n - i));

    make_array(%N, |i| fixed_inside_block(x1[i],CLK[2*%N - 1]));
    make_array(%N, |i| fixed_inside_block(y1[i],CLK[2*%N - 1]));
    make_array(%N, |i| fixed_inside_block(x2[i],CLK[2*%N - 1]));
    make_array(%N, |i| fixed_inside_block(y2[i],CLK[2*%N - 1]));
    make_array(%N, |i| fixed_inside_block(y3[i],CLK[2*%N - 1]));

    sum(%N, |i| x1[i] * CLK[i]) + sum(%N, |i| y1[i] * CLK[4 + i]) in EL_RANGE;
    sum(%N, |i| x2[i] * CLK[i]) in EL_RANGE;
    //sum(4, |i| y3[i] * CLK[i]) + sum(4, |i| y2[i] * CLK[4 + i]) in EL_RANGE;
    y3[0] in EL_RANGE; y3[1] in EL_RANGE; y3[2] in EL_RANGE;y3[3] in EL_RANGE; y2[0] in EL_RANGE; y2[1] in EL_RANGE;y2[2] in EL_RANGE; y2[3] in EL_RANGE;

    let x1f = array_as_fun(x1, %N);
    let y1f = array_as_fun(y1, %N);
	let x2f = array_as_fun(x2, %N);
	let y2f = array_as_fun(y2, %N);
	let y3f = array_as_fun(y3, %N);

    let eq0 = [|nr| product(x1f, y1f)(nr)+ x2f(nr)- prepend_zeros(y2f, %N)(nr) - y3f(nr)][0];

    let carry;carry in CR_RANGE;

    carry * CLK[0] = 0;

    sum(2*%N, |i| eq0(i) * CLK[i]) + carry = carry' * %BASE;

}
