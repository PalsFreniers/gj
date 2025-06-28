module engine::logger;
import std::io;

enum TColors : char (inline String c) {
        RESET  = "\e[0m",
        CYAN   = "\e[36m",
        GREEN  = "\e[32m",
        YELLOW = "\e[33m",
        RED    = "\e[31m",
}

macro color(TColor $c, String $str) {
        return $c +++ $str +++ TColors.RESET;
}

enum LogLevel : char (inline String prefix){
        DEBUG = color(TColors.CYAN, "[DEBUG]"),
        INFO  = color(TColors.GREEN, "[INFO]"),
        WARN  = color(TColors.YELLOW, "[WARNING]"),
        ERROR = color(TColors.RED, "[ERROR]"),
}

alias Logger = String;

fn void Logger.log(self, LogLevel lvl, String msg, args...) {
        io::printf("%s '%s' => ", lvl, self);
        io::printfn(msg, args);
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

macro Logger.error(self, $msg, args...) {
        self.log(LogLevel.ERROR, $msg, args);
}
