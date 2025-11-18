module quest01;

import std.stdio;
import std.string : format;

struct ComplexNumber
{
    long x;
    long y;

    ComplexNumber opBinary(string op)(ComplexNumber n2) const
    {
        static if (op == "+")
        {
            return ComplexNumber(x + n2.x, y + n2.y);
        }
        else static if (op == "-")
        {
            return ComplexNumber(x - n2.x, y - n2.y);
        }
        else static if (op == "*")
        {
            return ComplexNumber(x * n2.x - y * n2.y, x * n2.y + y * n2.x);
        }
        else static if (op == "/")
        {
            return ComplexNumber(x / n2.x, y / n2.y);
        }
    }

    string toString() const
    {
        return format("[%d,%d]", x, y);
    }
}

void part1()
{
    //auto a = ComplexNumber(25, 9); // example
    auto a = ComplexNumber(160, 63);
    auto result = ComplexNumber(0, 0);
    for (int i = 0; i < 3; i++)
    {
        result = result * result;
        result = result / ComplexNumber(10, 10);
        result = result + a;
    }
    writeln("result = ", result);
}

void part23(int gridresolution)
{
    // auto corner1 = ComplexNumber(35_300, -64_910); example
    auto corner1 = ComplexNumber(-21_733, -68_997);

    auto corner2 = corner1 + ComplexNumber(1000, 1000);
    // iterate among x and y coordinates
    auto goodpoints = 0;
    // print corner
    writeln("corner1 = ", corner1);
    writeln("corner2 = ", corner2);
    for (long x = corner1.x; x <= corner2.x; x += gridresolution)
    {
        for (long y = corner1.y; y <= corner2.y; y += gridresolution)
        {
            auto p = ComplexNumber(x, y);
            writeln("checking point = ", p);
            auto r = ComplexNumber(0, 0);
            auto good = 1;
            for (int i = 0; i < 100; i++)
            {
                r = r * r;
                r = r / ComplexNumber(100_000, 100_000);
                r = r + p;
                if (r.x > 1_000_000 || r.x < -1_000_000 || r.y > 1_000_000 || r.y < -1_000_000)
                {
                    good = 0;
                    break;
                }
            }
            // print point and result
            if (good)
                writeln("result = ", r);

            goodpoints += good;
        }
    }
    writeln("good points = ", goodpoints);
}

void main()
{
    writeln("-------------- part1  ------------------");
    part1();
    writeln("-------------- part2  ------------------");
    part23(10);
    writeln("-------------- part3  ------------------");
    part23(1);
}
