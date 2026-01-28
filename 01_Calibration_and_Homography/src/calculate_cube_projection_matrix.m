
for k=1:4
    switch k
        case 1
            vertices=vertices1;
        case 2
            vertices=vertices2;
        case 3
            vertices=vertices3;
        case 4
            vertices=vertices4;
    end

    for j=1:6
        switch j
            case 1
                a=1; b=2; c=3; d=4;
            case 2
                a=1; b=2; c=6; d=5;
            case 3
                a=1; b=5; c=8; d=4;
            case 4
                a=5; b=6; c=7; d=8;
            case 5
                a=4; b=3; c=7; d=8;
            case 6
                a=2; b=6; c=7; d=3;

        end
        P1 = vertices(a,:)';
        P2 = vertices(b,:)';
        P3 = vertices(c,:)';
        P4 = vertices(d,:)';

        wP1_ = [P1;1];
        wP2_ = [P2;1];
        wP3_ = [P3;1];
        wP4_ = [P4;1];

        p1_ = K * [cRw ctw] * wP1_;
        p2_ = K * [cRw ctw] * wP2_;
        p3_ = K * [cRw ctw] * wP3_;
        p4_ = K * [cRw ctw] * wP4_;

        p1 = p1_(1:2)/p1_(3);
        p2 = p2_(1:2)/p2_(3);
        p3 = p3_(1:2)/p3_(3);
        p4 = p4_(1:2)/p4_(3);

        pc1 = round (p1);
        pc2 = round (p2);
        pc3 = round (p3);
        pc4 = round (p4);



        switch k
            case 1
                mpcc1(j*2-1:j*2,:)=[pc1,pc2,pc3,pc4,pc1];
            case 2
                mpcc2(j*2-1:j*2,:)=[pc1,pc2,pc3,pc4,pc1];
            case 3
                mpcc3(j*2-1:j*2,:)=[pc1,pc2,pc3,pc4,pc1];
            case 4
                mpcc4(j*2-1:j*2,:)=[pc1,pc2,pc3,pc4,pc1];
        end



    end
end