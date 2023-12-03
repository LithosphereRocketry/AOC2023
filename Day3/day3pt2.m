adjfilt = [1 1 1; 1 0 1; 1 1 1];
horzfilt = [1 0 1];
nextfilt = [0 0 1];

grid = uint8(cell2mat(textread("input.txt", "%s")));
isnum = (((grid >= '0') & (grid <= '9')));
isgear = (grid == '*');

[xs, ys] = find(isgear);
lgears = [xs ys].';
gearcounts = isgear * 0;
for loc = lgears
    neigborhood = isnum(loc(1) + [-1:1], loc(2) + [-1:1]);
    nextto = conv2(neigborhood, nextfilt, 'same') > 0;
    corrected = neigborhood & !nextto;
    gearcounts(loc(1), loc(2)) = sum(sum(corrected));
end
[xlv, ylv] = find(gearcounts == 2);
lvalid = [xlv ylv].';

total = 0;
for loc = lvalid
    whereis = isgear*0;
    whereis(loc(1), loc(2)) = 1;
    safenums = isnum & conv2(whereis, adjfilt, 'same');
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

    ratio = 1;
    for line = char(fixedgrid).'
        ratio *= prod(cell2mat(textscan(line, "%u")));
    end
    total += ratio;
end
format long g
total