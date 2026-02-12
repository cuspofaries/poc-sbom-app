FROM python:3.12-slim AS builder

WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt
COPY . .

FROM python:3.12-slim

WORKDIR /app
COPY --from=builder /install /usr/local
COPY --from=builder /build/*.py .

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/health')" || exit 1

USER 1000:1000

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]
