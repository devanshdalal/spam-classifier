function [ ] = cvx1 %( C , trainfile , testfile  )
%Q1 svm convex optimization using cvx package
    
    C=1;
    trainfile='train-small';                   % Train file and test files
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
                n=n+1;
                hash(word)=n;
            end
        end
    end
    n
    m
    X = zeros(m,n);                             % (X,Y) matrices.
    Y = ones(m,1);
    
    for i=1:m                                   % Filling X and Y.
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
    
    Q = 0.5*(Y*Y').*(X*X');                     % Qij = 0.5*yi*yj*<xi,xj>
    cvx_begin;                                  % CVX problem
        variable a(m,1);
        minimize ( a'*Q*a - sum(a));
        subject to
            a >= 0;
            a <= C;
            Y'*a == 0;
    cvx_end;
    W = X'*(a.*Y);
    B0=-inf; B1=inf;
    
    eps=0.0001;
    for i=1:m                                  % calculating Intercept term
        if a(i)>eps
            fprintf('One of the suppoert vector is: %dth point .\n',i);
            if Y(i)==1
                B1=min(B1,X(i,:)*W);
            else
                B0=max(B0,X(i,:)*W);
            end
        end
    end
    
    B0
    B1
    B=-0.5*(B0+B1)
    
    fprintf('spam/total in train data  : %d/%d\n', sum(Y<0),m );
	S = 2*(sign( X*W + B )>=0)-1;
    fprintf('estimated spam/total in train data  : %d/%d\n', sum(S==-1),m );
    fprintf('Accuracy %d/%d.\n', sum(S==Y),m);
    
% % % % % % % % %     Classification   % % % % % % % %
    test = readFile(testfile);
    lines = strsplit(test,'\n');
    tm = size(lines,2);
    TX = zeros(tm,n);
    TY = ones(tm,1);
    
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
    
    OY = 2*(sign( TX*W + B )>=0)-1;
    fprintf('spam/total in train data  : %d/%d\n', sum(TY==-1),tm );
    fprintf('estimated spam/total in train data  : %d/%d\n', sum(OY==-1),tm );
    fprintf('accuracy in spamm : %10d %10d\n', sum((TY==OY).*(OY==-1)),tm );
    fprintf('accuracy in ham : %10d %10d\n', sum((TY==OY).*(OY==1)),tm );
    
    fprintf('Accuracy %d/%d.\n', sum(TY==OY),tm);
end

