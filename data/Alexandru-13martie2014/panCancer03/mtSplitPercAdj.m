%% FUNCTION mtSplitPerc
%   Multi-task data set splitting by percentage. 
%   
%% INPUT
%   X: {n * d} * t - input matrix
%   Y: {n * 1} * t - output matrix
%   percent: percentage of the splitting range (0, 1)
%
%% OUTPUT
%   X_sel: the split of X that has the specifid percent of samples 
%   Y_sel: the split of Y that has the specifid percent of samples 
%   X_res: the split of X that has the 1-percent of samples 
%   Y_res: the split of Y that has the 1-percent of samples 
%   selIdx: the selection index of for X_sel and Y_sel for each task
%
%% LICENSE
%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%   Copyright (C) 2011 - 2012 Jiayu Zhou and Jieping Ye 
%
%   You are suggested to first read the Manual.
%   For any problem, please contact with Jiayu Zhou via jiayu.zhou@asu.edu
%
%   Last modified on June 3, 2012.
%

function [X_sel, Y_sel, X_res, Y_res, selIdx] = mtSplitPercAdj(A, L, percent)

if percent > 1 || percent <0
    error('splitting percentage error')
end

task_num = length(A);

selIdx = cell(task_num, 0);
X_sel = cell(task_num, 0);
Y_sel = cell(task_num, 0);
X_res = cell(task_num, 0);
Y_res = cell(task_num, 0);

for t = 1: task_num
   
    n = size(A{t},1);
    task_sample_size = n*n;
    tSelIdx = randperm(task_sample_size) <task_sample_size * percent;
    
    selIdx{t} = tSelIdx;
    
    Atrain = zeros(n);
    Atrain((tSelIdx==1)) = 1;
    
    k_train = 0;
    k_test = 0;
    for i = 1:n
        for j = 1:n
           if i >j
            if Atrain(i,j) == 1
                k_train = k_train + 1;
                Xtrain(k_train,:) = [Atrain(i,:) + Atrain(j,:)];
                Ytrain(k_train) = A{t}(i,j);
            else
                k_test = k_test + 1;
                Xtest(k_test,:) = [Atrain(i,:) + Atrain(j,:)];
                Ytest(k_test) = A{t}(i,j);
            end
           end
        end
    end
    
    X_sel{t} = Xtrain;
    Y_sel{t} = Ytrain';
    X_res{t} = Xtest;
    Y_res{t} = Ytest';
    
end