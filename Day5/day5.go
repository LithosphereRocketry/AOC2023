package main
import (
	"os"
	"bufio"
	"fmt"
	"slices"
)

type mapping struct {
	from int
	to int
	len int
}

func main() {
	f_nb, _ := os.Open("input.txt")
	f_nb.Seek(7, 0)
	f := bufio.NewReader(f_nb)
	var seeds []int
	for true {
		var val int
		n, _ := fmt.Fscanf(f, "%d", &val)
		if n == 0 {
			break
		}
		seeds = append(seeds, val)
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
		)
		for true {
			n, _ := fmt.Fscanf(f, "%d %d %d\n", &dst, &src, &num)
			if n != 3 { break }
			lmap = append(lmap, mapping{from:src, to:dst, len:num})
		}
		for ind, el := range tfseeds {
			for _, m := range lmap {
				if el >= m.from && el < m.from+m.len {
					tfseeds[ind] = m.to + (el - m.from)
					break
				}
			}
		}
	}
	fmt.Printf("%d\n", slices.Min(tfseeds))
}