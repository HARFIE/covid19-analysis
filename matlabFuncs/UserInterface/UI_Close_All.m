function UI_Close_All()
msg = 'Do you want to close all figures?(y/n)';
answer = input(msg, 's');
if lower(answer) == 'y'
    close all
end
end