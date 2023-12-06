machine Arith(latch,operation_id){
    /*
        EQ0: A(x1) * B(y1) + C(x2) = D (y2) * 2 ** 16 + op (y3)
    */
    operation eq0<0> x1_3,x1_2,x1_1,x1_0, y1_3,y1_2,y1_1,y1_0, x2_3,x2_2,x2_1,x2_0 -> y3_3,y3_2,y3_1,y3_0;
    pol constant latch = [0,0,0,0,0,0,0,1]*;
    col witness operation_id;

    constant %BASE = 2**4;
    let EL_RANGE = |i| i % %BASE ; 
    let CR_RANGE = |i| i % 2 ** 6;  //  64 
    
    pol constant CLK8_0 = [1,0,0,0,0,0,0,0]*;
    pol constant CLK8_1 = [0,1,0,0,0,0,0,0]*;
    pol constant CLK8_2 = [0,0,1,0,0,0,0,0]*;
    pol constant CLK8_3 = [0,0,0,1,0,0,0,0]*;
    pol constant CLK8_4 = [0,0,0,0,1,0,0,0]*;
    pol constant CLK8_5 = [0,0,0,0,0,1,0,0]*;
    pol constant CLK8_6 = [0,0,0,0,0,0,1,0]*;
    pol constant CLK8_7 = [0,0,0,0,0,0,0,1]*;

    pol commit x1_3,x1_2,x1_1,x1_0,y1_3,y1_2,y1_1,y1_0,x2_3,x2_2,x2_1,x2_0;pol witness y2_3,y2_2,y2_1,y2_0,y3_3,y3_2,y3_1,y3_0;

    x1_0*CLK8_0 + x1_1*CLK8_1 + x1_2*CLK8_2 + x1_3*CLK8_3 + y1_0*CLK8_4 + y1_1*CLK8_5 + y1_2*CLK8_6 + y1_3*CLK8_7 in EL_RANGE;
    x2_0*CLK8_0 + x2_1*CLK8_1 + x2_2*CLK8_2 + x2_3*CLK8_3 in EL_RANGE;
    
    //y3_0*CLK8_0 + y3_1*CLK8_1 + y3_2*CLK8_2 + y3_3*CLK8_3 + y2_0*CLK8_4 + y2_1*CLK8_5 + y2_2*CLK8_6 + y2_3*CLK8_7 in EL_RANGE;
    y3_0 in EL_RANGE; y3_1 in EL_RANGE; y3_2 in EL_RANGE;y3_3 in EL_RANGE; y2_0 in EL_RANGE; y2_1 in EL_RANGE;y2_2 in EL_RANGE; y2_3 in EL_RANGE;
    
    x1_0' * (1-CLK8_7) = x1_0 * (1-CLK8_7);
    x1_1' * (1-CLK8_7) = x1_1 * (1-CLK8_7);
    x1_2' * (1-CLK8_7) = x1_2 * (1-CLK8_7);
    x1_3' * (1-CLK8_7) = x1_3 * (1-CLK8_7);
    y1_0' * (1-CLK8_7) = y1_0 * (1-CLK8_7);
	y1_1' * (1-CLK8_7) = y1_1 * (1-CLK8_7);
	y1_2' * (1-CLK8_7) = y1_2 * (1-CLK8_7);
	y1_3' * (1-CLK8_7) = y1_3 * (1-CLK8_7);
    x2_0' * (1-CLK8_7) = x2_0 * (1-CLK8_7);
	x2_1' * (1-CLK8_7) = x2_1 * (1-CLK8_7);
	x2_2' * (1-CLK8_7) = x2_2 * (1-CLK8_7);
	x2_3' * (1-CLK8_7) = x2_3 * (1-CLK8_7);

    y3_0' * (1-CLK8_7) = y3_0 * (1-CLK8_7);
    y3_1' * (1-CLK8_7) = y3_1 * (1-CLK8_7);
    y3_2' * (1-CLK8_7) = y3_2 * (1-CLK8_7);
    y3_3' * (1-CLK8_7) = y3_3 * (1-CLK8_7);
    y2_0' * (1-CLK8_7) = y2_0 * (1-CLK8_7);
	y2_1' * (1-CLK8_7) = y2_1 * (1-CLK8_7);
	y2_2' * (1-CLK8_7) = y2_2 * (1-CLK8_7);
	y2_3' * (1-CLK8_7) = y2_3 * (1-CLK8_7);
    
    let carry;carry in CR_RANGE;
    
    carry * CLK8_0 = 0;

    pol eq0_0 = (x1_0 * y1_0) + x2_0 - y3_0;    
	pol eq0_1 = (x1_0 * y1_1) + (x1_1 * y1_0) + x2_1 - y3_1;    // = 27000 + 51000 + 0 - 60
	pol eq0_2 = (x1_0 * y1_2) + (x1_1 * y1_1) + (x1_2 * y1_0) + x2_2 - y3_2;
	pol eq0_3 = (x1_0 * y1_3) + (x1_1 * y1_2) + (x1_2 * y1_1) + (x1_3 * y1_0) + x2_3 - y3_3;
	pol eq0_4 = (x1_1 * y1_3) + (x1_2 * y1_2) + (x1_3 * y1_1) - y2_0;
	pol eq0_5 = (x1_2 * y1_3) + (x1_3 * y1_2) - y2_1;
	pol eq0_6 = (x1_3 * y1_3) - y2_2;
	pol eq0_7 = - y2_3;

    carry'* %BASE = carry + eq0_0 * CLK8_0 + eq0_1 * CLK8_1 + eq0_2 * CLK8_2 + eq0_3 * CLK8_3 + eq0_4 * CLK8_4 + eq0_5 * CLK8_5 + eq0_6 * CLK8_6 + eq0_7 * CLK8_7;
    //let eq0;eq0 = eq0_0 * CLK8_0 + eq0_1 * CLK8_1 + eq0_2 * CLK8_2 + eq0_3 * CLK8_3 + eq0_4 * CLK8_4 + eq0_5 * CLK8_5 + eq0_6 * CLK8_6 + eq0_7 * CLK8_7;
    //carry' * %BASE = carry + eq0;
}
