public class Fetch {
    private static final String RESET = "\033[0m";
    private static final String RED = "\033[91m";
    private static final String ORANGE = "\033[33m";
    private static final String YELLOW = "\033[93m";
    private static final String GREEN = "\033[92m";
    private static final String CYAN = "\033[96m";
    private static final String MAGENTA = "\033[95m";
    private static final String BOLD = "\033[1m";

    public static String fetchCreate() {
        StringBuilder sb = new StringBuilder();

        String user = System.getProperty("user.name").toLowerCase();
        String hostname = System.getenv("HOSTNAME");
        String osName = SystemNameProvider.getSystemName();
        String kernel = SystemNameProvider.getVersionName();
        String shell = System.getenv("SHELL").replace("bin", "").replace("/", "");
        String uptime = SystemNameProvider.getUptime();
        String pkgs = SystemNameProvider.runCommand(
                "bash -c 'command -v pacman >/dev/null && pacman -Q | wc -l || " +
                        "brew list --formula | wc -l && brew list --cask | wc -l || " +
                        "dpkg --list | grep '^ii' | wc -l || " +
                        "dnf list installed | wc -l || " +
                        "apt list --installed 2>/dev/null | wc -l" +
                        "qlist -I | wc -l || " +
                        "nix-store --query --requisites /run/current-system | wc -l || " +
                        "ls /var/log/packages | wc -l || echo N/A'"
        ).trim();

        if (hostname == null || hostname.isEmpty()) hostname = SystemNameProvider.runCommand("hostname");

        sb.append("╭──────────────────────────────────────────────────").append("\n");
        sb.append(String.format("│ " + RESET + RED + "  " + RESET + BOLD + "user   " + RESET + "⟶ " + RESET + RED + BOLD + " %s" + RESET + "\n", user));
        sb.append(String.format("│ " + RESET + ORANGE + "  " + RESET + BOLD + "hname  " + RESET + "⟶ " + RESET + ORANGE + BOLD + " %s" + RESET + "\n", hostname.toLowerCase()));
        sb.append(String.format("│ " + RESET + YELLOW + " 󰻀 " + RESET + BOLD + "distro " + RESET + "⟶ " + RESET + YELLOW + BOLD + " %s" + RESET + "\n", osName));
        sb.append(String.format("│ " + RESET + GREEN + " 󰌢 " + RESET + BOLD + "kernel " + RESET  + "⟶ " + RESET + GREEN + BOLD + " %s" + RESET + "\n", kernel));
        sb.append(String.format("│ " + RESET + CYAN + "  " + RESET + BOLD + "uptime " + RESET + "⟶ " + RESET + CYAN + BOLD + " %s" + RESET + "\n", uptime));
        sb.append(String.format("│ " + RESET + MAGENTA + "  " + RESET + BOLD + "shell  " + RESET + "⟶ " + RESET + MAGENTA + BOLD + " %s" + RESET + "\n", shell));
        sb.append(String.format("│ " + RESET + RED + " 󰏖 " + RESET + BOLD + "pkgs   " + RESET  + "⟶ " + RESET + RED + BOLD + " %s" + RESET + "\n", pkgs));
        sb.append("╰──────────────────────────────────────────────────").append("\n");

        return sb.toString();
    }
}