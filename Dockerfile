# Build stage
FROM node:18-alpine AS build

WORKDIR /usr/src/packages

# Copy root package.json and lockfile
COPY package.json ./
#COPY yarn.lock ./

# Copy components package.json
COPY packages/components/package.json ./packages/components/package.json

# Copy ui package.json
COPY packages/ui/package.json ./packages/ui/package.json

# Copy server package.json
COPY packages/server/package.json ./packages/server/package.json

RUN yarn install

# Copy app source
COPY . .

RUN yarn build

# Production stage
FROM node:18-alpine

WORKDIR /usr/src/app

COPY --from=build /usr/src/packages/package.json ./
COPY --from=build /usr/src/packages/yarn.lock ./
COPY --from=build /usr/src/packages/node_modules ./node_modules
COPY --from=build /usr/src/packages/dist ./dist

EXPOSE 3000

CMD [ "yarn", "start" ]
