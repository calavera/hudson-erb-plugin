package hudson.plugins.erb;

import java.util.Collections;
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

            container.runScriptlet(PathType.CLASSPATH, "ruby/hudson_erb.rb");
        }
    }

    private List<String> getRubyPath() {
        return Collections.singletonList(
            getClass().getClassLoader().getResource("ruby").toString().replace("jar:", ""));
    }
}
