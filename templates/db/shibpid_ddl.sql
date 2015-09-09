CREATE TABLE IF NOT EXISTS shibpid (
  localEntity TEXT NOT NULL,
  peerEntity TEXT NOT NULL,
  principalName VARCHAR(255) NOT NULL DEFAULT '',
  localId VARCHAR(255) NOT NULL,
  persistentId VARCHAR(36) NOT NULL,
  peerProvidedId VARCHAR(255) DEFAULT NULL,
  creationDate timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deactivationDate TIMESTAMP NULL DEFAULT NULL,
  KEY persistentId (persistentId),
  KEY persistentId_2 (persistentId, deactivationDate),
  KEY localEntity (localEntity(16), peerEntity(16), localId),
  KEY localEntity_2 (localEntity(16), peerEntity(16), localId, deactivationDate)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
