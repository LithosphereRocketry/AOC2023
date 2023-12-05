package main
import (
	"os"
	"bufio"
	"fmt"
	"slices"
)

type seedrange struct {
	beg int
	end int
}

type mapping struct {
	from int
	to int
	len int
}

func tform(sr seedrange, lmap []mapping) []seedrange {
	var res []seedrange;
	for _, m := range lmap {
		mr := seedrange{m.from, m.from+m.len}
		if sr.beg >= mr.end || sr.end <= mr.beg {
			continue
		}
		if sr.beg < mr.beg && sr.end > mr.beg {
			res = append(res, tform(seedrange{sr.beg, mr.beg}, lmap)...)
			sr.beg = mr.beg
		}
		if sr.beg < mr.end && sr.end > mr.end {
			res = append(res, tform(seedrange{sr.end, mr.end}, lmap)...)
			sr.end = mr.end
		}
		if sr.beg >= mr.beg && sr.end <= mr.end {
			return append(res, seedrange{sr.beg + (m.to-m.from),
										 sr.end + (m.to-m.from)})
		}
	}
	return append(res, sr)
}

func main() {
	f_nb, _ := os.Open("input.txt")
	f_nb.Seek(7, 0)
	f := bufio.NewReader(f_nb)
	var seeds []seedrange
	for true {
		var (
			pos int
			len int
		)
		n, _ := fmt.Fscanf(f, "%d %d", &pos, &len)
		if n == 0 {
			break
		}
		seeds = append(seeds, seedrange{pos, pos+len})
	}
	tfseeds := seeds
	for i := 0; i < 8; i++ {
		var layer string
		fmt.Fscanf(f, "%s map:\n", &layer)
		var (
			dst int
			src int
			num int
			lmap []mapping
			newseeds []seedrange
		)
		for true {
			n, _ := fmt.Fscanf(f, "%d %d %d\n", &dst, &src, &num)
			if n != 3 { break }
			lmap = append(lmap, mapping{from:src, to:dst, len:num})
		}
		for _, el := range tfseeds {
			newseeds = append(newseeds, tform(el, lmap)...)
		}
		tfseeds = newseeds
	}
	var roots []int
	for _, val := range tfseeds {
		roots = append(roots, val.beg)
	}
	fmt.Printf("%d\n", slices.Min(roots))
}