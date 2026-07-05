DROP DATABASE IF EXISTS Readly;
CREATE DATABASE Readly;
USE Readly;

-- 1 Utente
CREATE TABLE Utente (
    email VARCHAR(255) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    nome VARCHAR(255) NOT NULL,
    cognome VARCHAR(255) NOT NULL,
    telefono VARCHAR(20), 
    Admin BOOLEAN NOT NULL DEFAULT FALSE
);

-- 2 Carrello
CREATE TABLE Carrello (
    ID_Carrello VARCHAR(255) PRIMARY KEY,
    idUtente VARCHAR(255) UNIQUE,
    FOREIGN KEY (idUtente) REFERENCES Utente(email) ON DELETE CASCADE
);

-- 3 Prodotto
CREATE TABLE Prodotto (
    ISBN VARCHAR(13) PRIMARY KEY,
    titolo VARCHAR(255) NOT NULL,
    autore VARCHAR(255) NOT NULL,
    prezzo DECIMAL(7,2) NOT NULL,
    IVA TINYINT UNSIGNED NOT NULL,
    descrizione TEXT NOT NULL,
    categoria VARCHAR(255) NOT NULL,
    disponibilita INT NOT NULL,
    idUtentePubblica VARCHAR(255),
    FOREIGN KEY (idUtentePubblica) REFERENCES Utente(email) ON DELETE SET NULL
);

-- 4 Immagine
CREATE TABLE Immagine (
    url VARCHAR(555) PRIMARY KEY,
    ordine INT NOT NULL,
    ISBN_prodotto VARCHAR(13) NOT NULL, 
    FOREIGN KEY (ISBN_prodotto) REFERENCES Prodotto(ISBN) ON DELETE CASCADE
);

-- 5 Ordine
CREATE TABLE Ordine (
    numero_ordine INT AUTO_INCREMENT PRIMARY KEY, 
    data_ordine DATETIME NOT NULL,
    stato_ordine VARCHAR(50) NOT NULL,
    costo DECIMAL(9,2) NOT NULL,
    indirizzo VARCHAR(255) NOT NULL,
    corriere VARCHAR(255) NOT NULL,
    data_consegna DATE NOT NULL,
    idUtente VARCHAR(255) NOT NULL, 
    FOREIGN KEY (idUtente) REFERENCES Utente(email),
    
    CONSTRAINT check_stato_ordine CHECK (stato_ordine IN ('In lavorazione', 'Spedito', 'In Consegna', 'Consegnato', 'Annullato'))
);

-- 6 Fattura
CREATE TABLE Fattura (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    metodo_pagamento VARCHAR(50) NOT NULL,
    data_emissione DATETIME NOT NULL,
    totale DECIMAL(9,2) NOT NULL,
    numero_ordine INT UNIQUE NOT NULL, 
    FOREIGN KEY (numero_ordine) REFERENCES Ordine(numero_ordine) ON DELETE RESTRICT
);

-- 7 Contiene (Prodotto - Carrello)
CREATE TABLE Contiene (
    ISBN_prodotto VARCHAR(13),
    ID_Carrello VARCHAR(255),
    quantita INT NOT NULL,
    PRIMARY KEY (ISBN_prodotto, ID_Carrello),
    FOREIGN KEY (ISBN_prodotto) REFERENCES Prodotto(ISBN) ON DELETE CASCADE,
    FOREIGN KEY (ID_Carrello) REFERENCES Carrello(ID_Carrello) ON DELETE CASCADE
);

-- 8 WishList (Utente - Prodotto)
CREATE TABLE WishList (
    idUtente VARCHAR(255),
    ISBN_prodotto VARCHAR(13),
    data_aggiunta DATETIME NOT NULL,
    PRIMARY KEY (idUtente, ISBN_prodotto),
    FOREIGN KEY (idUtente) REFERENCES Utente(email) ON DELETE CASCADE,
    FOREIGN KEY (ISBN_prodotto) REFERENCES Prodotto(ISBN) ON DELETE CASCADE
);

-- 9 Prodotto Ordinato (Ordine - Prodotto)
CREATE TABLE ProdottoOrdinato (
    numero_ordine INT,
    ISBN_prodotto VARCHAR(13),
    prezzo DECIMAL(7,2) NOT NULL,
    IVA TINYINT UNSIGNED NOT NULL,
    quantita INT NOT NULL,
    PRIMARY KEY (numero_ordine, ISBN_prodotto),
    FOREIGN KEY (numero_ordine) REFERENCES Ordine(numero_ordine) ON DELETE CASCADE,
    FOREIGN KEY (ISBN_prodotto) REFERENCES Prodotto(ISBN) ON DELETE RESTRICT
);

-- Popolamento tabelle


INSERT INTO Utente (email, password, nome, cognome, telefono, Admin) VALUES
('admin@readlyadmin.com', 'dJ8Jut6KynVWYO6xd5LaiAIY1PvcTiX77Cedf+n2XXA=', 'John', 'Readly', '+393562541782', TRUE);

INSERT INTO Prodotto (ISBN, titolo, autore, prezzo, IVA, descrizione, categoria, disponibilita, idUtentePubblica) VALUES
('9780000000001', '1984', 'George Orwell', 9.99, 22, 'Pubblicato nel 1949, 1984 di George Orwell è un capolavoro della letteratura distopica. Ambientato in un futuro totalitario, il romanzo segue Winston Smith nella sua lotta per mantenere il libero arbitrio in una società oppressa dal Grande Fratello, dalla sorveglianza costante e dalla manipolazione della verità', 'Classici', 100, 'admin@readlyadmin.com'),
('9780000000002', 'I dolori del giovane Werther', 'Johann Wolfgang von Goethe', 12.99, 22, 'I dolori del giovane Werther è un romanzo epistolare di Johann Wolfgang von Goethe, pubblicato nel 1774. Il libro racconta la storia di Werther, un giovane uomo che si innamora di una donna già promessa ad un altro uomo', 'Classici', 50, 'admin@readlyadmin.com'),
('9780000000003', 'Il fu Mattia Pascal', 'Luigi Pirandello', 14.99, 22, 'Il fu Mattia Pascal è un romanzo di Luigi Pirandello pubblicato nel 1904. La storia segue le vicende di Mattia Pascal, un uomo che, creduto morto, decide di adottare una nuova identità per sfuggire alla sua vita precedente', 'Classici', 75, 'admin@readlyadmin.com'),
('9780000000004', 'La fattoria degli animali', 'George Orwell', 8.99, 22, 'La fattoria degli animali è un romanzo allegorico di George Orwell, pubblicato nel 1945. La storia racconta la rivolta degli animali di una fattoria contro il loro padrone umano, che rappresenta una critica alla rivoluzione russa e al totalitarismo', 'Classici', 120, 'admin@readlyadmin.com'),
('9780000000005', 'Uno, nessuno e centomila', 'Luigi Pirandello', 13.99, 22, 'Uno, nessuno e centomila è un romanzo di Luigi Pirandello pubblicato nel 1926. La storia segue le vicende di Vitangelo Moscarda, un uomo che scopre che la sua identità è percepita in modo diverso da ogni persona che lo conosce', 'Classici', 60, 'admin@readlyadmin.com'),
('9780000000006', 'Guarire con le parole', 'Rupi Kaur', 10.99, 22, 'Guarire con le parole è una raccolta di poesie di Rupi Kaur, pubblicata nel 2017. Il libro affronta temi come l’amore, la perdita, la guarigione e l’empowerment femminile attraverso versi semplici ma profondi', 'Psicologici', 200, 'admin@readlyadmin.com'),
('9780000000007', 'Intelligenza emotiva', 'Daniel Goleman', 15.99, 22, 'Intelligenza emotiva è un libro di Daniel Goleman pubblicato nel 1995. Il libro esplora il concetto di intelligenza emotiva, che include la capacità di riconoscere, comprendere e gestire le proprie emozioni e quelle degli altri', 'Psicologici', 150, 'admin@readlyadmin.com'),
('9780000000008', 'La dittatura delle abitudini', 'Charles Duhigg', 14.99, 22, 'La dittatura delle abitudini è un libro di Charles Duhigg pubblicato nel 2012. Il libro esplora il potere delle abitudini nella nostra vita quotidiana e come possiamo cambiarle per migliorare la nostra salute, produttività e felicità', 'Psicologici', 80, 'admin@readlyadmin.com'),
('9780000000009', 'L''arte di amare', 'Erich Fromm', 11.99, 22, 'L’arte di amare è un libro di Erich Fromm pubblicato nel 1956. Il libro esplora il concetto di amore come un’arte che richiede conoscenza, sforzo e dedizione per essere coltivata e mantenuta', 'Psicologici', 90, 'admin@readlyadmin.com'),
('9780000000010', 'Le vostre zone erronee', 'Wayne Dyer', 9.99, 22, 'Le vostre zone erronee è un libro di Wayne Dyer pubblicato nel 1976. Il libro esplora i pensieri e i comportamenti autolimitanti che ci impediscono di vivere una vita piena e soddisfacente, offrendo strategie per superarli e raggiungere il nostro potenziale', 'Psicologici', 110, 'admin@readlyadmin.com'),
('9780000000011', 'L''assassinio su l''Orient Express', 'Agatha Christie', 7.99, 22, 'L’assassinio sull’Orient Express è un romanzo giallo di Agatha Christie pubblicato nel 1934. La storia segue il detective Hercule Poirot mentre indaga su un omicidio avvenuto a bordo del famoso treno Orient Express', 'Gialli', 130, 'admin@readlyadmin.com'),
('9780000000012', 'Dieci piccoli indiani', 'Agatha Christie', 6.99, 22, 'Dieci piccoli indiani è un romanzo giallo di Agatha Christie pubblicato nel 1939. La storia segue dieci persone che vengono invitate su un’isola deserta, dove vengono uccise una ad una in base a una filastrocca', 'Gialli', 90, 'admin@readlyadmin.com'),
('9780000000013', 'Assassinio sul Nilo', 'Agatha Christie', 8.99, 22, 'Assassinio sul Nilo è un romanzo giallo di Agatha Christie pubblicato nel 1937. La storia segue il detective Hercule Poirot mentre indaga su un omicidio avvenuto a bordo di una nave da crociera sul Nilo', 'Gialli', 70, 'admin@readlyadmin.com'),
('9780000000014', 'Sherlock Holmes: Tutti i romanzi e racconti', 'Arthur Conan Doyle', 19.99, 22, 'Sherlock Holmes: Tutti i romanzi e racconti è una raccolta completa delle avventure del celebre detective creato da Arthur Conan Doyle. La raccolta include tutti i romanzi e racconti che vedono protagonista Sherlock Holmes, offrendo ai lettori l’opportunità di immergersi nel mondo del detective più famoso della letteratura', 'Gialli', 200, 'admin@readlyadmin.com'),
('9780000000015', 'Poirot: Tutti i romanzi e racconti', 'Agatha Christie', 18.99, 22, 'Poirot: Tutti i romanzi e racconti è una raccolta completa delle avventure del celebre detective Hercule Poirot creato da Agatha Christie. La raccolta include tutti i romanzi e racconti che vedono protagonista Poirot, offrendo ai lettori l’opportunità di immergersi nel mondo del detective più famoso della letteratura gialla', 'Gialli', 150, 'admin@readlyadmin.com'),
('9780000000016', 'Un mago di Terramare', 'Ursula K. Le Guin', 12.99, 22, 'Un mago di Terramare è un romanzo fantasy di Ursula K. Le Guin pubblicato nel 1968. La storia segue le avventure di Ged, un giovane mago che frequenta una scuola di magia sull’isola di Roke e deve affrontare una minaccia oscura che mette in pericolo il mondo', 'Fantasy', 80, 'admin@readlyadmin.com'),
('9780000000017', 'La ballata del prescelto sbagliato', 'Camilla Cosmelli', 13.50, 22, 'Un romanzo high fantasy che ribalta il classico tropo del "Prescelto". La storia esplora le ansie e la crescita personale attraverso il viaggio di Rowan, un protagonista fallibile e profondamente umano.', 'Fantasy', 60, 'admin@readlyadmin.com'),
('9780000000018', 'Il priorato dell''albero delle arance', 'Samantha Shannon', 14.99, 22, 'Il priorato dell’albero delle arance è un romanzo fantasy di Samantha Shannon pubblicato nel 2019. La storia segue le vicende di cinque donne che vivono in un monastero segreto e devono proteggere un antico albero magico da forze oscure che minacciano il loro mondo', 'Fantasy', 90, 'admin@readlyadmin.com'),
('9780000000019', 'Il mare senza stelle', 'Erin Morgenstern', 13.99, 22, 'Il mare senza stelle è un romanzo fantasy di Erin Morgenstern pubblicato nel 2020. La storia segue le avventure di un giovane uomo che si ritrova intrappolato in un mondo magico e deve trovare un modo per tornare a casa', 'Fantasy', 70, 'admin@readlyadmin.com'),
('9780000000020', 'Il circo della notte', 'Erin Morgenstern', 12.99, 22, 'Il circo della notte è un romanzo fantasy di Erin Morgenstern pubblicato nel 2011. La storia segue le vicende di un circo magico che appare senza preavviso e offre spettacoli straordinari, ma nasconde segreti oscuri e una rivalità tra due giovani maghi', 'Fantasy', 100, 'admin@readlyadmin.com'),
('9780000000021', 'A casa prima di sera', 'Riley Sager', 11.99, 22, 'A casa prima di sera è un romanzo thriller di Riley Sager pubblicato nel 2020. La storia segue le vicende di una donna che torna nella sua casa d’infanzia dopo la morte dei genitori e scopre segreti inquietanti che mettono in pericolo la sua vita', 'Horror', 80, 'admin@readlyadmin.com'),
('9780000000022', 'Il bosco non dimentica', 'Minka Kent', 10.99, 22, 'Ignare della civiltà e messe in guardia dai suoi mali, Wren, diciannovenne, e le sue due sorelle, Sage ed Evie, sono state cresciute in totale isolamento, fuori dal mondo, in una capanna primitiva tra i boschi dello Stato di New York. Quando la più giovane si ammala gravemente, la madre parte con lei in cerca d’aiuto presso un villaggio vicino. Ma non fanno mai ritorno.', 'Horror', 60, 'admin@readlyadmin.com'),
('9780000000023', 'Il vangelo di Pinocchio: il burattino dannato', 'Staraldo', 19.99, 22, 'Quando, in una notte di tempesta, un vecchio sconosciuto consegna a Geppetto un ceppo di pino “proveniente dall’oscurità”, il falegname non immagina di aver accolto in casa la creatura che spezzerà il destino di Collodi. Pinocchio non è solo un burattino che prende vita: è un miracolo distorto, un figlio desiderato che diventa un incubo.', 'Horror', 50, 'admin@readlyadmin.com'),
('9780000000024', 'Incubo reale', 'Giannicola Nicoletti', 12.99, 22, 'Vi è mai capita di iniziare una giornata come tutte le altre poi diventata un incubo? E'' quello che succede a questa famiglia in partenza per le vacanze estive che si ritrova improvvisamente risucchiata in un vortice di terrore. Ciascun membro dovrà cercare di venirne fuori, aggrappandosi a volte anche al più piccolo barlume di speranza.', 'Horror', 70, 'admin@readlyadmin.com'),
('9780000000025', 'L''altra mamma', 'Josh Malerman', 11.99, 22, 'Per Bela, otto anni, la mamma, il papà e la nonna Ruth sono tutto il suo mondo. Ma la sera, prima di andare a letto, c''è qualcun altro che le tiene compagnia. Lei la chiama l''altra mamma, esce dal suo armadio dopo la buonanotte, è una specie di amica che le parla e a volte fluttua sopra di lei.', 'Horror', 90, 'admin@readlyadmin.com'),
('9780000000026', 'It ends with us', 'Colleen Hoover', 13.99, 22, 'It ends with us è un romanzo di Colleen Hoover pubblicato nel 2016. La storia segue le vicende di Lily Bloom, una giovane donna che si innamora di un uomo affascinante ma complicato, e deve affrontare le difficoltà di una relazione tossica e la forza di trovare la propria felicità', 'Romantici', 120, 'admin@readlyadmin.com'),
('9780000000027', 'La casa sul mare celeste', 'T.J. Klune', 14.99, 22, 'La casa sul mare celeste è un romanzo di T.J. Klune pubblicato nel 2020. La storia segue le vicende di un uomo che eredita una casa su un’isola remota e scopre segreti magici e una comunità di persone straordinarie che lo aiutano a trovare l’amore e la felicità', 'Romantici', 80, 'admin@readlyadmin.com'),
('9780000000028', 'Le pagine della nostra vita', 'Nicholas Sparks', 12.99, 22, 'Le pagine della nostra vita è un romanzo di Nicholas Sparks pubblicato nel 1996. La storia segue le vicende di Noah e Allie, due giovani innamorati che devono affrontare le difficoltà della guerra e delle differenze sociali per vivere il loro amore eterno', 'Romantici', 150, 'admin@readlyadmin.com'),
('9780000000029', 'Orgoglio e pregiudizio', 'Jane Austen', 9.99, 22, 'Orgoglio e pregiudizio è un romanzo di Jane Austen pubblicato nel 1813. La storia segue le vicende di Elizabeth Bennet, una giovane donna intelligente e indipendente, e del signor Darcy, un uomo ricco e orgoglioso, mentre navigano tra le convenzioni sociali e i pregiudizi per trovare l’amore vero', 'Romantici', 100, 'admin@readlyadmin.com'),
('9780000000030', 'Romeo e Giulietta', 'William Shakespeare', 8.99, 22, 'Romeo e Giulietta è una tragedia di William Shakespeare pubblicata nel 1597. La storia segue le vicende di Romeo e Giulietta, due giovani innamorati appartenenti a famiglie rivali, che devono affrontare l’odio e la violenza per vivere il loro amore proibito', 'Romantici', 200, 'admin@readlyadmin.com');

INSERT INTO Immagine (url, ordine, ISBN_prodotto) VALUES
('9780000000001.jpg', 1, '9780000000001'),
('9780000000002.jpg', 1, '9780000000002'),
('9780000000003.jpg', 1, '9780000000003'),
('9780000000004.jpg', 1, '9780000000004'),
('9780000000005.jpg', 1, '9780000000005'),
('9780000000006.jpg', 1, '9780000000006'),
('9780000000007.jpg', 1, '9780000000007'),
('9780000000008.jpg', 1, '9780000000008'),
('9780000000009.jpg', 1, '9780000000009'),
('9780000000010.jpg', 1, '9780000000010'),
('9780000000011.jpg', 1, '9780000000011'),
('9780000000012.jpg', 1, '9780000000012'),
('9780000000013.jpg', 1, '9780000000013'),
('9780000000014.jpg', 1, '9780000000014'),
('9780000000015.jpg', 1, '9780000000015'),
('9780000000016.jpg', 1, '9780000000016'),
('9780000000017.jpg', 1, '9780000000017'),
('9780000000018.jpg', 1, '9780000000018'),
('9780000000019.jpg', 1, '9780000000019'),
('9780000000020.jpg', 1, '9780000000020'),
('9780000000021.jpg', 1, '9780000000021'),
('9780000000022.jpg', 1, '9780000000022'),
('9780000000023.jpg', 1, '9780000000023'),
('9780000000024.jpg', 1, '9780000000024'),
('9780000000025.jpg', 1, '9780000000025'),
('9780000000026.jpg', 1, '9780000000026'),
('9780000000027.jpg', 1, '9780000000027'),
('9780000000028.jpg', 1, '9780000000028'),
('9780000000029.jpg', 1, '9780000000029'),
('9780000000030.jpg', 1, '9780000000030');