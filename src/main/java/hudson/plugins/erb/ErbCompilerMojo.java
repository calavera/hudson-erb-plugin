package hudson.plugins.erb;

import java.io.File;
import java.io.FilenameFilter;

import java.util.ArrayList;
import java.util.List;

import org.apache.maven.model.Resource;
import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;

import org.jruby.embed.LocalContextScope;
import org.jruby.embed.PathType;
import org.jruby.embed.ScriptingContainer;

/**
 * Compiles ERB templates
 *
 * @goal erb-compile
 * @phase process-resources
 * @threadSafe
 */
public class ErbCompilerMojo extends AbstractMojo {
    /**
     * Project resources directory
     *
     * @parameter expression="${project.resources}"
     * @required
     * @readonly
     */
    private List<Resource> resources;

    public void execute() throws MojoExecutionException {
        ScriptingContainer container = new ScriptingContainer(LocalContextScope.SINGLETHREAD);

        for (Resource resourceDirectory : resources) {
            loadPathAndExtensions(container, resourceDirectory);

            container.put("resources", resourceDirectory.getDirectory());

            container.runScriptlet(PathType.CLASSPATH, "hudson_erb.rb");
        }
    }

    private void loadPathAndExtensions(ScriptingContainer container, Resource resourceDirectory) {
        List<String> loadPaths = getRubyPath();

        File dir = new File(resourceDirectory.getDirectory());
        File[] exts = dir.listFiles(filter);
        if (exts != null && exts.length > 0) {
            for (File ext : exts) {
                loadPaths.add(ext.getAbsolutePath());
            }
        }

        container.setLoadPaths(loadPaths);
    }

    private List<String> getRubyPath() {
        List<String> loadPath = new ArrayList<String>();
        loadPath.add(getResource("hudson_erb.rb"));
        loadPath.add(getResource("hudson_erb"));

        return loadPath;
    }

    private String getResource(String resource) {
        return getClass().getClassLoader().getResource(resource).toString().replace("jar:", "");
    }

    private static class ExtFilenameFilter implements java.io.FilenameFilter {
        public boolean accept(File dir, String name) {
            return name.equals("hudson_erb");
        }
    }

    private static ExtFilenameFilter filter = new ExtFilenameFilter();
}
