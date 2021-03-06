
/*
  This code is a working file used for everyday references.
  
  This code creates a language table
  
  The following code demonstrates SQL interpretations used in SQL Azure 2016.
  
  This is not a copy of any current implementation of any company.
*/

CREATE TABLE [dbo].[Language](
	[Language] [nvarchar](50) NOT NULL,
	[LanguageAbrev] [nvarchar](2) NOT NULL,
	[LanguageGuid] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Language] PRIMARY KEY CLUSTERED 
(
	[LanguageGuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

Insert into [Language]([LanguageAbrev],[Language])
values 
('aa','Afar'),
('ab','Abkhazian'),
('af','Afrikaans'),
('ak','Akan'),
('sq','Albanian'),
('am','Amharic'),
('ar','Arabic'),
('an','Aragonese'),
('hy','Armenian'),
('as','Assamese'),
('av','Avaric'),
('ae','Avestan'),
('ay','Aymara'),
('az','Azerbaijani'),
('ba','Bashkir'),
('bm','Bambara'),
('eu','Basque'),
('be','Belarusian'),
('bn','Bengali'),
('bh','Bihari languages'),
('bi','Bislama'),
('bo','Tibetan'),
('bs','Bosnian'),
('br','Breton'),
('bg','Bulgarian'),
('my','Burmese'),
('ch','Chamorro'),
('ce','Chechen'),
('zh','Chinese'),
('cu','Church Slavic'),
('cv','Chuvash'),
('kw','Cornish'),
('co','Corsican'),
('cr','Cree'),
('cy','Welsh'),
('cs','Czech'),
('da','Danish'),
('de','German'),
('dv','Divehi; Dhivehi; Maldivian'),
('dz','Dzongkha'),
('el','Greek'),
('en','English'),
('eo','Esperanto'),
('et','Estonian'),
('eu','Basque'),
('ee','Ewe'),
('fo','Faroese'),
('fa','Persian'),
('fj','Fijian'),
('fi','Finnish'),
('fr','French'),
('fy','Frisian'),
('ff','Fulah'),
('gd','Gaelic; Scottish Gaelic'),
('ga','Irish'),
('gl','Galician'),
('gv','Manx'),
('gn','Guarani'),
('gu','Gujarati'),
('ht','Haitian; Haitian Creole'),
('ha','Hausa'),
('he','Hebrew'),
('hz','Herero'),
('hi','Hindi'),
('ho','Hiri Motu'),
('hr','Croatian'),
('hu','Hungarian'),
('ig','Igbo'),
('io','Ido'),
('ii','Sichuan Yi; Nuosu'),
('iu','Inuktitut'),
('ie','Interlingue; Occidental'),
('id','Indonesian'),
('ik','Inupiaq'),
('is','Icelandic'),
('it','Italian'),
('jv','Javanese'),
('ja','Japanese'),
('kl','Kalaallisut; Greenlandic'),
('kn','Kannada'),
('ks','Kashmiri'),
('ka','Georgian'),
('kr','Kanuri'),
('kk','Kazakh'),
('km','Central Khmer'),
('ki','Kikuyu; Gikuyu'),
('rw','Kinyarwanda'),
('ky','Kirghiz; Kyrgyz'),
('kv','Komi'),
('kg','Kongo'),
('ko','Korean'),
('kj','Kuanyama; Kwanyama'),
('ku','Kurdish'),
('lo','Lao'),
('la','Latin'),
('lv','Latvian'),
('li','Limburgan; Limburger; Limburgish'),
('ln','Lingala'),
('lt','Lithuanian'),
('lb','Luxembourgish; Letzeburgesch'),
('lu','Luba-Katanga'),
('lg','Ganda'),
('mh','Marshallese'),
('ml','Malayalam'),
('mi','Maori'),
('mr','Marathi'),
('mk','Macedonian'),
('mg','Malagasy'),
('mt','Maltese'),
('mn','Mongolian'),
('ms','Malay'),
('my','Burmese'),
('na','Nauru'),
('nv','Navajo; Navaho'),
('nr','Ndebele, South; South Ndebele'),
('nd','Ndebele, North; North Ndebele'),
('ng','Ndonga'),
('ne','Nepali'),
('nl','Dutch; Flemish'),
('nn','Norwegian Nynorsk'),
('nb','Bokm�l, Norwegian'),
('no','Norwegian'),
('ny','Chichewa; Chewa; Nyanja'),
('oc','Occitan (post 1500)'),
('oj','Ojibwa'),
('or','Oriya'),
('om','Oromo'),
('os','Ossetian; Ossetic'),
('pa','Panjabi; Punjabi'),
('pi','Pali'),
('pl','Polish'),
('pt','Portuguese'),
('ps','Pushto; Pashto'),
('qu','Quechua'),
('rm','Romansh'),
('ro','Romanian; Moldavian; Moldovan'),
('rn','Rundi'),
('ru','Russian'),
('sg','Sango'),
('sa','Sanskrit'),
('si','Sinhala; Sinhalese'),
('sk','Slovak'),
('sl','Slovenian'),
('se','Northern Sami'),
('sm','Samoan'),
('sn','Shona'),
('sd','Sindhi'),
('so','Somali'),
('st','Sotho, Southern'),
('es','Spanish; Castilian'),
('sq','Albanian'),
('sc','Sardinian'),
('sr','Serbian'),
('ss','Swati'),
('su','Sundanese'),
('sw','Swahili'),
('sv','Swedish'),
('ty','Tahitian'),
('ta','Tamil'),
('tt','Tatar'),
('te','Telugu'),
('tg','Tajik'),
('tl','Tagalog'),
('th','Thai'),
('ti','Tigrinya'),
('to','Tonga (Tonga Islands)'),
('tn','Tswana'),
('ts','Tsonga'),
('tk','Turkmen'),
('tr','Turkish'),
('tw','Twi'),
('ug','Uighur; Uyghur'),
('uk','Ukrainian'),
('ur','Urdu'),
('uz','Uzbek'),
('ve','Venda'),
('vi','Vietnamese'),
('vo','Volap�k'),
('wa','Walloon'),
('wo','Wolof'),
('xh','Xhosa'),
('yi','Yiddish'),
('yo','Yoruba'),
('za','Zhuang; Chuang'),
('zu','Zulu')
