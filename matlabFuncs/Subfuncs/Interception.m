function X_interc = Interception(x1,y1, x2,y2)
y1(isnan(y1))=0;
y2(isnan(y2))=0;
if y1(1)>y2(1)
    y_aux = y1;
    y1 = y2;
    y2 = y_aux;
end

x_p = x1(1);
x_G = x1(1);
for i = 1:length(x1)
    if y1(i)< y2(i)
        x_p = x1(i);
    else
       x_G = x1(i);
       break;
    end
end
if x_G <= x1(1)
    X_interc = -1;
else
    X_interc = x_G;
end
end