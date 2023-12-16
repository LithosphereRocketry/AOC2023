using System;
using System.IO;

public class day13 {
    static long popcount(long val) {
        long tot = 0;
        while(val > 0) {
            tot += (val & 1);
            val >>= 1;
        }
        return tot;
    }

    static public void Main() {
        String text = File.ReadAllText("input.txt");
        String[] puzzles = text.Split("\n\n");

        long rtot = 0;
        long ctot = 0;

        foreach(String puzzle in puzzles) {
            String[] lines = puzzle.Split("\n");
            int rows = lines.Length;
            int cols = lines[0].Length;
            bool[,] grid = new bool[rows, cols];
            for(int i = 0; i < rows; i++) {
                for(int j = 0; j < cols; j++) {
                    grid[i, j] = (lines[i][j] == '#');
                }
            }
            long[] rowvecs = new long[cols];
            for(int i = 0; i < cols; i++) {
                long tot = 0;
                for(int j = 0; j < rows; j++) {
                    tot <<= 1;
                    if(grid[j, i]) { tot |= 1; }
                }
                rowvecs[i] = tot;
            }
            int rpalin = 0;
            for(int i = 0; i < cols-1; i++) {
                long pop = 0;
                for(int j = 0; j <= i && j < cols-i-1; j++) {
                    pop += popcount(rowvecs[i - j] ^ rowvecs[i + j + 1]);
                    if(pop > 1) { break; }
                }
                if(pop == 1) {
                    rpalin = i+1;
                    break;
                }
            }
            long[] colvecs = new long[rows];
            for(int i = 0; i < rows; i++) {
                long tot = 0;
                for(int j = 0; j < cols; j++) {
                    tot <<= 1;
                    if(grid[i, j]) { tot |= 1; }
                }
                colvecs[i] = tot;
            }
            int cpalin = 0;
            for(int i = 0; i < rows-1; i++) {
                long pop = 0;
                for(int j = 0; j <= i && j < rows-i-1; j++) {
                    pop += popcount(colvecs[i - j] ^ colvecs[i + j + 1]);
                    if(pop > 1) { break; }
                }
                if(pop == 1) {
                    cpalin = i+1;
                    break;
                }
            }
            if(rpalin > 0) { rtot += rpalin; }
            if(cpalin > 0) { ctot += cpalin; }
        }
        Console.WriteLine(ctot*100 + rtot);
    }
}
