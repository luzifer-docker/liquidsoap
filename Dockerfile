FROM ocaml/opam:debian

# Allows passing in a different script name, if desired.
ENV LIQUIDSOAP_SCRIPT=/etc/liquidsoap/liquidsoap.liq \
    LIQUIDSOAP_VERSION=1.3.3

# Initialize OPAM and install Liquidsoap and asssociated packages
COPY build.sh /usr/local/bin/build.sh
RUN set -ex \
 && /usr/local/bin/build.sh

# Expose mountpoints for script / data
VOLUME ["/data", "/etc/liquidsoap"]

# Expose ports for harbor connections and telnet server, respectively
EXPOSE 8080 8011

# Start Liquidsoap with a path to the script defined in the variable
ENTRYPOINT ["/home/liquidsoap/.opam/system/bin/liquidsoap"]
CMD [${LIQUIDSOAP_SCRIPT}]
