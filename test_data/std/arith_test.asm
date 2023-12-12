use std::arith::Arith;

machine Main{
    degree 64;

    reg pc[@pc];
    reg A_0[<=];
    reg A_1[<=];
    reg A_2[<=];
    reg A_3[<=];
    reg B_0[<=];
    reg B_1[<=];
    reg B_2[<=];
    reg B_3[<=];
    reg C_0[<=];
    reg C_1[<=];
    reg C_2[<=];
    reg C_3[<=];
    reg D_0[<=];
    reg D_1[<=];
    reg D_2[<=];
    reg D_3[<=];
    
    reg X0[<=];
    reg X1[<=];
    reg t_0;
    reg t_1;
    reg t_2;
    reg t_3;

    Arith arith;

    instr eq0 A_3,A_2,A_1,A_0,B_3,B_2,B_1,B_0,C_3,C_2,C_1,C_0 -> D_3,D_2,D_1,D_0 = arith.eq0

    instr assert_eq X0, X1 {
        X0 = X1
    }


    function main {
        t_3,t_2,t_1,t_0 <== eq0(15,15,15,15,15,15,15,15,0,0,0,0);
        assert_eq t_0,1;
        assert_eq t_1,0;
        assert_eq t_2,0;
        assert_eq t_3,0;

        t_3,t_2,t_1,t_0 <== eq0(15,15,15,15,0,0,0,1,15,15,15,15);
        assert_eq t_0,14;
        assert_eq t_1,15;
        assert_eq t_2,15;
        assert_eq t_3,15;
    }
}