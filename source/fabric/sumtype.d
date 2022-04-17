module fabric.sumtype;

public import std.sumtype;

///
template matchAny(Types...)
{
    bool matchAny(TSumType)(auto ref TSumType obj)
    if (isSumType!TSumType)
    {
        import std.meta : staticMap;

        alias matchHandler(T) = (in T _) => true;

        return obj.match!(staticMap!(matchHandler, Types), _ => false);
    }
}

/// ditto
@("Overview matchAny")
unittest
{
    SumType!(int, string, Object) obj = 100;

    assert(obj.matchAny!int);
    assert(obj.matchAny!(int, string));

    assert(!obj.matchAny!string);
    assert(!obj.matchAny!(string, Object));
}
