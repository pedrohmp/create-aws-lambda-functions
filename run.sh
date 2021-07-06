# 1o passo criar o arquivo de politicas de segurança
# 2o criar role de segurança

aws iam create-role \
	--role-name lambda-exemplo \
	--assume-role-policy-document file://politicas.json \
	| tee logs/role.log

#3o criar arquivo com o conteudo e zipla-lo
zip function.zip index.js

aws lambda create-function \
	--function-name hello-cli-2 \
	--zip-file fileb://function.zip \
	--handler index.handler \
	--runtime nodejs14.x \
	--role arn:aws:iam::717668786709:role/lambda-exemplo \
	| tee logs/lambda-create.log

	#4o invoke lambda!
	aws lambda invoke \
		--function-name hello-cli-2 \
		--log-type Tail \
		logs/lambda-exec.log 

	#5 atualizar / zipar
	zip function.zip index.js

	#6o atualizar lambda
	aws lambda update-function-code \
		--zip-file fileb://function.zip \
		--function-name hello-cli \
		--publish \
		| tee logs/lambda-update.log

	#remover
	aws lambda delete-function \
		--function-name hello-cli-2

	aws iam delete-role \
		--role-name lambda-exemplo	