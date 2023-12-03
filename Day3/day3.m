adjfilt = [1 1 1; 1 0 1; 1 1 1];
horzfilt = [1 0 1];

grid = uint8(cell2mat(textread("input.txt", "%s")));
isnum = (((grid >= '0') & (grid <= '9')));
issym = !(isnum | (grid == '.'));
adjsym = conv2(issym, adjfilt, 'same') > 0;

safenums = isnum & adjsym;
loop = true;
while loop
    newsafe = safenums | ((isnum & conv2(safenums, horzfilt, 'same')) > 0);
    trulynew = newsafe & !safenums;
    if sum(sum(trulynew)) == 0
        loop = false;
    end
    safenums = newsafe;
end

fixedgrid = (!safenums .* ' ') + (safenums .* grid);

total = 0;
for line = char(fixedgrid).'
    total += sum(cell2mat(textscan(line, "%u")));
end
total