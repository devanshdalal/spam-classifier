function [ ] = d2  %( trainfile , testfile )
%P4 SVM spam classification using Libsvm in matlab
    
    trainfile = 'train';                 % Train file and test files
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
    writeFile('LibSvmInptR.txt',out);
    
%     Start Using LibSvm now
    [train_labels, train_features] = libsvmread('LibSvmInptR.txt');
    disp('Train Data Loaded in LibSvm');
    model = svmtrain(train_labels, train_features, '-s 0 -t 2 -c 1 -g 0.00025');
    
    disp('Now LibSvm has learnt the model ...');
    disp('Accracy in train data itself: ');
    svmpredict(train_labels,train_features,model);

%   READING FILES
    test = readFile(testfile);
    lines = strsplit(test,'\n');
    tm = size(lines,2);
    TX = zeros(tm,n);
    TY = ones(tm,1);
    
    tout='';
    for i=1:tm
        if strcmp(lines(i),''); continue; end;
        words=strsplit(char(lines(i)));
        if strcmp(words(2),'spam')
            TY(i)=-1;
            tout=[tout '-1  '];
        else
            tout=[tout '1  '];
        end
        l = length(words);
        match = [];
        for j=3:2:l
            word = char(words(j));
            if hash.isKey(word)
                TX(i,hash(word))=str2num( char(words(j+1)) );
                match = [match ; hash(word)  str2num( char(words(j+1)) ) ];
            end
        end
        match=sortrows(match);
        for i=1:size(match,1)
            tout=[tout , num2str(match(i,1)),':',num2str(match(i,2)),' ' ];
        end
        tout = [ tout char(10)];
    end
    writeFile('LibSvmTesting.txt',tout);
    
    [test_labels, test_features] = libsvmread('LibSvmTesting.txt');
    disp('Test File Loaded in LibSvm. Wait for a few seconds for accuracy');
    %   Testing begins now
    
    my=svmpredict(test_labels,test_features,model);
    
    
end

