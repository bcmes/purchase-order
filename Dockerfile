# Etapa 1: Compilação
# Utilizando a imagem oficial do Maven para compilar o projeto
FROM maven:3.8.8-amazoncorretto-21 AS build

# Definindo o diretório de trabalho
WORKDIR /app

# Copiando o arquivo de configuração do Maven (pom.xml)
COPY pom.xml .

# Baixando as dependências do Maven
RUN mvn dependency:go-offline -B

# Copiando o código-fonte do projeto
COPY src ./src

# Compilando o projeto
RUN mvn clean package -DskipTests

# Etapa 2: Executando o JAR compilado
# Utilizando a imagem do JDK para executar o JAR gerado
FROM eclipse-temurin:23.0.1_11-jre-ubi9-minimal

# Definindo o diretório de trabalho na nova imagem
WORKDIR /app

# Copiando o JAR da etapa de build para a imagem final
COPY --from=build /app/target/*.jar /app/app.jar

# Expondo a porta que a aplicação vai usar (por exemplo, 8080)
EXPOSE 8080

# Definindo o comando de execução da aplicação
CMD ["java", "-jar", "/app/app.jar"]