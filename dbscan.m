
function [C,point_type]=dbscan(X,min_pts,epsilon,dist)
    v=zeros(size(X,1),1);
    C=zeros(size(X,1),1);
    for i=1:size(X,1);
        if v(i,1)==1;
            continue;
        else dtemp=dist(X(i,:),X);
            if sum(dtemp<=epsilon)-1<min_pts;
                continue;
            else
            point_type(i,1)=1;
            v(i,1)=1;
            a=max(C)+1;
            C(i,1)=a;
            Q=find(dtemp<=epsilon);
            while size(Q,2)>0;
                if v(Q(1),1)==1;
                    Q(:,1)=[];
                else C(Q(1),1)=a;
                    v(Q(1),1)=1;
                    dtempy=dist(X(Q(1),:),X);
                    if sum(dtempy<=epsilon)-1<min_pts;
                        point_type(Q(1),1)=2;
                        Q(:,1)=[];
                    else 
                    point_type(Q(1),1)=1;
                    Z=find(dtempy<=epsilon);
                    Q=[Q Z];
                    Q(:,1)=[];
                    end
                end       
            end
            end
        end
    point_type(v==0,1)=3;
    end
end
        