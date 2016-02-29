function [ ] = cvx2  %( C , gamma , trainfile , testfile )
%Q1 svm convex optimization using cvx package
    
    C=1;
    trainfile='train-small';
    gamma = 0.00025;
    testfile='test';

    % READING FILES
    input = readFile(trainfile);
    lines = strsplit(input,'\n');
    hash = containers.Map;                      % Dictionary
    m = size(lines,2); n=0;
    for i=1:m                                   % Building the dictionary
        words=strsplit(char(lines(i)));
        l = length(words);
        for j=3:2:l
            word = char(words(j));
            if not( hash.isKey(word) )
                n = n+1;
                hash(word)=n;
            end
        end
    end
    n
    m
    X = zeros(m,n);
    Y = ones(m,1);
    
    for i=1:m                               % Filling X and Y.
        if strcmp(lines(i),''); continue; end;
        words=strsplit(char(lines(i)));
        if strcmp(words(2),'spam')
            Y(i)=-1;
        end
        l = length(words);
        for j=3:2:l
            word = char(words(j));
            X(i,hash(word))=str2num( char(words(j+1)) );
        end
    end
    
    Q = zeros(m,m);
    K = zeros(m,m);
    for i = 1:m                           % Qij = 0.5*yi*yj*K(xi,xj)
        disp(i);
        for j = 1:m
            d=(X(i,:)-X(j,:));
            K(i,j)=exp(-(d*d'*gamma));
            Q(i,j)=0.5*Y(i,1)*Y(j,1)*K(i,j);
        end
    end

    cvx_begin;                                  % cvx problem
        variable a(m,1);
        minimize ( a'*Q*a - sum(a));
        subject to
            a >= 0;
            a <= C;
            Y'*a == 0;
    cvx_end;
    
    B0=-inf; B1=inf;
    eps=0.0001;
    aY = a.*Y;
    for i=1:m                                  % calculating Intercept term
        if a(i)>eps
            fprintf('One of the suppoert vector is: %dth point .\n',i);
            if Y(i)==1
                B1=min(B1, sum(aY.*K(:,i)) );
            else
                B0=max(B0, sum(aY.*K(:,i)) );
            end
        end
    end
    
    B0
    B1
    B=-0.5*(B0+B1)
    
    OY = arrayfun(@(x) clip(x), sum(repmat(aY,1,m).*K)+B )';
    
    fprintf('spam/total in test data  : %d/%d\n', sum(Y==-1),m );
    fprintf('estimated spam/total in test data  : %d/%d\n', sum(OY==-1),m );
    fprintf('Accuracy %d/%d.\n', sum(OY==Y),m);

% % % % % % % % %     Classification   % % % % % % % % 
    input = readFile(testfile);
    lines = strsplit(input,'\n');
    tm = size(lines,2);
    
    TX = zeros(tm,n);
    TY = ones(tm,1);
    LY = ones(tm,1);   % Learnt Y for test cases
    
    for i=1:tm                              %Building (TX,TY) for testing
        if strcmp(lines(i),''); continue; end;
        words=strsplit(char(lines(i)));
        if strcmp(words(2),'spam')
            TY(i)=-1;
        end
        l = length(words);
        for j=3:2:l
            word = char(words(j));
            if hash.isKey(word)
                TX(i,hash(word))=str2num( char(words(j+1)) );
            end
        end
    end
    
    for i=1:tm
        acc=0;
        for j=1:m
            acc = acc + aY(j,1)*exp( -gamma*norm(X(j,:)-TX(i,:)).^2 );
        end    
        LY(i,1)=clip(acc);
    end
    
    fprintf('spam/total in test data  : %d/%d\n', sum(TY<0),tm );
    fprintf('estimated spam/total in test data  : %d/%d\n', sum(LY<0),tm );
    fprintf('Accuracy in testing : %d/%d.\n',  sum(LY==TY) ,tm);

    fprintf('accuracy in spamm : %10d %10d\n', sum((TY==LY).*(LY<0)),tm );
    fprintf('accuracy in ham : %10d %10d\n', sum((TY==LY).*(LY>0)),tm );
    
end

function  x = clip(x)
    if x>=0
        x=1;
    else
        x=-1;
    end 
end