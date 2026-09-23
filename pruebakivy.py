from kivy.app import App
from kivy.uix.button import Button

class TestApp(App):
    def build(self):
        # Creamos un botón gigante para probar que la ventana abra
        return Button(text='¡Kivy está funcionando perfectamente!')

if __name__ == '__main__':
    TestApp().run()



# py -3.12 pruebakivy.py




