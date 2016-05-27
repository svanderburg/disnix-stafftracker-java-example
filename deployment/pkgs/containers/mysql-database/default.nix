{ stdenv, mysql, nettools, dysnomia
, mysqlUsername ? "root", mysqlPassword ? "secret"
, user ? "mysql-database", group ? "mysql-database"
, dataDir ? "/var/db/mysql", pidDir ? "/run/mysqld"
}:

let
  mysqldOptions = "--user=${user} --datadir=${dataDir} --basedir=${mysql} --pid-file=${pidDir}/mysqld.pid";
in
stdenv.mkDerivation {
  name = "mysql-database";
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

            # Make the socket directory
            mkdir -p /run/mysqld
            chmod 0755 /run/mysqld
            chown -R ${user} /run/mysqld
            
            ${mysql}/bin/mysqld_safe ${mysqldOptions} &
            
            # Wait until the MySQL server is available for use
            count=0
            while [ ! -e /run/mysqld/mysqld.sock ]
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
                ) | ${mysql}/bin/mysql -u root -N
            fi
            ;;
        deactivate)
            mysqladmin -u ${mysqlUsername} -p "${mysqlPassword}" -p shutdown
            
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
  
    # Restart the job when it accidentally terminates
    mkdir -p $out/etc/dysnomia/containers
      
    # Add Dysnomia container configuration file for the MySQL DBMS
    cat > $out/etc/dysnomia/containers/mysql-database <<EOF
    mysqlUsername="${mysqlUsername}"
    mysqlPassword="${mysqlPassword}"
    mysqlPort=3306
    EOF
    
    # Copy the Dysnomia module that manages MySQL databases
    mkdir -p $out/etc/dysnomia/modules
    cp ${dysnomia}/libexec/dysnomia/mysql-database $out/etc/dysnomia/modules
  '';
}
