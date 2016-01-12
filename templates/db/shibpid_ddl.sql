CREATE TABLE IF NOT EXISTS shibpid (
    localEntity VARCHAR(255) NOT NULL,
    peerEntity VARCHAR(255) NOT NULL,
    persistentId VARCHAR(50) NOT NULL,
    principalName VARCHAR(50) NOT NULL,
    localId VARCHAR(50) NOT NULL,
    peerProvidedId VARCHAR(50) NULL,
    creationDate TIMESTAMP NOT NULL,
    deactivationDate TIMESTAMP NULL,
    PRIMARY KEY (localEntity, peerEntity, persistentId),
    KEY persistentId (persistentId),
    KEY persistentId_2 (persistentId, deactivationDate),
    KEY localEntity (localEntity(16), peerEntity(16), localId),
    KEY localEntity_2 (localEntity(16), peerEntity(16), localId, deactivationDate)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

