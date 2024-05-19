#!/bin/bash

docker stop netflix
docker rm netflix
docker image rm dhruvdarji123/netflix-react-app:latest 
