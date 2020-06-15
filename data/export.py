#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sqlite3
import json

def connect(db = "tr5nr.sqlite"):
    """ connects to SQLite database
    :param db: database file
    :return: connection object or None
    """
    conn = None
    try:
        conn = sqlite3.connect(db)
    except sqlite3.Error as e:
        print(e)
    
    return conn

def query(conn, sql = ""):
    """ makes a SQL Query to the connection
    :param conn: sqlite connection object
    :param sql: sql query
    :return: cursor rows object
    """
    cursor = conn.cursor()
    cursor.execute(sql)
    rows = cursor.fetchall()
    return rows

def get_stations(conn):
    sql = """
        SELECT codigo, nombre, tramo, tiempo, tipo from estacion ORDER BY codigo ASC
    """

    rows = query(conn, sql)
    data = []
    
    for row in rows:
        data.append({
            "code": row[0],
            "name": row[1],
            "section": row[2],
            "time": row[3],
            "type": row[4]
        })
    
    return data

def get_users(conn):
    sql = """
        SELECT codigo, tipo FROM usuario ORDER BY codigo ASC
    """
    rows = query(conn, sql)
    data = []
    
    for row in rows:
        category = "general"

        if row[0] == 1:
            category = "student"
        elif row[0] == 2:
            category = "senior"
        elif row[0] == 3:
            category = "handicapped"
        elif row[0] == 4:
            category = "special"

        data.append({
            "code": row[0],
            "name": row[1],
            "category": category
        })
    
    return data

def get_schedules(conn):
    sql = """
        SELECT origen, direccion, dia, hora FROM horario ORDER BY origen ASC
    """

    rows = query(conn, sql)
    data = []

    for row in rows:
        data.append({
            "origin": row[0],
            "destination": row[1],
            "day": row[2],
            "time": row[3]
        })
    
    return data

def get_ranges(conn):
    sql = """
        SELECT codigo, tipo, desde, hasta FROM rango ORDER BY codigo ASC
    """

    rows = query(conn, sql)
    data = []

    for row in rows:
        category = "low"
        if row[0] == 1:
            category = "mid"
        elif row[0] == 2:
            category = "high"
        
        data.append({
            "code": row[0],
            "name": row[1],
            "start": row[2],
            "end": row[3],
            "category": category
        })
    
    return data

def get_fares(conn):
    sql = """
        SELECT origen, destino, rango, usuario, valor FROM tarifa ORDER BY origen ASC
    """

    rows = query(conn, sql)
    data = []

    for row in rows:
        data.append({
            "from": row[0],
            "to": row[1],
            "range": row[2],
            "user": row[3],
            "cost": row[4]
        })
    
    return data

def output_json(data):
    return json.dumps(data)

def output_alasql(data):

    create_tables = """
alasql("CREATE TABLE stations (code number, name string, section number, time number, type number)");
const insertStation = alasql.compile(`INSERT INTO stations VALUES(?, ?, ?, ?, ?)`);

alasql("CREATE TABLE users (code number, name string, category string)");
const insertUser = alasql.compile(`INSERT INTO users VALUES(?, ?, ?)`);

alasql("CREATE TABLE schedules (origin number, destination number, day number, time number)");
const insertSchedule = alasql.compile(`INSERT INTO schedules VALUES(?, ?, ?, ?)`);

alasql("CREATE TABLE ranges (code number, name string, category string, start number, end number)");
const insertRange = alasql.compile(`INSERT INTO ranges VALUES(?, ?, ?, ?, ?)`);

alasql("CREATE TABLE fares (from number, to number, range number, user number, cost number)");
const insertFare = alasql.compile(`INSERT INTO fares VALUES(?, ?, ?, ?, ?)`);
"""
    stations = ""
    for station in data["stations"]:
        stations += f'insertStation([{station["code"]}, `{station["name"]}`, {station["section"]}, {station["time"]}, {station["type"]}]);\n'

    users = ""
    for user in data["users"]:
        users += f'insertUser([{user["code"]}, `{user["name"]}`, `{user["category"]}`]);\n'
    
    schedules = ""
    for schedule in data["schedules"]:
        schedules += f'insertSchedule([{schedule["origin"]}, {schedule["destination"]}, {schedule["day"]}, {schedule["time"]}]);\n'
    
    ranges = ""
    for _range in data["ranges"]:
        ranges += f'insertRange([{_range["code"]}, `{_range["name"]}`, `{_range["category"]}`, {_range["start"]}, {_range["end"]}]);\n'

    fares = ""
    for fare in data["fares"]:
        fares += f'insertFare([{fare["from"]}, {fare["to"]}, {fare["range"]}, {fare["user"]}, {fare["cost"]}]);\n'

    js = f"""
// Internal database using AlaSQL
import alasql from "alasql";

{create_tables}
{stations}
{users}
{ranges}
{fares}
{schedules}

export default alasql;
"""
    return js

def main():
    conn = connect()
    stations = get_stations(conn)
    users = get_users(conn)
    schedules = get_schedules(conn)
    ranges = get_ranges(conn)
    fares = get_fares(conn)

    data = {
        "stations": stations,
        "users": users,
        "schedules": schedules,
        "ranges": ranges,
        "fares": fares
    }

    #print(output_json(data))
    print(output_alasql(data))


if __name__ == "__main__":
    main()