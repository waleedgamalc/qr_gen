# -------------------------
# Stage 1: Build dependencies
# -------------------------

FROM python:3.13.14-slim-trixie AS build 

WORKDIR /source

COPY requirements.txt .

RUN pip install --no-cache-dir  \ 
--prefix=/install \ 
-r requirements.txt

# -------------------------
# Stage 2: Runtime image
# -------------------------

FROM python:3.13.14-slim-trixie


WORKDIR /app 

COPY --from=build /install /usr/local

COPY . .

EXPOSE 5000

CMD ["python" , "app.py"]
