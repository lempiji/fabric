module fabric.checkedint;

public import std.checkedint;

///
void saturateOp(string op, T)(ref T value, T rhs) pure nothrow @safe @nogc
{
    auto temp = checked!Saturate(value);
    static if (op == "+=")
        temp += rhs;
    else static if (op == "-=")
        temp -= rhs;
    else static if (op == "*=")
        temp *= rhs;
    else static if (op == "/=")
        temp /= rhs;
    else
        static assert(false);
    value = temp.get();
}

/// ditto
unittest
{
    byte n;
    n.saturateOp!"+="(byte.max);
    n.saturateOp!"+="(byte.max);
    assert(n == byte.max);
}