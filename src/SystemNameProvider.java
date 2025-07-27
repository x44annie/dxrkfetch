import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.regex.*;

public class SystemNameProvider {

    public static String getSystemName() {
        String os = System.getProperty("os.name").toLowerCase();
        String localLine;

        if (os.contains("mac")) {
            localLine = getMacOSName();
        } else if (os.contains("linux")) {
            localLine = getLinuxDistroName();
        } else {
            localLine = "Unknown OS";
        }

        return localLine.toLowerCase();
    }

    public static String getVersionName() {
        String os = System.getProperty("os.name").toLowerCase();

        if (os.contains("mac")) {
            return getVersionMacOS();
        } else if (os.contains("linux")) {
            return getVersionLinux();
        } else {
            return "Unknown Version";
        }
    }

     private static String getLinuxDistroName() {
        try {
            ProcessBuilder builder = new ProcessBuilder("cat", "/etc/os-release");
            Process process = builder.start();

            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;

            while ((line = reader.readLine()) != null) {
                if (line.startsWith("NAME=")) {
                    return line.split("=", 2)[1].replace("\"", "").trim();
                }
            }
        } catch (Exception e) {
          System.out.println("Invalid input, type is not supported");
        }
        return "Unknown Linux";
    }

    private static String getVersionLinux() {
        try {
            ProcessBuilder builder = new ProcessBuilder("uname", "-a");
            Process process = builder.start();

            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;

            if ((line = reader.readLine()) != null) {
                Pattern pattern = Pattern.compile("\\b\\d+(\\.\\d+)+([-\\w]*)?\\b");
                Matcher matcher = pattern.matcher(line);

                if (matcher.find()) {
                    return matcher.group().trim();
                }
            }
        } catch (Exception e) {
          System.out.println("Invalid input, type is not supported");
        }
        return "Unknown Version";
    }

    private static String getMacOSName() {
        try {
            ProcessBuilder builder = new ProcessBuilder("sw_vers");
            Process process = builder.start();

            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;

            while ((line = reader.readLine()) != null) {
                if (line.startsWith("ProductName")) {
                    return line.split(":", 2)[1].trim();
                }
            }
        } catch (Exception e) {
          System.out.println("Invalid input, type is not supported");
        }
        return "Unknown macOS";
    }

    private static String getVersionMacOS() {
        try {
            ProcessBuilder builder = new ProcessBuilder("sw_vers");
            Process process = builder.start();

            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;

            while ((line = reader.readLine()) != null) {
                if (line.startsWith("ProductVersion")) {
                    return line.split(":", 2)[1].trim();
                }
            }
        } catch (Exception e) {
          System.out.println("Invalid input, type is not supported");
        }
        return "Unknown Version";
    }

    public static String runCommand(String command) {
        try {
            Process process = Runtime.getRuntime().exec(new String[]{"bash", "-c", command});
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            return reader.readLine();
        } catch (Exception e) {
            System.out.println("Failed to run command: " + command);
            return "N/A";
        }
    }

    public static String getUptime() {
        String os = System.getProperty("os.name").toLowerCase();
        if (os.contains("mac")) {
            return runCommand("uptime | sed 's/.*up *//; s/,.*//' ");
        } else {
            return runCommand("uptime -p");
        }
    }
}