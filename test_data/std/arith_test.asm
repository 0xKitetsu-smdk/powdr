use std::arith::Arith;

machine Main{
    degree 256;

    reg pc[@pc];
    reg A_0[<=];reg A_1[<=];reg A_2[<=];reg A_3[<=];reg A_4[<=];reg A_5[<=];reg A_6[<=];reg A_7[<=];reg A_8[<=];reg A_9[<=];reg A_10[<=];reg A_11[<=];reg A_12[<=];reg A_13[<=];reg A_14[<=];reg A_15[<=];
    reg B_0[<=];reg B_1[<=];reg B_2[<=];reg B_3[<=];reg B_4[<=];reg B_5[<=];reg B_6[<=];reg B_7[<=];reg B_8[<=];reg B_9[<=];reg B_10[<=];reg B_11[<=];reg B_12[<=];reg B_13[<=];reg B_14[<=];reg B_15[<=];
    reg C_0[<=];reg C_1[<=];reg C_2[<=];reg C_3[<=];reg C_4[<=];reg C_5[<=];reg C_6[<=];reg C_7[<=];reg C_8[<=];reg C_9[<=];reg C_10[<=];reg C_11[<=];reg C_12[<=];reg C_13[<=];reg C_14[<=];reg C_15[<=];
    reg D_0[<=];reg D_1[<=];reg D_2[<=];reg D_3[<=];reg D_4[<=];reg D_5[<=];reg D_6[<=];reg D_7[<=];reg D_8[<=];reg D_9[<=];reg D_10[<=];reg D_11[<=];reg D_12[<=];reg D_13[<=];reg D_14[<=];reg D_15[<=];
    
    reg t_0;reg t_1;reg t_2;reg t_3;reg t_4;reg t_5;reg t_6;reg t_7;reg t_8;reg t_9;reg t_10;reg t_11;reg t_12;reg t_13;reg t_14;reg t_15;

    Arith arith;

    instr eq0 A_15,A_14,A_13,A_12,A_11,A_10,A_9,A_8,A_7,A_6,A_5,A_4,A_3,A_2,A_1,A_0, B_15,B_14,B_13,B_12,B_11,B_10,B_9,B_8,B_7,B_6,B_5,B_4,B_3,B_2,B_1,B_0, C_15,C_14,C_13,C_12,C_11,C_10,C_9,C_8,C_7,C_6,C_5,C_4,C_3,C_2,C_1,C_0 -> D_15,D_14,D_13,D_12,D_11,D_10,D_9,D_8,D_7,D_6,D_5,D_4,D_3,D_2,D_1,D_0 = arith.eq0

    instr assert_eq4 A_3,A_2,A_1,A_0,B_3,B_2,B_1,B_0 {
        A_3 = B_3,A_2 = B_2,A_1 = B_1,A_0 = B_0
    }

    instr assert_eq16 A_15,A_14,A_13,A_12,A_11,A_10,A_9,A_8,A_7,A_6,A_5,A_4,A_3,A_2,A_1,A_0, B_15,B_14,B_13,B_12,B_11,B_10,B_9,B_8,B_7,B_6,B_5,B_4,B_3,B_2,B_1,B_0 {
        A_15 = B_15,A_14 = B_14,A_13 = B_13,A_12 = B_12,A_11 = B_11,A_10 = B_10,A_9 = B_9,A_8 = B_8,A_7 = B_7,A_6 = B_6,A_5 = B_5,A_4 = B_4,A_3 = B_3,A_2 = B_2,A_1 = B_1,A_0 = B_0
    }


    function main {
        t_15,t_14,t_13,t_12,t_11,t_10,t_9,t_8,t_7,t_6,t_5,t_4,t_3,t_2,t_1,t_0 <== eq0(15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15, 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
        assert_eq16 t_15,t_14,t_13,t_12,t_11,t_10,t_9,t_8,t_7,t_6,t_5,t_4,t_3,t_2,t_1,t_0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1;

        t_15,t_14,t_13,t_12,t_11,t_10,t_9,t_8,t_7,t_6,t_5,t_4,t_3,t_2,t_1,t_0 <== eq0(15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1, 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15);
        assert_eq16 t_15,t_14,t_13,t_12,t_11,t_10,t_9,t_8,t_7,t_6,t_5,t_4,t_3,t_2,t_1,t_0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,14;
    }
}