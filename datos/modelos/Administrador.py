from peewee import IntegerField, Model, AutoField, CharField, DateField
from datos.conexion import conectar
from auxiliares.datos_app import default_0

base_datos = conectar()


class BaseModel(Model):
    class Meta:
        database = base_datos


class Administrador(BaseModel):
    id_usuario = IntegerField()
    cargo = CharField(max_length=50)
    fecha_contratacion = DateField()

    class Meta:
        table_name = "administrador"
