clc;
clear all;
aa=dir('Topographic_attributes\dam_slope_table\dam_slope_table\');
aa4=[];
for i=3:length(aa)
    fname=[];fname1=[];aa1=[];aa2=[];aa3=[];
disp(i)
    fname=aa(i).name;
    fname1=fname(1:end-4);
aa1=xlsread(['Topographic_attributes\dam_slope_table\dam_slope_table\',fname]);
aa2=dlmread(['Dam_name_file_contain_lat_lon\',fname1]);
aa3=[aa2(:,1:2) aa1(:,5)];
aa4=[aa4;aa3];
end
dlmwrite(['Topographic_attributes\','result_dam_slope_output'],aa4,' ');

%%%%%%% 
clc;
clear all;
aa=xlsread(['Topographic_attributes\Dam_Elevation\Dam_elevation_file.xls']);
bb=[aa(:,5) aa(:,4) aa(:,6) aa(:,7) aa(:,8)];
dlmwrite(['Topographic_attributes\','result_dam_elevation__mean_min_max_output'],bb,' ');

%%%%% area%%%
clc;
clear all;
aa=xlsread(['Topographic_attributes\cr11.xlsx']);
bb=[aa(:,4) aa(:,3) bb1];
bb1=aa(:,5)./100;

dlmwrite(['Topographic_attributes\','result_dam_area_output'],bb,' ')
tt=max(bb1);
%%%% circularity ratio%%%%
dd=[aa(:,4) aa(:,3) aa(:,9)];
dlmwrite(['Topographic_attributes\','result_dam_Circularityratio_output'],dd,' ');
