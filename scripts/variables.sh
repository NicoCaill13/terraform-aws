#!/usr/bin/env bash
name="$1"
environment="$2"
slug="$name $environment"
projectDirectory="$3"
gitDirectory="$4"
port="$5"


[[ ! -z "$6" ]] && nbTarget=$6 || nbTarget=1
[[ ! -z "$7" ]] && subnet=$7 || subnet="private"
[[ ! -z "$8" ]] && isDocker=$8 || isDocker="dockerOff"