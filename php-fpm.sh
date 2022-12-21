#!/bin/bash -ex

set -ex;

source common.sh;

VS=$1; shift;

nrn-add-packages php$VS-fpm
