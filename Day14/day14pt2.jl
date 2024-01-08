# function shuffle(grid)
#     for (i, row) in pairs(grid)
#         for(j, item) in pairs(row)
#             if(item == 'O')
#                 newi = i;
#                 while(newi > 1 && grid[newi-1][j] == '.')
#                     newi -= 1;
#                 end
#                 grid[i][j] = '.'
#                 grid[newi][j] = 'O'
#             end
#         end
#     end
# end

function shuffle(grid::Matrix{Char})
    cols, rows = size(grid)
    for i in 1:cols
        accum = 0
        floor = 0
        for j in 1:rows
            if grid[i, j] == 'O'
                grid[i, j] = '.'
                accum += 1
            elseif grid[i, j] == '#'
                grid[i, (floor+1):(floor+accum)] .= 'O'
                floor = j
                accum = 0
            end
        end
        grid[i, (floor+1):(floor+accum)] .= 'O'
    end
end

function prep(fname)
    f = open(fname, "r")
    return stack([collect(line) for line=readlines(f)])
end

function process(grid)
    for i in 1:40000
        shuffle(grid)
    end
    indvec = transpose((size(grid)[2]):-1:1)
    return sum((grid .== 'O') .* indvec)
end

println(process(prep("testinput.txt")))
