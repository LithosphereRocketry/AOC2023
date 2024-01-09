function prep(fname)
    f = open(fname, "r")
    return stack([collect(line) for line=readlines(f)])
end

function nbound(grid, x, y)
    dist = 0
    while y-dist-1 >= 1 && grid[x, y-dist-1] != '#'
        dist += 1
    end
    return dist
end
function sbound(grid, x, y)
    _, rows = size(grid)
    dist = 0
    while y+dist+1 <= rows && grid[x, y+dist+1] != '#'
        dist += 1
    end
    return dist
end
function ebound(grid, x, y)
    cols, _ = size(grid)
    dist = 0
    while x+dist+1 <= cols && grid[x+dist+1, y] != '#'
        dist += 1
    end
    return dist
end
function wbound(grid, x, y)
    dist = 0
    while x-dist-1 >= 1 && grid[x-dist-1, y] != '#'
        dist += 1
    end
    return dist
end

struct Bound
    x::Int
    y::Int
    n::Int
end

function getbounds(grid)
    cols, rows = size(grid)
    inpoints = [Tuple(i) for i=findall(grid .== '#')]
    npoints = vcat(inpoints, [(c, rows+1) for c=1:cols])
    spoints = vcat(inpoints, [(c, 0) for c=1:cols])
    epoints = vcat(inpoints, [(0, r) for r=1:rows])
    wpoints = vcat(inpoints, [(cols+1, r) for r=1:rows])
    nbounds = [Bound(x, y, nbound(grid, x, y)) for (x, y)=npoints]
    ebounds = [Bound(x, y, ebound(grid, x, y)) for (x, y)=epoints]
    sbounds = [Bound(x, y, sbound(grid, x, y)) for (x, y)=spoints]
    wbounds = [Bound(x, y, wbound(grid, x, y)) for (x, y)=wpoints]
    return (nbounds, wbounds, sbounds, ebounds)
end

function shuffle(ballgrid::BitMatrix, nb::Vector{Bound}, wb::Vector{Bound},
                                      sb::Vector{Bound}, eb::Vector{Bound})
    for b in nb
        rocks = count(view(ballgrid, b.x, (b.y-b.n):(b.y-1)))
        ballgrid[b.x, (b.y-b.n+rocks):(b.y-1)] .= false
        ballgrid[b.x, (b.y-b.n):(b.y-b.n+rocks-1)] .= true
    end
    for b in wb
        rocks = count(view(ballgrid, (b.x-b.n):(b.x-1), b.y))
        ballgrid[(b.x-b.n+rocks):(b.x-1), b.y] .= false
        ballgrid[(b.x-b.n):(b.x-b.n+rocks-1), b.y] .= true
    end
    for b in sb
        rocks = count(view(ballgrid, b.x, (b.y+1):(b.y+b.n)))
        ballgrid[b.x, (b.y+1):(b.y+b.n-rocks)] .= false
        ballgrid[b.x, (b.y+b.n-rocks+1):(b.y+b.n)] .= true
    end
    for b in eb
        rocks = count(view(ballgrid, (b.x+1):(b.x+b.n), b.y))
        ballgrid[(b.x+1):(b.x+b.n-rocks), b.y] .= false
        ballgrid[(b.x+b.n-rocks+1):(b.x+b.n), b.y] .= true
    end
end

function process(grid, n)
    nb, wb, sb, eb = getbounds(grid)
    ballgrid = grid .== 'O'
    history = Dict{BitMatrix, Int}()
    invhist = Dict{Int, Int}()
    history[ballgrid] = 0
    invhist[0] = score(ballgrid)
    for i in 1:n
        shuffle(ballgrid, nb, wb, sb, eb)
        if ballgrid in keys(history)
            firstseen = history[ballgrid]
            loopct = i - firstseen
            aka = firstseen + mod((n - i), loopct)
            return invhist[aka]
        else
            history[ballgrid] = i
            invhist[i] = score(ballgrid)
        end
    end
    return ballgrid
end

function score(bgrid)
    indvec = transpose((size(bgrid)[2]):-1:1)
    return sum(bgrid .* indvec)
end

println(process(prep("input.txt"), 1000000000))
