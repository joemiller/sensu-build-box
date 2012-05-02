name "sensu_build_box"
description "role for the sensu-build-box"
run_list(
  "recipe[apt]",
  "recipe[sensu_jenkins]",
  "recipe[sensu_repo]"
)

override_attributes(
  :sensu_repo => {
    :base_dir => '/repo',
    :user     => 'repo'
  }
)
