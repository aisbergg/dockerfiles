NODE_VERSIONS=12 10 8

build_targets=$(addprefix build-, $(NODE_VERSIONS))
$(build_targets): update
$(build_targets): build-%: ./release/%
	@ cd $< ;\
	make build

update:
	@ /usr/bin/env bash ./update.sh
