module fabric.dotnet.io.directory;

private import std.datetime.systime : SysTime;

private static import std.file;

private import fabric.dotnet.io.path;
private import fabric.dotnet.io.filesystem;

version (Windows)
    version = Fabric_DotnetIoDirectory_SupportSymlink;
else version (Posix)
    version = Fabric_DotnetIoDirectory_SupportSymlink;

///
enum SearchOption
{
    TopDirectoryOnly = 0,
    AllDirectories = 1,
}

///
struct Directory
{
    @disable this();

    // TODO return DirectoryInfo
    static std.file.DirEntry createDirectory(string path)
    {
        auto fullPath = Path.getFullPath(path);
        std.file.mkdir(fullPath);
        return std.file.DirEntry(fullPath);
    }

    version (Fabric_DotnetIoDirectory_SupportSymlink)
    {
        // TODO return FileSystemInfo
        static std.file.DirEntry createSymbolicLink(string path, string pathToTarget)
        {
            version (Windows)
            {
                import core.sys.windows.winbase;
                import std.windows.syserror;
                import std.utf : toUTF16z;

                scope lpSymlinkFileName = toUTF16z(path);
                scope lpTargetFileName = toUTF16z(pathToTarget);
                const status = CreateSymbolicLinkW(lpSymlinkFileName, lpTargetFileName, 1);
                wenforce(status == 1, "CreateSymbolicLink");
            }
            else version (Posix)
            {
                std.file.symlink(pathToTarget, path);
            }

            return std.file.DirEntry(path);
        }
    }

    static void delete_(string path)
    {
        return std.file.rmdir(path);
    }

    static void delete_(string path, bool recurse)
    {
        if (recurse)
            std.file.rmdirRecurse(path);
        else
            std.file.rmdir(path);
    }

    // TODO return DirectoryInfo
    static auto enumerateDirectories(string path)
    {
        import std.algorithm : filter;

        return std.file.dirEntries(path, std.file.SpanMode.shallow).filter!(entry => entry.isDir);
    }

    // TODO return DirectoryInfo
    static auto enumerateDirectories(string path, string pattern)
    {
        import std.algorithm : filter;

        return std.file.dirEntries(path, pattern, std.file.SpanMode.shallow)
            .filter!(entry => entry.isDir);
    }

    // TODO return DirectoryInfo
    static auto enumerateDirectories(string path, string pattern, SearchOption option)
    {
        import std.algorithm : filter;

        const mode = option == SearchOption.AllDirectories ? std.file.SpanMode.breadth
            : std.file.SpanMode.shallow;

        return std.file.dirEntries(path, pattern, mode).filter!(entry => entry.isDir);
    }

    // TODO return FileInfo
    static auto enumerateFiles(string path)
    {
        import std.algorithm : filter;

        return std.file.dirEntries(path, std.file.SpanMode.shallow).filter!(entry => entry.isFile);
    }

    // TODO return FileInfo
    static auto enumerateFiles(string path, string pattern)
    {
        import std.algorithm : filter;

        return std.file.dirEntries(path, pattern, std.file.SpanMode.shallow)
            .filter!(entry => entry.isFile);
    }

    // TODO return FileInfo
    static auto enumerateFiles(string path, string pattern, SearchOption option)
    {
        import std.algorithm : filter;

        const mode = option == SearchOption.AllDirectories ? std.file.SpanMode.breadth
            : std.file.SpanMode.shallow;

        return std.file.dirEntries(path, pattern, mode).filter!(entry => entry.isFile);
    }

    // TODO return FileInfo
    static auto enumerateFileSytemInfo(string path)
    {
        import std.algorithm : filter;

        return std.file.dirEntries(path, std.file.SpanMode.shallow);
    }

    // TODO return FileInfo
    static auto enumerateFileSytemInfo(string path, string pattern)
    {
        import std.algorithm : filter;

        return std.file.dirEntries(path, pattern, std.file.SpanMode.shallow);
    }

    // TODO return FileInfo
    static auto enumerateFileSytemInfo(string path, string pattern, SearchOption option)
    {
        import std.algorithm : filter;

        const mode = option == SearchOption.AllDirectories ? std.file.SpanMode.breadth
            : std.file.SpanMode.shallow;

        return std.file.dirEntries(path, pattern, mode);
    }

    static bool exists(string path)
    out (result)
    {
        if (result)
            assert(path !is null);
    }
    do
    {

        scope fullPath = Path.getFullPath(path);
        return std.file.exists(fullPath);
    }

    static SysTime getCreationTime(string path)
    {
        scope fullPath = Path.getFullPath(path);
        scope entry = std.file.DirEntry(fullPath);
        return entry.timeCreated.toLocalTime();
    }

    static SysTime getCreationTimeUtc(string path)
    {
        scope fullPath = Path.getFullPath(path);
        scope entry = std.file.DirEntry(fullPath);
        return entry.timeCreated.toUTC();
    }

    static SysTime getLastAccessTime(string path)
    {
        scope fullPath = Path.getFullPath(path);
        scope entry = std.file.DirEntry(fullPath);
        return entry.timeLastAccessed.toLocalTime();
    }

    static SysTime getLastAccessTimeUtc(string path)
    {
        scope fullPath = Path.getFullPath(path);
        scope entry = std.file.DirEntry(fullPath);
        return entry.timeLastAccessed.toUTC();
    }

    static SysTime getLastWriteTime(string path)
    {
        scope fullPath = Path.getFullPath(path);
        scope entry = std.file.DirEntry(fullPath);
        return entry.timeLastModified.toLocalTime();
    }

    static SysTime getLastWriteTimeUtc(string path)
    {
        scope fullPath = Path.getFullPath(path);
        scope entry = std.file.DirEntry(fullPath);
        return entry.timeLastModified.toUTC();
    }

    static string getCurrentDirectory()
    {
        return std.file.getcwd();
    }

    /+ NOTE These are not supported. Please use the enumerate version instead

    static string[] getDirectories(string path);
    static string[] getDirectories(string path, string pattern);
    static string[] getDirectories(string path, string pattern, SearchOption option);

    static string[] getFiles(string path);
    static string[] getFiles(string path, string pattern);
    static string[] getFiles(string path, string pattern, SearchOption option);

    static string[] getSystemEntries(string path);
    static string[] getSystemEntries(string path, string pattern);
    static string[] getSystemEntries(string path, string pattern, SearchOptions option);
    +/

    /+ TODO
    static string getDirectoryRoot(string path);

    static string getLogicalDrives();

    static string getParent(string path);

    static void move(string sourceDirName, string destDirName);

    static DirEntry resolveLinkTarget(string linkPath, bool returnFinalTarget);

    static SysTime setCreationTime(string path, SysTime creationTime);
    static SysTime setCreationTimeUtc(string path, SysTime creationTime);

    static void setCurrentDirectory(string path);

    static void setLastAccessTime(string path, SysTime lastAccessTime);
    static void setLastAccessTimeUtc(string path, SysTime lastAccessTime);

    static void setLastWriteTime(string path, SysTime lastWriteTime);
    static void setLastWriteTimeUtc(string, SysTime lastWriteTime);
    +/
}

@("Directory")
unittest
{
    Directory.createDirectory("test_link_source");
    scope (exit)
        Directory.delete_("test_link_source");

    auto entry = Directory.createSymbolicLink("test_link", "test_link_source");
    scope (exit)
        Directory.delete_("test_link");

    assert(entry.name == "test_link", "name: " ~ entry.name);
}
