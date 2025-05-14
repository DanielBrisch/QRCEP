CREATE TABLE address (
    cep          TEXT    PRIMARY KEY,
    logradouro   TEXT    NOT NULL,
    complemento  TEXT    DEFAULT '',
    unidade      TEXT    DEFAULT '',
    bairro       TEXT    NOT NULL,
    localidade   TEXT    NOT NULL,
    uf           TEXT    NOT NULL,
    estado       TEXT    NOT NULL,
    regiao       TEXT    NOT NULL,
    ibge         TEXT    NOT NULL,
    gia          TEXT    DEFAULT '',
    ddd          TEXT    NOT NULL,
    siafi        TEXT    NOT NULL
)