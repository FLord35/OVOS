#Специфицируем среду, в которой работает докер, в нашем случае это Node.js
ARG NODE_VERSION=20.10.0

#Объявляем докуру среду
FROM node:${NODE_VERSION}-alpine

#По умолчанию используем среду режима 'production'
ENV NODE_ENV production

#Создаём рабочую диресторию по указанному адресу
WORKDIR /usr/src/app

#Скачиваем зависимости для кэша Докера
#Крепим ссылку к /root/.npm для увеличения скорости следующих билдов
#Крепим ссылки к package.json и package-lock.json чтобы их не копировать
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=package-lock.json,target=package-lock.json \
    --mount=type=cache,target=/root/.npm \
    npm ci --omit=dev

#Запускаем приложение как пользователь без root прав
USER node

#Копируем все файлы приложения в образ
COPY . .

#Указываем порт, на котором нас будет слушать контейнер
EXPOSE 8080

#Запускаем приложение
CMD node server.js
