%Ԥ�����Ƕ��1


function [h1,h2,h3,h4,h5,fO2,y1,y2,y3,y4,y5,d]=first2(in,B,tall)

%�������Լ���
S=B;%�������ͼ������Ϊ�̶���
I=in;%ǰ�������ĵ�

f=imsubtract(S,I);%����ͼ�����2017��Ľ��쿴���£����������Ԥ���������Ч���ܲ�����ԭ��ġ�����ͼ�ⲿ��������һ�£����ǻ������ȵ��ڲ���Ϣ�����Ԥ����ʧ����ϸ�ڣ�����֮��ı������ͱ���ˡ����ʱ������������ܼ���������ͬ���෴�������򡣾����Ƕ������飬Ҫ���������޹�����Ӱ�죬��������ǡ���Ϊ�����п��ܽ�Ӱ��Ŵ���νʧ֮���壬�ͽ�~~~~

figure(1);imshow(f);
f2= rgb2gray(f);  %�ҶȻ�
figure(2);imshow(f2);




f3=im2bw(f2,0.1);  %ʹ����ֵ���Ҷ�ͼ��ֵ��
figure(3),imshow(f3);

T0=imreconstruct(imerode(f3,strel('disk',100)),f3);%��ʴͼ��

BW1=edge(T0,'canny');  %��Ե������ӣ�����Ҳ���ڲ��ı�Ե�������
figure(4),imshow(BW1);

%f4=bwfill(BW1,'holes');  %����ɫ�����µİ�ɫ�ն�
f5=imfill(f3,'holes');  % ��������ڲ���

figure(5),imshow(f5);

T1=filter2(fspecial('average',3),f5)/255; %����3*3ģ��ƽ���˲�

BW=T1;%����ͼ��
dim=size(BW);
col=round(dim(2)/2)-90;%������ʼ��������
row=find(BW(:,col),1);%������ʼ��������
connectivity=8;
num_points=200000;
contour=bwtraceboundary(BW,[row,col],'N',connectivity,num_points);%��ȡ�߽�
imshow(BW);
hold on
plot(contour(:,2),contour(:,1),'g','LineWidth',1);%��Ȼ�Ƕ�f8��������������ɫ������
%������������İ�ɫ%����ȫ��ͼ
T=imreconstruct(imerode(BW,strel('disk',100)),BW);%��ʴͼ��


f6=~T;


figure(6),imshow(f6);%�ٽ�ͼ��ɫ�������Ϊ��ɫ


[l,m]=bwlabel(~f6,8);
status=regionprops(l,'BoundingBox');  %ע����l��������1 http://baike.baidu.com/link?url=cgHkmOQeWKA6kjFjIk-PYxyrtTchmPfJEyFKi1N6k7uc4neB1oxfYH3cZqdK90RxW5iu-hsK2INg6d8Q4Lmkja
figure(7),imshow(f6);
xlabel('��С��Ӿ���');
for i=1:m
    rectangle('position',status(i).BoundingBox,'edgecolor','r');
end          %��󳤿�ĵó�  ʧ���ˣ���д����ô��ȫͼ   �������ɹ��ˣ����������ȫͼ���ɫ�ġ�˵��Ĭ�ϲ������ǰ�ɫ��������������һ�������ó��ľ�������ڰף�Ϊ�˷��������ҷ�ɫ�ˡ�
%��ô������һ�������ʱ���һ����ɫͼ~f4�����ǻ����ʱ����ʵ����f4�ϵġ�����
%�����Ҳ�������status�����ﵫ���԰���http://www.cnblogs.com/einyboy/archive/2012/08/03/2621820.html
chang=regionprops(l,'MajorAxisLength'),kuang=regionprops(l,'MinorAxisLength');%ch�ǳ���ku�ǿ�
%�٣������ǣ�˵�����͵�̫��ɬ�˶������������ܵó�����Ȼ����ô�Ǹ����飬��Ҫ����һ������

ch1=chang(1).MajorAxisLength    %������ʦ����ʵ������Ҳ������һ�£�����һ���Ӿ���ϵ�������أ�ch��1�������Ӿ��Ƿ��������еĵ�һ��Ԫ�ء�
%������������Ч����������ch(1).MajorAxisLength ans =807.4852
%status(i).BoundingBox(1),
%status(i).BoundingBox(2),status(i).BoundingBox(3),status(i).BoundingBox(4),
%�ֱ��Ǿ������Ͻ�����ͳ�����ʵ����ֱ�ӵ��ó�������

ch=status(1).BoundingBox    %�鿴������Ϣ���ֱ������Ͻ�x,y,��ߡ�

left=status(1).BoundingBox(1)-1;
top=status(1).BoundingBox(2);%���������һ�����أ���Ϊ�ܵ�����֮ǰ�����㹫ʽ��Ӱ�졣





figure(8),imshow(f6)      %һ�����һ�¡�
fO2=imcrop(f6,[left-1,top-1,status(1).BoundingBox(3)+1,status(1).BoundingBox(4)+1]);%ע������������ǿ�͸߶����������ˣ� ��Ϊʲô����1����Ϊ֮ǰ˵�ģ����Ҹ���һ���հ����ء�
%�������ǰ�������������������ˣ����Ҫ����ͬ���֣��Ͱ��������в�ͬ��ͼ���ò�ͬ�ı�ʶ��
figure(8),imshow(fO2);


%���˰������ָ����ͬ���������������Ӧ�����ꡣ


%ͷ���㣨��ʵ���ǲ���������


[row,col]=size(fO2);
for i0=1:row
    for j0=1:col
        if fO2(i0,j0)==0
            y0=i0;
            x0=j0;
        else
        end
    end
end
%��0��Ϊ�˱����������ij��ͻ��Ӧ�÷ֳɲ�ͬ�ĺ�����

%ע�⣺������������������ʦѧ�������öϵ������Ƿ�ִ����һ��ķ�����֮ǰһֱ�����㡣����֪�����﷨����Ҫ�ԡ�֮ǰendǰ����һ��return����ʦ����������return���������֪����Ȼ��
%���ų�����˵return���û�з��ص�ʵ�ʵط��ͳ�ȥ�ˣ���ִ���ˡ�����.4��18�ա�


%Ϊʲô��ʾ�������Ǹ���λ���أ�����106,1������㡣����ˣ���4��18�ա�

%�������Ҿ����ʶ�𣦱��������󾱲��ʶ�𣦲���ͼ��ǰ����ʶ��
height=status(1).BoundingBox(4);
[row,col]=size(fO2);




row1=round(row*0.995-height*0.84);%���㾱���������岿λ����
row2=round(row*1.005-height*0.84); %���㾱���������岿λ����
col_array=linspace(0,0,row2-row1+1);%��������,�洢�����������              %%%%%%%%%%�粿�ĸ߶���0.844h���Ժ�ֻ������
for i=row1:row2
    for j=1:col/2
        if fO2(i,j)==0
            col_array(i-row1+1)=j;
            break
        end
    end
end
%ȡcol_array�����е����ֵ
row_1=0;
col_l=0;
for k=row1:l:row2
    if(col_array(i-row1+1)>col_1)
        row1=row_1;
        col_l=col_array(i-row1+1);
    end
end
y1=row1;
x1=col_array(i-row1+1);  %���ﰡ��x0,y0,x1,y2���������������µ����������꣨���ǹ�ע�Ŀ���ֻ��y���ꡣ��
hold on
plot(x1,y1,'.','MarkerEdgeColor','g','MarkerSize',16);%%ע������1����ĸl




%����������ͼ��Χ��ʶ��
[row,col]=size(fO2);    %row�Ǹ߶�y��col�ǳ���x��
row1=round(row*0.995-height*0.72); %�����ز�����ߵ�����
row2=round(row*1.005-height*0.72); %�����ز�����ߵ�����
col_array=linspace(0,0,row2-row1+1);%��������,�洢�����������
col1=round(col/2); %ȡ����

for i=row1:row2    %i��y��j��x������������������������
    for j=1:col
        if fO2(i,j)==0
            col_array(i-row1+1)=j;
            break
        end
    end
end
%ȡcol_array�����е����ֵ
row_1=0;
col_l=0;
for k=row1:l:row2
    if(col_array(i-row1+1)>col_1)
        row1=row_1;
        col_l=col_array(i-row1+1);
    end
end
y2=row1;
x2=col_array(i-row1+1);  %���ﰡ��x0,y0,x1,y2���������������µ����������꣨���ǹ�ע�Ŀ���ֻ��y���ꡣ��
hold on
plot(x2,y2,'.','MarkerEdgeColor','g','MarkerSize',16);%%ע������1����ĸl
%%%%%%�����ᣡ����һ�����ˣ�

row1=round(row*0.995-height*0.60); %�����ز�����ߵ�����
row2=round(row*1.005-height*0.60); %�����ز�����ߵ�����
col_array=linspace(0,0,row2-row1+1);%��������,�洢�����������
col1=round(col/2); %ȡ����

for i=row1:row2    %i��y��j��x������������������������
    for j=1:col
        if fO2(i,j)==0
            col_array(i-row1+1)=j;
            break
        end
    end
end
%ȡcol_array�����е����ֵ
row_1=0;
col_l=0;
for k=row1:l:row2
    if(col_array(i-row1+1)>col_1)
        row1=row_1;
        col_l=col_array(i-row1+1);
    end
end
y3=row1;
x3=col_array(i-row1+1);  %���ﰡ��x0,y0,x1,y2���������������µ����������꣨���ǹ�ע�Ŀ���ֻ��y���ꡣ��
hold on
plot(x3,y3,'.','MarkerEdgeColor','r','MarkerSize',16);%%ע������1����ĸl



%%%��һ��

row1=round(row*0.995-height*0.467); %�����ز�����ߵ�����
row2=round(row*1.005-height*0.467); %�����ز�����ߵ�����
col_array=linspace(0,0,row2-row1+1);%��������,�洢�����������
col1=round(col/2); %ȡ����

for i=row1:row2    %i��y��j��x������������������������
    for j=1:col
        if fO2(i,j)==0
            col_array(i-row1+1)=j;
            break
        end
    end
end
%ȡcol_array�����е����ֵ
row_1=0;
col_l=0;
for k=row1:l:row2
    if(col_array(i-row1+1)>col_1)
        row1=row_1;
        col_l=col_array(i-row1+1);
    end
end
y4=row1;
x4=col_array(i-row1+1);  %���ﰡ��x0,y0,x1,y2���������������µ����������꣨���ǹ�ע�Ŀ���ֻ��y���ꡣ��
hold on
plot(x4,y4,'.','MarkerEdgeColor','r','MarkerSize',16);%%ע������1����ĸl


%��һ����
row1=round(row*0.995-height*0.267); %�����ز�����ߵ�����
row2=round(row*1.005-height*0.267); %�����ز�����ߵ�����
col_array=linspace(0,0,row2-row1+1);%��������,�洢�����������
col1=round(col/2); %ȡ����

for i=row1:row2    %i��y��j��x������������������������
    for j=1:col
        if fO2(i,j)==0
            col_array(i-row1+1)=j;
            break
        end
    end
end
%ȡcol_array�����е����ֵ
row_1=0;
col_l=0;
for k=row1:l:row2
    if(col_array(i-row1+1)>col_1)
        row1=row_1;
        col_l=col_array(i-row1+1);
    end
end
y5=row1;
x5=col_array(i-row1+1);  %���ﰡ��x0,y0,x1,y2���������������µ����������꣨���ǹ�ע�Ŀ���ֻ��y���ꡣ��
hold on
plot(x5,y5,'.','MarkerEdgeColor','r','MarkerSize',16);%%ע������1����ĸl


plot(height*(1-0.267),'.','MarkerEdgeColor','g','MarkerSize',16);

%%%%%��ʵ������ȫ������ô�ţ�ֱ�Ӱ���������ҳ��������У����ǲ����ı߽磡����

%%%%�������

d=tall/height;


fa=fO2(y1,:);fb=fO2(y2,:);fc=fO2(y3,:);fd=fO2(y4,:);fe=fO2(y5,:);     %ȡ��ĳһ�е�ͼ����Ϣ��������һ�п�ȵļ��㡣


%1
i=1;

for n=2:numel(fa)
    
    if  fa(n-1)~=fa(n);   %�Ӱ׵��ڵı߽����һ�β��Ҹ�ֵ��a��i����һ�㹲2�Σ�a��2��-a��1������ÿ���ش����ȼ�ʹ���к�ɫ����
        a(i)=n;
        i=i+1;
    end
end
h1= d*(a(2)-a(1))   %s�����������������  ��Ҫ����ǰ���d
%2
i=1;
for n=2:numel(fb)
    
    if  fb(n-1)~=fb(n);   %�Ӱ׵��ڵı߽����һ�β��Ҹ�ֵ��a��i����һ�㹲2�Σ�a��2��-a��1������ÿ���ش����ȼ�ʹ���к�ɫ����
        a(i)=n;
        i=i+1;
    end
end
h2= d*(a(2)-a(1))   %s�����������������  ��Ҫ����ǰ���d
%3
i=1;
for n=2:numel(fc)
    
    if  fc(n-1)~=fc(n);   %�Ӱ׵��ڵı߽����һ�β��Ҹ�ֵ��a��i����һ�㹲2�Σ�a��2��-a��1������ÿ���ش����ȼ�ʹ���к�ɫ����
        a(i)=n;
        i=i+1;
    end
end
h3= d*(a(2)-a(1))   %s�����������������  ��Ҫ����ǰ���d
%4
i=1;
for n=2:numel(fd)
    
    if  fd(n-1)~=fd(n);   %�Ӱ׵��ڵı߽����һ�β��Ҹ�ֵ��a��i����һ�㹲2�Σ�a��2��-a��1������ÿ���ش����ȼ�ʹ���к�ɫ����
        a(i)=n;
        i=i+1;
    end
end
h4= d*(a(2)-a(1))   %s�����������������  ��Ҫ����ǰ���d
%5
i=1;
for n=2:numel(fe)
    
    if  fe(n-1)~=fe(n);   %�Ӱ׵��ڵı߽����һ�β��Ҹ�ֵ��a��i����һ�㹲2�Σ�a��2��-a��1������ÿ���ش����ȼ�ʹ���к�ɫ����
        a(i)=n;
        i=i+1;
    end
end
h5= d*(a(2)-a(1))   %s�����������������  ��Ҫ����ǰ���d



%�����������桢��������ϣ�����Բ���������
%

