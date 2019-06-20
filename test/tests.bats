#!/usr/bin/env bats

@test "It should install terraform in PATH" {
  command -v terraform
}

@test "It should use terraform v0.12.0" {
  terraform --version | grep 0.12.0
}

@test "It should install awscli in PATH" {
  command -v aws
}

@test "It should use aws 1.16.183" {
  aws --version | grep 1.16.183
}

@test "It should install git in PATH" {
  command -v git
}
