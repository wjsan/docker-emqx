
# EMQX Docker Setup

## Pré-requisitos

1. Configure o nome de domínio e o e-mail no arquivo `.env`:
	 ```env
	 DOMAIN=seu-dominio.com
	 EMAIL=seu-email@dominio.com
	 ```
2. Torne o script de instalação executável:
	```bash
	chmod +x install-docker.sh
	```

3. Instale o docker
   ```bash
   ./install-docker.sh
   ```

4. Torne o script de configuração executável:
	 ```bash
	 chmod +x update-certs-and-setup.sh
	 chmod +x start-emqx.sh
	 ```

5. Certifique-se de que a porta **80** está aberta para que o Let's Encrypt possa verificar o domínio.
	```bash
	sudo su # login as root
	iptables -I INPUT -j ACCEPT # will allow traffic
	iptables-save > /etc/iptables/rules.v4 # persist configuration
	exit
	```
	Utilize o site https://www.yougetsignal.com/tools/open-ports/ para testar se as portas utilizadas estão abertas.

6. Adicione o usuário ao grupo docker:
	```bash
	sudo usermod -aG docker $USER
	```
---

## Build e Execução

Para construir e iniciar os containers:
```bash
docker compose up -d --build
```

---

## Inspeção de Logs

- **Certbot**:
	```bash
	docker logs --details certbot
	```
	Veja os logs do Certbot, incluindo informações sobre expiração dos certificados.

- **EMQX Broker**:
	```bash
	docker logs --details emqx
	```
	Veja os logs do broker EMQX e verifique se foi iniciado com sucesso.

---