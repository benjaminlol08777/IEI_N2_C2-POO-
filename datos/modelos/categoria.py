from peewee import Model, AutoField, CharField, TextField
from conexion import conectar

base_datos = conectar


class BaseModel:
    class Meta:
        DataBase = base_datos


class categoria:
    descripcion = TextField(null=True)
    id_categoria = AutoField()
    nombre = CharField(max_length=50)

    class Meta:
        table_name = "categoria"
