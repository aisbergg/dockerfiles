NODE_VERSIONS=14 12

build_targets=$(addprefix build-, $(NODE_VERSIONS))
$(build_targets): update
$(build_targets): build-%: ./release/%
	@ cd $< ;\
	make build

update:
	@ /usr/bin/env bash ./update.sh
