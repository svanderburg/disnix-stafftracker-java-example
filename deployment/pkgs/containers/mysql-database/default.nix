{ stdenv, mysql, nettools, dysnomia
, name ? "mysql-database"
, mysqlUsername ? "root", mysqlPassword ? "secret"
, user ? "mysql-database", group ? "mysql-database"
, dataDir ? "/var/db/mysql", pidDir ? "/run/mysqld"
, port ? 3306
}:

let
  mysqldOptions = "--port=${toString port} --user=${user} --datadir=${dataDir} --basedir=${mysql} --pid-file=${pidDir}/mysqld.pid --socket=${pidDir}/mysqld.sock";
in
stdenv.mkDerivation {
  inherit name;
  
  buildCommand = ''
    mkdir -p $out/bin
    
    # Link some executables for convenience
    
    ln -s ${mysql}/bin/mysql $out/bin
    ln -s ${mysql}/bin/mysqldump $out/bin
    ln -s ${mysql}/bin/mysqladmin $out/bin
    
    # Create wrapper script
    cat > $out/bin/wrapper <<EOF
    #! ${stdenv.shell} -e
    
    # MySQL server needs the hostname command
    export PATH=\$PATH:${nettools}/bin
    
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
      
            if [ ! -d ${dataDir}/mysql ]
            then
                # Create the data directory
                mkdir -m 0700 -p ${dataDir}
                chown -R ${user} ${dataDir}
                ${mysql}/bin/mysql_install_db ${mysqldOptions}
                touch /tmp/mysql_init
            fi

            # Make the pid directory
            mkdir -m 0755 -p ${pidDir}
            chown -R ${user} ${pidDir}

            # Run the MySQL server
            ${mysql}/bin/mysqld_safe ${mysqldOptions} &
            
            # Wait until the MySQL server is available for use
            count=0
            while [ ! -e ${pidDir}/mysqld.sock ]
            do
                if [ \$count -eq 30 ]
                then
                    echo "Tried 30 times, giving up..."
                    exit 1
                fi

                echo "MySQL daemon not yet started. Waiting for 1 second..."
                count=\$((count++))
                sleep 1
            done
            
            if [ -f /tmp/mysql_init ]
            then
                # Change root password

                ( echo "use mysql;"
                  echo "update user set Password=password('${mysqlPassword}') where User='${mysqlUsername}';"
                  echo "flush privileges;"
                  echo "grant all on *.* to '${mysqlUsername}'@'%' identified by '${mysqlPassword}';"
                ) | ${mysql}/bin/mysql --socket=${pidDir}/mysqld.sock -u root -N
            fi
            ;;
        deactivate)
            ${mysql}/bin/mysqladmin --socket=${pidDir}/mysqld.sock -u ${mysqlUsername} -p "${mysqlPassword}" -p shutdown
            
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
  
    # Add Dysnomia container configuration file for the MySQL DBMS
    mkdir -p $out/etc/dysnomia/containers
    
    cat > $out/etc/dysnomia/containers/${name} <<EOF
    mysqlUsername="${mysqlUsername}"
    mysqlPassword="${mysqlPassword}"
    mysqlPort=${toString port}
    mysqlSocket=${pidDir}/mysqld.sock
    EOF
    
    # Copy the Dysnomia module that manages MySQL databases
    mkdir -p $out/etc/dysnomia/modules
    cp ${dysnomia}/libexec/dysnomia/mysql-database $out/etc/dysnomia/modules
  '';
}
