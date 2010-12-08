package hudson.plugins.erb;

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
        container.setLoadPaths(getRubyPath());

        for (Resource resourceDirectory : resources) {
            container.put("resources", resourceDirectory.getDirectory());

            container.runScriptlet(PathType.CLASSPATH, "hudson_erb.rb");
        }
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
}
