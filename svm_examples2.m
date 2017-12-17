%% Testing parameters of SVM classifiers on various datasets
%% uses libsvm from: https://www.csie.ntu.edu.tw/~cjlin/libsvm/#download

addpath('libsvm-3.22/matlab/',0)

%% Linear SVM
%% load and visualize data
data = load('mixed.mat');
c = data.c;
x = data.x;
scatter(x(:,1),x(:,2),36,c)
colormap(winter)
print('scatter1.png', '-dpng')

%% Train SVM classifier using various values for 'nu' and evaluate using 4-fold cross validation
%% split data into 4 random parts
rng(3)
idx=randperm(size(c,1));
for i=1:4
    start=((i-1)*size(c,1)/4)+1;
    fin=i*size(c,1)/4;
    ip(i,:)=idx(start:fin);
end

%% Train and evaluate classifier for different values of nu
for j=1:50
    nu(j)=.1+(j-1)/100;
    args{j}=['-s 1 -t 0 -n ' num2str(nu(j))];
    for i=1:4
        xtemp=x;
        xtemp(ip(i,:),:)=[];
        prt{i}=xtemp;
        ctemp=c;
        ctemp(ip(i,:),:)=[];
        cprt{i}=ctemp;
        ctest{i}=c(ip(i,:),:);
        xtest{i}=x(ip(i,:),:);
        MD{i}=svmtrain(cprt{i},prt{i},args{j});
        chat{i}=svmpredict(ctest{i},xtest{i},MD{i});
        confusion{i}=confusionmat(chat{i},ctest{i});
        accuracy(i)=trace(confusion{i})/sum(sum(confusion{i}));
    end
    acc(j)=sum(accuracy)/4;
end

%%
nu=transpose(nu);
acc=transpose(acc);

%% plot accuracy vs nu
[mx,ind]=max(acc)
plot(nu, acc,'Color','blue','MarkerIndices',ind,'Marker','pentagram','MarkerFaceColor','red','MarkerEdgeColor','red','MarkerSize',10)
xlabel('nu')
ylabel('acc')
print('scatter2.png', '-dpng')

%% Train for optimal nu, predict new points
args=['-s 1 -t 0 -n ' num2str(nu(ind))]
Mdopt=svmtrain(c,x,args)
%%
BB=[max(x(:,1)) max(x(:,2)); min(x(:,1)) min(x(:,2))];
ranges=[BB(1,1)-BB(2,1) BB(1,2)-BB(2,2)]
for i=1:30
    y1(i)=(ranges(1)*i)/30 + BB(2,1);
    y2(i)=(ranges(2)*i)/30 + BB(2,2);
end
[X Y]=meshgrid(y1,y2)
a=0
for i=1:30
    for j=1:30
        a=a+1
        y(a,:)=[X(1,i) Y(j,1)]
    end
end
%% visualize decision area
cs=rand(900,1)
chat=svmpredict(cs,y,Mdopt)
scatter(y(:,1),y(:,2),36,chat)
colormap(winter)
print('scatter3.png', '-dpng')


%% Kernal SVM
% RBF Kernel SVM data
clear all
data = load('target.mat');
c = data.c;
x = data.x;
scatter(x(:,1),x(:,2),36,c)
colormap(winter)
print('scatter4.png', '-dpng')

%% Train SVM classifier using various values for gamma and evaluate using 4-fold cross validation
rng(3)
idx=randperm(size(c,1));
for i=1:4
    start=((i-1)*size(c,1)/4)+1;
    fin=i*size(c,1)/4;
    ip(i,:)=idx(start:fin);
end
%% Train and evaluate classifier for different values of gamma
for j=1:31
    gam(j)=2^(j-15)
    args{j}=['-s 1 -t 2 -n 0.5 -g ' num2str(gam(j))];
    for i=1:4
        xtemp=x;
        xtemp(ip(i,:),:)=[];
        prt{i}=xtemp;
        ctemp=c;
        ctemp(ip(i,:),:)=[];
        cprt{i}=ctemp;
        ctest{i}=c(ip(i,:),:);
        xtest{i}=x(ip(i,:),:);
        MD{i}=svmtrain(cprt{i},prt{i},args{j});
        chat{i}=svmpredict(ctest{i},xtest{i},MD{i});
        confusion{i}=confusionmat(chat{i},ctest{i});
        accuracy(i)=trace(confusion{i})/sum(sum(confusion{i}));
    end
    acc(j)=sum(accuracy)/4;
end

%% plot accuracy vs gamma
[mx,ind]=max(acc)
plot(log2(gam), acc,'Color','blue','MarkerIndices',ind,'Marker','pentagram','MarkerFaceColor','red','MarkerEdgeColor','red','MarkerSize',10)
xlabel('log2(gam)')
ylabel('acc')
print('scatter5.png', '-dpng')

%% Train for optimal gam, predict new points
args=['-s 1 -t 2 -n .5 -g ' num2str(gam(ind))]
Mdopt=svmtrain(c,x,args)
%% create points
BB=[max(x(:,1)) max(x(:,2)); min(x(:,1)) min(x(:,2))];
ranges=[BB(1,1)-BB(2,1) BB(1,2)-BB(2,2)]
for i=1:30
    y1(i)=(ranges(1)*i)/30 + BB(2,1);
    y2(i)=(ranges(2)*i)/30 + BB(2,2);
end
[X Y]=meshgrid(y1,y2)
a=0
for i=1:30
    for j=1:30
        a=a+1
        y(a,:)=[X(1,i) Y(j,1)]
    end
end

%% visualize decision area
cs=rand(900,1)
chat=svmpredict(cs,y,Mdopt)
scatter(y(:,1),y(:,2),36,chat)
colormap(winter)
print('scatter6.png', '-dpng')
