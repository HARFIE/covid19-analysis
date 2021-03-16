function limitX(figHandle, Xmin, Xmax)
N = numel(figHandle.Children);
for n =1:N
    son = figHandle.Children(n);
    if strcmp(get(son,'type'),'axes')
        if strcmp(son.Tag, '')
            son.XLim = [datetime(Xmin), datetime(Xmax)];
        end
    end
end
end