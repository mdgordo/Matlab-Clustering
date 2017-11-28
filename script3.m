%%  
% Linear SVM testing dat 
data = load('simple_iris.mat');
x = data.x;
c = data.c;
kh = @(x,y) x*y';
%%
Md = svm_train(c,x,kh);
[chat, d]=svm_classify(Md,x)
%% Plot details
red=chat==-1
blue=chat==1
[mn, in]=max(d(red))
[mx, ix]=min(d(blue))
colors=zeros(size(chat, 1), 3)
colors(red,:)=repmat([1 0 0],sum(red),1)
colors(blue,:)=repmat([0 0 1],sum(blue),1)
colors(in,:)=[0 0 0]
colors(ix,:)=[0 0 0]
scatter(x(:,1),x(:,2),36,colors)
%% plot support vectors
j=1
    for i=1:size(x,1)
        wsum(i,j)=Md.v(i,1)*x(i,j)
    end
j=2
    for i=1:size(x,1)
        wsum(i,j)=Md.v(i,1)*x(i,j)
    end
%% 
w=sum(wsum)
hold on
fimplicit(@(x,y) w(1)*x+w(2)*y-Md.beta)
hold on
fimplicit(@(x,y) w(1)*x+w(2)*y-Md.beta-1)
hold on
fimplicit(@(x,y) w(1)*x+w(2)*y-Md.beta+1)
xlim([4 7.5])
ylim([1.5 5])
print('svmscatter1.png', '-dpng')
 %%
% Quadratic kernel SVM testing data
clear all

data = load('simple_nonlinear.mat');
x = data.x;
c = data.c;
kh = @(x,y) (x*y'+1)^2
Md = svm_train(c,x,kh);

%% create points
BB=[max(x(:,1)) max(x(:,2)); min(x(:,1)) min(x(:,2))];
ranges=[BB(1,1)-BB(2,1) BB(1,2)-BB(2,2)]
for i=1:20
    y1(i)=(ranges(1)*i)/20 + BB(2,1);
    y2(i)=(ranges(2)*i)/20 + BB(2,2);
end
[X Y]=meshgrid(y1,y2)
a=0
for i=1:20
    for j=1:20
        a=a+1
        y(a,:)=[X(1,i) Y(j,1)]
    end
end
%%
[chat, d]=svm_classify(Md,y)
scatter(y(:,1),y(:,2),36,chat) 
%% plot details
red=chat==-1
blue=chat==1
[mn, in]=max(d(red))
[mx, ix]=min(d(blue))
colors=zeros(size(chat, 1), 3)
colors(red,:)=repmat([1 0 0],sum(red),1)
colors(blue,:)=repmat([0 0 1],sum(blue),1)
colors(in,:)=[0 0 0]
colors(ix,:)=[0 0 0]
scatter(y(:,1),y(:,2),36,colors)
print('svmscatter2.png', '-dpng')
%%
scatter(y(:,1),y(:,2),36,d) 
print('svmscatter3.png', '-dpng')


