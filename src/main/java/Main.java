import org.apache.catalina.startup.Tomcat;
import java.io.File;

public class Main {
    public static void main(String[] args) throws Exception {
        String port = System.getenv("PORT") != null ? System.getenv("PORT") : "8080";
        Tomcat tomcat = new Tomcat();
        tomcat.setPort(Integer.parseInt(port));

        // Tìm webapp trong JAR
        String jarFile = Main.class.getProtectionDomain().getCodeSource().getLocation().getPath();
        String webappDir = new File(jarFile).getParent();

        // Dùng thư mục tạm hoặc giữ nguyên
        tomcat.addWebapp("", "src/main/webapp"); // Chỉ chạy local

        // Trên Render: Dùng /tmp
        File tempWebapp = new File("/tmp/webapp");
        // Copy từ JAR vào /tmp (cần logic)

        tomcat.start();
        tomcat.getServer().await();
    }
}