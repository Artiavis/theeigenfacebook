function avg = meanface(F)

fields = fieldnames(F);

Sum = zeros(size(F(1).(fields{1})));
count = 0;

for i = 1:length(F),
    for j = 1:length(fields);
        X = double(F(i).(fields{j}));
        Sum = Sum + X;
        count = count + 1;
    end;
end;

avg = Sum ./ count;