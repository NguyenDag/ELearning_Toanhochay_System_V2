import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.core.StandardContext;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

import java.io.File;

public class Main {
    public static void main(String[] args) throws Exception {
        String port = System.getenv("PORT") != null ? System.getenv("PORT") : "8080";
        Tomcat tomcat = new Tomcat();
        tomcat.setPort(Integer.parseInt(port));

        // Đường dẫn đến thư mục webapp
        String webappDir = new File("src/main/webapp").getAbsolutePath();
        StandardContext ctx = (StandardContext) tomcat.addWebapp("", webappDir);

        // Thêm classes (nếu có Servlet)
        File classesDir = new File("target/classes");
        if (classesDir.exists()) {
            StandardRoot resources = new StandardRoot(ctx);
            resources.addPreResources(new DirResourceSet(
                resources, "/WEB-INF/classes",
                classesDir.getAbsolutePath(), "/"
            ));
            ctx.setResources(resources);
        }

        tomcat.getConnector();
        tomcat.start();
        System.out.println("Server running at http://localhost:" + port);
        tomcat.getServer().await();
    }
}