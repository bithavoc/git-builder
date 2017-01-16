#FROM docker:1.12.6-dind
FROM bithavoc/builder:latest
ADD build_scripts build_scripts
#RUN apk --update add git ruby openssh
RUN chmod +x build_scripts/build.sh
CMD docker-entrypoint.sh ruby build_scripts/build.rb
