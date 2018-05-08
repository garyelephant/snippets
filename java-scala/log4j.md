Java 代码必须用org.apache.log4j.Logger;
import org.apache.log4j.Logger;
private static final Logger log = Logger.getLogger(PolarisAccumulator.class);

启动时指定log4j.properties 的方式: java -Dlog4j.configuration=conf/log4j.properties ...

配置文件示例如下：（指定打印出所有的debug日志）
log4j.rootLogger=debug, console
log4j.appender.console=org.apache.log4j.ConsoleAppender
log4j.appender.console.layout=org.apache.log4j.PatternLayout
log4j.appender.console.layout.ConversionPattern=%-4r [%t] %-5p %c %x - %m%n
