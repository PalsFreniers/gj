module engine::logger;
import std::io;
import libc;

enum TColor : char (inline String c) {
        RESET  = "\e[0m",
        CYAN   = "\e[36m",
        GREEN  = "\e[32m",
        YELLOW = "\e[33m",
        RED    = "\e[31m",
}

macro @color(TColor $c, String $str) {
        return $c.c +++ $str +++ TColor.RESET.c;
}

enum LogLevel : char (inline String prefix){
        DEBUG = @color(TColor.CYAN, "[DEBUG]"),
        INFO  = @color(TColor.GREEN, "[INFO]"),
        WARN  = @color(TColor.YELLOW, "[WARNING]"),
        ERROR = @color(TColor.RED, "[ERROR]"),
}

alias Logger = String;

macro void Logger.log(self, LogLevel lvl, String $msg, args...) {
        io::printf("%s '%s' => ", lvl, self);
        io::printfn($msg, ...args);
}

macro Logger.debug(self, $msg, args...) {
        self.log(LogLevel.DEBUG, $msg, args);
}

macro Logger.info(self, $msg, args...) {
        self.log(LogLevel.INFO, $msg, args);
}

macro Logger.warn(self, $msg, args...) {
        self.log(LogLevel.WARN, $msg, args);
}

macro Logger.error(self, $msg, args...) @noreturn {
        self.log(LogLevel.ERROR, $msg, args);
        unreachable("game crashed");
}
