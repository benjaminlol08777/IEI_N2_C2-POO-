from decouple import config
from peewee import MySQLDatabase

def conectar(): 
   database=MySQLDatabase(
    "encuestapru",
    **{
        "charset": "utf8mb4",
        "host": "localhost",
        "port": 3306,
        "user": "ezequielmr",
        "password": "clave123",})
   return database