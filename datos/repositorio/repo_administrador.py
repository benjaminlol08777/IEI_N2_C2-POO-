from datos.modelos.administrador import Administrador


def listado_administradores():
    administradores = Administrador.select()
    if administradores:
        return administradores
