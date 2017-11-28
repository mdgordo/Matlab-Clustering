data = load('iris_num.mat'); 
x = data.x;
c = data.c;
k=3;
X=x(:,1:2);
%% 2 dimensional clusters
[C,M,C0,M0]=KmeansClustering(X,k)

%%
figure
scatter(X(:,1),X(:,2),36,C0)
hold on
scatter(M0(:,1),M0(:,2),'+','MarkerEdgeColor','r')
print('kmeans1.png', '-dpng')

figure
scatter(X(:,1),X(:,2),36,C)
hold on
scatter(M(:,1),M(:,2),'+','MarkerEdgeColor','r')
print('kmeans2.png', '-dpng')

%% 4 dimensional clusters, accuracy
X=x
for i=1:3
    [C,M,C0,M0]=KmeansClustering(X,k)
    conf=confusionmat(C,c)
    tot=sum(sum(conf))
    correct=sum(max(conf,[],2))
    accuracy(i)=correct/tot
end

%% Rand Index 
for i=1:3
    [C,M,C0,M0]=KmeansClustering(X,k)
    RI(i)=randindex(C,c)
end

%% Compare RandIndex, SSE, and accuracy
clear C M C0 M0 conf tot correct accuracy RI errs SSE
for i=1:50
    [C{i},M{i}]=KmeansClustering(X,k);
    RI(i,1)=randindex(C{i},c);
    conf=confusionmat(C{i},c);
    tot=sum(sum(conf));
    correct=sum(max(conf,[],2));
    accuracy(i,1)=correct/tot
    for j=1:k
        errs{j}=pdist2(X(C{i}==j,:),M{i}(j,:))
    end
    for j=1:k
        sums(j)=sum(errs{j}.^2)
    end
    SSE(i,1)=sum(sums)
end
%%
histogram(accuracy,4)
title('histogram of accuracy')
print('acchist.png', '-dpng')
%%
histogram(SSE,4)
title('histogram of SSE')
print('SSEhist.png', '-dpng')
%%
scatter(accuracy,SSE)
title('Scatter of accuracy vs SSE')
xlabel('Accuracy')
ylabel('SSE')
print('scatteraccvsse.png', '-dpng')
    
