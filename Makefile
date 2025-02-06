.PHONY: setup start clean

setup:
	mkdir -p code-server-config prefect
	chmod +x custom-init.sh
	docker-compose up --build -d

start:
	@echo "Access code-server at http://$$(grep VM_IP .env | cut -d'=' -f2):8443"
	@echo "Once inside code-server:"
	@echo "1. cd /config/workspace"
	@echo "2. source .venv/bin/activate"
	@echo "3. ./start_prefect.sh"

clean:
	docker-compose down
	rm -rf code-server-config/*