{ stdenv, tomcat, jdk, dysnomia
, baseDir ? "/var/tomcat"
, catalinaOpts ? "-Xms64m -Xmx256m"
, user ? "tomcat-webapp"
, group ? "tomcat-webapp"
, commonLibs ? []
}:

stdenv.mkDerivation {
  name = "tomcat-webapplication";
  buildCommand = ''
    mkdir -p $out/bin
    
    cat > $out/bin/wrapper <<EOF
    #! ${stdenv.shell} -e
    
    case "\$1" in
        activate)
            # Create group
            if ! getent group ${group}
            then
                groupadd ${group}
            fi
            
            # Create user
            if ! id -u ${user}
            then
                useradd ${user}
            fi

            # Create the base directory
            mkdir -p ${baseDir}

            # Create a symlink to the bin directory of the tomcat component
            ln -sfn ${tomcat}/bin ${baseDir}/bin
            
            # Create a conf/ directory
            mkdir -p ${baseDir}/conf
            chown ${user}:${group} ${baseDir}/conf

            # Symlink the config files in the conf/ directory (except for catalina.properties and server.xml)
            for i in \$(ls ${tomcat}/conf | grep -v catalina.properties | grep -v server.xml)
            do
                ln -sfn ${tomcat}/conf/\$i ${baseDir}/conf/\$(basename \$i)
            done
            
            # Create a modified catalina.properties file
            # Change all references from CATALINA_HOME to CATALINA_BASE and add support for shared libraries
            sed -e 's|\''${catalina.home}|\''${catalina.base}|g' \
                -e 's|shared.loader=|shared.loader=\''${catalina.base}/shared/lib/\*.jar|' \
                ${tomcat}/conf/catalina.properties > ${baseDir}/conf/catalina.properties

            # Copy the server.xml config
            cp ${tomcat}/conf/server.xml ${baseDir}/conf/server.xml
            
            # Create a logs/ directory
            mkdir -p ${baseDir}/logs
            chown ${user}:${group} ${baseDir}/logs
            
            # Create a temp/ directory
            mkdir -p ${baseDir}/temp
            chown ${user}:${group} ${baseDir}/temp

            # Create a lib/ directory
            mkdir -p ${baseDir}/lib
            chown ${user}:${group} ${baseDir}/lib

            # Create a shared/lib directory
            mkdir -p ${baseDir}/shared/lib
            chown ${user}:${group} ${baseDir}/shared/lib

            # Create a webapps/ directory
            mkdir -p ${baseDir}/webapps
            chown ${user}:${group} ${baseDir}/webapps
            
            # Create a work/ directory
            mkdir -p ${baseDir}/work
            chown ${user}:${group} ${baseDir}/work
            
            # Symlink all the given common libs files or paths into the lib/ directory
            for i in ${tomcat} ${toString commonLibs}
            do
                if [ -f \$i ]
                then
                    # If the given web application is a file, symlink it into the common/lib/ directory
                    ln -sfn \$i ${baseDir}/lib/\$(basename \$i)
                elif [ -d \$i ]
                then
                    # If the given web application is a directory, then iterate over the files
                    # in the special purpose directories and symlink them into the tomcat tree

                    for j in \$i/lib/*
                    do
                        ln -sfn \$j ${baseDir}/lib/\$(basename \$j)
                   done
                fi
            done

            # Start Apache Tomcat
            su ${user} -s /bin/sh -c 'CATALINA_BASE=${baseDir} JAVA_HOME=${jdk} CATALINA_OPTS="${catalinaOpts}" ${tomcat}/bin/startup.sh'
            ;;
        deactivate)
            su ${user} -s /bin/sh -c "CATALINA_BASE=${baseDir} JAVA_HOME=${jdk} ${tomcat}/bin/shutdown.sh"
            
            # Delete user
            if id -u ${user}
            then
                userdel ${user}
            fi
            
            # Delete group
            if getent group ${group}
            then
                groupdel ${group}
            fi
            ;;
    esac
    EOF
    
    chmod +x $out/bin/wrapper
    
    # Add Dysnomia container configuration file for Apache Tomcat
    mkdir -p $out/etc/dysnomia/containers
    cat > $out/etc/dysnomia/containers/tomcat-webapplication <<EOF
    tomcatPort=8080
    EOF
    
    # Copy the Dysnomia module that manages Apache Tomcat web applications
    mkdir -p $out/etc/dysnomia/modules
    cp ${dysnomia}/libexec/dysnomia/tomcat-webapplication $out/etc/dysnomia/modules
  '';
}
