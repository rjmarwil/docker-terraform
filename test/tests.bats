#!/usr/bin/env bats

@test "It should install terraform in PATH" {
  which terraform
}

@test "It should use terraform v0.11.10" {
  terraform --version | grep 0.11.10
}

@test "It should install awscli in PATH" {
  which aws
}

@test "It should use aws 1.16.48" {
  aws --version | grep 1.16.48
}
