clc;
clear all;
a=xlsread('soil_final_output_data\soil_HWSD2_data\HWSD2_LAYERS.xlsx');
flist=readtable('Soil_Majority_values\soil_majority_values.csv');
aa=table2cell(flist);
aa1=string(aa);
for i=1:length(aa1)
    disp(i)
     fname=char(aa1(i,2));
     fname1=lower(fname(1:12));
    b=aa1(i,5);
    c=str2double(b);
    d=find(a(:,2)==c);
    soil_d=a(d,[2 8 9 25 26 27 28 29 30 31 33 35 22]);
    dlmwrite(['soil_final_output_data\filter_soildata2_step1\',fname1],soil_d,' ');
end
%%
%% taking weighted average of soil properties
clc 
clear all
flist=dir('soil_final_output_data\filter_soildata2_step1\');
for i=3:length(flist)
    disp(i)
    fname=flist(i).name;
    data=dlmread(['soil_final_output_data\filter_soildata2_step1\',fname]);
    a=unique(data(:,2));
    data_new=[];
    f_data=[];
    for j=1:length(a)
        disp(j)
        b=find(data(:,2)==a(j,1));
        data1=data(b,:);
        s=find(isnan(data1)==1);
        data1(s)=0;
        share=data1(1,3);
        coarse=(20*(data1(1,6)+data1(2,6)+data1(3,6)+data1(4,6)+data1(5,6))+50*(data1(6,6)+data1(7,6)))/200;
        sand=(20*(data1(1,7)+data1(2,7)+data1(3,7)+data1(4,7)+data1(5,7))+50*(data1(6,7)+data1(7,7)))/200;
        silt=(20*(data1(1,8)+data1(2,8)+data1(3,8)+data1(4,8)+data1(5,8))+50*(data1(6,8)+data1(7,8)))/200;
        clay=(20*(data1(1,9)+data1(2,9)+data1(3,9)+data1(4,9)+data1(5,9))+50*(data1(6,9)+data1(7,9)))/200;
        organic=(20*(data1(1,12)+data1(2,12)+data1(3,12)+data1(4,12)+data1(5,12))+50*(data1(6,12)+data1(7,12)))/200;
%         bulk_d=(20*(data1(1,11)+data1(2,11)+data1(3,11)+data1(4,11)+data1(5,11))+50*(data1(6,11)+data1(7,11)))/200;
        awc=data1(1,13);
        data_new=[data_new;share coarse sand silt clay organic awc];
    end
    coarse=[];
    sand=[];
    silt=[];
    clay=[];
    organic=[];
    bulk_d=[];
    awc=[];
    for z=1:length(data_new(:,1))
        disp(z);
        coarse=[coarse;data_new(z,1)*data_new(z,2)];
        sand=[sand;data_new(z,1)*data_new(z,3)];
        silt=[silt;data_new(z,1)*data_new(z,4)];
        clay=[clay;data_new(z,1)*data_new(z,5)];
        organic=[organic;data_new(z,1)*data_new(z,6)];
%         bulk_d=[bulk_d;data_new(z,1)*data_new(z,7)];
        awc=[awc;data_new(z,1)*data_new(z,7)];
    end
  f_data=[f_data;sum(coarse)/100 sum(sand)/100 sum(silt)/100 sum(clay)/100 sum(organic)/100 sum(awc)/100];

dlmwrite(['soil_final_output_data\filter_soildata2_step2\',fname],f_data,' ');
end
%%
%% code to find soil porosity and conductivity
%In the HWSD database, soil strata are divided into different depths having some intervals; from 0 to 100 cm of soil strata has an interval of 20 cm and , and from 100 to 200 cm, soil depth has a interval of 50 cm
data1=dlmread('soil_final_output_data\all_new.tmp');
flist=dir('dam_name_file_containing_clip_lat_lon\'); % lat long
%farea=dir('area_160st\');
aa=dir('soil_final_output_data\filter_soildata2_step2\');
f_data1=[];
f_data=[];
for i=3:length(flist)
    disp(i);
    fname=flist(i).name;
    ans1=dlmread(['dam_name_file_containing_clip_lat_lon\',fname]); %lat long 
    lat_lon=ans1(:,1:2);
    filter_data=[];
    for j=1:length(lat_lon(:,1))
        disp(j)
        a=find(lat_lon(j,1)==data1(:,3) & lat_lon(j,2)==data1(:,4));
        filter_data=[filter_data;lat_lon(j,:) data1(a,[13 14 15 23 24 25 34 35 36 37 38 39])];
    end
    conductivity=[];
    depth=[];
    porosity=[];
    bulk_d=[];
    for z=1:length(filter_data(:,1))
        conductivity=[conductivity;(filter_data(z,3)*filter_data(z,6)+filter_data(z,4)*filter_data(z,7)+filter_data(z,5)*filter_data(z,8))/(filter_data(z,6)+filter_data(z,7)+filter_data(z,8))];
        depth=[depth;filter_data(z,6)+filter_data(z,7)+filter_data(z,8)];
        c=1-(filter_data(z,9)/filter_data(z,12));
        d=1-(filter_data(z,10)/filter_data(z,13));
        e=1-(filter_data(z,11)/filter_data(z,14));
        porosity=[porosity;(c*filter_data(z,6)+d*filter_data(z,7)+e*filter_data(z,8))/(filter_data(z,6)+filter_data(z,7)+filter_data(z,8))];
        bulk_d=[bulk_d;(filter_data(z,9)*filter_data(z,6)+filter_data(z,10)*filter_data(z,7)+filter_data(z,11)*filter_data(z,8))/(filter_data(z,6)+filter_data(z,7)+filter_data(z,8))];
    end
ans2=dlmread(['Dam_name_file_contain_lat_lon\',fname]);
st_latlon=ans2(1,1:2);
max_water_content=mean(depth)*mean(porosity);
f_data=dlmread(['soil_final_output_data\filter_soildata2_step2\',fname]);
f_data1=[f_data1;st_latlon f_data mean(conductivity) mean(depth) mean(porosity) max_water_content mean(bulk_d)];

end
dlmwrite('soil_final_output_data\soil_final_output',f_data1,' ');