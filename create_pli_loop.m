%% Apply Phase Lag Index to the Specified Folder
% Computes phase lag index matrices for each matrix and saves them
% in the specified folder.
% Inputs: N_start, N_end (file numeration start and end - Integer),
% src_filenamepattern_str (input matrix name pattern - String),
% dst_filenamepattern_str (output matrix name pattern - String),
% src_foldername_str (input folder name - String),
% dst_foldername_str (output folder name - String)
%
% Note about input matrices: Matrices should be placed in a folder and
% each matrix is NxT. N is the number of channels and T is the length of
% the time series.
% Note about output matrices: Each output matrix is a NxN matrix in which
% (i, j)th element is the phase lag index between time series i and
% time series j.
% Last updated: September 26, 2016

function [ ] = create_pli_loop(N_start, N_end, src_filenamepattern_str, dst_filenamepattern_str, src_foldername_str, dst_foldername_str)
    num_channels = 62;
    mkdir(dst_foldername_str); 
    for n = N_start:N_end
        loaded = load(strcat(src_foldername_str,'/',src_filenamepattern_str, int2str(n), '.mat'));
        variables = fields(loaded);
        phase_signal = angle(hilbert(transpose(loaded.(variables{1}))));
        PLI = zeros(num_channels, num_channels);
        for i=1:num_channels-1
            for j=i+1:num_channels
                PLI(i,j) = abs(mean(sign(phase_signal(:,i) - phase_signal(:,j))));
            end
        end
        PLI = triu(PLI);
        PLI = PLI + PLI';
        PLI(eye(size(PLI))~=0)=1;
        save(strcat(dst_foldername_str,'/',dst_filenamepattern_str, int2str(n)), 'PLI');
    end
end