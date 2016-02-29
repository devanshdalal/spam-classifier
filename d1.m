function [ ] = d1 %( trainfile , testfile )
%P4 SVM spam classification using Libsvm in matlab(Linear Kernel)
    
    trainfile = 'train';              % Train file and test files
    testfile = 'test';
%     addpath('/home/btech/cs1120224/Documents/MATLAB/libsvm-3.20/matlab');

    % READING FILES
    input = readFile(trainfile);
    lines = strsplit(input,'\n');
    hash = containers.Map;
    m = size(lines,2); n=0;
    for i=1:m
        words=strsplit(char(lines(i)));
        l = length(words);
        for j=3:2:l
            word = char(words(j));
%             if isempty(word); continue; end;
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
    
    out='';
    for i=1:m                       % converting to LibSvm format
        if strcmp(lines(i),''); continue; end;
        words=strsplit(char(lines(i)));
        if strcmp(words(2),'spam')
            Y(i)=-1;
            out=[out '-1  '];
        else
            out=[out '1  '];
        end
        l = length(words);
        match = [];
        for j=3:2:l
            word = char(words(j));
            X(i,hash(word))=str2num( char(words(j+1)) );
            match = [match ; hash(word)  str2num( char(words(j+1)) ) ];
        end
        match=sortrows(match);
        for i=1:size(match,1)
            out=[out , num2str(match(i,1)),':',num2str(match(i,2)),' ' ];
        end
        out = [ out char(10)];
    end
    writeFile('LibSvmInpt.txt',out);
    
%     Start Using LibSvm now
    [trainlabels, trainfeatures] = libsvmread('LibSvmInpt.txt');
    disp('File Loaded in LibSvm.');
    disp('Now LibSvm is solving our problem ....');
    model = svmtrain(trainlabels, trainfeatures, '-s 0 -t 0 -c 1');
    W = model.SVs' * model.sv_coef;
    B = -model.rho;
    
    fprintf('spam/total in train data  : %d/%d\n', sum(Y<0),m );
	S = 2*(sign( X*W + B )>=0)-1;
    fprintf('estimated spam/total in train data  : %d/%d\n', sum(S==-1),m );
    fprintf('Accuracy %d/%d.\n', sum(S==Y),m);
    
%      Testing begins now
%   READING FILES
    test = readFile(testfile);
    lines = strsplit(test,'\n');
    tm = size(lines,2);
    TX = zeros(tm,n);
    TY = ones(tm,1);
    
    for i=1:tm
        if strcmp(lines(i),''); continue; end;
        words=strsplit(char(lines(i)));
        if strcmp(words(2),'spam')
            TY(i)=-1;
        end
        l = length(words);
        for j=3:2:l
            word = char(words(j)) ;
            if hash.isKey(word)
                TX(i,hash(word))=str2num( char(words(j+1)) );
            end
        end
    end
    
    OY = 2*(sign( TX*W + B )>=0)-1;
    fprintf('spam/total in train data  : %d/%d\n', sum(TY==-1),tm );
    fprintf('estimated spam/total in train data  : %d/%d\n', sum(OY==-1),tm );
    
    fprintf('Accuracy %d/%d.\n', sum(TY==OY),tm);
    
end

