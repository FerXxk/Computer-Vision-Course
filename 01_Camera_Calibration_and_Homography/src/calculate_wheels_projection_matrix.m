


for p=1:50
    for r=1:4
        for j=1:2
        switch r
            case 1
                if(j==1)
                    ruedas=ruedas11;
                else
                    ruedas=ruedas12;
                end
            case 2
                if(j==1)
                   ruedas=ruedas21;
                else
                    ruedas=ruedas22;
                end
            case 3
                if(j==1)
                    ruedas=ruedas31;
                else
                    ruedas=ruedas32;
                end
            case 4
                if(j==1)
                    ruedas=ruedas41;
                else
                    ruedas=ruedas42;
                end
        end

       
            
            P1 = ruedas(p,:);

            wP1_ = [P1';1];
          

            p1_ = K * [cRw ctw] * wP1_;
           

            p1 = p1_(1:2)/p1_(3);
          
            pc1 = round (p1);
          
            switch r
                case 1
                     if(j==1)
                    mruedas11(p,:)=pc1;
                        else
                     mruedas12(p,:)=pc1;
                    end
                case 2
                    if(j==1)
                    mruedas21(p,:)=pc1;
                        else
                     mruedas22(p,:)=pc1;
                    end
                case 3
                    if(j==1)
                    mruedas31(p,:)=pc1;
                        else
                     mruedas32(p,:)=pc1;
                    end
                case 4
                   if(j==1)
                    mruedas41(p,:)=pc1;
                        else
                     mruedas42(p,:)=pc1;
                    end
            end


        end
    end
end