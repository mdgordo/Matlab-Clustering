%% randindex is a function for determining the accuracy of clusters
%% inputs are C and c, same size vectors of assigned clusters and true cluster values

function RI = randindex(C,c)
    bi=nchoosek(size(C,1),2)
    %% which points in same class - c
    for i=1:size(c,1)
        for j=1:size(c,1)
            if c(i,1)==c(j,1)
                comp(i,j)=1;
            else comp(i,j)=0;
            end
        end
    end
    %% which points in same class - C
    for i=1:size(C,1)
        for j=1:size(C,1)
            if C(i,1)==C(j,1)
                labs(i,j)=1;
            else labs(i,j)=0;
            end
        end
    end
    %% - RandIndex correct
count=labs==comp;
correct=(sum(sum(count))-size(c,1))/2;
RI=correct/bi;
end     
