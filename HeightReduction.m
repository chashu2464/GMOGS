load nVector.mat;
is_new = 1;  % 表示遍历过程是否有新增菱形
pool(1) = RhoList(1,1);
RhoNum = size(RhoList,1);
RhoUnion = [];
while(is_new)
    is_new = 0;
    for i=1:RhoNum
        if ~ismember(i,RhoUnion)
            for j=1:4
                if ismember(RhoList(i,j),pool)
                    RhoUnion = [RhoUnion i];
                    is_new = 1;
                    for k=1:4
                        if ~ismember(RhoList(i,k),pool)
                            pool = [pool RhoList(i,k)];
                        end
                    end
                    break;
                end
            end
        end
    end
end

UnionNum = length(RhoUnion)  %表示最大可连通菱形数量
RhoMap = zeros(RhoNum,1);
PointMap = zeros(RhoNum,4);
Height = zeros(size(DotMat,1),1);

PointMap(RhoUnion(1),1) = 1;
Height(RhoList(RhoUnion(1),1)) = 0;
for n=1:UnionNum
    for p=1:4
        CPN = RhoList(RhoUnion(n),p);
        List = RhoAroundPoint(CPN,RhoList);
        for i=1:length(List)
            if ~RhoMap(List(i))
                RhoMap(List(i)) = 1;
                nCart = CartersianCal(nVector.a(List(i)),nVector.b(List(i)));
                for j=1:4
                    if ~PointMap(List(i),j)
                        %计算相对坐标
                        rx = DotMat(RhoList(List(i),j),1) - DotMat(RhoList(List(i),1),1);
                        ry = DotMat(RhoList(List(i),j),2) - DotMat(RhoList(List(i),1),2);
                        %计算该点高度
                        Height(RhoList(List(i),j)) = HeightCal(nCart,rx,ry);
                        PointMap(List(i),j) = 1;
                    end
                end
            end
        end
    end
end
Height = [DotMat(:,1), DotMat(:,2), Height];
plot3(Height(:,1),Height(:,2),Height(:,3),'.');
    
function re = CartersianCal(a,b)  % 将极坐标矢量转换成直角坐标
    re.x0 = cos(b)*sin(a);
    re.y0 = cos(b)*cos(a);
    re.z0 = sin(b);
end

function h = HeightCal(n,x,y)  % 计算某顶点高度
    %x,y为相对坐标
    h = -(x * n.x0 + y * n.y0) / n.z0;
end

function list = RhoAroundPoint(pn,RhoList)  %求某点周围的菱形
    list = [];
    for n=1:size(RhoList,1)
        for m=1:4
            if RhoList(n,m)==pn
                list = [list n];
                break;
            end
        end
    end
end