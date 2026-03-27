.PHONY: help check verify deploy bump release

help:
	@printf "Targets:\n"
	@printf "  make check    # run local repository validation used by CI\n"
	@printf "  make verify   # compare local awink.server.conf with live host config\n"
	@printf "  make deploy   # deploy shared server config to the host\n"
	@printf "  make bump     # update consumer submodules on this workstation\n"
	@printf "  make release  # run verify -> deploy -> bump\n"

check:
	./check.sh

verify:
	./verify-live-nginx.sh

deploy:
	./deploy-awink-server.sh

bump:
	./bump-consumers.sh

release:
	./release.sh
