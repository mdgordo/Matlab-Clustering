%% Implements K means clustering in Matlab on data X with k clusters. 
%% Returns C = vector of classes, M = cluster centroids, C0 = initial classes, and M0 initial centroids

function [C,M,C0,M0]=KmeansClustering(X,k)
    %% pick k random centroids
    a=randperm(size(X,1));
    M0=X(a(1:3),:);
    %% dist from each point to the centroid
    for i=1:size(X,1)
        for j=1:k
            D(i,j)=pdist2(X(i,:),M0(j,:));
        end
        [mn, ind]=min(D(i,:));
        C0(i,:)=ind;
    end
    %% initialize loop
    dist=1
    oldM=M0;
    C=C0;
    %% 
    while dist>0 
        %% Calculate new centroids
        for i=1:k
            M(i,:)=mean(X(C==i,:));
        end
        for i=1:k
            move(i)=pdist2(M(i,:),oldM(i,:));
        end
        dist=sum(move);
        %% Calculate new classes
        for i=1:size(X,1)
            for j=1:k
                D2(i,j)=pdist2(X(i,:),M(j,:));
            end
            [mn, ind]=min(D2(i,:));
            C(i,:)=ind;
        end
        oldM=M;
    end
end
