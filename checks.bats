#! /usr/bin/env bats

# Variable SUT_IP should be set outside this script and should contain the IP
# address of the System Under Test.

# Tests
@test 'Namespace configuration' {
  run bash -c "curl -s http://${SUT_IP}:6006/v3.0/TRAVIS/conscience/info"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
  [[ "${output}" =~ "TRAVIS" ]]
}

@test 'List the services types' {
  run bash -c "curl -s http://${SUT_IP}:6006/v3.0/TRAVIS/conscience/info?what=types"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
  [[ "${output}" =~ "oiofs" ]]
}

@test 'Register a rawx' {
  run bash -c "curl -s -d '{\"type\":\"rawx\", \"addr\":\"127.0.0.1:6121\", \"tags\": { \"stat.cpu\": 42, \"stat.idle\": 42, \"stat.io\": 42 }}' -H \"Content-Type: application/json\" -X POST  http://${SUT_IP}:6006/v3.0/TRAVIS/conscience/register"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
}

@test 'Rawx is present' {
  run bash -c "curl -s http://${SUT_IP}:6006/v3.0/TRAVIS/conscience/list?type=rawx"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
  [[ "${output}" =~ "127.0.0.1:6121" ]]
}

@test 'Specific configurations' {
  run bash -c "docker exec -ti ${SUT_ID} cat /etc/oio/sds/TRAVIS/oioproxy-0/oioproxy-0.conf"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
  [[ "${output}" =~ "proxy.period.cs.downstream=7" ]]
  [[ "${output}" =~ "proxy.cache.enabled=off" ]]
}
