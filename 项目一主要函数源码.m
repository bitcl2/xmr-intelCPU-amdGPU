%预处理和嵌套1


function [h1,h2,h3,h4,h5,fO2,y1,y2,y3,y4,y5,d]=first2(in,B,tall)

%今天试试剪切
S=B;%这个背景图像设置为固定的
I=in;%前景就是拍的

f=imsubtract(S,I);%两幅图相减，2017年的今天看了下，当年出现先预处理再相减效果很差是有原因的。两幅图外部条件即便一致，还是会有亮度等内部信息差别，先预处理丢失大量细节，主体之外的背景差别就变大了。这个时候再相减，可能减掉本来相同（相反）的区域。就像是对照试验，要首先消除无关因素影响，不能最后考虑。因为过程中可能将影响放大。所谓失之毫厘，就酱~~~~

figure(1);imshow(f);
f2= rgb2gray(f);  %灰度化
figure(2);imshow(f2);




f3=im2bw(f2,0.1);  %使用阈值将灰度图二值化
figure(3),imshow(f3);

T0=imreconstruct(imerode(f3,strel('disk',100)),f3);%腐蚀图像

BW1=edge(T0,'canny');  %边缘检测算子，但是也把内部的边缘提出来了
figure(4),imshow(BW1);

%f4=bwfill(BW1,'holes');  %填充黑色背景下的白色空洞
f5=imfill(f3,'holes');  % 填充主体内部分

figure(5),imshow(f5);

T1=filter2(fspecial('average',3),f5)/255; %进行3*3模板平滑滤波

BW=T1;%读入图像
dim=size(BW);
col=round(dim(2)/2)-90;%计算起始点列坐标
row=find(BW(:,col),1);%计算起始点行坐标
connectivity=8;
num_points=200000;
contour=bwtraceboundary(BW,[row,col],'N',connectivity,num_points);%提取边界
imshow(BW);
hold on
plot(contour(:,2),contour(:,1),'g','LineWidth',1);%仍然是对f8操作，边线用绿色框起来
%消除绿线以外的白色%背景全黑图
T=imreconstruct(imerode(BW,strel('disk',100)),BW);%腐蚀图像


f6=~T;


figure(6),imshow(f6);%再将图像反色，人像变为黑色


[l,m]=bwlabel(~f6,8);
status=regionprops(l,'BoundingBox');  %注意是l不是数字1 http://baike.baidu.com/link?url=cgHkmOQeWKA6kjFjIk-PYxyrtTchmPfJEyFKi1N6k7uc4neB1oxfYH3cZqdK90RxW5iu-hsK2INg6d8Q4Lmkja
figure(7),imshow(f6);
xlabel('最小外接矩形');
for i=1:m
    rectangle('position',status(i).BoundingBox,'edgecolor','r');
end          %最大长宽的得出  失败了，填写的怎么是全图   哈哈，成功了，他框出的是全图嘛，白色的。说明默认操作的是白色。在上面膨胀那一部分最后得出的就是外黑内白，为了方便算数我反色了。
%那么，我这一步读入的时候读一个反色图~f4，但是画框的时候其实还是f4上的。恩。
%长宽找不到，在status数组里但不对啊。http://www.cnblogs.com/einyboy/archive/2012/08/03/2621820.html
chang=regionprops(l,'MajorAxisLength'),kuang=regionprops(l,'MinorAxisLength');%ch是长，ku是宽。
%嘿，还真是，说明解释的太晦涩了都，这样还真能得出长宽。然而怎么是个数组，我要的是一个数。

ch1=chang(1).MajorAxisLength    %问了老师，其实在网上也看到了一下，所以一下子就联系起来了呢！ch（1）这样子就是访问内容中的第一个元素。
%命令行中输入效果是这样的ch(1).MajorAxisLength ans =807.4852
%status(i).BoundingBox(1),
%status(i).BoundingBox(2),status(i).BoundingBox(3),status(i).BoundingBox(4),
%分别是矩形左上角坐标和长宽其实可以直接调用出来的呢

ch=status(1).BoundingBox    %查看数组信息，分别是左上角x,y,宽高。

left=status(1).BoundingBox(1)-1;
top=status(1).BoundingBox(2);%左各增加了一个像素，因为受到我们之前算宽度算公式的影响。





figure(8),imshow(f6)      %一会剪切一下。
fO2=imcrop(f6,[left-1,top-1,status(1).BoundingBox(3)+1,status(1).BoundingBox(4)+1]);%注意后两个数字是宽和高而不是坐标了！ 另，为什么加上1？因为之前说的，左右各加一个空白像素。
%这样我们把整个人像给剪切下来了，如果要看不同部分，就按比例剪切不同的图，用不同的标识别。
figure(8),imshow(fO2);


%把人按比例分割出不同的区块算出各部对应的坐标。


%头顶点（其实我们不用算它）


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
%加0是为了避免与下面的ij冲突，应该分成不同的函数。

%注意：：：：今天问周雅老师学会了设置断点来看是否执行这一句的方法。之前一直不出点。另外知道了语法的重要性。之前end前边有一个return，老师发现问题问return到哪里，并不知道，然后
%王雅晨告诉说return如果没有返回到实际地方就出去了，不执行了。以上.4月18日。


%为什么显示不出来那个点位置呢！！（106,1）这个点。解决了，见4月18日。

%面轮廓右颈侧点识别＆背面轮廓左颈侧点识别＆侧面图像前颈点识别
height=status(1).BoundingBox(4);
[row,col]=size(fO2);




row1=round(row*0.995-height*0.84);%计算颈部所在人体部位上限
row2=round(row*1.005-height*0.84); %计算颈部所在人体部位下限
col_array=linspace(0,0,row2-row1+1);%定义数组,存储检测点的纵坐标              %%%%%%%%%%肩部的高度是0.844h，以后只输出肩宽
for i=row1:row2
    for j=1:col/2
        if fO2(i,j)==0
            col_array(i-row1+1)=j;
            break
        end
    end
end
%取col_array数组中的最大值
row_1=0;
col_l=0;
for k=row1:l:row2
    if(col_array(i-row1+1)>col_1)
        row1=row_1;
        col_l=col_array(i-row1+1);
    end
end
y1=row1;
x1=col_array(i-row1+1);  %这里啊，x0,y0,x1,y2……依次是上至下的特征点坐标（我们关注的可能只是y坐标。）
hold on
plot(x1,y1,'.','MarkerEdgeColor','g','MarkerSize',16);%%注意数字1和字母l




%正背面轮廓图胸围的识别
[row,col]=size(fO2);    %row是高度y，col是长度x。
row1=round(row*0.995-height*0.72); %计算胸部标记线的上限
row2=round(row*1.005-height*0.72); %计算胸部标记线的下限
col_array=linspace(0,0,row2-row1+1);%定义数组,存储检测点的纵坐标
col1=round(col/2); %取中线

for i=row1:row2    %i是y，j是x！！！！！！！！！！！！
    for j=1:col
        if fO2(i,j)==0
            col_array(i-row1+1)=j;
            break
        end
    end
end
%取col_array数组中的最大值
row_1=0;
col_l=0;
for k=row1:l:row2
    if(col_array(i-row1+1)>col_1)
        row1=row_1;
        col_l=col_array(i-row1+1);
    end
end
y2=row1;
x2=col_array(i-row1+1);  %这里啊，x0,y0,x1,y2……依次是上至下的特征点坐标（我们关注的可能只是y坐标。）
hold on
plot(x2,y2,'.','MarkerEdgeColor','g','MarkerSize',16);%%注意数字1和字母l
%%%%%%歪歪歪！！下一部分了！

row1=round(row*0.995-height*0.60); %计算胸部标记线的上限
row2=round(row*1.005-height*0.60); %计算胸部标记线的下限
col_array=linspace(0,0,row2-row1+1);%定义数组,存储检测点的纵坐标
col1=round(col/2); %取中线

for i=row1:row2    %i是y，j是x！！！！！！！！！！！！
    for j=1:col
        if fO2(i,j)==0
            col_array(i-row1+1)=j;
            break
        end
    end
end
%取col_array数组中的最大值
row_1=0;
col_l=0;
for k=row1:l:row2
    if(col_array(i-row1+1)>col_1)
        row1=row_1;
        col_l=col_array(i-row1+1);
    end
end
y3=row1;
x3=col_array(i-row1+1);  %这里啊，x0,y0,x1,y2……依次是上至下的特征点坐标（我们关注的可能只是y坐标。）
hold on
plot(x3,y3,'.','MarkerEdgeColor','r','MarkerSize',16);%%注意数字1和字母l



%%%下一个

row1=round(row*0.995-height*0.467); %计算胸部标记线的上限
row2=round(row*1.005-height*0.467); %计算胸部标记线的下限
col_array=linspace(0,0,row2-row1+1);%定义数组,存储检测点的纵坐标
col1=round(col/2); %取中线

for i=row1:row2    %i是y，j是x！！！！！！！！！！！！
    for j=1:col
        if fO2(i,j)==0
            col_array(i-row1+1)=j;
            break
        end
    end
end
%取col_array数组中的最大值
row_1=0;
col_l=0;
for k=row1:l:row2
    if(col_array(i-row1+1)>col_1)
        row1=row_1;
        col_l=col_array(i-row1+1);
    end
end
y4=row1;
x4=col_array(i-row1+1);  %这里啊，x0,y0,x1,y2……依次是上至下的特征点坐标（我们关注的可能只是y坐标。）
hold on
plot(x4,y4,'.','MarkerEdgeColor','r','MarkerSize',16);%%注意数字1和字母l


%下一部分
row1=round(row*0.995-height*0.267); %计算胸部标记线的上限
row2=round(row*1.005-height*0.267); %计算胸部标记线的下限
col_array=linspace(0,0,row2-row1+1);%定义数组,存储检测点的纵坐标
col1=round(col/2); %取中线

for i=row1:row2    %i是y，j是x！！！！！！！！！！！！
    for j=1:col
        if fO2(i,j)==0
            col_array(i-row1+1)=j;
            break
        end
    end
end
%取col_array数组中的最大值
row_1=0;
col_l=0;
for k=row1:l:row2
    if(col_array(i-row1+1)>col_1)
        row1=row_1;
        col_l=col_array(i-row1+1);
    end
end
y5=row1;
x5=col_array(i-row1+1);  %这里啊，x0,y0,x1,y2……依次是上至下的特征点坐标（我们关注的可能只是y坐标。）
hold on
plot(x5,y5,'.','MarkerEdgeColor','r','MarkerSize',16);%%注意数字1和字母l


plot(height*(1-0.267),'.','MarkerEdgeColor','g','MarkerSize',16);

%%%%%其实我们完全不用这么着，直接按人体比例找出行数就行，我们不关心边界！！！

%%%%输入身高

d=tall/height;


fa=fO2(y1,:);fb=fO2(y2,:);fc=fO2(y3,:);fd=fO2(y4,:);fe=fO2(y5,:);     %取出某一行的图像信息，进行这一行宽度的计算。


%1
i=1;

for n=2:numel(fa)
    
    if  fa(n-1)~=fa(n);   %从白到黑的边界计数一次并且赋值给a（i），一般共2次，a（2）-a（1）乘以每像素代表长度即使本行黑色长度
        a(i)=n;
        i=i+1;
    end
end
h1= d*(a(2)-a(1))   %s就是你算出来的数了  需要乘以前面的d
%2
i=1;
for n=2:numel(fb)
    
    if  fb(n-1)~=fb(n);   %从白到黑的边界计数一次并且赋值给a（i），一般共2次，a（2）-a（1）乘以每像素代表长度即使本行黑色长度
        a(i)=n;
        i=i+1;
    end
end
h2= d*(a(2)-a(1))   %s就是你算出来的数了  需要乘以前面的d
%3
i=1;
for n=2:numel(fc)
    
    if  fc(n-1)~=fc(n);   %从白到黑的边界计数一次并且赋值给a（i），一般共2次，a（2）-a（1）乘以每像素代表长度即使本行黑色长度
        a(i)=n;
        i=i+1;
    end
end
h3= d*(a(2)-a(1))   %s就是你算出来的数了  需要乘以前面的d
%4
i=1;
for n=2:numel(fd)
    
    if  fd(n-1)~=fd(n);   %从白到黑的边界计数一次并且赋值给a（i），一般共2次，a（2）-a（1）乘以每像素代表长度即使本行黑色长度
        a(i)=n;
        i=i+1;
    end
end
h4= d*(a(2)-a(1))   %s就是你算出来的数了  需要乘以前面的d
%5
i=1;
for n=2:numel(fe)
    
    if  fe(n-1)~=fe(n);   %从白到黑的边界计数一次并且赋值给a（i），一般共2次，a（2）-a（1）乘以每像素代表长度即使本行黑色长度
        a(i)=n;
        i=i+1;
    end
end
h5= d*(a(2)-a(1))   %s就是你算出来的数了  需要乘以前面的d



%接下来是正面、侧面的整合，用椭圆或多边形拟合
%

