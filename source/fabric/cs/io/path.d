/// like a System.IO.Path
module fabric.cs.io.path;

private import std.algorithm;
private import std.array;
private import std.path;

///
struct Path
{
    @disable this();

    alias directorySeparatorChar = std.path.dirSeparator;

    static string changeExtension(string path, string extension) pure
    {
        return withExtension(path, extension).array();
    }

    static string combine(string[] paths...) @safe pure nothrow
    {
        return buildNormalizedPath(paths);
    }

    static bool endsInDirectorySeparator(string path) pure
    {
        import std.algorithm : endsWith;

        return endsWith(path, directorySeparatorChar);
    }

    static string getDirectoryName(string path) pure
    {
        return dirName(path);
    }

    static string getExtension(string path) pure
    {
        return extension(path);
    }

    static string getFileName(string path) pure
    {
        if (endsInDirectorySeparator(path))
            return "";

        return baseName(path);
    }

    static string getFileNameWithoutExtension(string path) pure
    {
        return baseName(stripExtension(path));
    }

    static string getFullPath(string path)
    {
        return absolutePath(path);
    }

    static string getFullPath(string path, string basePath) pure
    {
        return absolutePath(path, basePath);
    }

    static string getRelativePath(string relativeTo, string path) pure
    {
        return relativePath(path, relativeTo);
    }

    static string getTempPath()
    {
        import std.file;

        return tempDir();
    }

    static bool hasExtension(string path) pure
    {
        return extension(path) !is null;
    }

    static bool isPathFullyQualified(string path) pure
    {
        return isAbsolute(path);
    }

    static bool isPathRooted(string path) pure
    {
        return isRooted(path);
    }

    static string trimEndingDirectorySeparator(string path) pure
    {
        if (endsWith(path, directorySeparatorChar))
            return path[0 .. $ - directorySeparatorChar.length];
        
        return path;
    }
}
