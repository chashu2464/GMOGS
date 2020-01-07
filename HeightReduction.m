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
