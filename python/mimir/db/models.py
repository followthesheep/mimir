# !/usr/bin/env python
# -*- coding: utf-8 -*-
# 
# Filename: models.py
# Project: db
# Author: Brian Cherinka
# Created: Thursday, 27th September 2018 5:09:03 pm
# License: <<licensename>>
# Copyright (c) 2018 Brian Cherinka
# Last Modified: Saturday, 29th September 2018 12:12:00 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import

import os

from sqlalchemy import create_engine, MetaData, Column
from sqlalchemy.orm import sessionmaker, scoped_session
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy.types import Integer


class DatabaseConnection(object):
    ''' This class creates a database connection '''
    def __init__(self, db_connection_string):
        ''' initialize the db '''        
        self.engine = create_engine(db_connection_string, echo=False)
        self.metadata = MetaData(bind=self.engine)
        self.Base = declarative_base(metadata=self.metadata)
        self.Session = scoped_session(sessionmaker(
            bind=self.engine, autocommit=True, expire_on_commit=True))

# create the db connection string
dbpath = os.path.abspath(os.path.dirname(__file__))
dbfile = os.path.join(dbpath, 'gcg.db')
database_connection_string = 'sqlite:///{0}'.format(dbfile)
# init the db
db = DatabaseConnection(database_connection_string)
# get the Base
Base = db.Base 


class Stars(Base):
    __tablename__ = 'stars'
    __table_args__ = {'autoload': True}


class Spectra(Base):
    __tablename__ = 'spectra'
    __table_args__ = {'autoload': True}

    star = relationship('Stars', backref='spectra')


class StarKit(Base):
    __tablename__ = 'starkit'
    __table_args__ = {'autoload': True}

    spectra = relationship('Spectra', backref='starkit')


class Observations(Base):
    __tablename__ = 'observations'
    __table_args__ = {"autoload": True}

    field = relationship('Field', backref='observations')
    spectra = relationship('Spectra', backref='observations')


class Field(Base):
    __tablename__ = 'field'
    __table_args__ = {"autoload": True}


class Image(Base):
    __tablename__ = 'image'
    __table_args__ = {"autoload": True}

    observations = relationship('Observations', backref='image')


class Points(Base):
    __tablename__ = 'points'
    __table_args__ = {"autoload": True}

    image = relationship('Image', backref='points')
    star = relationship('Stars', backref='point')


class Catalog1(Base):
    __tablename__ = 'catalog1'
    __table_args__ = {"autoload": True}

    star = relationship('Stars', backref='catalog1')


class StarView(Base):
    __tablename__ = 'star_view'
    __table_args__ = {"autoload": True}

    name = Column(Integer, primary_key=True)