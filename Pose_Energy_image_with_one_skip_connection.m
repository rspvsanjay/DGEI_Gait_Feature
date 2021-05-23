path = 'G:\PEI_Analysis\TUMGAID\Global_Frames_with_13_key_poses_TUMGAID\';
list = dir(path);
fName = {list.name};
[~,y]=size(fName);
poses = cell(0,0);
for pose_no=3:y
    poses{pose_no-2}=double(imread(char(strcat(path,fName(pose_no)))));
    max1 = max(poses{pose_no-2}(:));
    poses{pose_no-2} = poses{pose_no-2}/max1;
end

path1 = 'G:\Depth_Cropped_Fliped_Renamed_BinaryImageShifted_Fliped\';
save_path = 'H:\Neurocomputing_COFEI\Depth_Cropped_Fliped_Renamed_BinaryImageShifted_Fliped_Half_Cyclic_PEI\';
list1 = dir(path1);
fName1 = {list1.name};
[~,y1]=size(fName1);
save_path
for f_no=3:y1
    path2=char(strcat(path1,fName1(f_no),'\'));
    list2 = dir(path2);
    fName2 = {list2.name};
    [~,y2]=size(fName2);
    fName1(f_no)
    for ff_no=3:y2
        path3= char(strcat(path2,fName2(ff_no),'\'));
        list3 = dir(path3);
        fName3 = {list3.name};
        [~,y3]=size(fName3);
        v = cell(y-2,y3-2);
        for pose_num=1:y-2
            for fff_no=3:y3
                image=double(imread(char(strcat(path3,fName3(fff_no)))));
                r=corr2(poses{pose_num},image);
                v{pose_num}=[v{pose_num},r];
            end
        end
        mat1 = double([]);
        for pose_num=1:y-2
            mat1 = [mat1,v{pose_num}];
        end
        mat2 = (1-mat1);
        NumberofNodes = length(mat2)/(y-2);
        s=[];
        t=[1];
        for num=1:(y-2)
            s=[s,length(mat2)+1];% s is vector of elements, connectivity start from
        end
        for num=1:(y-3)
            t=[t,NumberofNodes*num+1]; % t target vector respect to vector s correspondings
        end
        for num=1:length(mat2)
            if mod(num,NumberofNodes)~=0
                s=[s,num,num,num];
                t=[t,num+1,mod(num+NumberofNodes,length(mat2))+1,mod(num+NumberofNodes*2,length(mat2))+1];
            end
        end
        for num=1:(y-2)
            t=[t,length(mat2)+2];
        end
        for num=1:(y-2)
            s=[s,NumberofNodes*num];
        end
        w = [];
        for num=1:length(t)-(y-2)
            w = [w,mat2(t(num))];
        end
        for num=1:(y-2)%
            w = [w,0.99];
        end
        w(isnan(w))=0;
        G = digraph(s,t,w);
        %             figure,plot(G,'EdgeLabel',G.Edges.Weight);
        [p,d] = shortestpath(G,length(mat2)+1,length(mat2)+2);
        %             p
        %             d
        pei = cell(y-2,0);
        for num=1:y-2
            pei{num} = double(zeros(size(poses{1})));
        end
        for number=1:length(p)-2
            if mod(p(number+1),NumberofNodes)~=0
                posNum = floor(p(number+1)/NumberofNodes)+1;
                frameNum = mod(p(number+1),NumberofNodes);
            else
                posNum = (p(number+1)/NumberofNodes);
                frameNum = length(p)-2;
            end
            path4 = char(strcat(path3,fName3(frameNum+2)));
            image = double(imread(path4));
            max1 = max(image(:));
            image = image/max1;
            pei{posNum} = pei{posNum}+image;            
        end
        if ~exist(char(strcat(save_path,fName1(f_no),'\')),'dir')
            mkdir(char(strcat(save_path,fName1(f_no),'\')));
        end
        for num = 1:y-2
            max1 = max(pei{num}(:));
            pei{num} = pei{num}/max1;
            if num<10
                imwrite(pei{num},char(strcat(save_path,fName1(f_no),'\',fName2(ff_no),'_pose0',int2str(num),'.png')));
            else
                imwrite(pei{num},char(strcat(save_path,fName1(f_no),'\',fName2(ff_no),'_pose',int2str(num),'.png')));
            end
        end
    end
end