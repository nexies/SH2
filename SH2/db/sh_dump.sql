--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2 (Ubuntu 16.2-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.2 (Ubuntu 16.2-1.pgdg22.04+1)

-- Started on 2025-02-11 20:13:42 MSK

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 224 (class 1259 OID 94734)
-- Name: ControllableDevice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ControllableDevice" (
    id bigint NOT NULL,
    device_type integer DEFAULT 0 NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    group_id bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public."ControllableDevice" OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 94749)
-- Name: SpatialGroup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."SpatialGroup" (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    description text
);


ALTER TABLE public."SpatialGroup" OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 94748)
-- Name: ControllableDeviceGroup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ControllableDeviceGroup_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ControllableDeviceGroup_id_seq" OWNER TO postgres;

--
-- TOC entry 3524 (class 0 OID 0)
-- Dependencies: 225
-- Name: ControllableDeviceGroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ControllableDeviceGroup_id_seq" OWNED BY public."SpatialGroup".id;


--
-- TOC entry 222 (class 1259 OID 94725)
-- Name: ControllableDeviceType; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ControllableDeviceType" (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    definition text,
    description text
);


ALTER TABLE public."ControllableDeviceType" OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 94724)
-- Name: ControllableDeviceType_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ControllableDeviceType_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ControllableDeviceType_id_seq" OWNER TO postgres;

--
-- TOC entry 3525 (class 0 OID 0)
-- Dependencies: 221
-- Name: ControllableDeviceType_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ControllableDeviceType_id_seq" OWNED BY public."ControllableDeviceType".id;


--
-- TOC entry 227 (class 1259 OID 94757)
-- Name: ControllableDevice_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ControllableDevice_group_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ControllableDevice_group_id_seq" OWNER TO postgres;

--
-- TOC entry 3526 (class 0 OID 0)
-- Dependencies: 227
-- Name: ControllableDevice_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ControllableDevice_group_id_seq" OWNED BY public."ControllableDevice".group_id;


--
-- TOC entry 223 (class 1259 OID 94733)
-- Name: ControllableDevice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ControllableDevice_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ControllableDevice_id_seq" OWNER TO postgres;

--
-- TOC entry 3527 (class 0 OID 0)
-- Dependencies: 223
-- Name: ControllableDevice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ControllableDevice_id_seq" OWNED BY public."ControllableDevice".id;


--
-- TOC entry 218 (class 1259 OID 94692)
-- Name: Masters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Masters" (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public."Masters" OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 94691)
-- Name: Masters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Masters_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Masters_id_seq" OWNER TO postgres;

--
-- TOC entry 3528 (class 0 OID 0)
-- Dependencies: 217
-- Name: Masters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Masters_id_seq" OWNED BY public."Masters".id;


--
-- TOC entry 220 (class 1259 OID 94699)
-- Name: NetInterface; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."NetInterface" (
    id integer NOT NULL,
    net_type integer NOT NULL,
    name character varying(100),
    definition text,
    description text,
    master integer NOT NULL,
    ip_address character varying(100),
    "sendSocket" integer,
    "receiveSocket" integer
);


ALTER TABLE public."NetInterface" OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 94698)
-- Name: NetDevices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."NetDevices_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."NetDevices_id_seq" OWNER TO postgres;

--
-- TOC entry 3529 (class 0 OID 0)
-- Dependencies: 219
-- Name: NetDevices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."NetDevices_id_seq" OWNED BY public."NetInterface".id;


--
-- TOC entry 216 (class 1259 OID 94683)
-- Name: NetType; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."NetType" (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    definition text,
    description text
);


ALTER TABLE public."NetType" OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 94682)
-- Name: NetType_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."NetType_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."NetType_id_seq" OWNER TO postgres;

--
-- TOC entry 3530 (class 0 OID 0)
-- Dependencies: 215
-- Name: NetType_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."NetType_id_seq" OWNED BY public."NetType".id;


--
-- TOC entry 243 (class 1259 OID 94891)
-- Name: Rs485Contact; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Rs485Contact" (
    id bigint NOT NULL,
    rs_device_id bigint NOT NULL,
    emergency boolean DEFAULT false NOT NULL,
    name character varying(100) NOT NULL,
    definition text,
    description text,
    shift integer NOT NULL,
    pwm integer DEFAULT 0,
    output boolean DEFAULT false
);


ALTER TABLE public."Rs485Contact" OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 94889)
-- Name: Rs485Contact_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Rs485Contact_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Rs485Contact_id_seq" OWNER TO postgres;

--
-- TOC entry 3531 (class 0 OID 0)
-- Dependencies: 241
-- Name: Rs485Contact_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Rs485Contact_id_seq" OWNED BY public."Rs485Contact".id;


--
-- TOC entry 242 (class 1259 OID 94890)
-- Name: Rs485Contact_shift_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Rs485Contact" ALTER COLUMN shift ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."Rs485Contact_shift_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 16
    CACHE 1
);


--
-- TOC entry 237 (class 1259 OID 94820)
-- Name: Rs485Device; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Rs485Device" (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    definition text,
    description text,
    net_interface_id integer NOT NULL,
    rs485_delay_timeout integer,
    is_input boolean NOT NULL,
    box integer NOT NULL,
    parity boolean,
    base_address character varying(100) NOT NULL,
    noise_filters boolean,
    word_len integer,
    net_max_timeout integer,
    stop_bit smallint,
    type_id integer DEFAULT 0 NOT NULL,
    net_address_len integer,
    version character varying(100),
    protocol_id integer DEFAULT 0 NOT NULL,
    baud_rate integer
);


ALTER TABLE public."Rs485Device" OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 94803)
-- Name: Rs485DeviceType; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Rs485DeviceType" (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    definition text,
    description text
);


ALTER TABLE public."Rs485DeviceType" OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 94802)
-- Name: Rs485DeviceType_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Rs485DeviceType_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Rs485DeviceType_id_seq" OWNER TO postgres;

--
-- TOC entry 3532 (class 0 OID 0)
-- Dependencies: 232
-- Name: Rs485DeviceType_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Rs485DeviceType_id_seq" OWNED BY public."Rs485DeviceType".id;


--
-- TOC entry 236 (class 1259 OID 94819)
-- Name: Rs485Device_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Rs485Device_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Rs485Device_id_seq" OWNER TO postgres;

--
-- TOC entry 3533 (class 0 OID 0)
-- Dependencies: 236
-- Name: Rs485Device_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Rs485Device_id_seq" OWNED BY public."Rs485Device".id;


--
-- TOC entry 240 (class 1259 OID 94873)
-- Name: Rs485Key; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Rs485Key" (
    id bigint NOT NULL,
    rs_device_id bigint NOT NULL,
    shift integer NOT NULL,
    name character varying(100) NOT NULL,
    definition text,
    description text,
    state integer DEFAULT 0 NOT NULL,
    counter integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."Rs485Key" OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 94871)
-- Name: Rs485Key_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Rs485Key_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Rs485Key_id_seq" OWNER TO postgres;

--
-- TOC entry 3534 (class 0 OID 0)
-- Dependencies: 238
-- Name: Rs485Key_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Rs485Key_id_seq" OWNED BY public."Rs485Key".id;


--
-- TOC entry 239 (class 1259 OID 94872)
-- Name: Rs485Key_shift_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Rs485Key" ALTER COLUMN shift ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."Rs485Key_shift_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 16
    CACHE 1
);


--
-- TOC entry 235 (class 1259 OID 94811)
-- Name: Rs485Protocol; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Rs485Protocol" (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    definition text,
    description text
);


ALTER TABLE public."Rs485Protocol" OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 94810)
-- Name: Rs485Protocol_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Rs485Protocol_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Rs485Protocol_id_seq" OWNER TO postgres;

--
-- TOC entry 3535 (class 0 OID 0)
-- Dependencies: 234
-- Name: Rs485Protocol_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Rs485Protocol_id_seq" OWNED BY public."Rs485Protocol".id;


--
-- TOC entry 231 (class 1259 OID 94782)
-- Name: SwitchDevice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."SwitchDevice" (
    id bigint NOT NULL,
    switch_type integer DEFAULT 0 NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    group_id integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."SwitchDevice" OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 94773)
-- Name: SwitchDeviceType; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."SwitchDeviceType" (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    definition text,
    description text
);


ALTER TABLE public."SwitchDeviceType" OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 94772)
-- Name: SwitchDeviceType_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."SwitchDeviceType_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."SwitchDeviceType_id_seq" OWNER TO postgres;

--
-- TOC entry 3536 (class 0 OID 0)
-- Dependencies: 228
-- Name: SwitchDeviceType_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."SwitchDeviceType_id_seq" OWNED BY public."SwitchDeviceType".id;


--
-- TOC entry 230 (class 1259 OID 94781)
-- Name: SwitchDevice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."SwitchDevice_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."SwitchDevice_id_seq" OWNER TO postgres;

--
-- TOC entry 3537 (class 0 OID 0)
-- Dependencies: 230
-- Name: SwitchDevice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."SwitchDevice_id_seq" OWNED BY public."SwitchDevice".id;


--
-- TOC entry 3287 (class 2604 OID 94737)
-- Name: ControllableDevice id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ControllableDevice" ALTER COLUMN id SET DEFAULT nextval('public."ControllableDevice_id_seq"'::regclass);


--
-- TOC entry 3286 (class 2604 OID 94728)
-- Name: ControllableDeviceType id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ControllableDeviceType" ALTER COLUMN id SET DEFAULT nextval('public."ControllableDeviceType_id_seq"'::regclass);


--
-- TOC entry 3284 (class 2604 OID 94695)
-- Name: Masters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Masters" ALTER COLUMN id SET DEFAULT nextval('public."Masters_id_seq"'::regclass);


--
-- TOC entry 3285 (class 2604 OID 94702)
-- Name: NetInterface id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."NetInterface" ALTER COLUMN id SET DEFAULT nextval('public."NetDevices_id_seq"'::regclass);


--
-- TOC entry 3283 (class 2604 OID 94686)
-- Name: NetType id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."NetType" ALTER COLUMN id SET DEFAULT nextval('public."NetType_id_seq"'::regclass);


--
-- TOC entry 3303 (class 2604 OID 94894)
-- Name: Rs485Contact id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Rs485Contact" ALTER COLUMN id SET DEFAULT nextval('public."Rs485Contact_id_seq"'::regclass);


--
-- TOC entry 3297 (class 2604 OID 94823)
-- Name: Rs485Device id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Rs485Device" ALTER COLUMN id SET DEFAULT nextval('public."Rs485Device_id_seq"'::regclass);


--
-- TOC entry 3295 (class 2604 OID 94806)
-- Name: Rs485DeviceType id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Rs485DeviceType" ALTER COLUMN id SET DEFAULT nextval('public."Rs485DeviceType_id_seq"'::regclass);


--
-- TOC entry 3300 (class 2604 OID 94876)
-- Name: Rs485Key id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Rs485Key" ALTER COLUMN id SET DEFAULT nextval('public."Rs485Key_id_seq"'::regclass);


--
-- TOC entry 3296 (class 2604 OID 94814)
-- Name: Rs485Protocol id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Rs485Protocol" ALTER COLUMN id SET DEFAULT nextval('public."Rs485Protocol_id_seq"'::regclass);


--
-- TOC entry 3290 (class 2604 OID 94752)
-- Name: SpatialGroup id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SpatialGroup" ALTER COLUMN id SET DEFAULT nextval('public."ControllableDeviceGroup_id_seq"'::regclass);


--
-- TOC entry 3292 (class 2604 OID 94785)
-- Name: SwitchDevice id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SwitchDevice" ALTER COLUMN id SET DEFAULT nextval('public."SwitchDevice_id_seq"'::regclass);


--
-- TOC entry 3291 (class 2604 OID 94776)
-- Name: SwitchDeviceType id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SwitchDeviceType" ALTER COLUMN id SET DEFAULT nextval('public."SwitchDeviceType_id_seq"'::regclass);


--
-- TOC entry 3499 (class 0 OID 94734)
-- Dependencies: 224
-- Data for Name: ControllableDevice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ControllableDevice" (id, device_type, name, description, group_id) FROM stdin;
1	1	Cвет в прихожей	\N	1
8	1	Свет холл 1 этажа	\N	8
2	1	Свет в переднем дворе	\N	7
3	1	Свет в гардеробе	\N	1
4	1	Свет на балконе	\N	1
5	1	Фасад правая сторона	\N	7
6	1	Фасад левая сторона	\N	7
7	1	Светильник главный вход	\N	1
9	1	Свет над обеденным столом	\N	2
10	1	Гостиная, потолок слева	\N	2
11	1	Гостиная, потолок справа	\N	2
12	1	Подсветка кухни	\N	2
13	1	Освещение лестницы (1 этаж)\n	\N	8
14	1	Свет в заднем дворе	\N	7
15	1	Освещение лестничной площадки	\N	8
16	1	Гостиная, кирпичная стена	\N	2
17	1	Гостиная, подсветка ниш	\N	2
18	1	Гостиная, штукатурная стена	\N	2
19	1	Кладовая	\N	8
20	5	Вентилятор душ	\N	4
37	1	Свет в душевой	\N	4
38	1	Свет в комнате отдыха	\N	4
39	1	Освещение сауны (нижнее)	\N	4
40	1	Освещение сауны (верхнее)	\N	4
41	1	Освещение котельной	\N	4
42	5	Вентилятор комната отдыха	\N	4
43	1	Свет коридор	\N	4
44	1	Свет терраса	\N	7
45	1	Верхний свет	\N	5
46	1	Освещение сцены	\N	5
47	4	Проектор	\N	5
48	4	Фронтальное освещение сцены	\N	5
49	1	Подсветка карты	\N	9
50	1	Потолок	\N	9
51	1	Потолок	\N	11
52	1	Потолок	\N	10
53	1	Подсветка гитар	\N	10
54	1	Доска	\N	6
57	1	Стена	\N	6
58	1	Потолок	\N	6
\.


--
-- TOC entry 3497 (class 0 OID 94725)
-- Dependencies: 222
-- Data for Name: ControllableDeviceType; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ControllableDeviceType" (id, name, definition, description) FROM stdin;
1	simple light	Простой свет	Обычная подвесная лампа, либо включена, либо выключена
2	dimmable light	Регулируемый свет	Лампа с возможностью регулировки яркости
3	RGB light	RGB-подсветка	Разноцветная подсветка, например светодиодная лента
4	spotlight	Прожектор	\N
5	vent	Вентилятор	\N
0	unknown	Не определено	\N
\.


--
-- TOC entry 3493 (class 0 OID 94692)
-- Dependencies: 218
-- Data for Name: Masters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Masters" (id, name) FROM stdin;
1	master
\.


--
-- TOC entry 3495 (class 0 OID 94699)
-- Dependencies: 220
-- Data for Name: NetInterface; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."NetInterface" (id, net_type, name, definition, description, master, ip_address, "sendSocket", "receiveSocket") FROM stdin;
1	1	RS485-1	RS-485 net	\N	1	192.168.127.254	30001	30011
2	1	RS485-2	\N	\N	1	192.168.127.254	30005	30015
3	2	DMX-512-1	\N	\N	1	192.168.127.254	30013	30003
4	2	DMX-512-2	\N	\N	1	192.168.127.254	30014	30004
\.


--
-- TOC entry 3491 (class 0 OID 94683)
-- Dependencies: 216
-- Data for Name: NetType; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."NetType" (id, name, definition, description) FROM stdin;
1	RS485	ANSI TIA/EIA-485-A:1998 Electrical Charachteristics of Generatos and Receivers for Usi in Balanced Digital Multipoint Systems	\N
2	DMX-512	Digital Multiplex with 512 individual channels	\N
\.


--
-- TOC entry 3518 (class 0 OID 94891)
-- Dependencies: 243
-- Data for Name: Rs485Contact; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Rs485Contact" (id, rs_device_id, emergency, name, definition, description, shift, pwm, output) FROM stdin;
183	1	f	OUT_RS_1_11_01	свет в прихожей	\N	1	0	f
184	1	f	OUT_RS_1_11_02	чердак. передний двор	\N	2	0	f
185	1	f	OUT_RS_1_11_03	 свет в гардеробе	\N	3	0	t
186	1	f	OUT_RS_1_11_04	балкон	\N	4	0	f
187	1	f	OUT_RS_1_11_05		\N	5	0	f
188	1	f	OUT_RS_1_11_06		\N	6	0	f
189	1	f	OUT_RS_1_11_07		\N	7	0	f
190	1	f	OUT_RS_1_11_08		\N	8	0	f
191	1	f	OUT_RS_1_11_09	Фасад правая сторона	\N	9	0	f
192	1	f	OUT_RS_1_11_10	Фасад левая сторона	\N	10	0	f
193	1	f	OUT_RS_1_11_11	Светильник главный вход	\N	11	0	f
194	1	f	OUT_RS_1_11_12		\N	12	0	f
195	1	f	OUT_RS_1_11_13		\N	13	0	f
196	1	f	OUT_RS_1_11_14		\N	14	0	f
197	1	f	OUT_RS_1_11_15		\N	15	0	f
198	4	t	OUT_RS_1_14_06	гостиная потолок справа	\N	6	0	f
199	21	t	OUT_RS_1_14_06	гостиная потолок справа	\N	6	0	f
200	4	f	OUT_RS_1_14_07	гостиная подсветка кухни	\N	7	0	t
201	21	f	OUT_RS_1_14_07	гостиная подсветка кухни	\N	7	0	t
202	4	f	OUT_RS_1_14_08	освещение лестница	\N	8	0	f
203	21	f	OUT_RS_1_14_08	освещение лестница	\N	8	0	f
204	4	f	OUT_RS_1_14_09	освещение внутренний двор	\N	9	0	f
205	21	f	OUT_RS_1_14_09	освещение внутренний двор	\N	9	0	f
206	4	f	OUT_RS_1_14_10	освещение лестничная площадка	\N	10	0	f
207	21	f	OUT_RS_1_14_10	освещение лестничная площадка	\N	10	0	f
208	4	f	OUT_RS_1_14_11	гостиная стена кирпичная	\N	11	0	f
209	21	f	OUT_RS_1_14_11	гостиная стена кирпичная	\N	11	0	f
210	4	f	OUT_RS_1_14_12	Подсветка ниш	\N	12	2	f
211	21	f	OUT_RS_1_14_12	Подсветка ниш	\N	12	2	f
212	4	f	OUT_RS_1_14_13	гостиная стена штукатурная	\N	13	0	f
213	21	f	OUT_RS_1_14_13	гостиная стена штукатурная	\N	13	0	f
214	4	f	OUT_RS_1_14_14	кладовка	\N	14	0	f
215	21	f	OUT_RS_1_14_14	кладовка	\N	14	0	f
216	4	f	OUT_RS_1_14_15		\N	15	0	t
217	21	f	OUT_RS_1_14_15		\N	15	0	t
218	4	f	OUT_RS_1_14_16		\N	16	0	f
219	21	f	OUT_RS_1_14_16		\N	16	0	f
220	7	f	OUT_RS_1_15_01	вентилятор душ	\N	1	0	f
221	22	f	OUT_RS_1_15_01	вентилятор душ	\N	1	0	f
222	7	f	OUT_RS_1_15_02		\N	2	0	f
223	22	f	OUT_RS_1_15_02		\N	2	0	f
224	7	f	OUT_RS_1_15_03	душевая свет	\N	3	0	f
225	22	f	OUT_RS_1_15_03	душевая свет	\N	3	0	f
226	7	f	OUT_RS_1_15_04	комната отдыха свет	\N	4	0	f
227	22	f	OUT_RS_1_15_04	комната отдыха свет	\N	4	0	f
228	7	f	OUT_RS_1_15_05		\N	5	0	f
229	22	f	OUT_RS_1_15_05		\N	5	0	f
230	7	f	OUT_RS_1_15_06	освещение сауны нижнее	\N	6	0	f
231	22	f	OUT_RS_1_15_06	освещение сауны нижнее	\N	6	0	f
232	7	f	OUT_RS_1_15_07	освещение сауны верхнее	\N	7	0	f
233	22	f	OUT_RS_1_15_07	освещение сауны верхнее	\N	7	0	f
234	7	f	OUT_RS_1_15_08	освещение котельной	\N	8	0	f
235	22	f	OUT_RS_1_15_08	освещение котельной	\N	8	0	f
236	7	f	OUT_RS_1_15_09	вентиляция комната отдыха	\N	9	0	f
237	22	f	OUT_RS_1_15_09	вентиляция комната отдыха	\N	9	0	f
238	7	f	OUT_RS_1_15_10		\N	10	0	f
239	22	f	OUT_RS_1_15_10		\N	10	0	f
240	7	f	OUT_RS_1_15_11	свет в туалете	\N	11	0	f
241	22	f	OUT_RS_1_15_11	свет в туалете	\N	11	0	f
242	7	f	OUT_RS_1_15_12	освещение коридор	\N	12	0	f
243	22	f	OUT_RS_1_15_12	освещение коридор	\N	12	0	f
244	7	f	OUT_RS_1_15_13	освещение террасы	\N	13	0	f
245	22	f	OUT_RS_1_15_13	освещение террасы	\N	13	0	f
246	7	f	OUT_RS_1_15_14		\N	14	0	f
247	22	f	OUT_RS_1_15_14		\N	14	0	f
248	7	f	OUT_RS_1_15_15		\N	15	0	f
249	22	f	OUT_RS_1_15_15		\N	15	0	f
250	7	f	OUT_RS_1_15_16		\N	16	0	f
251	22	f	OUT_RS_1_15_16		\N	16	0	f
252	9	f	OUT_RS_1_16_01	освещение над сценой	\N	1	0	f
253	23	f	OUT_RS_1_16_01	освещение над сценой	\N	1	0	f
254	9	f	OUT_RS_1_16_02	освещение в зрительном зале	\N	2	0	f
255	23	f	OUT_RS_1_16_02	освещение в зрительном зале	\N	2	0	f
256	9	f	OUT_RS_1_16_03	проектор	\N	3	0	f
257	23	f	OUT_RS_1_16_03	проектор	\N	3	0	f
258	9	f	OUT_RS_1_16_04		\N	4	0	f
259	23	f	OUT_RS_1_16_04		\N	4	0	f
260	9	f	OUT_RS_1_16_05	фронтальное освещение сцены	\N	5	0	f
261	23	f	OUT_RS_1_16_05	фронтальное освещение сцены	\N	5	0	f
262	9	f	OUT_RS_1_16_06		\N	6	0	f
263	23	f	OUT_RS_1_16_06		\N	6	0	f
264	9	f	OUT_RS_1_16_07		\N	7	0	f
265	23	f	OUT_RS_1_16_07		\N	7	0	f
266	9	f	OUT_RS_1_16_08		\N	8	0	f
267	23	f	OUT_RS_1_16_08		\N	8	0	f
268	9	f	OUT_RS_1_16_09		\N	9	0	f
269	23	f	OUT_RS_1_16_09		\N	9	0	f
270	9	f	OUT_RS_1_16_10		\N	10	0	f
271	23	f	OUT_RS_1_16_10		\N	10	0	f
272	9	f	OUT_RS_1_16_11		\N	11	0	f
273	23	f	OUT_RS_1_16_11		\N	11	0	f
274	9	f	OUT_RS_1_16_12		\N	12	0	f
275	23	f	OUT_RS_1_16_12		\N	12	0	f
276	9	f	OUT_RS_1_16_13		\N	13	0	f
277	23	f	OUT_RS_1_16_13		\N	13	0	f
278	9	f	OUT_RS_1_16_14		\N	14	0	f
279	23	f	OUT_RS_1_16_14		\N	14	0	f
280	9	f	OUT_RS_1_16_15		\N	15	0	f
281	23	f	OUT_RS_1_16_15		\N	15	0	f
282	9	f	OUT_RS_1_16_16		\N	16	0	f
283	23	f	OUT_RS_1_16_16		\N	16	0	f
284	11	f	OUT_RS_2_22_01	Степина комната, карта	\N	1	0	f
285	11	f	OUT_RS_2_22_02		\N	2	0	f
286	11	f	OUT_RS_2_22_03		\N	3	0	f
287	11	f	OUT_RS_2_22_04	Катина комната	\N	4	0	t
288	11	f	OUT_RS_2_22_05	Холл 2 этаж, доска	\N	5	0	t
289	11	f	OUT_RS_2_22_06		\N	6	0	f
290	11	f	OUT_RS_2_22_07		\N	7	0	f
291	11	f	OUT_RS_2_22_08		\N	8	0	f
292	11	f	OUT_RS_2_22_09	Степина комната	\N	9	0	t
293	11	f	OUT_RS_2_22_09	поломка	\N	10	0	f
294	11	f	OUT_RS_2_22_10	Холл 2 этажа стена	\N	11	0	f
295	11	f	OUT_RS_2_22_11	Гришина комната потолок	\N	12	0	f
296	11	f	OUT_RS_2_22_12	холл 2 этаж потолок	\N	13	0	t
297	11	f	OUT_RS_2_22_13	Гришина комната, подсветка гитар	\N	14	0	f
298	11	f	OUT_RS_2_22_14		\N	15	0	f
299	11	f	OUT_RS_2_22_15		\N	16	0	f
300	16	f	OUT_RS_2_26_01	Ванная верхний свет	\N	1	0	t
301	16	f	OUT_RS_2_26_02	Большой с/у над зеркалом	\N	2	0	t
302	16	f	OUT_RS_2_26_03	Спальня потолок	\N	3	0	t
303	16	f	OUT_RS_2_26_04	Большой с/у, верхний свет	\N	4	0	t
304	16	f	OUT_RS_2_26_05	Вентиляция ванная	\N	5	0	f
305	16	f	OUT_RS_2_26_06		\N	6	0	f
306	16	f	OUT_RS_2_26_07		\N	7	0	f
307	16	f	OUT_RS_2_26_08		\N	8	0	f
308	16	f	OUT_RS_2_26_09	Гостевой с/у потолок	\N	9	0	f
309	16	f	OUT_RS_2_26_10	Малый с/у потолок	\N	10	0	t
310	16	f	OUT_RS_2_26_11	Гостевой с/у вентиляция	\N	11	0	f
311	16	f	OUT_RS_2_26_12	Гостевая комната	\N	12	0	f
312	16	f	OUT_RS_2_26_13	Вентилятор туалет	\N	13	0	f
313	16	f	OUT_RS_2_26_14	Гостевая комната, стена	\N	14	0	t
314	16	f	OUT_RS_2_26_15		\N	15	0	f
315	16	f	OUT_RS_2_26_16		\N	16	0	f
316	19	f	OUT_RS_2_12_01	Управление отоплением	\N	1	0	f
317	19	f	OUT_RS_2_12_02	Светильник. Крыльцо	\N	2	0	t
318	19	f	OUT_RS_2_12_03	Светильник. Фасад дома	\N	3	0	f
319	19	f	OUT_RS_2_12_04	Светильник. Передний двор	\N	4	0	f
320	19	f	OUT_RS_2_12_05	Светильник. Задний двор	\N	5	0	f
321	19	f	OUT_RS_2_12_06	Светильник. Балкон	\N	6	0	f
322	19	f	OUT_RS_2_12_07	Светильник. Терраса	\N	7	0	t
323	19	f	OUT_RS_2_12_08	Светильник. Навес у котельной	\N	8	0	f
324	19	f	OUT_RS_2_12_09	Светильник. Прихожая	\N	9	0	t
325	19	f	OUT_RS_2_12_10	Светильник, Гардероб	\N	10	0	t
326	19	f	OUT_RS_2_12_11		\N	11	0	f
327	19	f	OUT_RS_2_12_12		\N	12	0	f
328	19	f	OUT_RS_2_12_13		\N	13	0	f
329	19	f	OUT_RS_2_12_14		\N	14	0	f
330	19	f	OUT_RS_2_12_15		\N	15	0	f
331	19	f	OUT_RS_2_12_16		\N	16	0	f
332	20	f	OUT_RS_2_13_01		\N	1	0	f
333	20	f	OUT_RS_2_13_02		\N	2	0	f
334	20	f	OUT_RS_2_13_03		\N	3	0	f
335	20	f	OUT_RS_2_13_04		\N	4	0	f
336	20	f	OUT_RS_2_13_05		\N	5	0	f
337	20	f	OUT_RS_2_13_06		\N	6	0	f
338	20	f	OUT_RS_2_13_07		\N	7	0	f
339	20	f	OUT_RS_2_13_08		\N	8	0	f
340	20	f	OUT_RS_2_13_09		\N	9	0	f
341	20	f	OUT_RS_2_13_10		\N	10	0	f
342	20	f	OUT_RS_2_13_11		\N	11	0	f
343	20	f	OUT_RS_2_13_12		\N	12	0	f
344	20	f	OUT_RS_2_13_13		\N	13	0	f
345	20	f	OUT_RS_2_13_14		\N	14	0	f
346	20	f	OUT_RS_2_13_15		\N	15	0	f
347	20	f	OUT_RS_2_13_16		\N	16	0	f
\.


--
-- TOC entry 3512 (class 0 OID 94820)
-- Dependencies: 237
-- Data for Name: Rs485Device; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Rs485Device" (id, name, definition, description, net_interface_id, rs485_delay_timeout, is_input, box, parity, base_address, noise_filters, word_len, net_max_timeout, stop_bit, type_id, net_address_len, version, protocol_id, baud_rate) FROM stdin;
1	ЩР-12 Центральный щит. Прихожая. Контроллер вывода	\N	\N	1	\N	f	11	\N	16*2	\N	\N	\N	\N	0	\N	\N	0	\N
2	ЩР-12 Центральный щит. Прихожая. Контроллер ввода	main box first floor key-controller	\N	1	2	t	12	f	16*2+1	f	8	5	1	2	8	1.0	1	9600
3	ЩР-13 (Гостиная слева). Контроллер ввода	living room left box key-controller	\N	1	2	t	13	f	16*3	f	8	5	1	2	8	1.0	1	9600
4	ЩР-14 (Гостиная справа). Контроллер вывода	\N	\N	1	2	f	14	f	16*4	f	8	5	1	1	8	1.0	1	9600
5	ЩР-14 (Гостиная справа). Контроллер ввода	\N	\N	1	2	t	14	f	16*5	f	8	5	1	2	8	1.0	1	9600
6	ЩР-15 (Комната отдыха). Контроллер ввода			1	\N	t	15	f	16*8	f	8	5	1	2	8	1.0	1	9600
7	ЩР-15 (Комната отдыха). Контроллер вывода			1	\N	f	15	f	16*7	f	8	5	1	0	8	1.0	1	9600
8	ЩР-16 (Музыкальная студия). Контроллер ввода			1	\N	t	16	f	16*6	f	8	5	1	2	8	1.0	1	9600
9	ЩР-16 (Музыкальная студия). Контроллер вывода			1	\N	f	16	f	16*6+1	f	8	5	1	0	8	1.0	1	9600
10	ЩР-21 (Центральный щит 2-этажа). Контроллер ввода			1	\N	t	21	f	16*7+1	f	8	5	1	0	8	1.0	1	9600
11	ЩР-22 (Степина комната). Контроллер вывода			1	\N	f	22	f	16*9	f	8	5	1	0	8	1.0	1	9600
12	ЩР-23 (Степина комната). Контроллер ввода			1	\N	t	23	f	16*10	f	8	5	1	2	8	1.0	1	9600
13	ЩР-24 (Гришина комната). Контроллер ввода			1	\N	t	24	f	16*11	f	8	5	1	2	8	1.0	1	9600
14	ЩР-25 (Гостевая комната). Контроллер ввода			1	\N	t	25	f	16*12	f	8	5	1	2	8	1.0	1	9600
15	ЩР-26 (Спальня комната). Контроллер ввода			1	\N	t	26	f	16*13	f	8	5	1	2	8	1.0	1	9600
16	ЩР-26 (Спальня комната). Контроллер вывода			1	\N	f	26	f	16*14	f	8	5	1	0	8	1.0	1	9600
17	ЩР-31 (Чердак, левая сторона). Контроллер ввода			1	\N	t	31	f	16*14+1	f	8	5	1	0	8	1.0	1	9600
18	ЩР-32 (Чердак, правая сторона). Контроллер вывода			1	\N	f	32	f	16*15	f	8	5	1	0	8	1.0	1	9600
19				2	\N	f	12	f	16*2	f	8	5	1	0	8	1.0	1	9600
20	ЩР-13 (Гостиная слева). Контроллер вывода			2	\N	f	13	f	16*3	f	8	5	1	0	8	1.0	1	9600
21	ЩР-14 (Гостиная справа). Контроллер вывода			2	\N	f	14	f	16*4	f	8	5	1	0	8	1.0	1	9600
22	ЩР-15 (Комната отдыха). Контроллер вывода			2	\N	f	15	f	16*5	f	8	5	1	0	8	1.0	1	9600
23	ЩР-16 (Музыкальная студия). Контроллер вывода			2	\N	f	16	f	16*6	f	8	5	1	0	8	1.0	1	9600
24	ЩР-21 (Центральный щит 2-этажа). Контроллер вывода			2	\N	f	21	f	16*7	f	8	5	1	0	8	1.0	1	9600
25	ЩР-23 (Степина комната). Контроллер вывода			2	\N	f	23	f	16*8	f	8	5	1	0	8	1.0	1	9600
26	ЩР-24 (Гришина комната). Контроллер вывода			2	\N	f	24	f	16*9	f	8	5	1	0	8	1.0	1	9600
27	ЩР-25 (Гостевая комната). Контроллер вывода			2	\N	f	25	f	16*10	f	8	5	1	0	8	1.0	1	9600
28	ЩР-31 (Чердак, левая сторона). Контроллер вывода			2	\N	f	31	f	16*12	f	8	5	1	0	8	1.0	1	9600
29	ЩР-32 (Чердак, правая сторона). Контроллер вывода 2			2	\N	f	32	f	16*13	f	8	5	1	0	8	1.0	1	9600
\.


--
-- TOC entry 3508 (class 0 OID 94803)
-- Dependencies: 233
-- Data for Name: Rs485DeviceType; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Rs485DeviceType" (id, name, definition, description) FROM stdin;
0	none	\N	\N
1	MU110-16R	output	Контроллер вывода
2	MV110-16D	input	Контроллер ввода
\.


--
-- TOC entry 3515 (class 0 OID 94873)
-- Dependencies: 240
-- Data for Name: Rs485Key; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Rs485Key" (id, rs_device_id, shift, name, definition, description, state, counter) FROM stdin;
3	2	3	IN_RS_1_12_03	\N	\N	0	0
5	2	5	IN_RS_1_12_05	\N	\N	0	0
10	2	10	IN_RS_1_12_10	\N	\N	0	0
13	2	13	IN_RS_1_12_13	\N	\N	0	0
14	2	14	IN_RS_1_12_14	\N	\N	0	0
15	2	15	IN_RS_1_12_15	\N	\N	0	0
16	2	16	IN_RS_1_12_16	\N	\N	0	0
18	3	2	IN_RS_1_13_02 	\N	\N	0	100
20	3	4	IN_RS_1_13_04	\N	\N	0	71
23	3	7	IN_RS_1_13_07	\N	\N	0	0
24	3	8	IN_RS_1_13_08	\N	\N	0	0
31	3	15	IN_RS_1_13_15 	\N	\N	0	0
32	3	16	IN_RS_1_13_16 	\N	\N	0	0
34	5	2	IN_RS_1_14_02 (Задний двор)	\N	\N	0	55
35	5	3	IN_RS_1_14_03 (Кладовая)	\N	\N	0	1702
36	5	4	IN_RS_1_14_04 (Выход на террасу)	\N	\N	0	132
37	5	5	IN_RS_1_14_05 (Гостиная, освещение стен)	\N	\N	0	0
38	5	6	IN_RS_1_14_06 (Лестница 2-3 этаж)	\N	\N	0	0
39	5	7	IN_RS_1_14_07 (Холл 1 этажа, освещение верхнее)	\N	\N	0	0
40	5	8	IN_RS_1_14_08 (Лестница 1-2 этаж, светодиодная подсветка)	\N	\N	0	0
41	5	9	IN_RS_1_14_09 (Лестница 2-3 этаж, светодиодная подсветка)	\N	\N	0	8
42	5	10	IN_RS_1_14_10	\N	\N	0	9
43	5	11	IN_RS_1_14_11 (Освещение лестничной площадки)	\N	\N	0	14
44	5	12	IN_RS_1_14_12 (Холл 1 этажа от лестницы)	\N	\N	0	20
45	5	13	IN_RS_1_14_13	\N	\N	0	20
46	5	14	IN_RS_1_14_14 (Освещение лестницы)	\N	\N	0	8
47	5	15	IN_RS_1_14_15 (Кладовая)	\N	\N	0	111
48	5	16	IN_RS_1_14_16 (Кладовая)	\N	\N	0	111
49	6	1	IN_RS_1_15_01 (С/У 1 этажа, свет)	\N	\N	0	0
50	6	2	IN_RS_1_15_02 (С/У 1 этажа, вентиляция)	\N	\N	0	0
51	6	3	IN_RS_1_15_03	\N	\N	0	0
52	6	4	IN_RS_1_15_04	\N	\N	0	0
53	6	5	IN_RS_1_15_05 (Котельная, свет)	\N	\N	0	3089
54	6	6	IN_RS_1_15_06 (Сауна, нижнее освещение)	\N	\N	0	2506
55	6	7	IN_RS_1_15_07 (Сауна, верхнее освещение)	\N	\N	0	3557
56	6	8	IN_RS_1_15_08 (Предбанник, свет)	\N	\N	0	1970
57	6	9	IN_RS_1_15_09 (Туалет 1 этажа)	\N	\N	0	0
58	6	10	IN_RS_1_15_10 (Туалет 1 этажа, свет)	\N	\N	0	20888
59	6	11	IN_RS_1_15_11 (Туалет 1 этажа)	\N	\N	0	711
60	6	12	IN_RS_1_15_12 (Туалет 1 этажа)	\N	\N	0	711
61	6	13	IN_RS_1_15_13 (Комната отдыха, вентиляция)	\N	\N	0	2700
62	6	14	IN_RS_1_15_14 (Комната отдыха, свет)	\N	\N	0	8483
63	6	15	IN_RS_1_15_15 (Душ, свет)	\N	\N	0	9593
64	6	16	IN_RS_1_15_16 (Душ, вентиляция)	\N	\N	0	2195
65	8	1	IN_RS_1_16_01 (Музыкальная комната, верхний свет)	\N	\N	0	157
66	8	2	IN_RS_1_16_02 (Музыкальная комната, сцена)	\N	\N	0	379
67	8	3	IN_RS_1_16_03 (Музыкальная комната, проектор)	\N	\N	0	40
68	8	4	IN_RS_1_16_04 (Кладовка)	\N	\N	0	7
69	8	5	IN_RS_1_16_05	\N	\N	0	0
70	8	6	IN_RS_1_16_06	\N	\N	0	0
71	8	7	IN_RS_1_16_07	\N	\N	0	0
72	8	8	IN_RS_1_16_08	\N	\N	0	0
73	8	9	IN_RS_1_16_09	\N	\N	0	155
74	8	10	IN_RS_1_16_10	\N	\N	0	376
75	8	11	IN_RS_1_16_11	\N	\N	0	198
76	8	12	IN_RS_1_16_12	\N	\N	0	189
77	8	13	IN_RS_1_16_13	\N	\N	0	189
78	8	14	IN_RS_1_16_14	\N	\N	0	179
79	8	15	IN_RS_1_16_15	\N	\N	0	2
80	8	16	IN_RS_1_16_16	\N	\N	0	2
81	10	1	IN_RS_1_21_01	\N	\N	0	0
11	2	11	IN_RS_1_12_11	(Свет в прихожей из коридора)	\N	0	3
12	2	12	IN_RS_1_12_12	(Свет в гардеробе из коридора)	\N	0	3
17	3	1	IN_RS_1_13_01	(Гостиная, освещение над столом)	\N	0	100
19	3	3	IN_RS_1_13_03	(Гостиная, освещение кухня)	\N	0	71
21	3	5	IN_RS_1_13_05 	(Кухня над столешницей, правый)	\N	0	253
82	10	2	IN_RS_1_21_02	\N	\N	0	0
83	10	3	IN_RS_1_21_03	\N	\N	0	0
84	10	4	IN_RS_1_21_04	\N	\N	0	0
85	10	5	IN_RS_1_21_05	\N	\N	0	0
86	10	6	IN_RS_1_21_06	\N	\N	0	0
87	10	7	IN_RS_1_21_07	\N	\N	0	0
88	10	8	IN_RS_1_21_08	\N	\N	0	0
89	10	9	IN_RS_1_21_09	\N	\N	0	0
90	10	10	IN_RS_1_21_10	\N	\N	0	0
91	10	11	IN_RS_1_21_11	\N	\N	0	0
92	10	12	IN_RS_1_21_12	\N	\N	0	0
93	10	13	IN_RS_1_21_13	\N	\N	0	0
94	10	14	IN_RS_1_21_14	\N	\N	0	0
95	10	15	IN_RS_1_21_15	\N	\N	0	0
96	10	16	IN_RS_1_21_16	\N	\N	0	0
97	12	1	IN_RS_1_23_01 (Катина комната, верхний свет)	\N	\N	0	4609
98	12	2	IN_RS_1_23_02 (Катина комната, боковой свет)	\N	\N	0	281
99	12	3	IN_RS_1_23_03 	\N	\N	0	4609
100	12	4	IN_RS_1_23_04 (Степина комната, боковой свет)	\N	\N	0	282
101	12	5	IN_RS_1_23_05 (Степина комната, карта)	\N	\N	0	2322
102	12	6	IN_RS_1_23_06 (Степина комната, верхний свет)	\N	\N	0	3161
103	12	7	IN_RS_1_23_07 (Выход на балкон, свет)	\N	\N	0	2343
104	12	8	IN_RS_1_23_08 (Лестница 2-3 этаж)	\N	\N	0	3160
105	12	9	IN_RS_1_23_09 (Холл 2 этажа, освещение верхнее)	\N	\N	0	0
106	12	10	IN_RS_1_23_10	\N	\N	0	0
107	12	11	IN_RS_1_23_11	\N	\N	0	0
108	12	12	IN_RS_1_23_12	\N	\N	0	0
109	12	13	IN_RS_1_23_13	\N	\N	0	0
110	12	14	IN_RS_1_23_14	\N	\N	0	0
111	12	15	IN_RS_1_23_15	\N	\N	0	0
112	12	16	IN_RS_1_23_16	\N	\N	0	0
113	13	1	IN_RS_1_24_01 (Гришина комната, верхний свет)	\N	\N	0	3060
114	13	2	IN_RS_1_24_02 (Гришина комната, подсветка гитар)	\N	\N	0	3221
115	13	3	IN_RS_1_24_03	\N	\N	0	0
116	13	4	IN_RS_1_24_04	\N	\N	0	0
117	13	5	IN_RS_1_24_05 (Холл 2 этаж, доска)	\N	\N	0	2893
118	13	6	IN_RS_1_24_06 (Холл 2 этаж, подсветка стен)	\N	\N	0	2120
119	13	7	IN_RS_1_24_07 (Холл 2 этажа, верхний свет)	\N	\N	0	2098
120	13	8	IN_RS_1_24_08	\N	\N	0	1177
121	13	9	IN_RS_1_24_09	\N	\N	0	13
122	13	10	IN_RS_1_24_10	\N	\N	0	13
123	13	11	IN_RS_1_24_11	\N	\N	0	12
124	13	12	IN_RS_1_24_12	\N	\N	0	11
125	13	13	IN_RS_1_24_13	\N	\N	0	0
126	13	14	IN_RS_1_24_14	\N	\N	0	0
127	13	15	IN_RS_1_24_15	\N	\N	0	0
128	13	16	IN_RS_1_24_16	\N	\N	0	0
129	14	1	IN_RS_1_25_01 	\N	\N	0	0
130	14	2	IN_RS_1_25_02 (Гостевая ванная комната, 2 этаж, вентиляция)	\N	\N	0	277
131	14	3	IN_RS_1_25_03 (Гостевая ванная комната, 2 этаж, свет)	\N	\N	0	1789
132	14	4	IN_RS_1_25_04 	\N	\N	0	0
133	14	5	IN_RS_1_25_05	\N	\N	0	0
134	14	6	IN_RS_1_25_06 (Гостевая комната, боковой свет)	\N	\N	0	0
135	14	7	IN_RS_1_25_07	\N	\N	0	0
136	14	8	IN_RS_1_25_08	\N	\N	0	0
137	14	9	IN_RS_1_25_09 (Гостевая комната, боковой свет)	\N	\N	0	596
138	14	10	IN_RS_1_25_10 (Гостевая комната, верхний свет)	\N	\N	0	1142
139	14	11	IN_RS_1_25_11	\N	\N	0	0
140	14	12	IN_RS_1_25_12	\N	\N	0	0
141	14	13	IN_RS_1_25_13 (Малый С/У, 2 этаж, свет)	\N	\N	0	4818
142	14	14	IN_RS_1_25_14	\N	\N	0	208
143	14	15	IN_RS_1_25_15	\N	\N	0	4816
144	14	16	IN_RS_1_25_16	\N	\N	0	208
145	15	1	IN_RS_1_26_01	\N	\N	0	112
146	15	2	IN_RS_1_26_02 (Спальня, верхний свет)	\N	\N	0	1342
147	15	3	IN_RS_1_26_03	\N	\N	0	1342
148	15	4	IN_RS_1_26_04	\N	\N	0	111
149	15	5	IN_RS_1_26_05 (Большой С/У, верхний свет)	\N	\N	0	1264
150	15	6	IN_RS_1_26_06 (Большой С/У, боковая подсветка)	\N	\N	0	615
151	15	7	IN_RS_1_26_07 	\N	\N	0	518
152	15	8	IN_RS_1_26_08 (Лестница, 1-2 этаж, светодиодная подсветка)	\N	\N	0	262
153	15	9	IN_RS_1_26_09	\N	\N	0	6
154	15	10	IN_RS_1_26_10 (Лестница 1-2 этаж, свет)	\N	\N	0	173
155	15	11	IN_RS_1_26_11	\N	\N	0	179
156	15	12	IN_RS_1_26_12 (Холл 2 этажа, верхний свет)	\N	\N	0	4276
157	15	13	IN_RS_1_26_13 (Ванная комната, 2 этаж, вентилятор)	\N	\N	0	1083
158	15	14	IN_RS_1_26_14	\N	\N	0	1085
159	15	15	IN_RS_1_26_15 (Ванная комната, 2 этаж, свет)	\N	\N	0	1509
160	15	16	IN_RS_1_26_16 	\N	\N	0	741
161	17	1	IN_RS_1_31_01	\N	\N	0	0
162	17	2	IN_RS_1_31_02	\N	\N	0	0
163	17	3	IN_RS_1_31_03	\N	\N	0	0
164	17	4	IN_RS_1_31_04	\N	\N	0	0
165	17	5	IN_RS_1_31_05	\N	\N	0	0
166	17	6	IN_RS_1_31_06	\N	\N	0	0
167	17	7	IN_RS_1_31_07	\N	\N	0	0
168	17	8	IN_RS_1_31_08	\N	\N	0	0
169	17	9	IN_RS_1_31_09	\N	\N	0	0
170	17	10	IN_RS_1_31_10	\N	\N	0	0
171	17	11	IN_RS_1_31_11	\N	\N	0	0
172	17	12	IN_RS_1_31_12	\N	\N	0	0
173	17	13	IN_RS_1_31_13	\N	\N	0	0
174	17	14	IN_RS_1_31_14	\N	\N	0	0
175	17	15	IN_RS_1_31_15	\N	\N	0	0
176	17	16	IN_RS_1_31_16	\N	\N	0	0
1	2	1	IN_RS_1_12_01	(Свет на крыльце)	\N	0	0
2	2	2	IN_RS_1_12_02	(Свет в прихожей)	\N	0	19
4	2	4	IN_RS_1_12_04	(Свет в гардеробе)	\N	0	19
6	2	6	IN_RS_1_12_06	(Гардероб)	\N	0	0
7	2	7	IN_RS_1_12_07	(Прихожая)	\N	0	0
8	2	8	IN_RS_1_12_08	(Выключить все)	\N	0	0
9	2	9	IN_RS_1_12_09	(Свет в холле 1 этажа)	\N	0	0
22	3	6	IN_RS_1_13_06 	(Кухня над столешницей, левый)	\N	0	123
25	3	9	IN_RS_1_13_09 	(Гостиная, свет верхний, слева)	\N	0	1474
26	3	10	IN_RS_1_13_10 	(Гостиная, свет верхний, справа)	\N	0	1635
27	3	11	IN_RS_1_13_11 	(Гостиная, освещение стена)	\N	0	1309
28	3	12	IN_RS_1_13_12 	(Гостиная, свет над столом)	\N	0	808
29	3	13	IN_RS_1_13_13 	(Гостиная, подсветка кухни)	\N	0	1185
30	3	14	IN_RS_1_13_14 	(Гостиная, подсветка ниш)	\N	0	798
33	5	1	IN_RS_1_14_01 	(Лестница, 1-2 этаж)	\N	0	41
\.


--
-- TOC entry 3510 (class 0 OID 94811)
-- Dependencies: 235
-- Data for Name: Rs485Protocol; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Rs485Protocol" (id, name, definition, description) FROM stdin;
0	none	\N	\N
4	dcon	\N	\N
1	owen	Owen	\N
2	modbus_rtu	ModBus-RTU	\N
3	modbus_ascii	ModBus-Ascii	\N
\.


--
-- TOC entry 3501 (class 0 OID 94749)
-- Dependencies: 226
-- Data for Name: SpatialGroup; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."SpatialGroup" (id, name, description) FROM stdin;
0	Без категории	\N
2	Гостиная	\N
3	Лестница 1-2 этаж	\N
4	Комната отдыха	\N
5	Музыкальная комната	\N
6	Холл второго этажа	\N
7	Двор	\N
8	Холл первого этажа	\N
1	Прихожая	\N
9	Степина комната	\N
10	Гришина комната	\N
11	Катина комната	\N
\.


--
-- TOC entry 3506 (class 0 OID 94782)
-- Dependencies: 231
-- Data for Name: SwitchDevice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."SwitchDevice" (id, switch_type, name, description, group_id) FROM stdin;
1	1	Крыльцо	\N	1
2	1	Прихожая	\N	1
3	1	Гардероб	\N	1
4	1	Прихожая 2	\N	1
5	1	Выключить все	\N	1
6	1	Прихожая из коридора	\N	1
7	1	Гардероб из коридора	\N	1
13	1	Свет в холле	\N	8
14	1	Свет над столом	\N	2
15	1	Кухня	\N	2
16	1	Кухня, над столешницей правый	\N	2
17	1	Кухня, над столешницей левый	\N	2
18	1	Верхний свет слева	\N	2
19	1	Верхний свет справа	\N	2
20	1	Выключатель освещения стены	\N	2
21	1	Выключатель света над столом	\N	2
22	1	Выключатель подсветки кухни	\N	2
23	1	Выключатель подсветки ниш	\N	2
\.


--
-- TOC entry 3504 (class 0 OID 94773)
-- Dependencies: 229
-- Data for Name: SwitchDeviceType; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."SwitchDeviceType" (id, name, definition, description) FROM stdin;
0	unknown	Не определено	\N
1	simple switch	Простой выключатель	\N
3	color dimmer	Цветной регулируемый выключатель	\N
2	one key dimmer	Одинарный регулируемый выключатель	\N
4	two keys dimmer	Двойной регулируемый выключатель	\N
\.


--
-- TOC entry 3538 (class 0 OID 0)
-- Dependencies: 225
-- Name: ControllableDeviceGroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."ControllableDeviceGroup_id_seq"', 11, true);


--
-- TOC entry 3539 (class 0 OID 0)
-- Dependencies: 221
-- Name: ControllableDeviceType_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."ControllableDeviceType_id_seq"', 5, true);


--
-- TOC entry 3540 (class 0 OID 0)
-- Dependencies: 227
-- Name: ControllableDevice_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."ControllableDevice_group_id_seq"', 19, true);


--
-- TOC entry 3541 (class 0 OID 0)
-- Dependencies: 223
-- Name: ControllableDevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."ControllableDevice_id_seq"', 58, true);


--
-- TOC entry 3542 (class 0 OID 0)
-- Dependencies: 217
-- Name: Masters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Masters_id_seq"', 1, true);


--
-- TOC entry 3543 (class 0 OID 0)
-- Dependencies: 219
-- Name: NetDevices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."NetDevices_id_seq"', 4, true);


--
-- TOC entry 3544 (class 0 OID 0)
-- Dependencies: 215
-- Name: NetType_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."NetType_id_seq"', 2, true);


--
-- TOC entry 3545 (class 0 OID 0)
-- Dependencies: 241
-- Name: Rs485Contact_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Rs485Contact_id_seq"', 358, true);


--
-- TOC entry 3546 (class 0 OID 0)
-- Dependencies: 242
-- Name: Rs485Contact_shift_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Rs485Contact_shift_seq"', 1, false);


--
-- TOC entry 3547 (class 0 OID 0)
-- Dependencies: 232
-- Name: Rs485DeviceType_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Rs485DeviceType_id_seq"', 1, false);


--
-- TOC entry 3548 (class 0 OID 0)
-- Dependencies: 236
-- Name: Rs485Device_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Rs485Device_id_seq"', 29, true);


--
-- TOC entry 3549 (class 0 OID 0)
-- Dependencies: 238
-- Name: Rs485Key_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Rs485Key_id_seq"', 1, false);


--
-- TOC entry 3550 (class 0 OID 0)
-- Dependencies: 239
-- Name: Rs485Key_shift_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Rs485Key_shift_seq"', 1, false);


--
-- TOC entry 3551 (class 0 OID 0)
-- Dependencies: 234
-- Name: Rs485Protocol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Rs485Protocol_id_seq"', 4, true);


--
-- TOC entry 3552 (class 0 OID 0)
-- Dependencies: 228
-- Name: SwitchDeviceType_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."SwitchDeviceType_id_seq"', 4, true);


--
-- TOC entry 3553 (class 0 OID 0)
-- Dependencies: 230
-- Name: SwitchDevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."SwitchDevice_id_seq"', 23, true);


--
-- TOC entry 3318 (class 2606 OID 94756)
-- Name: SpatialGroup ControllableDeviceGroup_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SpatialGroup"
    ADD CONSTRAINT "ControllableDeviceGroup_pkey" PRIMARY KEY (id);


--
-- TOC entry 3314 (class 2606 OID 94732)
-- Name: ControllableDeviceType ControllableDeviceType_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ControllableDeviceType"
    ADD CONSTRAINT "ControllableDeviceType_pkey" PRIMARY KEY (id);


--
-- TOC entry 3316 (class 2606 OID 94742)
-- Name: ControllableDevice ControllableDevice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ControllableDevice"
    ADD CONSTRAINT "ControllableDevice_pkey" PRIMARY KEY (id);


--
-- TOC entry 3310 (class 2606 OID 94697)
-- Name: Masters Masters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Masters"
    ADD CONSTRAINT "Masters_pkey" PRIMARY KEY (id);


--
-- TOC entry 3312 (class 2606 OID 94706)
-- Name: NetInterface NetDevices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."NetInterface"
    ADD CONSTRAINT "NetDevices_pkey" PRIMARY KEY (id);


--
-- TOC entry 3308 (class 2606 OID 94690)
-- Name: NetType NetType_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."NetType"
    ADD CONSTRAINT "NetType_pkey" PRIMARY KEY (id);


--
-- TOC entry 3334 (class 2606 OID 94901)
-- Name: Rs485Contact Rs485Contact_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Rs485Contact"
    ADD CONSTRAINT "Rs485Contact_pkey" PRIMARY KEY (id);


--
-- TOC entry 3336 (class 2606 OID 94903)
-- Name: Rs485Contact Rs485Contact_rs_device_id_shift_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Rs485Contact"
    ADD CONSTRAINT "Rs485Contact_rs_device_id_shift_key" UNIQUE (rs_device_id, shift);


--
-- TOC entry 3324 (class 2606 OID 94808)
-- Name: Rs485DeviceType Rs485DeviceType_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Rs485DeviceType"
    ADD CONSTRAINT "Rs485DeviceType_pkey" PRIMARY KEY (id);


--
-- TOC entry 3328 (class 2606 OID 94829)
-- Name: Rs485Device Rs485Device_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Rs485Device"
    ADD CONSTRAINT "Rs485Device_pkey" PRIMARY KEY (id);


--
-- TOC entry 3330 (class 2606 OID 94882)
-- Name: Rs485Key Rs485Key_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Rs485Key"
    ADD CONSTRAINT "Rs485Key_pkey" PRIMARY KEY (id);


--
-- TOC entry 3332 (class 2606 OID 94884)
-- Name: Rs485Key Rs485Key_rs_device_id_shift_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Rs485Key"
    ADD CONSTRAINT "Rs485Key_rs_device_id_shift_key" UNIQUE (rs_device_id, shift);


--
-- TOC entry 3326 (class 2606 OID 94818)
-- Name: Rs485Protocol Rs485Protocol_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Rs485Protocol"
    ADD CONSTRAINT "Rs485Protocol_pkey" PRIMARY KEY (id);


--
-- TOC entry 3320 (class 2606 OID 94780)
-- Name: SwitchDeviceType SwitchDeviceType_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SwitchDeviceType"
    ADD CONSTRAINT "SwitchDeviceType_pkey" PRIMARY KEY (id);


--
-- TOC entry 3322 (class 2606 OID 94791)
-- Name: SwitchDevice SwitchDevice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SwitchDevice"
    ADD CONSTRAINT "SwitchDevice_pkey" PRIMARY KEY (id);


--
-- TOC entry 3339 (class 2606 OID 94743)
-- Name: ControllableDevice ControllableDevice_device_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ControllableDevice"
    ADD CONSTRAINT "ControllableDevice_device_type_fkey" FOREIGN KEY (device_type) REFERENCES public."ControllableDeviceType"(id);


--
-- TOC entry 3340 (class 2606 OID 94765)
-- Name: ControllableDevice ControllableDevice_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ControllableDevice"
    ADD CONSTRAINT "ControllableDevice_group_id_fkey" FOREIGN KEY (group_id) REFERENCES public."SpatialGroup"(id) NOT VALID;


--
-- TOC entry 3337 (class 2606 OID 94712)
-- Name: NetInterface NetDevices_master_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."NetInterface"
    ADD CONSTRAINT "NetDevices_master_fkey" FOREIGN KEY (master) REFERENCES public."Masters"(id);


--
-- TOC entry 3338 (class 2606 OID 94707)
-- Name: NetInterface NetDevices_net_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."NetInterface"
    ADD CONSTRAINT "NetDevices_net_type_fkey" FOREIGN KEY (net_type) REFERENCES public."NetType"(id);


--
-- TOC entry 3346 (class 2606 OID 94904)
-- Name: Rs485Contact Rs485Contact_rs_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Rs485Contact"
    ADD CONSTRAINT "Rs485Contact_rs_device_id_fkey" FOREIGN KEY (rs_device_id) REFERENCES public."Rs485Device"(id);


--
-- TOC entry 3343 (class 2606 OID 94830)
-- Name: Rs485Device Rs485Device_net_interface_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Rs485Device"
    ADD CONSTRAINT "Rs485Device_net_interface_id_fkey" FOREIGN KEY (net_interface_id) REFERENCES public."NetInterface"(id);


--
-- TOC entry 3344 (class 2606 OID 94840)
-- Name: Rs485Device Rs485Device_protocol_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Rs485Device"
    ADD CONSTRAINT "Rs485Device_protocol_id_fkey" FOREIGN KEY (protocol_id) REFERENCES public."Rs485Protocol"(id);


--
-- TOC entry 3345 (class 2606 OID 94835)
-- Name: Rs485Device Rs485Device_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Rs485Device"
    ADD CONSTRAINT "Rs485Device_type_id_fkey" FOREIGN KEY (type_id) REFERENCES public."Rs485DeviceType"(id);


--
-- TOC entry 3341 (class 2606 OID 94797)
-- Name: SwitchDevice SwitchDevice_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SwitchDevice"
    ADD CONSTRAINT "SwitchDevice_group_id_fkey" FOREIGN KEY (group_id) REFERENCES public."SpatialGroup"(id);


--
-- TOC entry 3342 (class 2606 OID 94792)
-- Name: SwitchDevice SwitchDevice_switch_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SwitchDevice"
    ADD CONSTRAINT "SwitchDevice_switch_type_fkey" FOREIGN KEY (switch_type) REFERENCES public."SwitchDeviceType"(id);


-- Completed on 2025-02-11 20:13:42 MSK

--
-- PostgreSQL database dump complete
--

