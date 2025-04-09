clc;
clear all;
flist1=dir('glim_raster_to_point\glim_raster_to_point\*.shp');
name=[];
st_name=[];
lat_lon=[];
n=0;
f_result=[];
final_r=[];
dam_name=[];
%area2=readtable(['all_dam_final_list.xlsx']);
for i=1:length(flist1)
    st=[];
    
    fname=flist1(i).name;
    data1=shaperead(['glim_raster_to_point\glim_raster_to_point\',fname]);
    area2=dlmread(['Dam_name_file_contain_lat_lon\',fname(1:end-4)]);
    area=[];
    soil_code=[];
    
    if length(data1)==0
        dam=string(fname(1:end-4));
        dam1=string(area2(:,1:2));
        dam2=[dam dam1];
        dam_name=[dam_name;dam2];
    end
  if length(data1)>0
    for j=1:length(data1)
        disp([i j])
        st(j,1)=data1(j).grid_code; 
%         area(j,1)=data1(j).AREA;
    end
    soiltype=unique(st);
    for y=1:length(soiltype);
        a=find(st(:,1)==soiltype(y,1));
        area(y,1)=length(a)/length(st);
    end
    
    soil_code=[soiltype area];
    s_ftable=sortrows(soil_code,2,'descend');
    if length(soiltype)>1
        st_name=[st_name;str2num(fname(1:end-4))];
        name(i,1)=s_ftable(1,1); % geology class
        name(i,2)=s_ftable(1,2); % fraction area
        name(i,3)=s_ftable(2,1); % geology class
        name(i,4)=s_ftable(2,2); % fraction area
    end

  if length(soiltype)==1
      st_name=[st_name;str2num(fname(1:end-4))];
      name(i,1)=s_ftable(1,1); % geology class
        name(i,2)=s_ftable(1,2); % fraction area
        name(i,3)=NaN; % geology class
        name(i,4)=NaN; % fraction area
  end
  end
  if length(data1)==0
      n=n+1;

% %       str=fname(1:end-4);
% %       st_name(n,1)=char(str);
  end
        lat_lon=[lat_lon;area2(1,1:2)];
      
end
%writematrix(dam_name,'empty_glim_point');
f_result=[lat_lon name];
%%
%%% comparing the lat_lon, with the help of that replacing glim values which are missing for dams
hh=dlmread('final_dam_glim_data_for_empty_id');
% Sample matrices (replace with your actual data)
matrix1 = f_result;
matrix2 = hh;

% Get the sizes of the matrices
[m1, ~] = size(matrix1);
[m2, ~] = size(matrix2);

% Loop through matrix1 and compare the first two columns with matrix2
for i = 1:m1
    for j = 1:m2
        if matrix1(i, 1) == matrix2(j, 1) && matrix1(i, 2) == matrix2(j, 2)
            % Replace the values in matrix1 with values from matrix2
            matrix1(i, 3:6) = matrix2(j, 3:6);
        end
    end
end
final_result1=matrix1; %%% emptty values are now replaced
%%%%
%%

flist=dir('C:\Users\hp\Desktop\Mayank_objective_1\new_dam_glyms\*.shp');
result=[];
for i=1:length(flist)
    fname1=flist(i).name;
    data1=shaperead(['C:\Users\hp\Desktop\Mayank_objective_1\new_dam_glyms\',fname1]);
   
    
%     for k=1:length(data1)
%           polygons = data1(k).Geometry;
%     area(k)= polyarea(polygons(:,1), polygons(:,2));
%     end
pr=[];
p=[];
area=[];
ap=[];
     for j=1:length(data1)
         disp([i j])
        pr(j,1)=data1(j).logK_Ferr_;
        p(j,1)=data1(j).Porosity_x;
        area(j,1)=data1(j).Shape_Area;
        ap(j,1)=pr(j,1)*area(j,1);
     end
     per=sum(ap)/(sum(area)*100);
     por=mean(p)/100;

     result=[result;per por];
end

final_r=[final_result1 result];
dlmwrite('geology_output',final_r,' ');

