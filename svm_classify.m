
function [chat,d] = svm_classify(Md,y)
%%
    for i=1:size(y,1)
        for j=1:size(Md.x,1)
            ky(j,1)=Md.kh(y(i,:),Md.x(j,:));
        end
        %%
        for j=1:size(ky,1)
            dvec(j,1)=Md.v(j,1)*ky(j,1);
        end
        %%
        d(i,1)=sum(dvec)-Md.beta
        if d(i,1)<=0
            chat(i,1)=-1;
        else chat(i,1)=1
        end
    end
end
