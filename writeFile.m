function file_contents = writeFile(filename,contents)
%READFILE reads a file and returns its entire contents 
%   file_contents = READFILE(filename) reads a file and returns its entire
%   contents in file_contents
%

% Load File
fid = fopen(filename,'w');
if fid
    fprintf(fid, '%c', contents);
    fclose(fid);
else
    file_contents = '';
    fprintf('Unable to write %s\n', filename);
end

end

