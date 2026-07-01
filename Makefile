GOMPLATE = docker run --rm -i \
	-e CENTRIFUGO_SECRET \
	-e CENTRIFUGO_ADMIN_PASSWORD \
	-e CENTRIFUGO_ALLOWED_ORIGINS \
	-e CENTRIFUGO_PERSONAL_NAMESPACE \
	-e CENTRIFUGO_ADDITIONAL_PERSONAL_NAMESPACES \
	hairyhenderson/gomplate:stable

.PHONY: validate

validate: export CENTRIFUGO_SECRET=test-secret
validate: export CENTRIFUGO_ADMIN_PASSWORD=test-password
validate: export CENTRIFUGO_ALLOWED_ORIGINS=http://localhost:3000
validate: export CENTRIFUGO_PERSONAL_NAMESPACE=personal
validate:
	@echo "==> Rendering with defaults"
	@$(GOMPLATE) < config-template.json | jq empty
	@echo "==> Rendering with additional namespaces and multiple origins"
	@CENTRIFUGO_ADDITIONAL_PERSONAL_NAMESPACES=alpha,beta \
	 CENTRIFUGO_ALLOWED_ORIGINS="http://localhost:3000,https://app.example.com" \
	 $(GOMPLATE) < config-template.json | jq empty
