module q01_fishbone;

import std.stdio;
import std.file;
import std.string;
import std.conv;
import std.algorithm;
import std.array;
import std.typecons;

long sword(string line) {
    // Split content into identifier and segments string
    auto parts = line.strip().split(':');
    if (parts.length != 2) {
        stderr.writeln("Invalid line format: ", line);
        // Or throw an exception
        import core.stdc.stdlib;
        exit(1);
    }
    // string identifier = parts[0]; // Identifier is not used in the logic
    string segmentsStr = parts[1];

    // Parse segments string into an array of integers
    auto segments = segmentsStr.split(',').map!(s => to!int(s.strip())).array;

    // Associative array for the fishbone and dynamic array for the spine
    int[string] fishbone;
    int[] spine;

    // Process each number to build the fishbone
    foreach (num; segments) {
        string placement = "C";
        while (placement in fishbone) {
            if (num < fishbone[placement] && (placement ~ "L") !in fishbone) {
                placement ~= "L";
            } else if (num > fishbone[placement] && (placement ~ "R") !in fishbone) {
                placement ~= "R";
            } else {
                placement ~= "C";
            }
        }
        fishbone[placement] = num;

        // If placement is on the central spine (no 'L' or 'R'), add to spine list
        if (!placement.canFind('L') && !placement.canFind('R')) {
            spine ~= num;
        }
    }

    long answer = 0;
    foreach (num; spine) {
        long n = num;
        long powerOf10 = 1;
        // Find the next power of 10 to shift the existing number
        do {
            powerOf10 *= 10;
            n /= 10;
        } while (n > 0);
        answer = answer * powerOf10 + num;
    }
    return answer;
}

void part1() {
    // Read the file content
    string content;
    try {
        content = readText("input.txt");
    } catch (FileException e) {
        stderr.writeln("Error reading file: ", e.msg);
        return;
    }
    sword(content).writeln;
}

void part2() {
    // read the file content as multiple lines, each line is a separate case
    string[] lines;
    try {
        lines = readText("input2.txt").strip().splitLines();
    } catch (FileException e) {
        stderr.writeln("Error reading file: ", e.msg);
        return;
    }

    // map each line to its corresponding sword value and associate with the identifier
    auto results = lines.map!((line) {
        auto parts = line.strip().split(':');
        string identifier = parts[0];
        long value = sword(line);
        return tuple(identifier, value);
    }).array;

    // take the difference between the max and min sword values
    long maxValue = results.map!(t => t[1]).maxElement;
    long minValue = results.map!(t => t[1]).minElement;
    long difference = maxValue - minValue;
    difference.writeln;
}



void main() {
    part1();
    part2();
}
