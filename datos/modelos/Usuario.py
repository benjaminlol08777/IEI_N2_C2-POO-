class Usuario:
    def __init__(self, id_usuario, rut, nombre, email, contraseña, fecha_registro, activo, rol):
        self.__id_usuario = id_usuario
        self.__rut = rut
        self.__nombre = nombre
        self.__email = email
        self.__contraseña = contraseña
        self.__fecha_registro = fecha_registro
        self.__activo = activo
        self.__rol = rol

