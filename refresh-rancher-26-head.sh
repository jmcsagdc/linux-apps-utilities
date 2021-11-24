printf "\nDocker container stop two-six-head"
docker container stop two-six-head

printf  "\nDocker container rm two-six-head"
docker container rm two-six-head

printf "\nPull new rancher v2.6-head"
docker pull rancher/rancher:v2.6-head

printf "\nRun Rancher 2.6-head on port 455"
docker run -d -p 92:80 -p 455:443 --name two-six-head --restart=unless-stopped --privileged rancher/rancher:v2.6-head

printf "\Sleep then watch for bootstrap password..."
sleep 30
watch "docker container logs two-six-head 2>&1 | grep Password"
