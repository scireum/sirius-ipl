/*
 * Made with all the love in the world
 * by scireum in Remshalden, Germany
 *
 * Copyright by scireum GmbH
 * http://www.scireum.de - info@scireum.de
 */

import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Semaphore;

/**
 * Initial Program Load - This is the main program entry point.
 * <p>
 * This will load all provided jar files from the "libs" sub folder as well as all classes from the "app"
 * folder. When debugging from an IDE, set the system property <tt>ide</tt> to <tt>true</tt> - this will
 * bypass class loading, as all classes are typically provided via the system classpath.
 * <p>
 * This class only generates a <tt>ClassLoader</tt> which is then used to invoke
 * {@code sirius.kernel.Sirius#initializeEnvironment(ClassLoader)} as stage2.
 */
@SuppressWarnings({"squid:S106", "squid:S1147", "squid:S1181", "squid:S1148"})
public class IPL {

    private static ClassLoader loader = ClassLoader.getSystemClassLoader();

    private IPL() {
    }

    /**
     * Main Program entry point
     *
     * @param args currently the command line arguments are ignored.
     */
    public static void main(String[] args) throws Exception {
        boolean debug = Boolean.parseBoolean(System.getProperty("debug"));
        boolean ide = Boolean.parseBoolean(System.getProperty("ide"));
        File home = new File(System.getProperty("user.dir"));
        System.out.println();
        System.out.println("I N I T I A L   P R O G R A M   L O A D");
        System.out.println("---------------------------------------");
        System.out.println("IPL from: " + home.getAbsolutePath());

        if (!ide) {
            buildAndInstallClassloader(debug, home);
        } else {
            System.out.println("IPL from IDE: not loading any classes or jars!");
        }

        try {
            System.out.println("IPL completed - Loading Sirius as stage2...");
            System.out.println();

            Class.forName("sirius.kernel.Setup", true, loader)
                 .getMethod("createAndStartEnvironment", ClassLoader.class)
                 .invoke(null, loader);

            Semaphore sync = new Semaphore(1);
            sync.acquire();

            Runtime.getRuntime().addShutdownHook(new Thread(() -> sync.release()));

            sync.acquire();

            Class.forName("sirius.kernel.Sirius", true, loader).getMethod("stop").invoke(null);

            System.exit(0);
        } catch (Throwable e) {
            e.printStackTrace();
            System.exit(-1);
        }
    }

    private static void buildAndInstallClassloader(boolean debug, File home) {
        List<URL> urls = new ArrayList<>();
        try {
            loadLibraries(debug, home, urls);
        } catch (Throwable e) {
            e.printStackTrace();
        }
        try {
            loadClasses(debug, home, urls);
        } catch (Throwable e) {
            e.printStackTrace();
        }
        loader = new URLClassLoader(urls.toArray(new URL[urls.size()]), loader);
        Thread.currentThread().setContextClassLoader(loader);
    }

    private static void loadClasses(boolean debug, File home, List<URL> urls) throws MalformedURLException {
        File classes = new File(home, "app");
        if (classes.exists()) {
            if (debug) {
                System.out.println(" - Classpath: " + classes.toURI().toURL());
            }
            urls.add(classes.toURI().toURL());
        }
    }

    private static void loadLibraries(boolean debug, File home, List<URL> urls) throws MalformedURLException {
        File jars = new File(home, "lib");
        if (jars.exists()) {
            for (URL url : allJars(jars)) {
                if (debug) {
                    System.out.println(" - Classpath: " + url);
                }
                urls.add(url);
            }
        }
    }

    /*
     * Enumerates all jars in the given directory
     */
    private static List<URL> allJars(File libs) throws MalformedURLException {
        List<URL> urls = new ArrayList<>();
        if (libs.listFiles() != null) {
            for (File file : libs.listFiles()) {
                if (file.getName().endsWith(".jar")) {
                    urls.add(file.toURI().toURL());
                }
            }
        }
        return urls;
    }
}
