function docker_ssh
	set first_container (docker container ls | head -n 2 | tail -n 1 | cut -d " " -f 1)
	docker exec -it $first_container bash
end
