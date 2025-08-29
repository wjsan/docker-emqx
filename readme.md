
# EMQX Docker Setup

## Pré-requisitos

1. Configure o nome de domínio e o e-mail no arquivo `.env`:
	 ```env
	 DOMAIN=seu-dominio.com
	 EMAIL=seu-email@dominio.com
	 ```
2. Torne o script de configuração executável:
	 ```bash
	 chmod +x update-certs-and-setup.sh
	 ```
3. Certifique-se de que a porta **80** está aberta para que o Let's Encrypt possa verificar o domínio.

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
	docker logs --details certbor
	```
	Veja os logs do Certbot, incluindo informações sobre expiração dos certificados.

- **EMQX Broker**:
	```bash
	docker logs --details emqx
	```
	Veja os logs do broker EMQX e verifique se foi iniciado com sucesso.

---