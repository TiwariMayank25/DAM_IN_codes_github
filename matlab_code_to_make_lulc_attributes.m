clc
clear all
fname=dir('lulc_txt_file\lulc_new_data\');
f_data=[];
for i=3:length(fname)
    disp(i)
    name=fname(i).name;
    data=dlmread(['lulc_txt_file\lulc_new_data\',name]);
%     area=dlmread(['area_160st\',name(1:end-4)]);
%     lat_lon=area(:,1:2);
    b=sortrows(data,2,'descend');
    c=sum(b(:,2));
    fraction=[];
%     for j=1:length(b(:,1))
%         disp(j)
%         fraction(j,1)=b(j,2)/c;
%     end
    for k=1:8
        z=find(b(:,1)==k);
        if length(z)>0
            frac= b(z,2)/c;
        else
            frac=0;
        end
        fraction=[fraction frac];
    end
f_data=[f_data;string(name) b(1,1) fraction];
end
%%
f_data1=readtable("all_dam_final_list.xlsx");%%% dam_lat_lon
ppp=table2cell(f_data1);
oooo=string(ppp);
f_data2=[oooo f_data];
f_data3=str2double(f_data2);
f_data4=f_data3(:,[2 3 5:13]);
dlmwrite('Mayank_lulc_output',f_data4,' ');

    
   
