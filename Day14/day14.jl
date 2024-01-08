open("input.txt", "r") do f
    grid = [collect(line) for line=readlines(f)]
    
    total = 0;
    for (i, row) in pairs(grid)
        for(j, item) in pairs(row)
            if(item == 'O')
                newi = i;
                while(newi > 1 && grid[newi-1][j] == '.')
                    newi -= 1;
                end
                grid[i][j] = '.'
                grid[newi][j] = 'O'
                total += length(grid) - newi + 1
            end
        end
    end
    println(total)
end
