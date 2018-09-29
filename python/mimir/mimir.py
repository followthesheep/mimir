# !/usr/bin/env python
# -*- coding: utf-8 -*-
# 
# Filename: mimir.py
# Project: mimir
# Author: Brian Cherinka
# Created: Thursday, 27th September 2018 4:58:47 pm
# License: <<licensename>>
# Copyright (c) 2018 Brian Cherinka
# Last Modified: Saturday, 29th September 2018 1:06:44 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import

from mimir.db import models

session = models.db.Session()

# perform a query to get all the dates and velocities for a star S01
# grab the rows from starkit for star S01
q = session.query(models.Stars.name, models.Observations.date, models.StarKit.vlsr).\
    join(models.Spectra, models.StarKit, models.Observations).filter(
        models.Stars.name == 'S01')

# grab the rows from catalog1 for star S01                                                                                                                                                             ...: ls.Stars.name == 'S01')
q1 = session.query(models.Stars.name, models.Catalog1.date, models.Catalog1.vlsr).\
    join(models.Catalog1).filter(models.Stars.name == 'S01')

# union the two
q2 = q.union(q1)

# run the query
q2.all()
