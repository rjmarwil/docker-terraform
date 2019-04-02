#!/usr/bin/env bats

@test "It should install terraform in PATH" {
  command -v terraform
}

@test "It should use terraform v0.11.13" {
  terraform --version | grep 0.11.13
}

@test "It should install awscli in PATH" {
  command -v aws
}

@test "It should use aws 1.16.76" {
  aws --version | grep 1.16.76
}

@test "It should install git in PATH" {
  command -v git
}
