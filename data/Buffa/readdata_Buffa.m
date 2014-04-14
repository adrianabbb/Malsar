

 feat = dlmread([data_path 'microRNA.xls']);
 
 clinic = dlmread([data_path 'clinic.xls']);
 
 r = dlmread([data_path 'relapse.xls']);
 
 rm = dlmread([data_path 'relapse_month.xls']);
 
 X{1} = feat;
 Y{1} = r;
 
 % ER status
 X{2} = feat;
 Y{2} = clinic(:, 4);
 
 % Nodes involved
 c3 = clinic(:,3);
 c3(find(c3)) = 1;
 X{3} = feat;
 Y{3} = c3;
 
 % Tumor size
 c4 = clinic(:,2);
 cc4 = zeros(length(c4),1);
 cc4(find(c4>2.5)) = 1;
 X{4} = feat;
 Y{4} = cc4;
 
 % Age
 c1 = clinic(:,1);
 cc1 = zeros(length(c1),1);
 cc1(find(c1>55)) = 1;
 X{5} = feat;
 Y{5} = cc1;
 
 
 