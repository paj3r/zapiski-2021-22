import org.apache.commons.cli.*;

import java.util.Arrays;

public class Dn1 {

    public static void main (String[] args) throws ParseException {
        System.out.println(Arrays.toString(args));
        Options options = new Options();
        options.addOption("method", "method", true, "method");
        options.addOption("r", "r", true, "r");
        options.addOption("minx", "min-x", true, "min-x");
        options.addOption("miny", "min-y", true, "min-y");
        options.addOption("minz", "min-z", true, "min-z");
        options.addOption("maxx", "max-x", true, "max-x");
        options.addOption("maxy", "max-y", true, "max-y");
        options.addOption("maxz", "max-z", true, "max-z");
        options.addOption("resx", "res-x", true, "res-x");
        options.addOption("resy", "res-y", true, "res-y");
        options.addOption("resz", "res-z", true, "res-z");
        CommandLineParser parser = new DefaultParser();
        CommandLine cmd = parser.parse(options, args);
        String input = args[0];
        String output = args[1];
        String method = cmd.getOptionValue("method");
        float r = Float.parseFloat(cmd.getOptionValue("r"));
        float minx = Float.parseFloat(cmd.getOptionValue("minx"));
        float miny = Float.parseFloat(cmd.getOptionValue("miny"));
        float minz = Float.parseFloat(cmd.getOptionValue("minz"));
        float maxx = Float.parseFloat(cmd.getOptionValue("maxx"));
        float maxy = Float.parseFloat(cmd.getOptionValue("maxy"));
        float maxz = Float.parseFloat(cmd.getOptionValue("maxz"));
        float resx = Float.parseFloat(cmd.getOptionValue("resx"));
        float resy = Float.parseFloat(cmd.getOptionValue("resy"));
        float resz = Float.parseFloat(cmd.getOptionValue("resz"));
        System.out.println(maxy);

    }
}
