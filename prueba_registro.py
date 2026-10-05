"""
Formulario Kivy que guarda un Usuario en MySQL usando Peewee
"""

from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label
from kivy.uix.button import Button
from kivy.uix.textinput import TextInput
from kivy.uix.spinner import Spinner
from kivy.core.window import Window
from kivy.utils import get_color_from_hex
from kivy.metrics import dp

# Importamos las clases generadas por pwiz
from models import Usuario, database


class RegistroApp(App):

    def build(self):
        self.title = "Registro de Usuario"
        Window.clearcolor = get_color_from_hex('#1E1E2E')

        layout = BoxLayout(
            orientation='vertical',
            padding=dp(20),
            spacing=dp(10)
        )

        # Título
        layout.add_widget(Label(
            text="[b]Registro de Usuario[/b]",
            markup=True,
            font_size=dp(22),
            size_hint=(1, 0.12),
            color=get_color_from_hex('#89B4FA')
        ))

        # Campo RUT
        layout.add_widget(Label(text="RUT:", size_hint=(1, 0.05), color=get_color_from_hex('#CDD6F4')))
        self.rut_input = TextInput(multiline=False, size_hint=(1, 0.1), padding=[dp(10), dp(10)])
        layout.add_widget(self.rut_input)

        # Campo Nombre
        layout.add_widget(Label(text="Nombre:", size_hint=(1, 0.05), color=get_color_from_hex('#CDD6F4')))
        self.nombre_input = TextInput(multiline=False, size_hint=(1, 0.1), padding=[dp(10), dp(10)])
        layout.add_widget(self.nombre_input)

        # Campo Email
        layout.add_widget(Label(text="Email:", size_hint=(1, 0.05), color=get_color_from_hex('#CDD6F4')))
        self.email_input = TextInput(multiline=False, size_hint=(1, 0.1), padding=[dp(10), dp(10)])
        layout.add_widget(self.email_input)

        # Campo Contraseña
        layout.add_widget(Label(text="Contraseña:", size_hint=(1, 0.05), color=get_color_from_hex('#CDD6F4')))
        self.contrasena_input = TextInput(
            multiline=False,
            password=True,
            size_hint=(1, 0.1),
            padding=[dp(10), dp(10)]
        )
        layout.add_widget(self.contrasena_input)

        # Selector de Rol
        layout.add_widget(Label(text="Rol:", size_hint=(1, 0.05), color=get_color_from_hex('#CDD6F4')))
        self.rol_spinner = Spinner(
            text='Encuestado',
            values=('Administrador', 'Encuestado'),
            size_hint=(1, 0.1)
        )
        layout.add_widget(self.rol_spinner)

        # Botón Guardar
        self.boton = Button(
            text="Guardar en Base de Datos",
            size_hint=(1, 0.15),
            font_size=dp(16),
            background_color=get_color_from_hex('#A6E3A1'),
            color=get_color_from_hex('#1E1E2E')
        )
        self.boton.bind(on_press=self.guardar_usuario)
        layout.add_widget(self.boton)

        # Etiqueta de mensajes
        self.mensaje = Label(
            text="",
            font_size=dp(13),
            size_hint=(1, 0.1),
            color=get_color_from_hex('#F9E2AF')
        )
        layout.add_widget(self.mensaje)

        return layout

    def guardar_usuario(self, instance):
        """Este método se ejecuta al presionar el botón"""
        # 1. Leer los datos de los widgets
        rut = self.rut_input.text.strip()
        nombre = self.nombre_input.text.strip()
        email = self.email_input.text.strip()
        contrasena = self.contrasena_input.text.strip()
        rol = self.rol_spinner.text

        # 2. Validar
        if not all([rut, nombre, email, contrasena, rol]):
            self.mensaje.text = "⚠️ Todos los campos son obligatorios"
            self.mensaje.color = get_color_from_hex('#F38BA8')
            return

        # 3. Guardar en la base de datos
        try:
            # Conectar (si no está conectado)
            if database.is_closed():
                database.connect()

            # Crear el registro con Peewee
            nuevo = Usuario.create(
                rut=rut,
                nombre=nombre,
                email=email,
                contrasena=contrasena,
                rol=rol
                # activo y fecha_registro usan sus valores por defecto
            )

            # 4. Mostrar mensaje de éxito
            self.mensaje.text = f"✅ Usuario '{nombre}' guardado (ID: {nuevo.id_usuario})"
            self.mensaje.color = get_color_from_hex('#A6E3A1')

            # 5. Limpiar campos
            self.rut_input.text = ""
            self.nombre_input.text = ""
            self.email_input.text = ""
            self.contrasena_input.text = ""

        except Exception as e:
            # Capturamos errores (por ejemplo, email duplicado)
            self.mensaje.text = f"❌ Error: {str(e)}"
            self.mensaje.color = get_color_from_hex('#F38BA8')

        finally:
            # 6. Cerrar conexión siempre
            if not database.is_closed():
                database.close()


if __name__ == '__main__':
    RegistroApp().run()