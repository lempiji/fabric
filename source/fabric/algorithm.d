module fabric.algorithm;

///
template countBy(alias selector)
{
    auto countBy(R)(R data)
    {
        import std.algorithm : map;
        import std.functional : unaryFun;
        import std.range : ElementType;

        alias fun = unaryFun!selector;
        alias Elem = ElementType!R;
        alias Key = typeof({ return fun(Elem.init); }());

        size_t[Key] counts;
        foreach (key; data.map!fun)
        {
            counts[key]++;
        }
        return counts;
    }
}

/// ditto
@("Overview countBy")
unittest
{
    static struct Person
    {
        string name;
        int age;
    }

    alias countByName = countBy!"a.name";
    alias countByAge = countBy!(a => a.age);

    auto data = [Person("A", 10), Person("B", 10), Person("B", 20), Person("B", 30)];

    auto names = countByName(data);
    auto ages = countByAge(data);

    assert(names["A"] == 1);
    assert(names["B"] == 3);

    assert(ages[10] == 2);
    assert(ages[20] == 1);
    assert(ages[30] == 1);
}
