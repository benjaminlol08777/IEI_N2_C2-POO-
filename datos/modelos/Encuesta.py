from peewee import TextField, CharField, DateField, IntegerField, AutoField, Model, SQL
from datos.conexion import conectar

base_datos = conectar


class BaseModel:
    class Meta:
        DataBase = base_datos


class Encuesta(BaseModel):
    descripcion = TextField(null=True)
    estado = CharField(
        constraints=[SQL("DEFAULT 'BORRADOR'")], max_length=20, null=True
    )
    fecha_creacion = DateField(constraints=[SQL("DEFAULT curdate()")], null=True)
    fecha_expiracion = DateField(null=True)
    id_admin = IntegerField(index=True)
    id_categoria = IntegerField(index=True, null=True)
    id_encuesta = AutoField()
    titulo = CharField(max_length=100)

    class Meta:
        table_name = "encuesta"
