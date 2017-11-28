%%
clear all
data = load('cluster_1.mat');
x = data.x;

%% Test on unlabeled data
%% scramble data, calculate distances, epsilon
rng(3);
idx=randperm(size(x,1));
xrand=x(idx,:);
dist=@(y,Y) pdist2(y,Y)
D=pdist(xrand);
Dsq=squareform(D);
epsilon=prctile(D,1);
X=xrand;

%% calculate min_pts
for i=1:size(x,1)
    neighbors(i,1)=sum(Dsq(i,:)<=epsilon)-1;
end
min_pts=prctile(neighbors,10)

%% scan and plots
[C1,point_type]=dbscan(X,min_pts,epsilon,dist)
scatter(X(:,1),X(:,2),36,C1)
colormap jet
print('dbscan1.png', '-dpng')

%%
scatter(X(:,1),X(:,2),36,point_type)
print('dbscan2.png', '-dpng')
%% repeat w/different epsilon
epsilon=prctile(D,.3);
for i=1:size(x,1)
    neighbors(i,1)=sum(Dsq(i,:)<=epsilon)-1;
end
min_pts=prctile(neighbors,10)

%% scan and plots
[C2,point_type]=dbscan(X,min_pts,epsilon,dist)
scatter(X(:,1),X(:,2),36,C2)
colormap lines
print('dbscan3.png', '-dpng')
%%
scatter(X(:,1),X(:,2),36,point_type)
colormap jet
print('dbscan4.png', '-dpng')
%% Test on labeled data
clear all 
data = load('cluster_2.mat');
x = data.x;
c = data.c;

%% 27 iterations
% set up
e=[3 5 7];
m=[10 20 30];
for i=1:3
    rng(i);
    idx{i}=randperm(size(x,1));
    X{i}=x(idx{i},:);
    D{i}=pdist(X{i});
    A{i}=c(idx{i},:);
    for z=1:size(X{i},1)
        for q=1:size(X{i},1)
            if A{i}(z)==A{i}(q)
                labels{i}(z,q)=1;
            else labels{i}(z,q)=0;
            end
        end
    end
end
dist=@(y,Y) pdist2(y,Y)

%% Cluster
for i=1:3
    for j=1:3
        for k=1:3
            Dsq=squareform(D{i});
            epsilon=prctile(D{i},e(j));
            for l=1:size(Dsq,1)
                neighbors(l,1)=sum(Dsq(l,:)<=epsilon)-1;
            end
            min_pts=prctile(neighbors,m(k));
            [C{i,j,k},point_type{i,j,k}]=dbscan(X{i},min_pts,epsilon,dist);
            %% RandIndex
            RI(i,j,k)=randindex(C{i,j,k},c)
        end
    end
end
            
%% i=1 j=1 k=2 gives highest RandIndex, (3,3,1) gives lowest

%% plots
scatter(X{1}(:,1),X{1}(:,2),36,C{1,1,2})
print('dbscan5.png', '-dpng')
%%
scatter(X{1}(:,1),X{1}(:,2),36,C{3,3,1})
print('dbscan6.png', '-dpng')