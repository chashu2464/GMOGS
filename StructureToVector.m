%计算石墨烯表面结构法向量
global DotMat;
[x,y] = textread('RawData/262.txt','%f%f');
is_used = zeros(length(x),1);  %表示该点是否是菱形的其中一点
DotMat = [x,y,is_used];
RhoList = RhoMatch();
RhoNum = size(RhoList,1)
nVector = VectorCal(RhoList);
save("nVector.mat",'nVector','RhoList');
quiver(nVector.xs, nVector.ys, nVector.a, nVector.b);

%%  Function

function List = RhoMatch()
    global DotMat;
    N = size(DotMat,1);
    List = [];
    mode = 1;
    for p1=1:N
        p2 = ScanPoints(p1,-20,-4,-30,-10,N);
        if p2~=0
            p3 = ScanPoints(p1,-8,+8,-50,-35,N);
            if p3~=0
                p4 = ScanPoints(p1,+4,+20,-30,-10,N);
                if p4~= 0
                    if ~DotMat(p1,3) || ~DotMat(p2,3) || ~DotMat(p3,3) || ~DotMat(p4,3)
                        Rho = [p1,p2,p3,p4,mode];
                        DotMat(p1,3) = 1;
                        DotMat(p2,3) = 1;
                        DotMat(p3,3) = 1;
                        DotMat(p4,3) = 1;
                        if ~isempty(List)
                            List = [List;Rho];
                        else
                             List = Rho;
                        end
                    end
                end
            end
        end
    end
    mode = 2;
    for p1=1:N
        p2 = ScanPoints(p1,+10,+30,-20,-4,N);
        if p2~=0
            p3 = ScanPoints(p1,+35,+50,-8,+8,N);
            if p3~=0
                p4 = ScanPoints(p1,+10,+30,+4,+20,N);
                if p4~= 0
                    Rho = [p1,p2,p3,p4,mode];
                    DotMat(p1,3) = 1;
                    DotMat(p2,3) = 1;
                    DotMat(p3,3) = 1;
                    DotMat(p4,3) = 1;
                    if ~isempty(List)
                        List = [List;Rho];
                    else
                         List = Rho;
                    end
                end
            end
        end
    end

    function re = ScanPoints(id,xl,xh,yl,yh,N)
        x = DotMat(id,1);
        y = DotMat(id,2);
        for i=1:N
            if DotMat(i,1)>(x+xl) && DotMat(i,1)<=(x+xh) && DotMat(i,2)>(y+yl) && DotMat(i,2)<=(y+yh) %&& ~DotMat(i,3)
                re = i;
                return;
            end
        end
        re = 0;
    end

end

function nv = VectorCal(RhoList)
    global DotMat;
    std_len = 47.286;
    RhoNum = size(RhoList,1);
    xs = zeros(RhoNum,1);
    ys = zeros(RhoNum,1);
    a = zeros(RhoNum,1);
    b = zeros(RhoNum,1);
    for i=1:RhoNum
        if RhoList(i,5)==1
            len_x = DotMat(RhoList(i,4),1) - DotMat(RhoList(i,2),1);
            len_y = DotMat(RhoList(i,4),2) - DotMat(RhoList(i,2),2);
        else
            len_x = DotMat(RhoList(i,3),1) - DotMat(RhoList(i,1),1);
            len_y = DotMat(RhoList(i,3),2) - DotMat(RhoList(i,1),2);
        end
        xi = (DotMat(RhoList(i,1),1)+DotMat(RhoList(i,2),1)+DotMat(RhoList(i,3),1)+DotMat(RhoList(i,4),1))/4;
        yi = (DotMat(RhoList(i,1),2)+DotMat(RhoList(i,2),2)+DotMat(RhoList(i,3),2)+DotMat(RhoList(i,4),2))/4;
        len = sqrt(len_x^2+len_y^2);
        if len>std_len
            len = std_len;
        end
        ai = atan(len_y/len_x);
        bi = acos(len/std_len);
        
        a(i,1) = ai;
        b(i,1) = bi;
        xs(i,1) = xi;
        ys(i,1) = yi;
    end
    nv.a = a;
    nv.b = b;
    nv.xs = xs;
    nv.ys = ys;
end
