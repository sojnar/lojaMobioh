--
-- PostgreSQL database dump
--

-- Dumped from database version 12.3
-- Dumped by pg_dump version 13.2

-- Started on 2021-04-25 21:50:28

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 3079 OID 277778)
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- TOC entry 3314 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- TOC entry 3 (class 3079 OID 277789)
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- TOC entry 3315 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- TOC entry 2 (class 3079 OID 277866)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 3316 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 301 (class 1255 OID 277877)
-- Name: fnc_retorna_desc_mes(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fnc_retorna_desc_mes() RETURNS character varying
    LANGUAGE plpgsql
    AS $$

declare
    descricao character varying;
    mes       bigint;
BEGIN
    select extract(month from now()) into mes;
    SELECT (CASE
                WHEN mes = 1 THEN 'JAN'
                WHEN mes = 2 THEN 'FEV'
                WHEN mes = 3 THEN 'MAR'
                WHEN mes = 4 THEN 'ABR'
                WHEN mes = 5 THEN 'MAI'
                WHEN mes = 6 THEN 'JUN'
                WHEN mes = 7 THEN 'JUL'
                WHEN mes = 8 THEN 'AGO'
                WHEN mes = 9 THEN 'SET'
                WHEN mes = 10 THEN 'OUT'
                WHEN mes = 11 THEN 'NOV'
                WHEN mes = 12 THEN 'DEZ'
        END)
    INTO descricao;

    RETURN descricao;
END;
$$;


--
-- TOC entry 302 (class 1255 OID 277878)
-- Name: fnc_retorna_dia_mes_desc(date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fnc_retorna_dia_mes_desc(datames date) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
declare
    descricao character varying;
    mes       bigint;
BEGIN
    select extract(month from datames) into mes;
    SELECT (CASE
                WHEN mes = 1 THEN 'JANEIRO'
                WHEN mes = 2 THEN 'FEVEREIRO'
                WHEN mes = 3 THEN 'MARÇO'
                WHEN mes = 4 THEN 'ABRIL'
                WHEN mes = 5 THEN 'MAIO'
                WHEN mes = 6 THEN 'JUNHO'
                WHEN mes = 7 THEN 'JULHO'
                WHEN mes = 8 THEN 'AGOSTO'
                WHEN mes = 9 THEN 'SETEMBRO'
                WHEN mes = 10 THEN 'OUTUBRO'
                WHEN mes = 11 THEN 'NOVEMBRO'
                WHEN mes = 12 THEN 'DEZEMBRO'
        END)
    INTO descricao;

    RETURN extract(day from datames) || ' DE ' || descricao;
END;
$$;


--
-- TOC entry 303 (class 1255 OID 277879)
-- Name: fnc_retorna_dia_mes_hor_abrv(timestamp without time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fnc_retorna_dia_mes_hor_abrv(datahorario timestamp without time zone) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
declare
    descricao character varying;
    mes       bigint;
BEGIN
    select extract(month from datahorario) into mes;
    SELECT (CASE
                WHEN mes = 1 THEN 'JAN'
                WHEN mes = 2 THEN 'FEV'
                WHEN mes = 3 THEN 'MAR'
                WHEN mes = 4 THEN 'ABR'
                WHEN mes = 5 THEN 'MAI'
                WHEN mes = 6 THEN 'JUN'
                WHEN mes = 7 THEN 'JUL'
                WHEN mes = 8 THEN 'AGO'
                WHEN mes = 9 THEN 'SET'
                WHEN mes = 10 THEN 'OUT'
                WHEN mes = 11 THEN 'NOV'
                WHEN mes = 12 THEN 'DEZ'
        END)
    INTO descricao;
    RETURN extract(day from datahorario) || ' ' || descricao || ' - ' || TO_CHAR(datahorario, 'HH24:MI');
END;
$$;


--
-- TOC entry 304 (class 1255 OID 277880)
-- Name: fnc_retorna_ref_ped(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fnc_retorna_ref_ped() RETURNS character varying
    LANGUAGE plpgsql
    AS $$

declare
    referencia character varying;
BEGIN
    SELECT FORMAT('%s-%s-%s',
                  (select extract(year from now())),
                  fnc_retorna_desc_mes(),
                  (select (count(*) + 1) from lancamentospedidoapp)
               )
    INTO referencia;

    RETURN referencia;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 205 (class 1259 OID 277881)
-- Name: anunciosofertas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.anunciosofertas (
    idanunciooferta uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    iddepartamentosecao integer,
    iddepartamentosecaofiltro integer,
    marcafiltro character varying(250),
    titulo character varying(500) NOT NULL,
    preco numeric(12,6),
    precooferta numeric(12,6),
    tipo character varying(50) NOT NULL,
    posicao character varying(50) NOT NULL,
    iniciovigencia timestamp without time zone NOT NULL,
    fimvigencia timestamp without time zone NOT NULL,
    urlfoto character varying(250) NOT NULL,
    urlfotomobile character varying(250) NOT NULL,
    urlredirecionamentobanner character varying(250),
    ordem integer,
    exibirtitulo boolean DEFAULT true NOT NULL,
    ativo boolean NOT NULL,
    datacancelamento timestamp without time zone,
    dataatualizacao timestamp without time zone NOT NULL
);


--
-- TOC entry 206 (class 1259 OID 277889)
-- Name: anunciosofertasprodutos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.anunciosofertasprodutos (
    idanuncioofertaproduto uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    idanuncioofertaprodutoexterno character varying(50),
    idanunciooferta uuid NOT NULL,
    idprodutoweb uuid NOT NULL,
    ordem integer,
    ativo boolean NOT NULL,
    datacancelamento timestamp without time zone,
    dataatualizacao timestamp without time zone NOT NULL
);


--
-- TOC entry 207 (class 1259 OID 277893)
-- Name: cidades; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cidades (
    idcidadeibge integer NOT NULL,
    idestadoibge integer NOT NULL,
    codigoibge integer,
    nomecidade character varying(1000),
    dataatualizacao timestamp without time zone DEFAULT now()
);


--
-- TOC entry 208 (class 1259 OID 277900)
-- Name: clientes_codigo_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clientes_codigo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 209 (class 1259 OID 277902)
-- Name: clientes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clientes (
    idcliente uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    idclienteexterno character varying(50),
    idusuario uuid,
    codigocliente integer,
    nome character varying(500) NOT NULL,
    tipopessoa character varying(25) NOT NULL,
    cpfcnpj character varying(14) NOT NULL,
    telefone character varying(25),
    email character varying(500),
    datacadastro timestamp without time zone,
    solicitouresetsenha boolean DEFAULT false,
    permitesercontatado boolean DEFAULT false,
    permitereceberoferta boolean DEFAULT false,
    ativo boolean DEFAULT true,
    datainativacao timestamp without time zone,
    codigosequencial bigint DEFAULT nextval('public.clientes_codigo_seq'::regclass) NOT NULL,
    dataatualizacao timestamp without time zone NOT NULL
);


--
-- TOC entry 210 (class 1259 OID 277914)
-- Name: clientesenderecos_codigo_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clientesenderecos_codigo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 211 (class 1259 OID 277916)
-- Name: clientesenderecos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clientesenderecos (
    idclienteendereco uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    idcliente uuid NOT NULL,
    descricao character varying(30),
    logradouro character varying(300),
    numero character varying(25),
    complemento character varying(1000),
    bairro character varying(1000),
    idcidadeibge integer NOT NULL,
    cep character varying(8),
    referencia character varying(1000),
    ativo boolean DEFAULT true,
    principal boolean DEFAULT true,
    dadoslocalizacao text,
    codigosequencial bigint DEFAULT nextval('public.clientesenderecos_codigo_seq'::regclass) NOT NULL,
    dataatualizacao timestamp without time zone NOT NULL
);


--
-- TOC entry 212 (class 1259 OID 277926)
-- Name: concorrentes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.concorrentes (
    idconcorrente uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    idconcorrenteexterno character varying(50) NOT NULL,
    descricao character varying(25) NOT NULL,
    urlfoto character varying(250),
    datacadastro timestamp without time zone,
    ativo boolean DEFAULT true,
    datainativacao timestamp without time zone,
    dataatualizacao timestamp without time zone NOT NULL
);


--
-- TOC entry 213 (class 1259 OID 277931)
-- Name: concorrentesprecos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.concorrentesprecos (
    idconcorrentepreco uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    idconcorrente uuid NOT NULL,
    idprodutoweb uuid NOT NULL,
    precovenda numeric(12,6),
    dataexpiracao timestamp without time zone NOT NULL,
    dataatualizacao timestamp without time zone NOT NULL
);


--
-- TOC entry 214 (class 1259 OID 277935)
-- Name: cupons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cupons (
    idcupom uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    descricao character varying(50) NOT NULL,
    codigo character varying(20) NOT NULL,
    regras character varying(250) NOT NULL,
    valor numeric(12,6) NOT NULL,
    valorempercentual boolean DEFAULT false NOT NULL,
    quantidade integer NOT NULL,
    quantidadeporcliente integer DEFAULT 1 NOT NULL,
    datainicial timestamp without time zone NOT NULL,
    datafinal timestamp without time zone NOT NULL,
    horainicial time without time zone NOT NULL,
    horafinal time without time zone NOT NULL,
    primeiracompra boolean DEFAULT false NOT NULL,
    taxaentregagratis boolean DEFAULT false NOT NULL,
    taxaservicogratis boolean DEFAULT false NOT NULL,
    aplicaautomaticamente boolean DEFAULT false NOT NULL,
    sugerirnatelapagamento boolean DEFAULT false NOT NULL,
    disponivelentrega boolean DEFAULT true NOT NULL,
    disponivelretirada boolean DEFAULT true NOT NULL,
    disponivelsegunda boolean DEFAULT true NOT NULL,
    disponivelterca boolean DEFAULT true NOT NULL,
    disponivelquarta boolean DEFAULT true NOT NULL,
    disponivelquinta boolean DEFAULT true NOT NULL,
    disponivelsexta boolean DEFAULT true NOT NULL,
    disponivelsabado boolean DEFAULT true NOT NULL,
    disponiveldomingo boolean DEFAULT true NOT NULL,
    valorminimopedido numeric(12,6) NOT NULL,
    quantidademinimapedido integer DEFAULT 1 NOT NULL,
    valormaximodesconto numeric(12,6) NOT NULL,
    ativo boolean DEFAULT true NOT NULL
);


--
-- TOC entry 215 (class 1259 OID 277957)
-- Name: cuponsrestricoes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cuponsrestricoes (
    idcupomrestricao uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    idcupom uuid NOT NULL,
    idfilial uuid,
    iddepartamentosecao integer,
    idcliente uuid,
    idprodutoweb uuid,
    idempresaformapagamento uuid,
    dataatualizacao timestamp without time zone NOT NULL
);


--
-- TOC entry 216 (class 1259 OID 277961)
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


--
-- TOC entry 217 (class 1259 OID 277967)
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


--
-- TOC entry 218 (class 1259 OID 277970)
-- Name: departamentosecao_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.departamentosecao_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 219 (class 1259 OID 277972)
-- Name: departamentosecao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.departamentosecao (
    iddepartamentosecao integer DEFAULT nextval('public.departamentosecao_seq'::regclass) NOT NULL,
    iddepartamentosecaoexterno character varying(50) NOT NULL,
    iddepartamentoweb integer,
    descricao character varying(250) NOT NULL,
    tipoclassificacao character varying(25) NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    datacancelamento timestamp without time zone,
    dataatualizacao timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 220 (class 1259 OID 277978)
-- Name: empresas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.empresas (
    idempresa uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    idempresaexterno character varying(50) NOT NULL,
    codigoempresa character varying(25) NOT NULL,
    razaosocial character varying(500) NOT NULL,
    fantasia character varying(500) NOT NULL,
    cpfcnpj character varying(14) NOT NULL,
    logradouro character varying(300),
    numero character varying(25),
    complemento character varying(1000),
    bairro character varying(1000),
    idcidadeibge integer NOT NULL,
    cep integer,
    telefone character varying(25),
    latitude numeric,
    longitude numeric,
    horariofuncionamento character varying(500),
    telefonewhatsapp character varying(25),
    emailatendimento character varying(500),
    urlfoto character varying(250),
    urllogoemail character varying(250),
    hostservidor character varying(250),
    valortaxaservico numeric(12,6) DEFAULT 0 NOT NULL,
    valorminimopedidoentrega numeric(12,6) DEFAULT 0 NOT NULL,
    valorminimopedidoretirada numeric(12,6) DEFAULT 0 NOT NULL,
    valorminimopedidofretegratis numeric(12,6) DEFAULT 0 NOT NULL,
    valormaximopedido numeric(12,6) DEFAULT 0 NOT NULL,
    quantidademaximaparcelas integer DEFAULT 1 NOT NULL,
    quantidademaximadiasagendamento integer DEFAULT 3 NOT NULL,
    tempopreparacaopedido integer DEFAULT 60 NOT NULL,
    diaspreparacaopedido integer DEFAULT 0 NOT NULL,
    aceitapagamentoonline boolean DEFAULT false NOT NULL,
    pagamentoonlinetipo character varying(25),
    pagamentoonlineid character varying(300),
    pagamentoonlinetoken character varying(300),
    pagamentoonlinepreautorizacao boolean DEFAULT true NOT NULL,
    aceitaentregasegunda boolean DEFAULT true NOT NULL,
    aceitaentregaterca boolean DEFAULT true NOT NULL,
    aceitaentregaquarta boolean DEFAULT true NOT NULL,
    aceitaentregaquinta boolean DEFAULT true NOT NULL,
    aceitaentregasexta boolean DEFAULT true NOT NULL,
    aceitaentregasabado boolean DEFAULT true NOT NULL,
    aceitaentregadomingo boolean DEFAULT true NOT NULL,
    aceitaretiradasegunda boolean DEFAULT true NOT NULL,
    aceitaretiradaterca boolean DEFAULT true NOT NULL,
    aceitaretiradaquarta boolean DEFAULT true NOT NULL,
    aceitaretiradaquinta boolean DEFAULT true NOT NULL,
    aceitaretiradasexta boolean DEFAULT true NOT NULL,
    aceitaretiradasabado boolean DEFAULT true NOT NULL,
    aceitaretiradadomingo boolean DEFAULT true NOT NULL,
    sobre text,
    politica text,
    fatoremgramas numeric(12,6) DEFAULT 100 NOT NULL,
    entregaconsciente boolean DEFAULT false NOT NULL,
    urlchatatendimento character varying(500),
    urlfacebook character varying(500),
    urlinstagram character varying(500),
    urlplaystore character varying(500),
    urlappstore character varying(500),
    obsrodape character varying(500),
    dataatualizacao timestamp without time zone NOT NULL
);


--
-- TOC entry 221 (class 1259 OID 278012)
-- Name: empresasformapagamento; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.empresasformapagamento (
    idempresaformapagamento uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    idempresaformapagamentoexterno character varying(50),
    descricao character varying(50) NOT NULL,
    quantidademaximaparcelas integer DEFAULT 1 NOT NULL,
    valorminimoparcela numeric(12,6) DEFAULT 0 NOT NULL,
    percentualacrescimo numeric(12,6) DEFAULT 0 NOT NULL,
    entrega boolean DEFAULT false NOT NULL,
    retirada boolean DEFAULT false NOT NULL,
    offline boolean DEFAULT false NOT NULL,
    online boolean DEFAULT false NOT NULL,
    dinheiro boolean DEFAULT false NOT NULL,
    debito boolean DEFAULT false NOT NULL,
    credito boolean DEFAULT false NOT NULL,
    voucher boolean DEFAULT false NOT NULL,
    qrcode boolean DEFAULT false NOT NULL,
    tipobandeira character varying(250),
    urlfoto character varying(250),
    dataatualizacao timestamp without time zone NOT NULL
);


--
-- TOC entry 222 (class 1259 OID 278031)
-- Name: empresashorarioentrega; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.empresashorarioentrega (
    idempresahorarioentrega uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    idempresahorarioentregaexterno character varying(50),
    tipo character varying(50) NOT NULL,
    horarioinicial time without time zone NOT NULL,
    horariofinal time without time zone NOT NULL,
    quantidademaxima integer NOT NULL,
    ativo boolean NOT NULL,
    datacancelamento timestamp without time zone,
    dataatualizacao timestamp without time zone NOT NULL
);


--
-- TOC entry 223 (class 1259 OID 278035)
-- Name: empresastaxasentrega; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.empresastaxasentrega (
    idempresataxaentrega uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    idempresataxaentregaexterno character varying(50),
    kminicial numeric(12,6) NOT NULL,
    kmfinal numeric(12,6) NOT NULL,
    valortaxaentrega numeric(12,6) NOT NULL,
    ativo boolean NOT NULL,
    datacancelamento timestamp without time zone,
    dataatualizacao timestamp without time zone NOT NULL
);


--
-- TOC entry 224 (class 1259 OID 278039)
-- Name: estados; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.estados (
    idestadoibge integer NOT NULL,
    sigla character varying(2) NOT NULL,
    nomeestado character varying(50) NOT NULL,
    codigoibge integer NOT NULL,
    nomepais character varying DEFAULT 'BRASIL'::character varying NOT NULL,
    dataatualizacao timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 225 (class 1259 OID 278047)
-- Name: filiais; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.filiais (
    idempresa uuid NOT NULL,
    idfilial uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    idfilialexterno character varying(50) NOT NULL,
    codigofilial character varying(25) NOT NULL,
    razaosocial character varying(500) NOT NULL,
    fantasia character varying(500) NOT NULL,
    cpfcnpj character varying(14) NOT NULL,
    logradouro character varying(300),
    numero character varying(25),
    complemento character varying(1000),
    bairro character varying(1000),
    idcidadeibge integer NOT NULL,
    cep integer,
    telefone character varying(25),
    latitude numeric,
    longitude numeric,
    horariofuncionamento character varying(500),
    telefonewhatsapp character varying(25),
    emailatendimento character varying(500),
    urlgooglemaps text,
    ativo boolean DEFAULT true,
    datainativacao timestamp without time zone,
    dataatualizacao timestamp without time zone NOT NULL
);


--
-- TOC entry 226 (class 1259 OID 278055)
-- Name: lancamentospedidoapp_codigo_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lancamentospedidoapp_codigo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 227 (class 1259 OID 278057)
-- Name: lancamentospedidoapp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lancamentospedidoapp (
    idlancamentopedidoapp uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    idfilial uuid,
    idcliente uuid,
    idclienteendereco uuid,
    idempresahorarioentrega uuid,
    referencia character varying(50) DEFAULT public.fnc_retorna_ref_ped(),
    datalancamento timestamp without time zone,
    tipoentrega character varying(25),
    tipopagamento character varying(25),
    dataentrega timestamp without time zone NOT NULL,
    pedidopago boolean DEFAULT false,
    valortotalsemtaxa numeric(12,6),
    valortaxaentrega numeric(12,6),
    valortaxaservico numeric(12,6),
    valortaxacartao numeric(12,6),
    valordescontocupom numeric(12,6),
    valortotal numeric(12,6),
    posicao character varying(40),
    obs text,
    obsinterna text,
    responsavelrecebimento character varying(100),
    incluircpfcnpjnota boolean DEFAULT false,
    entregaconsciente boolean DEFAULT false NOT NULL,
    levartrocopara numeric(12,6),
    valortotalseparacaosemtaxa numeric(12,6),
    valortotalseparacao numeric(12,6),
    datahoraseparacao timestamp without time zone,
    datahoracancelamento timestamp without time zone,
    motivocancelamento character varying(500),
    codigosequencial bigint DEFAULT nextval('public.lancamentospedidoapp_codigo_seq'::regclass) NOT NULL,
    valordescontotaxaservico numeric(12,6),
    valordescontotaxaentrega numeric(12,6),
    idcupom uuid
);


--
-- TOC entry 228 (class 1259 OID 278069)
-- Name: lancamentospedidoapphistoricosituacao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lancamentospedidoapphistoricosituacao (
    idlancamentopedidoapphistoricosituacao uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    idlancamentopedidoapp uuid NOT NULL,
    tiposituacao character varying(50) NOT NULL,
    situacao character varying(50) NOT NULL,
    datahistorico timestamp without time zone NOT NULL
);


--
-- TOC entry 229 (class 1259 OID 278073)
-- Name: lancamentospedidoappitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lancamentospedidoappitem (
    idlancamentopedidoapp uuid NOT NULL,
    idlancamentopedidoappitem uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    idprodutoweb uuid,
    datalancamento timestamp without time zone,
    precounitario numeric(12,6),
    quantidade numeric(12,6),
    valorsubtotal numeric(12,6),
    valordescontounitario numeric(12,6),
    valordesconto numeric(12,6),
    percentualdesconto numeric(12,6),
    valoracrescimo numeric(12,6),
    valoracrescimounitario numeric(12,6),
    percentualacrescimo numeric(12,6),
    valortotal numeric(12,6),
    quantidadeseparacao numeric(12,6),
    precoseparacao numeric(12,6),
    valortotalseparacao numeric(12,6),
    datahoraseparacao timestamp without time zone,
    posicao character varying(50),
    obs text,
    datahoracancelamento timestamp without time zone
);


--
-- TOC entry 230 (class 1259 OID 278080)
-- Name: lancamentospedidoapprecebimento; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lancamentospedidoapprecebimento (
    idlancamentopedidoapp uuid NOT NULL,
    idlancamentopedidoapprecebimento uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    idempresaformapagamento uuid NOT NULL,
    datalancamento timestamp without time zone,
    datarecebimento timestamp without time zone,
    valoracrescimo numeric(12,6),
    valor numeric(12,6),
    pedidopago boolean,
    tipo character varying(50),
    quantidadeparcelas integer,
    bandeiracartao character varying(50),
    numerocartao character varying(50),
    titularcartao character varying(50),
    datavalidadecartao character varying(50),
    posicao character varying(50),
    numeroautorizacao character varying(100),
    idtransacao character varying(100),
    idpagamento character varying(100),
    capturado boolean DEFAULT false,
    valorcapturado numeric(12,6),
    datacaptura timestamp without time zone,
    valorseparacao numeric(12,6)
);


--
-- TOC entry 231 (class 1259 OID 278088)
-- Name: menu_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.menu_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 232 (class 1259 OID 278090)
-- Name: menu; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.menu (
    idmenu integer DEFAULT nextval('public.menu_seq'::regclass) NOT NULL,
    descricao character varying(250) NOT NULL,
    urlfoto character varying(50),
    ordem integer,
    tipo character varying(25) NOT NULL,
    chavepesquisa character varying(250) NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    datacancelamento timestamp without time zone,
    dataatualizacao timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 233 (class 1259 OID 278099)
-- Name: produtosestoque; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.produtosestoque (
    idprodutoestoque uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    idfilial uuid NOT NULL,
    idprodutoweb uuid NOT NULL,
    quantidadedisponivel numeric(12,6) DEFAULT 0 NOT NULL,
    dataatualizacao timestamp without time zone NOT NULL
);


--
-- TOC entry 234 (class 1259 OID 278104)
-- Name: produtossimilares; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.produtossimilares (
    idprodutosimilar uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    idprodutosimiliarexterno character varying(50),
    idprodutoweb uuid NOT NULL,
    idprodutowebsimilar uuid NOT NULL,
    ativo boolean NOT NULL,
    datacancelamento timestamp without time zone,
    dataatualizacao timestamp without time zone NOT NULL
);


--
-- TOC entry 235 (class 1259 OID 278108)
-- Name: produtosvisualizados; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.produtosvisualizados (
    idcliente uuid NOT NULL,
    idprodutoweb uuid NOT NULL,
    quantidade bigint DEFAULT 1 NOT NULL,
    datavisualizacao timestamp without time zone NOT NULL
);


--
-- TOC entry 236 (class 1259 OID 278112)
-- Name: produtosweb; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.produtosweb (
    idprodutoweb uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    idprodutowebexterno character varying(50),
    codigobarras character varying(50) NOT NULL,
    descricao character varying(100),
    situacao character varying(20) NOT NULL,
    tipoproduto character varying(20) NOT NULL,
    marca character varying(100),
    informacoes text,
    detalhes text,
    precounitario numeric(12,6),
    precoatacado numeric(12,6),
    quantidademinimaatacado numeric(12,6),
    precovenda numeric(12,6),
    precovendaatacado numeric(12,6),
    controlaestoque boolean DEFAULT false NOT NULL,
    possuiquantidadefracionada boolean DEFAULT false NOT NULL,
    fatoremgrama numeric(12,6),
    rootpathfoto character varying(100),
    rotuloimagem character varying(100),
    quantidadeimagem integer,
    imagemvalidada boolean DEFAULT false NOT NULL,
    destaque boolean DEFAULT false NOT NULL,
    ordem integer,
    ativo boolean NOT NULL,
    datacancelamento timestamp without time zone,
    dataatualizacao timestamp without time zone NOT NULL,
    dataatualizacaoimagem timestamp without time zone
);


--
-- TOC entry 237 (class 1259 OID 278123)
-- Name: produtoswebdepartamentosecao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.produtoswebdepartamentosecao (
    idprodutowebdepartametosecao uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    idprodutoweb uuid NOT NULL,
    iddepartamentoweb integer NOT NULL,
    idsecaoweb integer,
    ativo boolean NOT NULL,
    principal boolean NOT NULL,
    dataatualizacao timestamp without time zone NOT NULL
);


--
-- TOC entry 238 (class 1259 OID 278127)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usuarios (
    idusuario uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    idusuarioexterno character varying(50),
    login character varying(250),
    senha character varying(100) NOT NULL,
    codigousuario character varying(25),
    tipo character varying(20),
    ativo boolean DEFAULT true NOT NULL,
    datacancelamento timestamp without time zone,
    dataatualizacao timestamp without time zone NOT NULL
);


--
-- TOC entry 3026 (class 2606 OID 278134)
-- Name: clientesenderecos clientesenderecos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientesenderecos
    ADD CONSTRAINT clientesenderecos_pkey PRIMARY KEY (idclienteendereco);


--
-- TOC entry 3032 (class 2606 OID 278136)
-- Name: concorrentes concorrentes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.concorrentes
    ADD CONSTRAINT concorrentes_pkey PRIMARY KEY (idconcorrente);


--
-- TOC entry 3036 (class 2606 OID 278138)
-- Name: concorrentesprecos concorrentesprecos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.concorrentesprecos
    ADD CONSTRAINT concorrentesprecos_pkey PRIMARY KEY (idconcorrentepreco);


--
-- TOC entry 3043 (class 2606 OID 278140)
-- Name: cupons cupons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cupons
    ADD CONSTRAINT cupons_pkey PRIMARY KEY (idcupom);


--
-- TOC entry 3054 (class 2606 OID 278142)
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- TOC entry 3069 (class 2606 OID 278144)
-- Name: empresasformapagamento empresasformapagamento_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.empresasformapagamento
    ADD CONSTRAINT empresasformapagamento_pkey PRIMARY KEY (idempresaformapagamento);


--
-- TOC entry 3073 (class 2606 OID 278146)
-- Name: empresashorarioentrega empresashorarioentrega_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.empresashorarioentrega
    ADD CONSTRAINT empresashorarioentrega_pkey PRIMARY KEY (idempresahorarioentrega);


--
-- TOC entry 3020 (class 2606 OID 278148)
-- Name: clientes fku_clientes_email; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT fku_clientes_email UNIQUE (email);


--
-- TOC entry 3022 (class 2606 OID 278150)
-- Name: clientes fku_clientes_idclienteexterno; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT fku_clientes_idclienteexterno UNIQUE (idclienteexterno);


--
-- TOC entry 3030 (class 2606 OID 278152)
-- Name: clientesenderecos fku_clientesenderecos_descricao; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientesenderecos
    ADD CONSTRAINT fku_clientesenderecos_descricao UNIQUE (idcliente, descricao);


--
-- TOC entry 3034 (class 2606 OID 278154)
-- Name: concorrentes fku_concorrentes_idconcorrenteexterno; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.concorrentes
    ADD CONSTRAINT fku_concorrentes_idconcorrenteexterno UNIQUE (idconcorrenteexterno);


--
-- TOC entry 3041 (class 2606 OID 278156)
-- Name: concorrentesprecos fku_concorrentesprecos_idconcorrente_idprodutoweb; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.concorrentesprecos
    ADD CONSTRAINT fku_concorrentesprecos_idconcorrente_idprodutoweb UNIQUE (idconcorrente, idprodutoweb);


--
-- TOC entry 3058 (class 2606 OID 278158)
-- Name: departamentosecao fku_departamentosecao_iddepartamentosecaoexterno; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departamentosecao
    ADD CONSTRAINT fku_departamentosecao_iddepartamentosecaoexterno UNIQUE (iddepartamentosecaoexterno);


--
-- TOC entry 3065 (class 2606 OID 278160)
-- Name: empresas fku_empresas_idempresaexterno; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.empresas
    ADD CONSTRAINT fku_empresas_idempresaexterno UNIQUE (idempresaexterno);


--
-- TOC entry 3071 (class 2606 OID 278162)
-- Name: empresasformapagamento fku_empresasformapagamento_descricao; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.empresasformapagamento
    ADD CONSTRAINT fku_empresasformapagamento_descricao UNIQUE (descricao);


--
-- TOC entry 3075 (class 2606 OID 278164)
-- Name: empresashorarioentrega fku_empresashorarioentrega_idempresahorarioentregaexterno; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.empresashorarioentrega
    ADD CONSTRAINT fku_empresashorarioentrega_idempresahorarioentregaexterno UNIQUE (idempresahorarioentregaexterno);


--
-- TOC entry 3077 (class 2606 OID 278166)
-- Name: empresastaxasentrega fku_empresataxasentrega_idempresataxaentregaexterno; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.empresastaxasentrega
    ADD CONSTRAINT fku_empresataxasentrega_idempresataxaentregaexterno UNIQUE (idempresataxaentregaexterno);


--
-- TOC entry 3086 (class 2606 OID 278168)
-- Name: filiais fku_filiais_idfilialexterno; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.filiais
    ADD CONSTRAINT fku_filiais_idfilialexterno UNIQUE (idfilialexterno);


--
-- TOC entry 3106 (class 2606 OID 278170)
-- Name: menu fku_menu_tipo_chavepesquisa; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.menu
    ADD CONSTRAINT fku_menu_tipo_chavepesquisa UNIQUE (tipo, chavepesquisa);


--
-- TOC entry 3112 (class 2606 OID 278172)
-- Name: produtosestoque fku_produtosestoque_idfilial_idprodutoweb; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produtosestoque
    ADD CONSTRAINT fku_produtosestoque_idfilial_idprodutoweb UNIQUE (idfilial, idprodutoweb);


--
-- TOC entry 3118 (class 2606 OID 278174)
-- Name: produtossimilares fku_produtossimilares_idprodutosimilarexterno; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produtossimilares
    ADD CONSTRAINT fku_produtossimilares_idprodutosimilarexterno UNIQUE (idprodutosimiliarexterno);


--
-- TOC entry 3120 (class 2606 OID 278176)
-- Name: produtossimilares fku_produtossimilares_idprodutoweb_idprodutosimilar; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produtossimilares
    ADD CONSTRAINT fku_produtossimilares_idprodutoweb_idprodutosimilar UNIQUE (idprodutoweb, idprodutowebsimilar);


--
-- TOC entry 3124 (class 2606 OID 278178)
-- Name: produtosvisualizados fku_produtosvisualizados_idcliente_idprodutoweb; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produtosvisualizados
    ADD CONSTRAINT fku_produtosvisualizados_idcliente_idprodutoweb UNIQUE (idcliente, idprodutoweb);


--
-- TOC entry 3130 (class 2606 OID 278180)
-- Name: produtosweb fku_produtosweb_idprodutowebexterno; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produtosweb
    ADD CONSTRAINT fku_produtosweb_idprodutowebexterno UNIQUE (idprodutowebexterno);


--
-- TOC entry 3136 (class 2606 OID 278182)
-- Name: produtoswebdepartamentosecao fku_produtoswebdepartamentosecao_idprod_iddepto_idsec; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produtoswebdepartamentosecao
    ADD CONSTRAINT fku_produtoswebdepartamentosecao_idprod_iddepto_idsec UNIQUE (idprodutoweb, iddepartamentoweb, idsecaoweb);


--
-- TOC entry 3142 (class 2606 OID 278184)
-- Name: usuarios fku_usuarios_idusuarioexterno; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT fku_usuarios_idusuarioexterno UNIQUE (idusuarioexterno);


--
-- TOC entry 3144 (class 2606 OID 278186)
-- Name: usuarios fku_usuarios_login; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT fku_usuarios_login UNIQUE (login);


--
-- TOC entry 3052 (class 2606 OID 278188)
-- Name: cuponsrestricoes idcupomrestricao; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cuponsrestricoes
    ADD CONSTRAINT idcupomrestricao PRIMARY KEY (idcupomrestricao);


--
-- TOC entry 3097 (class 2606 OID 278190)
-- Name: lancamentospedidoapphistoricosituacao lancamentospedidoapphistoricosituacao_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lancamentospedidoapphistoricosituacao
    ADD CONSTRAINT lancamentospedidoapphistoricosituacao_pkey PRIMARY KEY (idlancamentopedidoapphistoricosituacao);


--
-- TOC entry 3010 (class 2606 OID 278192)
-- Name: anunciosofertas pk_anunciosofertas_idanunciooferta; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.anunciosofertas
    ADD CONSTRAINT pk_anunciosofertas_idanunciooferta PRIMARY KEY (idanunciooferta);


--
-- TOC entry 3014 (class 2606 OID 278194)
-- Name: anunciosofertasprodutos pk_anunciosofertasprodutos_idanuncioofertaproduto; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.anunciosofertasprodutos
    ADD CONSTRAINT pk_anunciosofertasprodutos_idanuncioofertaproduto PRIMARY KEY (idanuncioofertaproduto);


--
-- TOC entry 3017 (class 2606 OID 278196)
-- Name: cidades pk_cidades_idcidadeibge; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cidades
    ADD CONSTRAINT pk_cidades_idcidadeibge PRIMARY KEY (idcidadeibge);


--
-- TOC entry 3024 (class 2606 OID 278198)
-- Name: clientes pk_clientes_idcliente; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT pk_clientes_idcliente PRIMARY KEY (idcliente);


--
-- TOC entry 3060 (class 2606 OID 278200)
-- Name: departamentosecao pk_departamentosecao_iddepartamentosecao; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departamentosecao
    ADD CONSTRAINT pk_departamentosecao_iddepartamentosecao PRIMARY KEY (iddepartamentosecao);


--
-- TOC entry 3067 (class 2606 OID 278202)
-- Name: empresas pk_empresas_idempresa; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.empresas
    ADD CONSTRAINT pk_empresas_idempresa PRIMARY KEY (idempresa);


--
-- TOC entry 3082 (class 2606 OID 278204)
-- Name: estados pk_estados_idestadoibge; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estados
    ADD CONSTRAINT pk_estados_idestadoibge PRIMARY KEY (idestadoibge);


--
-- TOC entry 3088 (class 2606 OID 278206)
-- Name: filiais pk_filiais_idfilial; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.filiais
    ADD CONSTRAINT pk_filiais_idfilial PRIMARY KEY (idfilial);


--
-- TOC entry 3104 (class 2606 OID 278208)
-- Name: lancamentospedidoapprecebimento pk_idlancamentopedidoapprecebimento; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lancamentospedidoapprecebimento
    ADD CONSTRAINT pk_idlancamentopedidoapprecebimento PRIMARY KEY (idlancamentopedidoapprecebimento);


--
-- TOC entry 3092 (class 2606 OID 278210)
-- Name: lancamentospedidoapp pk_lancamentospedidoapp_idlancamentopedidoapp; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lancamentospedidoapp
    ADD CONSTRAINT pk_lancamentospedidoapp_idlancamentopedidoapp PRIMARY KEY (idlancamentopedidoapp);


--
-- TOC entry 3101 (class 2606 OID 278212)
-- Name: lancamentospedidoappitem pk_lancamentospedidoappitem_idlancamentopedidoappitem; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lancamentospedidoappitem
    ADD CONSTRAINT pk_lancamentospedidoappitem_idlancamentopedidoappitem PRIMARY KEY (idlancamentopedidoappitem);


--
-- TOC entry 3108 (class 2606 OID 278214)
-- Name: menu pk_menu_idmenu; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.menu
    ADD CONSTRAINT pk_menu_idmenu PRIMARY KEY (idmenu);


--
-- TOC entry 3114 (class 2606 OID 278216)
-- Name: produtosestoque pk_produtosestoque; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produtosestoque
    ADD CONSTRAINT pk_produtosestoque PRIMARY KEY (idprodutoestoque);


--
-- TOC entry 3132 (class 2606 OID 278218)
-- Name: produtosweb pk_produtosweb; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produtosweb
    ADD CONSTRAINT pk_produtosweb PRIMARY KEY (idprodutoweb);


--
-- TOC entry 3138 (class 2606 OID 278220)
-- Name: produtoswebdepartamentosecao pk_produtoswebdepartamentosecao; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produtoswebdepartamentosecao
    ADD CONSTRAINT pk_produtoswebdepartamentosecao PRIMARY KEY (idprodutowebdepartametosecao);


--
-- TOC entry 3146 (class 2606 OID 278222)
-- Name: usuarios pk_usuarios_idusuario; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT pk_usuarios_idusuario PRIMARY KEY (idusuario);


--
-- TOC entry 3079 (class 2606 OID 278224)
-- Name: empresastaxasentrega taxasentrega_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.empresastaxasentrega
    ADD CONSTRAINT taxasentrega_pkey PRIMARY KEY (idempresataxaentrega);


--
-- TOC entry 3015 (class 1259 OID 278225)
-- Name: fki_cidades_codigoibge; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_cidades_codigoibge ON public.cidades USING btree (codigoibge);


--
-- TOC entry 3027 (class 1259 OID 278226)
-- Name: fki_clientesenderecos_descricao; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_clientesenderecos_descricao ON public.clientesenderecos USING btree (descricao);


--
-- TOC entry 3037 (class 1259 OID 278227)
-- Name: fki_concorrentesprecos_precovenda; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_concorrentesprecos_precovenda ON public.concorrentesprecos USING btree (precovenda DESC NULLS LAST);


--
-- TOC entry 3044 (class 1259 OID 278228)
-- Name: fki_cupons_codigo; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_cupons_codigo ON public.cupons USING btree (codigo);


--
-- TOC entry 3055 (class 1259 OID 278229)
-- Name: fki_departamentosecao_descricao; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_departamentosecao_descricao ON public.departamentosecao USING btree (descricao);


--
-- TOC entry 3061 (class 1259 OID 278230)
-- Name: fki_empresas_cidades_idcidadeibge; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_empresas_cidades_idcidadeibge ON public.empresas USING btree (idcidadeibge);


--
-- TOC entry 3062 (class 1259 OID 278231)
-- Name: fki_empresas_codigoempresa; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_empresas_codigoempresa ON public.empresas USING btree (codigoempresa);


--
-- TOC entry 3063 (class 1259 OID 278232)
-- Name: fki_empresas_idempresa; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_empresas_idempresa ON public.empresas USING btree (idempresa);


--
-- TOC entry 3080 (class 1259 OID 278233)
-- Name: fki_estados_idestadoibge; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_estados_idestadoibge ON public.estados USING btree (idestadoibge);


--
-- TOC entry 3083 (class 1259 OID 278234)
-- Name: fki_filiais_id_empresa; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_filiais_id_empresa ON public.filiais USING btree (idempresa);


--
-- TOC entry 3084 (class 1259 OID 278235)
-- Name: fki_filiais_id_filial; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_filiais_id_filial ON public.filiais USING btree (idfilial);


--
-- TOC entry 3007 (class 1259 OID 278236)
-- Name: fki_fk_anunciosofertas_iddepartamentosecao; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_anunciosofertas_iddepartamentosecao ON public.anunciosofertas USING btree (iddepartamentosecao);


--
-- TOC entry 3008 (class 1259 OID 278237)
-- Name: fki_fk_anunciosofertas_iddepartamentosecaofiltro; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_anunciosofertas_iddepartamentosecaofiltro ON public.anunciosofertas USING btree (iddepartamentosecaofiltro);


--
-- TOC entry 3011 (class 1259 OID 278238)
-- Name: fki_fk_anunciosofertasprodutos_idanunciooferta; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_anunciosofertasprodutos_idanunciooferta ON public.anunciosofertasprodutos USING btree (idanunciooferta);


--
-- TOC entry 3012 (class 1259 OID 278239)
-- Name: fki_fk_anunciosofertasprodutos_idprodutoweb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_anunciosofertasprodutos_idprodutoweb ON public.anunciosofertasprodutos USING btree (idprodutoweb);


--
-- TOC entry 3018 (class 1259 OID 278240)
-- Name: fki_fk_clientes_idusuario; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_clientes_idusuario ON public.clientes USING btree (idusuario);


--
-- TOC entry 3028 (class 1259 OID 278241)
-- Name: fki_fk_clientesenderecos_idcliente; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_clientesenderecos_idcliente ON public.clientesenderecos USING btree (idcliente);


--
-- TOC entry 3038 (class 1259 OID 278242)
-- Name: fki_fk_concorrentesprecos_idconcorrente; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_concorrentesprecos_idconcorrente ON public.concorrentesprecos USING btree (idconcorrente);


--
-- TOC entry 3039 (class 1259 OID 278243)
-- Name: fki_fk_concorrentesprecos_idprodutoweb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_concorrentesprecos_idprodutoweb ON public.concorrentesprecos USING btree (idprodutoweb);


--
-- TOC entry 3045 (class 1259 OID 278244)
-- Name: fki_fk_cuponsrestricoes_iddepartamentosecao; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_cuponsrestricoes_iddepartamentosecao ON public.cuponsrestricoes USING btree (iddepartamentosecao);


--
-- TOC entry 3046 (class 1259 OID 278245)
-- Name: fki_fk_cuponsrestricoes_idempresaformapagamento; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_cuponsrestricoes_idempresaformapagamento ON public.cuponsrestricoes USING btree (idempresaformapagamento);


--
-- TOC entry 3047 (class 1259 OID 278246)
-- Name: fki_fk_cuponsrestricoes_idprodutoweb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_cuponsrestricoes_idprodutoweb ON public.cuponsrestricoes USING btree (idprodutoweb);


--
-- TOC entry 3056 (class 1259 OID 278247)
-- Name: fki_fk_departamentosecao_iddepartamentoweb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_departamentosecao_iddepartamentoweb ON public.departamentosecao USING btree (iddepartamentoweb);


--
-- TOC entry 3089 (class 1259 OID 278248)
-- Name: fki_fk_lancamentospedidoapp_idcliente; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_lancamentospedidoapp_idcliente ON public.lancamentospedidoapp USING btree (idcliente);


--
-- TOC entry 3090 (class 1259 OID 278249)
-- Name: fki_fk_lancamentospedidoapp_idempresahorarioentrega; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_lancamentospedidoapp_idempresahorarioentrega ON public.lancamentospedidoapp USING btree (idempresahorarioentrega);


--
-- TOC entry 3093 (class 1259 OID 278250)
-- Name: fki_fk_lancamentospedidoapphistoricosituacao_idlancamentopedido; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_lancamentospedidoapphistoricosituacao_idlancamentopedido ON public.lancamentospedidoapphistoricosituacao USING btree (idlancamentopedidoapp);


--
-- TOC entry 3098 (class 1259 OID 278251)
-- Name: fki_fk_lancamentospedidoappitem_idprodutoweb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_lancamentospedidoappitem_idprodutoweb ON public.lancamentospedidoappitem USING btree (idprodutoweb);


--
-- TOC entry 3102 (class 1259 OID 278252)
-- Name: fki_fk_lancamentospedidoapprecebimento_idempresaformapagamento; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_lancamentospedidoapprecebimento_idempresaformapagamento ON public.lancamentospedidoapprecebimento USING btree (idempresaformapagamento);


--
-- TOC entry 3109 (class 1259 OID 278253)
-- Name: fki_fk_produtosestoque_idprodutoweb_quantidade_disponivel; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_produtosestoque_idprodutoweb_quantidade_disponivel ON public.produtosestoque USING btree (idprodutoweb NULLS FIRST, quantidadedisponivel DESC);


--
-- TOC entry 3115 (class 1259 OID 278254)
-- Name: fki_fk_produtossimilares_idprodutoweb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_produtossimilares_idprodutoweb ON public.produtossimilares USING btree (idprodutoweb);


--
-- TOC entry 3116 (class 1259 OID 278255)
-- Name: fki_fk_produtossimilares_idprodutowebsimilar; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_produtossimilares_idprodutowebsimilar ON public.produtossimilares USING btree (idprodutowebsimilar);


--
-- TOC entry 3121 (class 1259 OID 278256)
-- Name: fki_fk_produtosvisualizados_idcliente; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_produtosvisualizados_idcliente ON public.produtosvisualizados USING btree (idcliente);


--
-- TOC entry 3122 (class 1259 OID 278257)
-- Name: fki_fk_produtosvisualizados_idprodutoweb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_produtosvisualizados_idprodutoweb ON public.produtosvisualizados USING btree (idprodutoweb);


--
-- TOC entry 3133 (class 1259 OID 278258)
-- Name: fki_fk_produtoswebdepartamentosecao_iddepartamentoweb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_produtoswebdepartamentosecao_iddepartamentoweb ON public.produtoswebdepartamentosecao USING btree (iddepartamentoweb);


--
-- TOC entry 3134 (class 1259 OID 278259)
-- Name: fki_fk_produtoswebdepartamentosecao_idprodutoweb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_produtoswebdepartamentosecao_idprodutoweb ON public.produtoswebdepartamentosecao USING btree (idprodutoweb);


--
-- TOC entry 3048 (class 1259 OID 278260)
-- Name: fki_fki_cuponsrestricoes_idcliente; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fki_cuponsrestricoes_idcliente ON public.cuponsrestricoes USING btree (idcliente);


--
-- TOC entry 3049 (class 1259 OID 278261)
-- Name: fki_fki_cuponsrestricoes_idcupom; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fki_cuponsrestricoes_idcupom ON public.cuponsrestricoes USING btree (idcupom);


--
-- TOC entry 3050 (class 1259 OID 278262)
-- Name: fki_fki_cuponsrestricoes_idfilial; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fki_cuponsrestricoes_idfilial ON public.cuponsrestricoes USING btree (idfilial);


--
-- TOC entry 3094 (class 1259 OID 278263)
-- Name: fki_lancamentospedidoapphistoricosituacao_situacao; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_lancamentospedidoapphistoricosituacao_situacao ON public.lancamentospedidoapphistoricosituacao USING btree (situacao);


--
-- TOC entry 3095 (class 1259 OID 278264)
-- Name: fki_lancamentospedidoapphistoricosituacao_tiposituacao; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_lancamentospedidoapphistoricosituacao_tiposituacao ON public.lancamentospedidoapphistoricosituacao USING btree (tiposituacao);


--
-- TOC entry 3099 (class 1259 OID 278265)
-- Name: fki_lancamentospedidoappitem_idlancamentopedidoapp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_lancamentospedidoappitem_idlancamentopedidoapp ON public.lancamentospedidoappitem USING btree (idlancamentopedidoapp);


--
-- TOC entry 3110 (class 1259 OID 278266)
-- Name: fki_produtosestoque_idfilial; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_produtosestoque_idfilial ON public.produtosestoque USING btree (idfilial);


--
-- TOC entry 3125 (class 1259 OID 278267)
-- Name: fki_produtosweb_descricao; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_produtosweb_descricao ON public.produtosweb USING btree (descricao);


--
-- TOC entry 3126 (class 1259 OID 278268)
-- Name: fki_produtosweb_idprodutoweb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_produtosweb_idprodutoweb ON public.produtosweb USING btree (idprodutoweb);


--
-- TOC entry 3127 (class 1259 OID 278269)
-- Name: fki_produtosweb_informacoes; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_produtosweb_informacoes ON public.produtosweb USING btree (informacoes);


--
-- TOC entry 3128 (class 1259 OID 278270)
-- Name: fki_produtosweb_marca; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_produtosweb_marca ON public.produtosweb USING btree (marca);


--
-- TOC entry 3139 (class 1259 OID 278271)
-- Name: fki_usuarios_idusuario; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_usuarios_idusuario ON public.usuarios USING btree (idusuario);


--
-- TOC entry 3140 (class 1259 OID 278272)
-- Name: fki_usuarios_login; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_usuarios_login ON public.usuarios USING btree (login);


--
-- TOC entry 3147 (class 2606 OID 278273)
-- Name: anunciosofertas fk_anunciosofertas_iddepartamentosecao; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.anunciosofertas
    ADD CONSTRAINT fk_anunciosofertas_iddepartamentosecao FOREIGN KEY (iddepartamentosecao) REFERENCES public.departamentosecao(iddepartamentosecao);


--
-- TOC entry 3148 (class 2606 OID 278278)
-- Name: anunciosofertas fk_anunciosofertas_iddepartamentosecaofiltro; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.anunciosofertas
    ADD CONSTRAINT fk_anunciosofertas_iddepartamentosecaofiltro FOREIGN KEY (iddepartamentosecaofiltro) REFERENCES public.departamentosecao(iddepartamentosecao);


--
-- TOC entry 3149 (class 2606 OID 278283)
-- Name: anunciosofertasprodutos fk_anunciosofertasprodutos_idanunciooferta; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.anunciosofertasprodutos
    ADD CONSTRAINT fk_anunciosofertasprodutos_idanunciooferta FOREIGN KEY (idanunciooferta) REFERENCES public.anunciosofertas(idanunciooferta);


--
-- TOC entry 3150 (class 2606 OID 278288)
-- Name: anunciosofertasprodutos fk_anunciosofertasprodutos_idprodutoweb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.anunciosofertasprodutos
    ADD CONSTRAINT fk_anunciosofertasprodutos_idprodutoweb FOREIGN KEY (idprodutoweb) REFERENCES public.produtosweb(idprodutoweb);


--
-- TOC entry 3151 (class 2606 OID 278293)
-- Name: cidades fk_cidades_estados_idestadoibge; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cidades
    ADD CONSTRAINT fk_cidades_estados_idestadoibge FOREIGN KEY (idestadoibge) REFERENCES public.estados(idestadoibge);


--
-- TOC entry 3152 (class 2606 OID 278298)
-- Name: clientes fk_clientes_idusuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT fk_clientes_idusuario FOREIGN KEY (idusuario) REFERENCES public.usuarios(idusuario);


--
-- TOC entry 3153 (class 2606 OID 278303)
-- Name: clientesenderecos fk_clientesenderecos_idcliente; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientesenderecos
    ADD CONSTRAINT fk_clientesenderecos_idcliente FOREIGN KEY (idcliente) REFERENCES public.clientes(idcliente);


--
-- TOC entry 3155 (class 2606 OID 278308)
-- Name: concorrentesprecos fk_concorrentesprecos_idconcorrente; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.concorrentesprecos
    ADD CONSTRAINT fk_concorrentesprecos_idconcorrente FOREIGN KEY (idconcorrente) REFERENCES public.concorrentes(idconcorrente);


--
-- TOC entry 3156 (class 2606 OID 278313)
-- Name: concorrentesprecos fk_concorrentesprecos_idprodutoweb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.concorrentesprecos
    ADD CONSTRAINT fk_concorrentesprecos_idprodutoweb FOREIGN KEY (idprodutoweb) REFERENCES public.produtosweb(idprodutoweb);


--
-- TOC entry 3157 (class 2606 OID 278318)
-- Name: cuponsrestricoes fk_cuponsrestricoes_idcliente; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cuponsrestricoes
    ADD CONSTRAINT fk_cuponsrestricoes_idcliente FOREIGN KEY (idcliente) REFERENCES public.clientes(idcliente);


--
-- TOC entry 3158 (class 2606 OID 278323)
-- Name: cuponsrestricoes fk_cuponsrestricoes_idcupom; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cuponsrestricoes
    ADD CONSTRAINT fk_cuponsrestricoes_idcupom FOREIGN KEY (idcupom) REFERENCES public.cupons(idcupom);


--
-- TOC entry 3159 (class 2606 OID 278328)
-- Name: cuponsrestricoes fk_cuponsrestricoes_iddepartamentosecao; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cuponsrestricoes
    ADD CONSTRAINT fk_cuponsrestricoes_iddepartamentosecao FOREIGN KEY (iddepartamentosecao) REFERENCES public.departamentosecao(iddepartamentosecao);


--
-- TOC entry 3160 (class 2606 OID 278333)
-- Name: cuponsrestricoes fk_cuponsrestricoes_idempresaformapagamento; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cuponsrestricoes
    ADD CONSTRAINT fk_cuponsrestricoes_idempresaformapagamento FOREIGN KEY (idempresaformapagamento) REFERENCES public.empresasformapagamento(idempresaformapagamento);


--
-- TOC entry 3161 (class 2606 OID 278338)
-- Name: cuponsrestricoes fk_cuponsrestricoes_idfilial; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cuponsrestricoes
    ADD CONSTRAINT fk_cuponsrestricoes_idfilial FOREIGN KEY (idfilial) REFERENCES public.filiais(idfilial);


--
-- TOC entry 3162 (class 2606 OID 278343)
-- Name: cuponsrestricoes fk_cuponsrestricoes_idprodutoweb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cuponsrestricoes
    ADD CONSTRAINT fk_cuponsrestricoes_idprodutoweb FOREIGN KEY (idprodutoweb) REFERENCES public.produtosweb(idprodutoweb);


--
-- TOC entry 3163 (class 2606 OID 278348)
-- Name: departamentosecao fk_departamentosecao_iddepartamentoweb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departamentosecao
    ADD CONSTRAINT fk_departamentosecao_iddepartamentoweb FOREIGN KEY (iddepartamentoweb) REFERENCES public.departamentosecao(iddepartamentosecao);


--
-- TOC entry 3164 (class 2606 OID 278353)
-- Name: empresas fk_empresas_cidades_idcidadeibge; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.empresas
    ADD CONSTRAINT fk_empresas_cidades_idcidadeibge FOREIGN KEY (idcidadeibge) REFERENCES public.cidades(idcidadeibge);


--
-- TOC entry 3165 (class 2606 OID 278358)
-- Name: filiais fk_filiais_cidades_idcidadeibge; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.filiais
    ADD CONSTRAINT fk_filiais_cidades_idcidadeibge FOREIGN KEY (idcidadeibge) REFERENCES public.cidades(idcidadeibge);


--
-- TOC entry 3166 (class 2606 OID 278363)
-- Name: filiais fk_filiais_empresas_idempresa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.filiais
    ADD CONSTRAINT fk_filiais_empresas_idempresa FOREIGN KEY (idempresa) REFERENCES public.empresas(idempresa);


--
-- TOC entry 3167 (class 2606 OID 278368)
-- Name: lancamentospedidoapp fk_lancamentospedidoapp_idcliente; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lancamentospedidoapp
    ADD CONSTRAINT fk_lancamentospedidoapp_idcliente FOREIGN KEY (idcliente) REFERENCES public.clientes(idcliente);


--
-- TOC entry 3154 (class 2606 OID 278373)
-- Name: clientesenderecos fk_lancamentospedidoapp_idclienteendereco; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientesenderecos
    ADD CONSTRAINT fk_lancamentospedidoapp_idclienteendereco FOREIGN KEY (idclienteendereco) REFERENCES public.clientesenderecos(idclienteendereco);


--
-- TOC entry 3168 (class 2606 OID 278378)
-- Name: lancamentospedidoapp fk_lancamentospedidoapp_idempresahorarioentrega; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lancamentospedidoapp
    ADD CONSTRAINT fk_lancamentospedidoapp_idempresahorarioentrega FOREIGN KEY (idempresahorarioentrega) REFERENCES public.empresashorarioentrega(idempresahorarioentrega);


--
-- TOC entry 3169 (class 2606 OID 278383)
-- Name: lancamentospedidoapphistoricosituacao fk_lancamentospedidoapphistoricosituacao_idlancamentopedidoapp; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lancamentospedidoapphistoricosituacao
    ADD CONSTRAINT fk_lancamentospedidoapphistoricosituacao_idlancamentopedidoapp FOREIGN KEY (idlancamentopedidoapp) REFERENCES public.lancamentospedidoapp(idlancamentopedidoapp);


--
-- TOC entry 3170 (class 2606 OID 278388)
-- Name: lancamentospedidoappitem fk_lancamentospedidoappitem_idlancamentopedidoapp; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lancamentospedidoappitem
    ADD CONSTRAINT fk_lancamentospedidoappitem_idlancamentopedidoapp FOREIGN KEY (idlancamentopedidoapp) REFERENCES public.lancamentospedidoapp(idlancamentopedidoapp);


--
-- TOC entry 3171 (class 2606 OID 278393)
-- Name: lancamentospedidoappitem fk_lancamentospedidoappitem_idprodutoweb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lancamentospedidoappitem
    ADD CONSTRAINT fk_lancamentospedidoappitem_idprodutoweb FOREIGN KEY (idprodutoweb) REFERENCES public.produtosweb(idprodutoweb);


--
-- TOC entry 3172 (class 2606 OID 278398)
-- Name: lancamentospedidoapprecebimento fk_lancamentospedidoapprecebimento_idempresaformapagamento; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lancamentospedidoapprecebimento
    ADD CONSTRAINT fk_lancamentospedidoapprecebimento_idempresaformapagamento FOREIGN KEY (idempresaformapagamento) REFERENCES public.empresasformapagamento(idempresaformapagamento);


--
-- TOC entry 3173 (class 2606 OID 278403)
-- Name: lancamentospedidoapprecebimento fk_lancamentospedidoapprecebimento_idlancamentopedidoapp; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lancamentospedidoapprecebimento
    ADD CONSTRAINT fk_lancamentospedidoapprecebimento_idlancamentopedidoapp FOREIGN KEY (idlancamentopedidoapp) REFERENCES public.lancamentospedidoapp(idlancamentopedidoapp);


--
-- TOC entry 3174 (class 2606 OID 278408)
-- Name: produtosestoque fk_produtosestoque_idfilial; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produtosestoque
    ADD CONSTRAINT fk_produtosestoque_idfilial FOREIGN KEY (idfilial) REFERENCES public.filiais(idfilial);


--
-- TOC entry 3175 (class 2606 OID 278413)
-- Name: produtosestoque fk_produtosestoque_idprodutoweb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produtosestoque
    ADD CONSTRAINT fk_produtosestoque_idprodutoweb FOREIGN KEY (idprodutoweb) REFERENCES public.produtosweb(idprodutoweb);


--
-- TOC entry 3176 (class 2606 OID 278418)
-- Name: produtossimilares fk_produtossimilares_idprodutoweb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produtossimilares
    ADD CONSTRAINT fk_produtossimilares_idprodutoweb FOREIGN KEY (idprodutoweb) REFERENCES public.produtosweb(idprodutoweb);


--
-- TOC entry 3177 (class 2606 OID 278423)
-- Name: produtossimilares fk_produtossimilares_idprodutowebsimilar; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produtossimilares
    ADD CONSTRAINT fk_produtossimilares_idprodutowebsimilar FOREIGN KEY (idprodutowebsimilar) REFERENCES public.produtosweb(idprodutoweb);


--
-- TOC entry 3178 (class 2606 OID 278428)
-- Name: produtosvisualizados fk_produtosvisualizados_idcliente; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produtosvisualizados
    ADD CONSTRAINT fk_produtosvisualizados_idcliente FOREIGN KEY (idcliente) REFERENCES public.clientes(idcliente);


--
-- TOC entry 3179 (class 2606 OID 278433)
-- Name: produtosvisualizados fk_produtosvisualizados_idprodutoweb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produtosvisualizados
    ADD CONSTRAINT fk_produtosvisualizados_idprodutoweb FOREIGN KEY (idprodutoweb) REFERENCES public.produtosweb(idprodutoweb);


--
-- TOC entry 3180 (class 2606 OID 278438)
-- Name: produtoswebdepartamentosecao fk_produtoswebdepartamentosecao_iddepartamentoweb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produtoswebdepartamentosecao
    ADD CONSTRAINT fk_produtoswebdepartamentosecao_iddepartamentoweb FOREIGN KEY (iddepartamentoweb) REFERENCES public.departamentosecao(iddepartamentosecao);


--
-- TOC entry 3181 (class 2606 OID 278443)
-- Name: produtoswebdepartamentosecao fk_produtoswebdepartamentosecao_idprodutoweb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produtoswebdepartamentosecao
    ADD CONSTRAINT fk_produtoswebdepartamentosecao_idprodutoweb FOREIGN KEY (idprodutoweb) REFERENCES public.produtosweb(idprodutoweb);


--
-- TOC entry 3182 (class 2606 OID 278448)
-- Name: produtoswebdepartamentosecao fk_produtoswebdepartamentosecao_idsecaoweb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produtoswebdepartamentosecao
    ADD CONSTRAINT fk_produtoswebdepartamentosecao_idsecaoweb FOREIGN KEY (idsecaoweb) REFERENCES public.departamentosecao(iddepartamentosecao);


-- Completed on 2021-04-25 21:50:29

--
-- PostgreSQL database dump complete
--

