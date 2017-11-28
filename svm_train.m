
function Md = svm_train(c,x,kh)
%% Create Mercer Matrix
    for i=1:size(x,1)
        for j=1:size(x,1)
            K(i,j)=kh(x(i,:),x(j,:));
        end
    end
%% Solve optimization problem
    C=c*transpose(c);
    H=K.*C;
    f=-ones(size(x,1),1);
    A=[];
    b=[];
    Aeq=transpose(c);
    Beq=0;
    LB=zeros(size(x,1),1);
    UB=inf(size(x,1),1);
    %%
    lambda=quadprog(H,f,A,b,Aeq,Beq,LB,UB);
    lambda=round(lambda,4)
    a=lambda>0
    lambdasparse=lambda(a)
    Ksparse=K(:,a)
    csparse=c(a)
%% calculate b and v
    for i=1:size(c,1)
        v(i,1)=c(i,1)*lambda(i,1)
    end
    %%
    for j=1:size(lambdasparse,1) 
        for i=1:size(c,1)
            bvec(i,j)=c(i,1)*lambda(i,1)*Ksparse(i,j);
        end
    end
    bsum=sum(bvec)
    bsum=bsum-transpose(csparse)
    %%  outputs
    beta=mean(bsum);
    Md = struct;
    Md.kh=kh;
    Md.v=v;
    Md.beta=beta;
    Md.x=x
    Md.a=a
end

